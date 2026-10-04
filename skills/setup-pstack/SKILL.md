---
name: setup-pstack
description: Configure pstack role models and reasoning preferences for OpenCode, Codex, or another CLI harness. Use for setup-pstack, configure pstack models, pstack budget, or changing model choices.
---

# Setup pstack

Read [the CLI harness contract](../poteto-mode/references/cli-harness.md) first.

Write portable workflow preferences to `~/.agents/pstack-models.md`. Prefer GPT 6.1 Sol and inherit the active model unless the user explicitly chooses otherwise. This file is read by pstack skills; it does not change the native harness's global model setting.

## Steps

1. **Detect capabilities.** Identify the active harness and its installed model catalog. OpenCode provides a model registry; use it to confirm `openai/gpt-6.1-sol` and supported variants. For Codex, consult the installed CLI and current documentation. Do not assume per-worker model selection exists. If detection is unavailable, use `inherit-parent` or ask the user for an available reference.
2. **Read current preferences.** Read `~/.agents/pstack-models.md` if it exists. Preserve existing roles and unrelated preferences. Missing roles fall back to the active model. Panel entries each count as one independent run, even when all inherit the same model.
3. **Confirm changes.** Honor an explicit choice already supplied. Otherwise ask which roles or reasoning budgets should change. Offer GPT 6.1 Sol if confirmed available, other user-requested confirmed models, and `inherit-parent`. Use separate supported effort settings rather than encoding effort into a model ID. `inherit-session` is the portable default budget.
4. **Validate.** Confirm every explicit model reference in the target harness. Model references are harness-specific. `auto` and `inherit-parent` are workflow aliases, resolved by omitting explicit selection. Where workers cannot select a model or effort, retain the session settings and disclose the limitation.
5. **Write preferences.** Update only the requested choices. Use the existing role labels: `feature, refactoring`, `bug-fix`, `perf-issue`, `hillclimb`, `judgment and prose`, `hardest tasks`, `how explorer`, `how explainer`, `why investigators`, `why synthesizer`, `reflect tooling`, `reflect judgment, divergent, synthesizer`, `swarm workers`, `architect runners`, and `interrogate reviewers`. The last two take comma-separated lists; other roles take one entry. Keep the preferred display name and budget separate from these entries.
6. **Report.** State the path written, changed roles, and any unsupported selections. Native harness configuration is untouched. If the user also requests changing the session or global default, consult that harness's current configuration documentation and preserve unrelated settings.
7. **Optional verification.** If the project lacks a live driver, offer `create-verification-skill` once. Do not install or generate one without agreement.
