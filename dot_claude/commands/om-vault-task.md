---
description: "Create a bead (durable task) in the obsidian-mind vault's beads DB from any workspace. Use for follow-up work discovered while coding."
---

# Vault Task

Create a durable task in the vault's beads DB without leaving the current workspace. The vault owns the task graph; this command only adds to it.

## When to Use

- You found follow-up work that should not be lost when this session ends
- A code change needs a knowledge-side action (design note, decision, review prep, person follow-up)
- You are blocked and the blocker needs tracking

Do not use it for today-only checklist items. Those stay in your own notes.

## How

1. Reuse an existing label. List them first:
   ```bash
   bd -C ~/Documents/obsidian-mind label list-all
   ```
   Labels map to vault project notes (a note declares `beads: <label>`). Do not invent near-duplicates.
2. Create the bead. Priority 0 is highest, 4 lowest. Default to 2.
   ```bash
   bd -C ~/Documents/obsidian-mind create "<imperative title>" -t task -p 2 -l <label> \
     --description "<what, why, where: repo/package, files, CR or ticket IDs>" \
     --acceptance "<how the vault knows it is done>" --json
   ```
3. If it belongs under an epic you are working, wire it:
   ```bash
   bd -C ~/Documents/obsidian-mind dep add <new-id> <epic-id> -t parent-child
   ```
   Add `--deps blocks:<id>` only when the new task truly cannot start until another finishes.
4. Report it back to the user as **"Title (om-xxxx)"**, never a bare ID.

## Rules

- Never `bd edit` (opens an editor and blocks). Use `bd update`.
- Never close, re-label, or re-parent beads you did not create in this session. Report instead.
- If `bd` warns about `beads.role`, ignore it; the vault sets the role.
