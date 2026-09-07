# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Johnathon's [chezmoi](https://www.chezmoi.io/) source directory, pushed to the **public** GitHub repo `johnschultz/dotstash`. Files here are rendered and copied to `$HOME`; nothing is used in place. There is no build or test suite; verification is `chezmoi diff` / `chezmoi apply`, or a scratch-directory render (see Verification).

## Hard rule: nothing Amazon-internal

Naming Amazon and its tools (brazil, toolbox, wssh, Kiro, ada) is fine. Hostnames, ticket links, `*.amazon.com` URLs other than wildcard SSH patterns, internal brew taps, and keys are not. Machine-specific values belong in the local files chezmoi creates once (`~/.ssh/config.d/00-local.conf`) or in init prompts, never in templates. Two pre-commit hooks enforce this: gitleaks for secrets and a `pygrep` hook for internal hostname and URL patterns. Run `pre-commit run --all-files` before pushing.

## Commands

```bash
chezmoi diff                  # preview what apply would change in $HOME
chezmoi apply -v              # render templates and write to $HOME
chezmoi execute-template < dot_config/zsh/10-path.zsh.tmpl     # render one template
chezmoi execute-template --init --promptString "Email address=x@example.com" --promptBool "Work machine=false" < .chezmoi.toml.tmpl
# prompt flags are keyed by the prompt TEXT, not the data key; *Once functions also reuse values already in ~/.config/chezmoi/chezmoi.toml
chezmoi data                  # dump template variables
chezmoi managed               # list targets chezmoi controls
```

chezmoi is installed by mise (and by the bootstrap one-liner into `~/.local/bin`). Needs 2.60+ for `promptBoolOnce` defaults. Check `which -a chezmoi`: a stale copy in `~/bin` wins because `35-path` puts `~/bin` first.

## Architecture: stubs plus drop-ins

Files that installers append to are **stubs** handled by `modify_` templates: chezmoi feeds the current file in as `.chezmoi.stdin` and the template echoes it back unchanged unless the one loader line is missing, in which case it inserts it (after a Kiro/Amazon Q pre-block if present). Output equals input on a healthy file, so `chezmoi status` stays quiet no matter what Kiro CLI, AIM, WSSH, devspaces, or `git lfs install` add. On a fresh machine stdin is empty and the loader alone is written. Each stub loads managed drop-ins:

| Stub | Managed drop-ins |
|---|---|
| `modify_dot_zshrc` | `dot_config/zsh/NN-*.zsh[.tmpl]` |
| `modify_dot_bashrc`, `modify_dot_bash_profile` | `dot_config/bash/NN-*.bash[.tmpl]` |
| `private_dot_ssh/modify_private_config` | `private_dot_ssh/private_config.d/*.conf[.tmpl]` |
| `dot_config/git/modify_config` | `dot_config/git/managed.gitconfig.tmpl` |

`run_once_before_05-backup-pre-stubs.sh` copies pre-existing versions of these files to `*.pre-stubs` before the first modify runs. `~/.zprofile` and `~/.profile` stay plain `create_` comment stubs; they load nothing.

Rules that follow from this:

- New shell config goes in a numbered drop-in, never in a stub. Order matters: brew (20) and mise (30) before user-local PATH (35) and compinit (40), so `~/bin` really is first and brew's completions are on fpath.
- Stub templates must NOT have a `.tmpl` suffix: with it, chezmoi renders the file as a script template first and `.chezmoi.stdin` is undefined. The first line must be `{{- /* chezmoi:modify-template */ -}}`.
- Each stub's idempotency key is one marker substring (`/.config/zsh/*.zsh`, `Include config.d/*.conf`, `managed.gitconfig`, `.bashrc`). Keep the marker stable when editing the loader text.
- Use `regexFind` + `trimPrefix` rather than `regexReplaceAll` when splicing: the loader text contains `$HOME`, which Go regexp would expand as a group reference in a replacement string.
- Kiro, Amazon Q, AIM, smithy-mcp, rodar lines never appear in managed content. Installers own them in the stubs.
- Shell snippets shared by zsh and bash live in `.chezmoitemplates/*.sh` and are pulled in with `{{ template "name.sh" . }}` from both `dot_config/zsh` and `dot_config/bash`, so the two shells cannot drift.

