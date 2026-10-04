#!/usr/bin/env python3
"""Validate only the pstack inventory, leaving unrelated skills untouched."""
import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote

root = Path(__file__).resolve().parent.parent
manifest = json.loads((root / "pstack-import.json").read_text())
errors = []
names = manifest["skills"]
if len(names) != len(set(names)):
    errors.append("duplicate skill IDs in manifest")
if not (root / manifest["license"]).is_file():
    errors.append("missing upstream license")

for name in names:
    folder = root / "skills" / name
    skill = folder / "SKILL.md"
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name) or len(name) > 64:
        errors.append(f"invalid portable ID: {name}")
    if not skill.is_file():
        errors.append(f"missing {skill.relative_to(root)}")
        continue
    text = skill.read_text()
    match = re.match(r"\A---\n(.*?)\n---(?:\n|$)", text, re.S)
    if not match:
        errors.append(f"{name}: missing YAML frontmatter")
        continue
    front = match[1]
    if not re.search(rf"^name: {re.escape(name)}$", front, re.M):
        errors.append(f"{name}: name must match directory ID")
    if not re.search(r"^description: \S", front, re.M):
        errors.append(f"{name}: missing description")
    if "[the CLI harness contract]" not in text:
        errors.append(f"{name}: missing portable harness contract")
    if re.search(r"^(?:disable-model-invocation|mode|icon|color|reminder|paths):", front, re.M):
        errors.append(f"{name}: editor-specific frontmatter")

    for document in folder.rglob("*.md"):
        body = document.read_text()
        body = re.sub(r"```.*?```", "", body, flags=re.S)
        for target in re.findall(r"\]\(([^\s)]+)(?:\s+[^)]*)?\)", body):
            target = unquote(target.split("#", 1)[0])
            if not target or re.match(r"[a-zA-Z][a-zA-Z0-9+.-]*:", target) or "<" in target:
                continue
            destination = (document.parent / target).resolve()
            if not destination.exists():
                errors.append(f"{document.relative_to(root)}: broken link {target}")

if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(1)
print(f"Validated {len(names)} pstack skills, contract links, local links, and license.")
