# dotfiles

Configuración portable de Neovim, pensada para arrancar rápido en cualquier máquina nueva.

## Stack

- **lazy.nvim** — gestor de plugins (se auto-instala en el primer arranque)
- **Mason + nvim-lspconfig** — LSP para TypeScript, Python y Lua
- **Telescope** — fuzzy finder de ficheros y texto
- **Treesitter** — syntax highlighting moderno
- **nvim-cmp** — autocompletado
- **oil.nvim** — explorador de ficheros (edita directorios como buffers)
- **tokyonight** — tema

## Requisitos

- Neovim ≥ 0.10
- git
- ripgrep (`rg`) — necesario para `live_grep` de Telescope
- fd — recomendado para `find_files` de Telescope
- Node.js — necesario para los LSP de TypeScript/JavaScript
- Python ≥ 3.10 — necesario para Pyright

En macOS:

```bash
brew install neovim ripgrep fd node python
```

## Instalación

```bash
git clone https://github.com/TU_USUARIO/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

El script enlaza `nvim/` a `~/.config/nvim`. Si ya tenías una config previa, se hace backup automático con timestamp.

Al lanzar `nvim` por primera vez, lazy.nvim instala todos los plugins. Mason instala los LSP la primera vez que abras un fichero del lenguaje correspondiente.

## Atajos principales

Leader es `Espacio`.

### Ficheros
- `<leader>ff` — buscar fichero
- `<leader>fg` — buscar texto en proyecto (live grep)
- `<leader>fb` — buscar buffer abierto
- `<leader>fr` — ficheros recientes
- `-` — abrir explorador en directorio actual (oil)

### Edición
- `<leader>w` — guardar
- `<leader>q` — salir
- `<leader>p` — pegar sin sobrescribir el registro
- `gcc` — comentar línea (`gc` en visual)

### LSP (al abrir un fichero con servidor activo)
- `gd` — ir a definición
- `gr` — ver referencias
- `K` — hover (documentación)
- `<leader>rn` — renombrar símbolo
- `<leader>ca` — code action
- `[d` / `]d` — diagnóstico anterior / siguiente

### Ventanas
- `<C-h/j/k/l>` — moverse entre splits

## Estructura

```
dotfiles/
├── README.md
├── install.sh
└── nvim/
    ├── init.lua              # entry point
    └── lua/
        ├── config/
        │   ├── options.lua   # opciones de vim
        │   ├── keymaps.lua   # atajos generales
        │   └── lazy.lua      # bootstrap del gestor de plugins
        └── plugins/          # un fichero por categoría
            ├── colorscheme.lua
            ├── telescope.lua
            ├── treesitter.lua
            ├── lsp.lua
            ├── completion.lua
            ├── editor.lua
            └── ui.lua
```

## Cómo extenderlo

Para añadir un plugin nuevo, crea un fichero en `nvim/lua/plugins/`:

```lua
return {
  "autor/plugin",
  event = "VeryLazy",
  config = function()
    require("plugin").setup({})
  end,
}
```

`lazy.nvim` los descubre automáticamente gracias al `import = "plugins"` en `lazy.lua`.

## Ideas para más adelante

- **conform.nvim** + **nvim-lint** — formateo (Prettier, Black, stylua) y linters al guardar
- **nvim-dap** — debugger integrado
- **flash.nvim** — saltos rápidos al estilo easymotion
- Mover `~/.config/zsh`, `~/.config/git`, `~/.tmux.conf`, etc. a este mismo repo y extender `install.sh` para enlazar todo

## Crear el repo

Desde el directorio descomprimido:

```bash
cd ~/dotfiles
git init
git add .
git commit -m "init: configuración base de Neovim"
gh repo create dotfiles --public --source=. --remote=origin --push
```
