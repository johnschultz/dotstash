# Johnathon's Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). Public repo: keep hostnames, ticket links, and anything internal out of it. Machine-specific values go in local files that chezmoi creates once and never overwrites.

## New machine

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply johnschultz/dotstash
```

Answer the two prompts (email, work machine). The bootstrap scripts install Homebrew (macOS and x86 Linux) and mise, then `brew bundle` and `mise install` run automatically. Open a new shell. mise then keeps `chezmoi` itself current.

Afterwards, add machine-local SSH aliases to `~/.ssh/config.d/00-local.conf` and run installers (Kiro CLI, WSSH, devspaces) as usual; they append to the unmanaged stubs.

## Existing machine (set up before the stub layout)

```bash
chezmoi update --no-apply   # pull
chezmoi init                # regenerate the config; prompts once for "Work machine"
chezmoi apply -v
```

The first apply copies `~/.zshrc`, `~/.bashrc`, `~/.bash_profile`, `~/.ssh/config` and `~/.config/git/config` to `*.pre-stubs`, then inserts one loader line into each. Nothing is removed, so the old shell setup keeps working alongside the new drop-ins; prune the old body against the `.pre-stubs` copy when convenient, then delete the copies. Put dev-desk aliases in `~/.ssh/config.d/00-local.conf`.

## How it is laid out

Files that third-party installers write to are **stubs**: chezmoi only ensures a single loader line is present (`modify_` templates) and leaves the rest of the file alone. Each stub loads managed drop-ins:

| Stub (only the loader line is managed) | Loads managed content from |
|---|---|
| `~/.zshrc` | `~/.config/zsh/*.zsh` |
| `~/.bashrc`, `~/.bash_profile` | `~/.config/bash/*.bash` |
| `~/.ssh/config` | `~/.ssh/config.d/*.conf` |
| `~/.config/git/config` | `~/.config/git/managed.gitconfig` |

Machine facts (`work`, `mac`, `linux`, `wsl`, `cloudDesktop`, `brewPrefix`) are computed once in `.chezmoi.toml.tmpl`. Templates only test those booleans. `brewPrefix` is empty on arm Linux, where Homebrew is skipped and mise supplies the CLI tools.

## Packages

- `~/.config/mise/config.toml`: node, python, go, rust and all CLI tools, including `bd` (beads). Works on every OS and arch.
- `~/.config/mise/mise.lock`: committed lockfile (`locked = true`), so every host installs the same versions. Bump with `mise lock -g --bump`, then `chezmoi re-add ~/.config/mise/mise.lock`; the next apply reinstalls everywhere.
- `~/.config/homebrew/Brewfile`: system libraries and macOS apps only.
- `~/.config/terminfo/xterm-ghostty.src`: Ghostty's terminfo, compiled with `tic -x` on Linux hosts that lack it (`run_onchange_after_15-terminfo.sh`), so `TERM=xterm-ghostty` over SSH gets a working zsh line editor. Skipped on macOS, where Ghostty ships the entry.

## Work hosts: Amazon tooling and the agent kit

On work machines `run_after_40-toolbox.sh` runs on every apply. It exits with one hint when `toolbox` is missing or there is no Midway session (`mwinit -o`, then `chezmoi apply` again). Otherwise it installs `ada`, `aim`, `claude-code`, `agentspaces` and `brazilworktreecli` if they are absent from `~/.toolbox/bin`, creates the Brazil workspace `~/workplace/agent-kit-ws` (version set `live`) with the `SchultjoAgentKit` package, symlinks it to `~/workplace/agent-kit`, and runs the kit's `setup/install.sh` if present. Everything Amazon-specific (accounts, remotes, namespaces) lives in that kit, not here.

Shell drop-in `65-vault` exports `KIT_VAULT_DIR` when `~/Documents/obsidian-mind` exists, so the kit can tell a vault host from a replica host without a prompt.

## Day to day

```bash
chezmoi diff          # what apply would change
chezmoi apply -v      # apply
chezmoi cd            # edit the source
pre-commit install    # once per clone: gitleaks guard
```
