#!/bin/sh
# Runs on every apply (cheap check) so a failed install is retried next time.
if ! command -v mise >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
  echo "Installing mise"
  curl -fsSL https://mise.run | sh || echo "WARNING: mise install failed; mise install will be skipped until it succeeds"
fi
