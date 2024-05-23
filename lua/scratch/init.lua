local M = {}
local opts = {}

local default_opts = {
	dir = vim.fn.getenv("HOME") .. "/.local/share/scratch/"
}

local function getSelection()
	local block = vim.fn.visualmode() == ""
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local start_row = s_start[2] - 1
	local start_col = s_start[3] - 1
	local end_row = s_end[2] - 1
	local end_col = s_end[3]
	if end_col == 2147483647 then
		end_col = end_col - 1
	end

	local lines = {}
	if block then
		for row = start_row, end_row do
			-- in visual block, we need to grab just the start_col to end_col from each line
			table.insert(lines, vim.api.nvim_buf_get_text(0, row, start_col, row, end_col, {})[1])
		end
	else
		lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
	end
	return {
		lines = lines,
		startRow = start_row,
		startCol = start_col,
		endRow = end_row,
		endCol = end_col,
		block = block
	}
end

function M.setup(user_opts)
	opts = vim.tbl_deep_extend("force", default_opts, user_opts)
	print(opts)
end

return M
