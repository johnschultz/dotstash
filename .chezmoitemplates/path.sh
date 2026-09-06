# Runs after brew and mise so user-local binaries really do come first.
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
{{- if .work }}
export PATH="$PATH:$HOME/.toolbox/bin"
{{- end }}
