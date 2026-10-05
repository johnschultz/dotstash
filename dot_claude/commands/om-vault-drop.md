---
description: "Drop a structured note into the obsidian-mind vault inbox from any workspace. The vault's /om-intake processes it later."
---

# Vault Drop

Write a structured note to `~/Documents/obsidian-mind/work/inbox/` so the vault Claude can process it later. Use this from any workspace when you discover something worth capturing — a decision, a win, a pattern, a project update, or a person note.

## When to Use

- You completed work that should be logged as a win or brag entry
- A decision was made that should be recorded
- You discovered a pattern or gotcha worth remembering
- You have a project status update for the vault
- You learned something about a person or team

## How to Write the Drop

Create a file at `~/Documents/obsidian-mind/work/inbox/YYYY-MM-DD-<short-kebab-topic>.md` (date in Pacific time) with this structure:

```markdown
---
date: YYYY-MM-DD  # Pacific time
source: "<workspace name or package name>"
type: "<one of: win, project-update, handoff, decision, customer-effect>"
bead: "<om-xxxx if this drop relates to a bead, else omit>"
supersedes: "<filename of an earlier drop this one replaces, else omit>"
description: "<one-line summary for the vault processor>"
tags: []
---

# <Title>

<Content — be specific. Include what happened, why it matters, and any relevant context like CR numbers, ticket IDs, or metrics. The vault Claude will handle linking, placement, and formatting.>
```

## Rules

- **Keep it self-contained.** The vault Claude doesn't have access to your current workspace context. Include enough detail to act on without reading other files.
- **One topic per drop.** If you have three things to capture, write three files.
- **Don't try to link or format for Obsidian.** No wikilinks, no frontmatter tags beyond the basics above. The vault processor handles all that.
- **Use today's date in Pacific time** (filename and `date:`) unless the event happened on a different day.
- **Name the bead if there is one.** Put the bead ID in the `bead` field; in the body cite it as "Title (om-xxxx)", never a bare ID. Closing the bead is separate: `bd -C ~/Documents/obsidian-mind close <id> --reason "..."`.
- **`handoff` type** is for handing a workstream back to the vault: current state, what is done, what is not, blockers, next step. Use it when a coding session ends an epic or pauses for more than a day.
- **Drop at terminal state.** Workers drop when the work is merged or abandoned. A later drop that replaces an earlier one names it in `supersedes:` so intake collapses the pair.
- **`decision` type** is emitted only by the Project Agent when a decision resolves. Body carries exactly: decision id (wd-...), the question as parked, the options offered, John's verbatim answer, the resolution timestamp (UTC and Pacific), and the task (board row id and bead as "Title (om-xxxx)"). Nothing else.
- **`customer-effect` type** only when a customer effect was MEASURED on real GetCounts traffic.
- **Include metrics when available.** "Reduced p99 by 20%" is better than "improved latency."

## Example

```markdown
---
date: 2026-05-29
source: "DFGReachForecasting"
type: "project-update"
description: "Chose Apache Pinot over Druid for standalone reach index PoC"
tags: []
---

# Standalone Reach Index: Pinot over Druid

After evaluating both options, chose Apache Pinot for the reach index PoC because:
- Better support for upserts (index updates are frequent)
- Star-tree index matches our high-cardinality targeting queries
- Existing Amazon internal deployment patterns via Gondola

Trade-off: Druid has better ecosystem tooling but upsert support is experimental.

Related: TDB-Index-Update-Reliability project, Reach 3YP Year 3 planning.
```

## After Writing

The file sits in the inbox until the user runs `/om-intake` from the vault workspace. No further action needed from this workspace.
