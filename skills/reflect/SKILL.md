---
name: reflect
description: Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete edit on an existing skill. Use when the user says reflect.
---

# Reflect

Read [the CLI harness contract](../poteto-mode/references/cli-harness.md) before this workflow. It defines model preferences, native tool mapping, permissions, and fallbacks.

Mine the current conversation for durable learnings, then route them into skill edits.

## When to invoke

Invoke when the user says "reflect" or "/reflect". Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## Process

### 1. Locate the active transcript

Use the active conversation or discover its scoped session export through the CLI harness contract. Validate the native session ID, workspace metadata, and opening prompt before passing an export to reviewers. Do not search unrelated histories or assume a JSONL schema. If no scoped export resolves, write a tight session digest and state that it is not a full tool trace.

### 2. Spawn three reviewers in parallel

One message, three native delegate calls, a general-purpose native delegate, with `model` set as below, access to the required MCP tools, with no writes unless explicitly scoped. Reviewers need MCP access for context lookups (tickets, chat threads, observability traces referenced in the transcript). MCP availability depends on the harness; confirm the required tools are exposed.

Each reviewer and the synthesizer name a role line in the `~/.agents/pstack-models.md` rule and a default. Set `model` to that line's value, or to the default if the rule or the line is missing. Leave `model` unset when the value is `auto` or `inherit-parent`. If the native delegate tool rejects a slug, use the active session model and disclose the fallback.

| Lens | Role line | Default `model` | Prompt template |
|---|---|---|---|
| Judgment | `reflect judgment, divergent, synthesizer` | `inherit-parent` | `references/judgment-reviewer.md` |
| Tooling | `reflect tooling` | `inherit-parent` | `references/tooling-reviewer.md` |
| Divergent | `reflect judgment, divergent, synthesizer` | `inherit-parent` | `references/divergent-reviewer.md` |

Pass each template verbatim, substituting the transcript path or digest where marked. Reviewers return findings in the native delegate response body.

### 3. Synthesize

One native delegate call, a general-purpose native delegate, with `model` from the `reflect judgment, divergent, synthesizer` line (default `inherit-parent`), access to the required MCP tools, with no writes unless explicitly scoped. The synthesizer's quality check includes spot-verifying citations, which can require MCP access. MCP availability depends on the harness; confirm the required tools are exposed. Use `references/synthesizer.md` verbatim, with each reviewer's full output inlined where marked. The synthesizer returns a structured Accepted / Rejected / Backlog list.

### 4. Structural enforcement check

Sanity-check the synthesizer's Accepted list. For any item that would be enforced more reliably by a lint rule, script, metadata flag, or runtime check, move it from Accepted to Backlog. See the **encode-lessons-in-structure** principle skill.

### 5. Apply

Before applying any Accepted edit, present the synthesizer's full Accepted/Rejected/Backlog output to the user and wait for explicit approval. The user picks which subset to apply and may redirect routings. Skill changes affect every future agent in the org. Do not auto-apply.

Present backlog items in the report. File them to an external tracker only when the user authorizes that write.

For each approved Accepted item, follow the Routing field exactly:

- Trivial existing-skill edit (a one-line bullet, a tightened sentence, a stale fact corrected): parent does directly.
- Substantive existing-skill edit (a new section, a new pattern table, more than ~10 lines): hand to the skill-authoring workflow in the CLI harness contract and run its draft / test / iterate loop.
- `tune description: <skill path>` (the skill exists but didn't trigger when it should have): hand to the skill-authoring workflow and run its description-optimization loop.
- `new skill via the skill-authoring workflow: <kebab-name>`: hand creation to the skill-authoring workflow. Do not invent the shape ad hoc.

If your environment ships a SKILL.md validator, run it on every touched skill before declaring done. Skip this step if it doesn't.

### 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<skill path>`. What changed, one line each.
- New skills created: `<skill path>`. One line each (rare).
- Backlog filed to the devex tracker: `<issue title>` (`<tags>`). One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
