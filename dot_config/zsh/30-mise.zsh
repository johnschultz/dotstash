# mise manages node, python, go and most CLI tools (see ~/.config/mise/config.toml).
# On a fresh machine mise lives only in ~/.local/bin, which 35-path has not added yet.
[ -x "$HOME/.local/bin/mise" ] && export PATH="$HOME/.local/bin:$PATH"
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
  eval "$(mise hook-env -s zsh)"   # load tool paths now, not at the first prompt, so starship is found below
fi
