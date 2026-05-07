#!/usr/bin/env bash
# Verifica que la instalación de dotfiles esté completa. Ejecutar después de install.sh.
set -uo pipefail

CYN='\033[0;36m'; GRN='\033[0;32m'; YEL='\033[1;33m'; RED='\033[0;31m'
BOLD='\033[1m'; RST='\033[0m'

PASS=0; FAIL=0; SKIP=0
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
[[ "$OS" == "Darwin" ]] && PLATFORM="macos" || PLATFORM="linux"

section() { echo -e "\n${BOLD}${CYN}── $* ──${RST}"; }

check() {
  local desc="$1"; shift
  if "$@" &>/dev/null; then
    echo -e "  ${GRN}✓${RST} $desc"
    PASS=$((PASS + 1))
  else
    echo -e "  ${RED}✗${RST} $desc"
    FAIL=$((FAIL + 1))
  fi
}

check_symlink() {
  local desc="$1" dst="$2" src="$3"
  # readlink -f resolves relative symlinks (stow creates relative paths) to absolute
  local resolved; resolved="$(readlink -f "$dst" 2>/dev/null || true)"
  if [[ -L "$dst" && "$resolved" == "$src" ]]; then
    echo -e "  ${GRN}✓${RST} $desc"
    PASS=$((PASS + 1))
  else
    local raw; raw="$(readlink "$dst" 2>/dev/null || echo 'no es symlink')"
    echo -e "  ${RED}✗${RST} $desc  (resuelve a: ${resolved:-$raw})"
    FAIL=$((FAIL + 1))
  fi
}

skip() { echo -e "  ${YEL}~${RST} $1 ($2)"; SKIP=$((SKIP + 1)); }

# ── 1. Binarios básicos (apt / brew) ──────────────────────────────────────────
section "Binarios básicos"
for bin in git zsh tmux fzf rg jq stow node npm curl wget gh zoxide htop tree; do
  check "$bin" command -v "$bin"
done
check "bat (bat o batcat)"  bash -c 'command -v bat &>/dev/null || command -v batcat &>/dev/null'
check "fd  (fd o fdfind)"   bash -c 'command -v fd  &>/dev/null || command -v fdfind  &>/dev/null'

# ── 2. Binarios de GitHub Releases ────────────────────────────────────────────
section "Binarios de GitHub Releases"
for bin in nvim delta lazygit eza starship tldr; do
  check "$bin" command -v "$bin"
done

nvim_version_ok() {
  local min="0.11.0" ver
  ver=$(nvim --version 2>/dev/null | head -1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  [[ -n "$ver" ]] && printf '%s\n%s\n' "$min" "$ver" | sort -V | head -1 | grep -qx "$min"
}
check "nvim >= 0.11.0" nvim_version_ok

# ── 3. Wrappers ~/.local/bin (solo Linux) ─────────────────────────────────────
if [[ "$PLATFORM" == "linux" ]]; then
  section "Wrappers ~/.local/bin"
  if command -v batcat &>/dev/null; then
    check "~/.local/bin/bat → batcat" test -L "$HOME/.local/bin/bat"
  else
    skip "~/.local/bin/bat" "batcat no instalado"
  fi
  if command -v fdfind &>/dev/null; then
    check "~/.local/bin/fd → fdfind" test -L "$HOME/.local/bin/fd"
  else
    skip "~/.local/bin/fd" "fdfind no instalado"
  fi
fi

# ── 4. Oh My Zsh ──────────────────────────────────────────────────────────────
section "Oh My Zsh"
check "~/.oh-my-zsh existe"               test -d "$HOME/.oh-my-zsh"
check "plugin zsh-autosuggestions"        test -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
check "plugin zsh-syntax-highlighting"   test -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

default_shell_is_zsh() {
  if [[ "$PLATFORM" == "linux" ]]; then
    getent passwd "$USER" | cut -d: -f7 | grep -q zsh
  else
    dscl . -read "/Users/$USER" UserShell 2>/dev/null | grep -q zsh
  fi
}
check "shell por defecto es zsh" default_shell_is_zsh

# ── 5. Symlinks de dotfiles ───────────────────────────────────────────────────
section "Symlinks de dotfiles"
check_symlink "~/.gitconfig"                   "$HOME/.gitconfig"                    "$DOTFILES/git/.gitconfig"
check_symlink "~/.gitignore_global"            "$HOME/.gitignore_global"             "$DOTFILES/git/.gitignore_global"
check_symlink "~/.config/nvim"                 "$HOME/.config/nvim"                  "$DOTFILES/nvim"
check_symlink "~/.zshrc"                       "$HOME/.zshrc"                        "$DOTFILES/zsh/.zshrc"
check_symlink "~/.claude/settings.json"        "$HOME/.claude/settings.json"         "$DOTFILES/claudeconfig/.claude/settings.json"
check_symlink "~/.claude/hooks/notify-stop.sh" "$HOME/.claude/hooks/notify-stop.sh"  "$DOTFILES/claudeconfig/.claude/hooks/notify-stop.sh"

# ── 6. Permisos ───────────────────────────────────────────────────────────────
section "Permisos de ficheros"
check "~/.claude/hooks/notify-stop.sh ejecutable" test -x "$HOME/.claude/hooks/notify-stop.sh"

# ── 7. Configuración de git ───────────────────────────────────────────────────
section "Git config (~/.gitconfig)"
check "user.name = Fran"                  bash -c '[[ "$(git config --global user.name)" == "Fran" ]]'
check "user.email = jfcobarea@gmail.com"  bash -c '[[ "$(git config --global user.email)" == "jfcobarea@gmail.com" ]]'
check "core.pager = delta"                bash -c '[[ "$(git config --global core.pager)" == "delta" ]]'
check "init.defaultBranch = main"         bash -c '[[ "$(git config --global init.defaultBranch)" == "main" ]]'
check "pull.rebase = true"                bash -c '[[ "$(git config --global pull.rebase)" == "true" ]]'

# ── 8. Contenido de .zshrc ────────────────────────────────────────────────────
section "Contenido de ~/.zshrc"
check "carga oh-my-zsh"          grep -q 'source.*oh-my-zsh.sh' "$HOME/.zshrc"
check "~/.local/bin en PATH"     grep -q '\.local/bin'          "$HOME/.zshrc"
check "init starship"            grep -q 'starship init'         "$HOME/.zshrc"
check "init zoxide"              grep -q 'zoxide init'           "$HOME/.zshrc"
check "NTFY_TOPIC definido"      grep -q 'NTFY_TOPIC'            "$HOME/.zshrc"

# ── 9. Remote del repo de dotfiles ────────────────────────────────────────────
section "Remote de dotfiles"
dotfiles_remote_is_ssh() {
  local url
  url="$(git -C "$DOTFILES" remote get-url origin 2>/dev/null)"
  [[ "$url" == git@github.com:* ]]
}
check "remote usa SSH (git@github.com)" dotfiles_remote_is_ssh

# ── Resumen ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}── Resultado ────────────────────────────────────────────${RST}"
echo -e "  ${GRN}✓ $PASS pasados${RST}   ${RED}✗ $FAIL fallidos${RST}   ${YEL}~ $SKIP omitidos${RST}"
echo ""
if [[ $FAIL -gt 0 ]]; then
  echo -e "  ${RED}Hay tests fallidos. Vuelve a ejecutar ./install.sh para intentar corregirlos.${RST}"
  exit 1
fi
echo -e "  ${GRN}Todos los checks pasaron.${RST}"
