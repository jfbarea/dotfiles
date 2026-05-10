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

## Commits

- Cada commit debe ser atómico: un cambio lógico por commit, ni más ni menos.
- Si una tarea implica varios cambios independientes (p. ej. nueva feature + fix de bug + docs), usa commits separados.
- No agrupes en un único commit cosas que no están relacionadas entre sí.
- No dejes cambios a medias en un commit: el árbol debe compilar y los tests deben pasar en cada punto de la historia.

## test.sh

Ante cualquier cambio estructural en el repo debes actualizar `test.sh` con los checks correspondientes:

- Nuevo paquete en `apt-packages.txt` o `Brewfile` → añadir `check` en la sección de binarios.
- Nuevo fichero stowed (en `zsh/`, `claudeconfig/`, `git/`) → añadir `check_symlink` en la sección de symlinks.
- Nuevo agente o comando de Claude Code → añadir `check_symlink` para su ruta en `~/.claude/`.
- Nuevo campo en `settings.json` que deba garantizarse → añadir `check` con `grep` en la sección de Claude Code settings.
- Nueva función de shell añadida al rc → añadir `check` que verifique que está disponible.

Después de modificar `test.sh`, ejecuta `bash test.sh` para confirmar que todos los checks pasan antes de hacer commit.
