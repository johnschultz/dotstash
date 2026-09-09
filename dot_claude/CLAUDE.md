# Two worlds: the vault and the code

There are two kinds of working directory on this machine. Each has its own steering. Do not blur them.

| World | Where | Owns | Steering |
|---|---|---|---|
| **Vault** (knowledge work) | `~/Documents/obsidian-mind` | Design, investigations, decisions, coaching, career, people, task state (beads) | The vault's own `CLAUDE.md` and `.claude/` |
| **Code** (implementation) | `~/workplace/**` and other repos | Source, builds, reviews, deployments | `~/workplace/CLAUDE.md` plus each repo's `.claude/` |

Rules of the seam:

- A vault session does not edit code. When work needs a code change, it creates a bead (a task in the vault's beads DB) and stops.
- A code session does not edit vault notes directly. It reports through the three verbs below. The vault's `/om-intake` routes what arrives.
- One task DB. Beads live in the vault at `~/Documents/obsidian-mind/.beads`. From any directory: `bd -C ~/Documents/obsidian-mind <cmd>`.
- Cite beads as "Title (om-xxxx)", never a bare ID.

## The three seam verbs

1. **Take a task.** `bd -C ~/Documents/obsidian-mind ready --parent <epic>` or `bd -C ~/Documents/obsidian-mind show <id>`. Claim before working: `bd -C ~/Documents/obsidian-mind update <id> --claim`. Close with a reason when done. Only the vault or John re-parents or re-labels beads.
2. **Pull context.** `/om-vault-context <topic>` or `qmd --index obsidian-mind query "<topic>"`. The QMD index lives in `~/.cache/qmd` and works from any directory. Read-only.
3. **Report back.** `/om-vault-drop` writes a self-contained note into the vault inbox (win, decision, gotcha, project update, handoff). `/om-vault-task` creates a bead for follow-up work. Both are fire-and-forget; the vault does the linking and placement.

Prefer the specialized agent for the world you are in. Coding agents run in the code world with `~/workplace` as an ancestor so they load coding steering. Vault agents run in the vault. Never spawn a code-mutating agent from the vault; hand it a bead instead.
