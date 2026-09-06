#!/bin/sh
# One-shot safety copy of files that the modify_ templates will patch for the first time.
for f in .zshrc .bashrc .bash_profile .ssh/config .config/git/config; do
  if [ -f "$HOME/$f" ] && [ ! -f "$HOME/$f.pre-stubs" ]; then
    cp -p "$HOME/$f" "$HOME/$f.pre-stubs"
  fi
done
exit 0
