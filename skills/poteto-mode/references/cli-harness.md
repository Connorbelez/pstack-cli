# CLI harness contract

Read this contract before using a pstack workflow. Harness instructions, repository instructions, permissions, and the user's scope take precedence over every skill and playbook. A skill never grants permission to publish, merge, deploy, install software, delete data, or change unrelated files.

## Discovery and invocation

The shared user installation is `~/.agents/skills/<id>/SKILL.md`. Project skills belong in `.agents/skills/<id>/SKILL.md`. Both OpenCode and Codex discover these locations without plugin manifests or duplicate copies.

- OpenCode: load a skill with the native skill tool using its exact directory ID, or use its slash entry when exposed.
- Codex: use `$<id>` or `/skills`, or read the selected `SKILL.md` from the advertised path.
- Other CLI harnesses: read the skill and its supporting files directly. Slash notation in the playbooks names a workflow, not a guaranteed command.

## Models

Read `~/.agents/pstack-models.md` when selecting a role. Prefer **GPT 6.1 Sol** for code, research, review, and prose. Default to `inherit-parent`: omit model selection and retain the active session's model. Panels use independent sessions and distinct review angles on that same model, not mandatory vendor diversity. If the session is not using the preferred model, report that fact; do not silently change global configuration.

OpenCode's confirmed reference is `openai/gpt-6.1-sol`, with `low`, `medium`, `high`, `xhigh`, and `max` variants. Use the model registry to confirm a reference before explicit selection. Only pass a model or variant when the user has requested that selection and the native tool supports it.

For Codex, verify model IDs and reasoning settings through the installed CLI and current documentation. Do not copy OpenCode's provider-prefixed reference into Codex or append reasoning tokens to a guessed model ID. If per-worker selection is unavailable, inherit the session model and disclose the limitation. `auto` is a pstack alias for `inherit-parent`, not a literal model ID.

If a configured model is unavailable, report the gap and inherit the active model when permitted. Never select an unrelated model from an error message. Keep reasoning budget separate from model identity and use only supported settings.

## Delegation

Use only the native tools actually advertised by the active harness. In OpenCode, use its subagent tool and supported agent type (`general` or `explore` when available). In Codex, use its native agent spawn, message, and wait tools when exposed. Do not invent tool names or pass another harness's fields.

Workflow role names are prompt instructions, not installed agent types. For a Poteto delegate, include `../SKILL.md` from this reference directory and the relevant playbook in its brief. For a comment reviewer, use `../../no-comments/references/comment-reviewer.md`. Give each delegate scope, evidence paths, verification steps, and a return contract. Request read-only behavior in the prompt; do not assume it changes MCP availability. Grant only the tools and writes the task actually needs.

Independent work can run concurrently. Writers need separate worktrees or disjoint paths. Local execution is the default; remote execution is optional and requires an available, authorized runner. Never assume cloud VMs, dashboard access, or remote secrets exist. Use native completion notifications or a blocking wait; do not sleep or poll agent progress when the harness forbids it. If delegation is absent or prohibited, execute the stages sequentially and label reviews as non-independent.

## Sessions, MCPs, and long-running work

Use the active conversation or the harness's scoped session/export API first. In OpenCode, discover the installed CLI/API operations rather than reading its database directly. In Codex, session files may be under `$CODEX_HOME/sessions` (default `~/.codex/sessions`); validate session metadata and working directory before reading message contents. Never glob or read unrelated project histories. If no scoped transcript is accessible, pass a concise digest and state the evidence limitation. JSONL schemas are harness-specific, not necessarily one chat message per line.

Discover MCP tools and resources through the harness's advertised catalog. Skip unavailable connectors with an explicit gap. Do not assume an on-disk MCP directory or connector-specific tools exist.

For monitoring, use native background jobs or an explicitly authorized external watcher. If neither exists, run one bounded check and provide a resumable checkpoint. Do not promise autonomous wake-ups after the session ends. Git branches, decision logs, and session exports are durable; local delegates are not guaranteed to survive a restart.

## Optional workflows

For skill authoring, use Codex's `skill-creator` if available. Otherwise author a portable skill directly: lowercase kebab-case directory and matching `name`, a YAML `description` with clear triggers, focused instructions, and relative supporting paths. Validate frontmatter, links, and a representative task. No authoring plugin is required.

Before commit, review the diff for unnecessary abstractions, stale comments, and unsupported claims. An optional cleanup skill may help but is not a dependency. For live verification, use the installed browser, terminal, simulator, or project-local `verify-*` driver appropriate to the surface. If a named control skill is absent, name and exercise the actual driver instead of claiming it ran.
