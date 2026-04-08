local M = {}

M.config = {
	texts_dir = vim.fn.stdpath("data") .. "/kant-texte",
	picker = "fzf-lua",
	readonly = true,
	show_references = true,
	keymaps = {
		search = "<leader>ks",
		werke = "<leader>kw",
		zufall = "<leader>kz",
	},
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Fall back to bundled texts if texts_dir does not exist
	local bundled = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h") .. "/texts"
	if vim.fn.isdirectory(M.config.texts_dir) == 0 then
		if vim.fn.isdirectory(bundled) == 1 then
			M.config.texts_dir = bundled
		else
			vim.notify("[kant.nvim] No texts found. Please run :KantUpdate.", vim.log.levels.WARN)
			return
		end
	end

	-- Set keymaps
	local k = M.config.keymaps
	if k.search then
		vim.keymap.set("n", k.search, ":KantSearch ", { desc = "Kant: Search" })
	end
	if k.werke then
		vim.keymap.set("n", k.werke, "<cmd>KantWerke<cr>", { desc = "Kant: Works list" })
	end
	if k.zufall then
		vim.keymap.set("n", k.zufall, "<cmd>KantZufall<cr>", { desc = "Kant: Random passage" })
	end
end

return M
