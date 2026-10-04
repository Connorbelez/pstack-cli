#!/usr/bin/env bash
# Read-only audit. An optional transcript directory must contain only exports
# for the requested workspace. Unknown session usage never earns a safe bucket.
set -euo pipefail
exec python3 - "$@" <<'PY'
import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time


def run(args, cwd=None):
    try:
        return subprocess.run(args, cwd=cwd, text=True, capture_output=True)
    except OSError as error:
        return subprocess.CompletedProcess(args, 1, '', str(error))


repo = sys.argv[1] if len(sys.argv) > 1 else run(['git', 'rev-parse', '--show-toplevel']).stdout.strip()
if not repo or not Path(repo).is_dir():
    sys.exit('not in a git repo; pass a repo path')
listing = run(['git', 'worktree', 'list', '--porcelain', '-z'], repo)
if listing.returncode:
    sys.exit(listing.stderr.strip())
worktrees = [token.removeprefix('worktree ') for token in listing.stdout.split('\0') if token.startswith('worktree ')]
if not worktrees:
    sys.exit('no git worktrees found')

prs = []
if shutil.which('gh'):
    result = run(['gh', 'pr', 'list', '--state', 'all', '--limit', '1000', '--json', 'number,state,headRefName'], repo)
    if result.returncode == 0:
        try:
            prs = json.loads(result.stdout)
        except json.JSONDecodeError:
            pass

transcripts = os.environ.get('PSTACK_TRANSCRIPTS_DIR')
history = Path(transcripts).expanduser() if transcripts else None
history_known = history is not None and history.is_dir()
if not history_known:
    print('warn: no scoped transcript exports; session usage is unknown', file=sys.stderr)
print('warn: merge checks use existing origin/main; fetch separately if needed', file=sys.stderr)
rows = []
for wt in worktrees[1:]:
    head = run(['git', 'rev-parse', 'HEAD'], wt).stdout.strip()
    stamp = run(['git', 'log', '-1', '--format=%ct', 'HEAD'], wt).stdout.strip()
    age = f'{int((time.time() - int(stamp)) / 86400)}d' if stamp.isdigit() else '?'
    merged = bool(head) and run(['git', 'merge-base', '--is-ancestor', head, 'origin/main'], repo).returncode == 0
    status = run(['git', 'status', '--porcelain'], wt)
    entries = status.stdout.splitlines()
    tracked = sum(not line.startswith('??') for line in entries)
    dirty = 'unknown' if status.returncode else f'wip:{tracked}' if tracked else f'scratch:{len(entries)}' if entries else 'clean'
    branch = run(['git', 'symbolic-ref', '--quiet', '--short', 'HEAD'], wt).stdout.strip()
    remote = 'detached' if not branch else 'no-remote'
    if branch and run(['git', 'show-ref', '--verify', '--quiet', f'refs/remotes/origin/{branch}'], repo).returncode == 0:
        remote_head = run(['git', 'rev-parse', f'origin/{branch}'], repo).stdout.strip()
        remote = 'pushed' if remote_head == head else 'diverged'
    matching = [pr for pr in prs if pr['headRefName'] == branch] if branch else []
    pr = ','.join(f"#{item['number']}/{item['state']}" for item in matching) or '-'
    last_stamp = 0
    readable_history = history_known
    if history_known:
        for path in history.rglob('*'):
            if path.is_symlink():
                readable_history = False
                continue
            if path.is_file() and path.suffix in {'.jsonl', '.json', '.md', '.txt'}:
                try:
                    text = path.read_text()
                    if f'{wt}/' in text or f'{wt}"' in text or json.dumps(wt) in text:
                        last_stamp = max(last_stamp, path.stat().st_mtime)
                except (OSError, UnicodeError):
                    readable_history = False
    last = datetime.datetime.fromtimestamp(last_stamp).strftime('%Y-%m-%d') if last_stamp else '-' if readable_history else 'unknown'
    recent = last_stamp > 0 and time.time() - last_stamp <= 4 * 86400
    if dirty == 'unknown' or tracked:
        bucket = 'hold-wip'
    elif any(item['state'] == 'OPEN' for item in matching):
        bucket = 'hold-open-pr'
    elif not readable_history:
        bucket = 'verify-session-state'
    elif recent:
        bucket = 'verify-recent-chat'
    elif merged or any(item['state'] == 'MERGED' for item in matching):
        bucket = 'safe-candidate'
    else:
        bucket = 'review'
    size_result = run(['du', '-sk', wt])
    size_text = size_result.stdout.split(maxsplit=1)[0] if size_result.stdout else ''
    size = int(size_text) if size_text.isdigit() else 0
    rows.append((size, [f'{size}K' if size else '?', age, 'YES' if merged else 'no', dirty, remote, pr, last, bucket, wt]))

print('SIZE\tAGE\tMERGED\tDIRTY\tREMOTE\tPR\tLAST_CHAT\tBUCKET\tWORKTREE')
for _, row in sorted(rows, key=lambda item: item[0], reverse=True):
    print('\t'.join(row))
PY
