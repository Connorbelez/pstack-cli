---
name: automate-me
description: "Use for \"automate me\", \"create/update/refresh my -mode skill\", \"turn/capture my preferences or working style into a skill\", or wanting agents to follow how the user works. Drafts or revises a personal -mode skill via the skill-authoring workflow + unslop, optionally pulling fresh evidence from recent transcripts."
---

# Automate me

Read [the CLI harness contract](../poteto-mode/references/cli-harness.md) before this workflow. It defines model preferences, native tool mapping, permissions, and fallbacks.

A guided flow for turning the user's working conventions into a skill agents will follow. The output is one `-mode` skill tailored to them (e.g. `jay-mode`, `priya-mode`).

This skill orchestrates three others: an inline mining pass (see step 1), the skill-authoring workflow in the CLI harness contract (authoring), and the **unslop** skill (prose discipline). It sequences them. It doesn't replace them.

## Flow

### 0. Check for an existing skill

Look recursively for `.agents/skills/**/*-mode/SKILL.md` and `~/.agents/skills/*-mode/SKILL.md` matching the user's handle. Mode skills can live in a personal category directory (`.agents/skills/<handle>/`), not only at the top level. If one exists, confirm intent with the native question interface (unless they already said "update my skill" or similar):

- Update the existing skill (default for repeat runs)
- Start fresh (rare, ask why before doing it)

Update mode changes the rest of the flow:
- Step 1 mines only history since the skill was last edited (`git log -1 --format=%cI <path>`).
- Step 2 asks what's changed or missing, not what to capture from zero.
- Step 4 edits the existing file in place. Preserve sections the user hasn't contradicted. Revise ones with new evidence. Add new sections only for genuinely new rules.

### 1. Mine their history

Locate scoped history through the CLI harness contract before fanning out. Validate workspace metadata before reading message contents. Never search unrelated project histories. If no scoped export is accessible, interview the user and use the active conversation, labeling the reduced evidence.

Survey recent agent conversations within that scope for recurring patterns. Run multiple parallel subagents across slices of history (e.g. last 2-4 weeks, split into 3 slices so each has enough material). Each slice mining subagent reads transcripts from the workspace-scoped path the parent provides, looks for the signals below, and returns a short structured list of patterns it saw with evidence pointers. Default signals worth hunting:

- Response preferences (length, tone, format, "dumb it down" corrections)
- Delegation habits (subagents, models, specialized workflows, parallelism)
- Verification posture (what "done" means, unit tests vs live repro, reviewers)
- Code and prose discipline (style, principles cited, lint/format tools)
- Process conventions (worktrees, commits, PRs, review/merge tooling)
- Meta preferences (fixing skills mid-task, proposing new ones)

Cross-check across slices before elevating a signal. Patterns seen in 2+ slices are high-confidence. Lone signals are weak and usually get dropped.

### 2. Ask the user directly

Mining misses intent that hasn't come up yet. Use the native question tool when available (otherwise ask concisely in chat) rather than asking the user to type from scratch.

Shape: one or two questions with 4-6 options each, multi-select enabled through the native tool schema for category questions. Start broad ("Which areas matter most?"), then follow up on selected areas with specific options. After the structured rounds, one free-form chat question catches anything the options missed.

Don't dump 20 questions.

### 3. Cluster findings

Group the combined signals into sections. Common ones (use only what applies):

- **Response style**: length, tone, format.
- **Autonomy**: how much to do without asking, MCP tool use.
- **Understand first**: which skills to reach for when scoping or investigating a change.
- **Subagents**: default, parallelism, model-to-task, specialized workflows.
- **Prose / code discipline**: principles, lint tools, style guides.
- **Review and verify**: repro posture, verification skills, live-testing tools.
- **Process**: git worktrees, commits, PRs, review/merge tooling.
- **Skills**: skill-authoring habits, fix-the-skill-first, proposing new skills.

The **poteto-mode** skill shows the shape. Read it for granularity. Don't copy its content. The user's rules are not the same as poteto-mode's.

### 4. Draft the skill

Use the skill-authoring workflow in the CLI harness contract to author the skill. Placement:

- Path: preserve an existing mode skill's category. For a new mode, use `.agents/skills/<handle>/<handle>-mode/SKILL.md` when the repo has an established personal category for that handle. Otherwise default to `.agents/skills/<handle>-mode/SKILL.md` in the project (or `~/.agents/skills/<handle>-mode/` if the user prefers a personal skill).
- Handle: the user's first name or chosen identifier.
- Frontmatter `description`: trigger on their name + `/<handle>-mode` + "work in their style", not on generic keywords like "write code" or "review PR".
- Frontmatter formatting: follow the skill-authoring workflow's YAML rules. Keep `description` as one YAML scalar. Quote it or use `description: >-` with indented continuation lines when punctuation or wrapping requires it.
- For explicit-only invocation, use OpenCode frontmatter `metadata.opencode/autoinvoke: false` and Codex `agents/openai.yaml` with `policy.allow_implicit_invocation: false`. Do not assume portability of harness-specific mode flags.

### 5. Iterate on prose

Apply the **unslop** skill and the skill-authoring workflow's writing guidelines to every line.

Show the draft to the user and take feedback. Expect multiple iterations. Cut ruthlessly. A mode skill is not a manual.

### 6. Land it

Write to the agreed skill location. Commit, push, or open a PR only when requested. If publishing through a repo, use a scoped branch rather than writing directly to main.

## Guardrails

- **Don't overfit to one conversation.** A preference stated once and contradicted another time is noise. Require multiple instances before codifying it.
- **Don't be clever.** Restating other skills' contents, inventing metaphors, or writing "poetic" prose for an agent reader is cost without benefit. Keep it operational.
- **Reference, don't inline.** Other skills the user relies on should appear as path references, not pasted excerpts. Same for any principle docs they maintain elsewhere.
- **Keep sections minimal.** Only add a section if the user has a specific, non-default rule there. "Communicate clearly" is not a section. "Short paragraphs. Tables when comparing options. Bullets only when items are genuinely parallel." is.
- **Name conventions generic.** Use "the user" or "the human" in imperatives, not the author's first name.
- **Don't force symmetry.** If a user has no process rules worth writing down, skip the Process section entirely.

## Evaluation

A `-mode` skill is subjective output. A benchmark loop is not a substitute for user feedback. Check whether it reads like them and whether it missed anything. Validate the file format, then deliver the approved draft.

Run a description-optimization loop only if the skill's trigger accuracy turns out to be a problem in practice.

## When not to use

- User wants a task-specific skill (not working conventions): the skill-authoring workflow alone, no mining required.
- User wants to capture one narrow workflow (e.g. "how I write commit messages"). That's a regular skill, not a mode skill.
