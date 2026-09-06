# Runs after brew so its site-functions are on fpath. -C skips the security scan of a fresh dump.
autoload -Uz compinit
compinit -C
