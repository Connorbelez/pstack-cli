# pstack for CLI harnesses

46 adapted skills live in `~/.agents/skills`. OpenCode and Codex both discover that user-level directory automatically. Existing unrelated skills and native harness configuration are unchanged.

## Use

- **OpenCode:** load the exact skill ID or use its exposed slash entry, for example `poteto-mode`, `architect`, or `interrogate`.
- **Codex:** use `$poteto-mode`, `$architect`, `$interrogate`, or `/skills`.
- **Other harnesses:** read `skills/<id>/SKILL.md` and its relative supporting files.

If the skill list is stale, restart the CLI session. The skills' YAML names match their lowercase directory IDs. Descriptions provide discovery triggers; editor-only mode and tool fields are not required.

## Models and portability

[Model preferences](pstack-models.md) prefer **GPT 6.1 Sol** across all roles. Entries default to `inherit-parent` so workers retain your active session model without guessing harness-specific IDs. OpenCode's confirmed reference is `openai/gpt-6.1-sol`; Codex references must be confirmed in the installed CLI. These preferences do not change either harness's global default model.

[The CLI harness contract](skills/poteto-mode/references/cli-harness.md) defines native tool mapping, scoped transcript access, MCP discovery, and permission boundaries. Workflows use local isolated worktrees by default. Independent review and design runs can all use GPT 6.1 Sol; vendor diversity is not required. Where delegation, session exports, remote execution, or live drivers are unavailable, report the limitation and use the documented fallback.

Design comparisons are implemented directly in `architect`; reviews use `interrogate` and `swarm`. The webhook UI skill accepts an existing webhook or a documented local CLI runner rather than a hosted editor-specific routine API. The comment reviewer is a bundled prompt, not a required custom agent type.

## Tools and validation

The instruction-only skills need no package installation. Optional tools:

- Decision log: Bash, `skills/show-me-your-work/scripts/log.sh`.
- Worktree audit: Bash, Python 3, git, `du`, and optional `gh`. Run `bash skills/poteto-mode/scripts/worktree-audit.sh <repo>`. Set `PSTACK_TRANSCRIPTS_DIR` only to a directory of exports scoped to that workspace. Unknown session usage blocks a safe recommendation. The script never deletes anything.
- Plan check: Node.js, `node skills/poteto-mode/scripts/check-plan.mjs <plan.md>`.
- PR watcher and orchestration ledger: Bun, git, and authenticated `gh`; additional forge tooling is optional. Dependencies are pinned by `skills/poteto-mode/scripts/bun.lock`. Install them only when these tools are needed, using `bun install --frozen-lockfile` in that scripts directory. Orchestration records state; it does not provide a runner or persistent wake service.

Run `python3 scripts/validate-pstack.py` to check the imported inventory, required frontmatter, portable contract links, and local Markdown links. When Bun is available, run `bun test orch watch-pr` from `skills/poteto-mode/scripts`.

## Source

[The import manifest](pstack-import.json) records the upstream revision and the exact adapted skill inventory. This is an adapted snapshot, not an automatic update mechanism. Re-imports must preserve these portability changes and unrelated local work. Upstream attribution and MIT terms are retained in [the license](licenses/pstack-MIT.txt).
