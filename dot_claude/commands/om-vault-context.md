---
description: "Pull current-state context on a topic from the obsidian-mind vault (notes + open beads) without leaving the current workspace. Read-only."
---

# Vault Context

Read what the vault knows about a topic before you start. Read-only: never edit vault files from a code workspace.

## Usage

```
/om-vault-context <topic or project label>
```

## Steps

1. **Search the vault index.** The QMD index is machine-wide, so this works from any directory.
   ```bash
   qmd --index obsidian-mind query "<topic>" -n 8
   ```
   If the `mcp__qmd__query` tool is available, use it instead with the same query and an `intent`.
2. **Read the project note.** Results under `work/active/` are the current-state notes. Fetch the best match:
   ```bash
   qmd --index obsidian-mind get "<path from results>"
   ```
   Check its frontmatter for `beads: <label>` and `status`. Prefer notes with `doc-tier: living`.
3. **Read the open task graph.**
   ```bash
   bd -C ~/Documents/obsidian-mind ready --label <label>
   bd -C ~/Documents/obsidian-mind list --label <label> --status in_progress
   ```
   If an epic exists: `bd -C ~/Documents/obsidian-mind ready --parent <epic-id>`.
4. **Check gotchas.** `qmd --index obsidian-mind query "<topic> gotcha" -n 3` and prefer hits under `brain/Gotchas.md`.
5. **Summarize** in five lines or fewer: current state and date, what is decided, what is open, which beads are ready, and the note paths you read. Cite beads as "Title (om-xxxx)".

## Rules

- Do not open or edit files under `~/Documents/obsidian-mind` with editing tools. Use `qmd get` and `bd` only.
- If QMD returns nothing, say so. Do not guess vault state from memory.
