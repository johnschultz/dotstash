# Code Comment Guidelines

When adding or editing comments in code changes, keep them lean. The test:

> **What does a developer need to know about this code immediately, six months from now?**

Everything else belongs in the **commit message** or **CR/PR description**, not in the code.

## Keep in the comment (durable — about the code as it stands)
- The **why** that isn't obvious from the code: a non-obvious invariant, a constraint, a gotcha that will bite the next reader.
- The **intent** of a guard or branch when the code alone doesn't make it clear.
- A pointer to a genuinely non-obvious dependency ("the bucket is cross-account, so the identity grant alone isn't enough").

## Move to the commit message / CR description (transient — about this change)
- **Bug-history narration** — "previously this collapsed into a null → 5xx", "this was failing with 403 since Jun 13". How it *used* to behave is review context, not code doc.
- **The before/after story** — what the change replaces, why the old path was wrong.
- **Metrics, dates, ticket numbers, rates** — "~1-1.5k/day", "since the weblab launch".
- **Blow-by-blow mechanism** that a reader can get from reading the code itself.

## Rule of thumb
If a comment sentence would read as stale or irrelevant once the change is old news, it's transient — put it in the commit. A comment that starts with "Previously…", "This was…", "Instead of the prior path…", or narrates a symptom is almost always transient.

## Applies to
- Inline code comments and block comments (the primary target).
- Class/function docstrings: keep them about *what the thing is and how to use it*, not the change that introduced it.
- **Exception:** published API contract docs (e.g. Smithy `///` docs, public SDK javadoc) legitimately describe semantics to *external callers* — keep the caller-facing meaning, but still drop internal implementation/metrics rationale.

Default to fewer, denser comments. An agent-drafted change often over-explains itself with review-time context; trim it before finalizing.
