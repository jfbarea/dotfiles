return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "typescript", "tsx", "javascript", "json", "jsonc",
        "python",
        "html", "css", "markdown", "markdown_inline",
        "bash", "yaml", "toml",
      },
      auto_install = true,
    })
  end,
}
