return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
  },
  opts = function(_, opts)
    local actions = require("diffview.actions")
    local noop = function() end

    -- diffview default binds `<leader>e` (focus_files) and `<leader>b`
    -- (toggle_files) buffer-local inside its panels, clobbering
    -- Neo-tree toggle and buffer keymaps while a diffview buffer is
    -- focused. Free those two keys and move the actions elsewhere.
    local override = {
      { "n", "<leader>e", noop },
      { "n", "<leader>b", noop },
      { "n", "<leader>gwf", actions.focus_files, { desc = "Diffview: Focus File Panel" } },
      { "n", "<leader>gwb", actions.toggle_files, { desc = "Diffview: Toggle File Panel" } },
    }

    opts.keymaps = opts.keymaps or {}
    for _, panel in ipairs({ "view", "file_panel", "file_history_panel" }) do
      opts.keymaps[panel] = vim.list_extend(opts.keymaps[panel] or {}, override)
    end

    -- diffview default binds conflict-resolution under `<leader>c*`
    -- (co/ca/cA collide with LazyVim LSP: Organize Imports, Code
    -- Action, Source Action). Only `view` carries the single-file
    -- variants; move the whole group to `<leader>gc*`.
    opts.keymaps.view = vim.list_extend(opts.keymaps.view, {
      { "n", "<leader>co", noop },
      { "n", "<leader>ct", noop },
      { "n", "<leader>cb", noop },
      { "n", "<leader>ca", noop },
      { "n", "<leader>cO", noop },
      { "n", "<leader>cT", noop },
      { "n", "<leader>cB", noop },
      { "n", "<leader>cA", noop },
      { "n", "<leader>gco", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
      { "n", "<leader>gct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
      { "n", "<leader>gcb", actions.conflict_choose("base"), { desc = "Choose BASE" } },
      { "n", "<leader>gca", actions.conflict_choose("all"), { desc = "Choose ALL" } },
      { "n", "<leader>gcO", actions.conflict_choose_all("ours"), { desc = "Choose OURS (whole file)" } },
      { "n", "<leader>gcT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS (whole file)" } },
      { "n", "<leader>gcB", actions.conflict_choose_all("base"), { desc = "Choose BASE (whole file)" } },
      { "n", "<leader>gcA", actions.conflict_choose_all("all"), { desc = "Choose ALL (whole file)" } },
    })

    -- file_panel also ships the whole-file conflict variants (cO/cT/cB/cA);
    -- no LSP client attaches there, but keep it consistent with `view`.
    opts.keymaps.file_panel = vim.list_extend(opts.keymaps.file_panel, {
      { "n", "<leader>cO", noop },
      { "n", "<leader>cT", noop },
      { "n", "<leader>cB", noop },
      { "n", "<leader>cA", noop },
      { "n", "<leader>gcO", actions.conflict_choose_all("ours"), { desc = "Choose OURS (whole file)" } },
      { "n", "<leader>gcT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS (whole file)" } },
      { "n", "<leader>gcB", actions.conflict_choose_all("base"), { desc = "Choose BASE (whole file)" } },
      { "n", "<leader>gcA", actions.conflict_choose_all("all"), { desc = "Choose ALL (whole file)" } },
    })
  end,
}
