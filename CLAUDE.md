# Dotfiles — project specs

## install.sh

- **Idempotente**: ejecutarlo N veces produce el mismo resultado que ejecutarlo una vez. Cada sección debe comprobar si la acción ya está hecha antes de hacerla (`command -v`, `-d`, `-f`, comparación de versiones, etc.).
- Los symlinks se crean con `safe_stow` / `safe_link`, que hacen backup de conflictos y usan `--restow` — son idempotentes por diseño.
- Las instalaciones de paquetes externos (neovim, lazygit, eza, starship, oh-my-zsh, plugins de zsh) llevan guard `if ! command -v … / if [[ ! -d … ]]` para no reinstalar si ya están presentes.

## Gestión de dotfiles

- GNU stow para los symlinks: un directorio por bloque (`git/`, `zsh/`, `claude/`).
- `nvim/` usa `safe_link` directo (symlink a la carpeta, no a ficheros individuales).
- Backup automático en `~/.dotfiles-backup/<timestamp>/` antes de reemplazar ficheros reales.

## Compatibilidad

- macOS (Homebrew) y Linux/Debian/Raspbian (apt + binarios de GitHub Releases).
- Arquitecturas: x86_64 y aarch64.