## Machine facts

`.chezmoi.toml.tmpl` computes everything once from two prompts (`email`, `work`) plus `.chezmoi.os` / `.chezmoi.arch` / `.chezmoi.kernel.osrelease`:

`work`, `mac`, `linux`, `wsl`, `cloudDesktop`, `brewPrefix` (empty on arm Linux, where brew is skipped).

Templates test only these booleans. `.chezmoiignore.tmpl` drops whole files per profile (mac-only `Library/`, work-only `70-work.*` and `20-work.conf`, WSL-only `80-wsl.*`, brew files when `brewPrefix` is empty). Prefer ignoring a file over rendering it empty.

## Packages

- `dot_config/mise/config.toml` is the cross-platform installer: languages and all CLI tools via mise's aqua/ubi/go backends. `run_onchange_after_30-mise-install.sh.tmpl` re-runs `mise install` when it changes.
- `dot_config/homebrew/Brewfile.tmpl` holds only system libs and macOS casks. `run_onchange_after_20-brew-bundle.sh.tmpl` re-runs `brew bundle` when it changes.
- `run_once_before_*` install Homebrew (when `brewPrefix` is set) and mise.

## SSH auth convention

Personal hosts (`10-personal.conf`) use the 1Password agent: the mac socket on macOS, `~/.1password/agent.sock` on personal Linux, and no `IdentityAgent` on cloud desktops so the agent forwarded from the laptop is used. Amazon hosts (`20-work.conf`) use `Match host` on the resolved hostname with `IdentityFile ~/.ssh/id_ecdsa` and no `IdentitiesOnly`, so aliases in the local `00-local.conf` only need a `HostName` line and a forwarded agent still works. Agent forwarding is scoped to `dev-dsk-*` only, never `*.corp.amazon.com`; on macOS it forwards the 1Password socket explicitly via `ForwardAgent <path>`.

## Git identity

`managed.gitconfig` sets the default `user.email` from the chezmoi prompt (the work address on work machines) and then uses `includeIf "hasconfig:remote.*.url:..."` to load `johnschultz.gitconfig` for any GitHub remote (`personalgithub`, `github.com`), then `ajaxify.gitconfig` for the ajaxify account (`nofugithub` alias, `github.com/northernfreightunlimited`, `github.com/ajaxify`); later includes win. `johnschultz.gitconfig` pins the johnschultz noreply identity, SSH signing with `~/.ssh/johnschultz.pub` (via 1Password's `op-ssh-sign` on macOS, via the agent elsewhere), and `commit.gpgsign` except on WSL. `ajaxify.gitconfig` overrides only name, email and signing key (`~/.ssh/ajaxify.pub`). `allowed_signers` lists both keys so `git log --show-signature` verifies locally. History was rewritten on 2026-09-06 to unify identities and sign every commit; the pre-rewrite bundle is at `~/.local/share/dotstash-pre-rewrite-backup.bundle`.

## Other conventions

- Commit messages follow `dot_config/git/git-commit-template.txt`: lowercase imperative subject, ≤50 chars, no trailing period. Types in use: `feat:`, `fix:`, `add:`, `refactor:`.
- `.chezmoiexternal.toml` pulls `~/.config/nvim` from `johnschultz/nvim-conf`; Neovim config does not live here.
- Only non-Amazon `~/.claude/rules` are managed (`dot_claude/rules/`).

## Verification without touching $HOME

Write a config with the desired `[data]` booleans and apply into a scratch dir:

```bash
chezmoi --config /tmp/cfg.toml --persistent-state /tmp/state.db --source "$PWD" \
  --destination /tmp/home --exclude scripts,externals apply
```
