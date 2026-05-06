return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "typescript", "tsx", "javascript", "json", "jsonc",
        "python",
        "html", "css", "markdown", "markdown_inline",
        "bash", "yaml", "toml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    })
  end,
}
