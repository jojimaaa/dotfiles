return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<C-p>",
      LazyVim.pick("find_files", { root = false }),
      desc = "Find Files",
    },
    {
      "<leader>bf",
      LazyVim.pick("buffers"),
      desc = "Telescope buffers",
    },
    {
      "<leader>fg",
      LazyVim.pick("live_grep", { root = false }),
      desc = "Live Grep (cwd)",
    },
    {
      "<leader>fG",
      LazyVim.pick("live_grep"),
      desc = "Live Grep (Root)",
    },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },
}
