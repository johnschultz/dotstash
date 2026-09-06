# Workflow Adversarial Verifier Guidelines

When designing adversarial verifier prompts in multi-agent workflows, verifiers must evaluate TWO axes independently:

1. **Is the finding real?** — Does the code actually have the described problem?
2. **Is the proposed fix safe?** — Could the recommended mechanism cause corruption, data loss, or violate framework/runtime constraints (e.g., thread safety, I/O safety, API contracts)?

Don't let verifiers stop at confirming the symptom — they must also validate the remedy. A real finding with an unsafe fix should be flagged as needing an alternative approach, not confirmed wholesale.
