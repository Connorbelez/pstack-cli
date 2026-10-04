# pstack CLI adaptation

46 MIT-licensed pstack skills adapted for Codex, OpenCode, and other CLI agents. The adaptation replaces editor-specific assumptions with a [portable harness contract](skills/poteto-mode/references/cli-harness.md). This repository is an independently maintained snapshot of the [recorded upstream revision](pstack-import.json).

## Review and install

Clone this repository into a separate directory and inspect [PSTACK.md](PSTACK.md), the import manifest, and the skills you intend to use. Place selected skill directories under `~/.agents/skills/`, preserving their names and relative reference files. Back up any existing skills with the same names first. Do not overwrite unrelated skills or change global model settings as part of installation.

The complete bundle expects `pstack-models.md` alongside the installed `skills/` directory. Its preferences are explicit defaults and should be reviewed for your current model registry. Restart the CLI session if discovery does not update. Harness-specific capability availability still governs what a skill can run.

## Verify

```sh
python3 scripts/validate-pstack.py
```

The validator checks the exact imported inventory, frontmatter, portable contract links, local links, and attribution. It does not prove every workflow against every CLI. Optional Bun helpers have their own locked dependencies and tests; see [PSTACK.md](PSTACK.md). No dependency install is needed for the instruction-only skills.

## Upstream or fork

Keep the CLI portability layer separate while proposing broadly useful wording and bug fixes to pstack's upstream. Native tool mappings, transcript scoping, and fallback paths are intentionally different from the editor bundle. Record upstream changes before re-importing instead of overwriting the adaptation.

[Attribution](ATTRIBUTION.md), [roadmap](ROADMAP.md), and [maintenance](MAINTAINERS.md) describe provenance and current support. The maintainer has not declared a stable cross-harness release.
