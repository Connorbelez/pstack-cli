### Worktree and simulator cleanup

**You own the disk and the safety gate.** Prune merged or abandoned git worktrees and stale iOS simulators to reclaim space. Deletion is irreversible, so every step guards against deleting something in use or holding uncommitted work.

1. Snapshot and audit. Record `df -h /`, then run `scripts/worktree-audit.sh` (principle-build-the-lever). It reads paths from `git worktree list`, including paths with spaces and worktrees outside the repo. If workspace-scoped transcript exports are available, set `PSTACK_TRANSCRIPTS_DIR` to their directory. Without scoped history, the audit marks session usage unknown and withholds a safe bucket. It never deletes anything.
2. The bucket is advice, not permission. The pinned and active chats are the real artifact (principle-prove-it-works). Get that set from the user or sidebar and cross-check every candidate. The lever has marked `safe` a worktree the user had pinned, so the pinned set wins.
3. Verify usage before deleting. Resolve every `verify-recent-chat` or `verify-session-state` row through scoped native session metadata, active processes, and the user's current work. Independent design and reproduction trees can remain active even when absent from a session selector. Unknown usage is not proof of abandonment.
4. Pause on irreversible loss. `wip:N` is N tracked uncommitted edits. Show the diff and get a decision first, since removing a clean worktree is recoverable from its branch but uncommitted work is gone. `scratch:N` is untracked throwaway, safe to drop, but name the files. Per Autonomy, clean and merged and not-in-use proceeds. `wip` and in-use pause.
5. Prune the confirmed set. Per path, `git worktree remove --force <path>`. If the dir survives on ignored build artifacts, `rm -rf` it, then `git worktree prune`. Branch refs survive, so no commits are lost. Confirm with `df -h /` and re-list.
6. Optional reclaimers depend on the platform. On macOS, inspect simulator runtimes and Xcode caches before proposing narrowly scoped deletion. On Linux, inspect actual package and build caches. Never clear OpenCode or Codex session databases, exports, or configuration as disposable cache. Every deletion requires the user's authorization for the exact target.

This is the one playbook that deletes user state with no code review to catch a slip, so the gates above are the review.

**Reply:** `df -h /` before and after with space reclaimed, the worktrees pruned, and a one-line reason for each held back (in-use by which chat, or uncommitted work).
