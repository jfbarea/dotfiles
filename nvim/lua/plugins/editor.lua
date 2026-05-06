return {
  -- File explorer that edits directories as buffers (super lightweight)
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    config = function()
      require("oil").setup({
        view_options = { show_hidden = true },
      })
    end,
  },

  -- Comment with gcc (line) / gc (visual)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  -- Auto-pairs for brackets/quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Hint popup for keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },
}
