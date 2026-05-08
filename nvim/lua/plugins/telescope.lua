return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",                                                               desc = "Find files" },
    { "<leader>fa", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",                                    desc = "Find all files (incl. gitignored)" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",                                                                desc = "Grep in project" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",                                                                  desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                                                desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                                                 desc = "Recent files" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "dist", ".next", "__pycache__", ".venv" },
        preview = { treesitter = false },
      },
    })
  end,
}
