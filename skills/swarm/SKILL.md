---
name: swarm
description: "Fan out N parallel workers, drain them, and return one report. Use for /swarm, 'swarm this', or parallel coverage, races, gauntlets, and exploration."
---

# Swarm

Read [the CLI harness contract](../poteto-mode/references/cli-harness.md) before this workflow. It defines model preferences, native tool mapping, permissions, and fallbacks.

Fan out N parallel isolated workers. They may cover separate slices, race the same brief, or mix both. The parent waits, aggregates, and returns one report.

## Start

Open a todolist with one entry per phase before launching anything.

1. Frame
2. Fan out
3. Aggregate
4. Report

## Phase A: Frame

1. State the done predicate and the artifact or report the swarm must return.
2. Choose the shape. Partition into slices, race N workers on identical briefs, or mix both. For a race or mixed shape, declare `first pass`, `rank all`, or `best-of` before spawning.
3. Set N from the user or derive it from the shape. N is total workers, not the harness concurrency limit.
4. Pick the worker model from the `swarm workers` line in `~/.agents/pstack-models.md`. If the rule or that line is missing, use `inherit-parent`. For `auto` or `inherit-parent`, omit `model` so the workers run on the parent model. If the native delegate tool rejects a slug, use the active session model and disclose the fallback. For a model race, name each arm's model up front.
5. Give each worker its own writable output when it writes. When workers verify or measure commits, each brief names the exact SHAs. A measurement brief also names the method (sample count, what one sample is, order). The worker records both in its result.

## Phase B: Fan out

Launch independent workers concurrently through the supported native delegate tool. Inherit the active model unless step 4 selects a confirmed, authorized alternative. Use local isolated worktrees by default; remote execution is optional and requires an available, authorized runner. Use only fields accepted by the current tool. Respect its concurrency limit and queue remaining work. If delegation is unavailable or forbidden, cover the slices sequentially and state that they were not independent.

When a worker needs a non-default branch, prepare its worktree at the exact branch or SHA through git and pass that path in the brief. Do not invent a cloud-specific branch field.

Every brief stands alone. Include the goal, scope, exact slice or race arm, how to verify, and what to report. Reports use `PASS`, `ISSUES`, or `BLOCKED` with evidence. A worker that can prove a defect reports `ISSUES` and lists every issue it can prove, not only the first.

If a worker drops out, proceed with N-1 and note it.

## Phase C: Aggregate

Read the terminal results. Drop a result that does not record the SHAs and method its brief names, and rerun that worker once. After a second miss, record a gap. A gap does not count as a pass. For coverage, every required slice needs a result. For a race, apply the selection rule declared up front. Use first pass, rank all, or best-of. Do not paste raw worker dumps.

Keep a compact result table, one-line evidenced issues, and explicit gaps or dropouts.

## Phase D: Report

Return one consolidated in-chat report with the table, issue one-liners, gaps or dropouts, and the race rule when used.
