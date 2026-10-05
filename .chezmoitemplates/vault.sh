# The obsidian-mind vault, when this host has it. The agent kit reads KIT_VAULT_DIR to decide
# between vault mode (beads live here) and replica mode (beads come from the remote).
[ -d "$HOME/Documents/obsidian-mind" ] && export KIT_VAULT_DIR="$HOME/Documents/obsidian-mind"
