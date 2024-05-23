local M = {}
local opts = {}
local default_opts = {
	dir = "$HOME/.local/share/scratch/",
	find_prompt_icon = "",
	find_prompt_text = "Find Scratch File",
}

local fio = require("scratch.file_io")

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
	opts.dir = vim.fn.expand(opts.dir)

	fio.mkdir(opts.dir)
end

function M.create(name)
	if not name then
		vim.ui.input({ prompt = "File Name" }, function(input)
			M.create(input)
		end)
	else
		fio.write_file(opts.dir .. ".last", name)
		vim.cmd("e " .. opts.dir .. name)
	end
end

function M.open(name)
	if not name then
		name = opts.dir .. fio.read_file(opts.dir .. ".last")
	end
	vim.cmd("e " .. name)
end

function M.find()
	local ok, tl = pcall(require, "telescope.builtin")
	if not ok then
		vim.api.nvim_err_writeln("telescope not installed")
		return
	end
	local pt = opts.find_prompt_text
	if opts.find_prompt_icon ~= "" then
		pt = opts.find_prompt_icon .. " " .. pt
	end
	tl.find_files({
		prompt_title = pt,
		path_dispaly = { "smart" },
		cwd = opts.dir
	})
end

return M
