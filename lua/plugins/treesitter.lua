return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		-- nvim-treesitter v1.0: use ensure_installed in setup()
		require("nvim-treesitter").setup({
			ensure_installed = {
				"json",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"luadoc",
				"vim",
				"vimdoc",
				"query",
				"diff",
				"html",
				"c",
				"cpp",
				"cmake",
				"make",
				"python",
			},
		})

		require("nvim-ts-autotag").setup()

		-- Compatibility shims for plugins (e.g. telescope) that use old API
		local parsers = require("nvim-treesitter.parsers")
		if not parsers.ft_to_lang then
			parsers.ft_to_lang = function(ft)
				return vim.treesitter.language.get_lang(ft) or ft
			end
		end
		-- telescope previewers/utils.lua calls vim.treesitter.language.ft_to_lang
		-- which was removed in Neovim 0.11
		if vim.treesitter.language and not vim.treesitter.language.ft_to_lang then
			vim.treesitter.language.ft_to_lang = function(ft)
				return vim.treesitter.language.get_lang(ft) or ft
			end
		end
		if not package.loaded["nvim-treesitter.configs"] then
			package.preload["nvim-treesitter.configs"] = function()
				return {
					is_enabled = function()
						return false
					end,
					get_module = function()
						return {}
					end,
				}
			end
		end

		-- Textobjects: af/if=function, ac/ic=class, aa/ia=parameter
		local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
		if ok and textobjects.setup then
			textobjects.setup({
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
					goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
					goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
				},
			})
		end

		-- Incremental selection using built-in vim.treesitter API
		-- (replaces old nvim-treesitter incremental_selection config)
		local node_stack = {}

		local function select_node(node)
			local sr, sc, er, ec = node:range()
			vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
			vim.cmd("normal! v")
			vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
		end

		-- init: enter visual and select current node
		vim.keymap.set("n", "<C-space>", function()
			node_stack = {}
			local node = vim.treesitter.get_node()
			if not node then
				return
			end
			table.insert(node_stack, node)
			select_node(node)
		end, { desc = "Select current treesitter node" })

		-- expand: grow selection to parent node
		vim.keymap.set("v", "<C-space>", function()
			local node = node_stack[#node_stack]
			if not node then
				node = vim.treesitter.get_node()
				if not node then
					return
				end
			end
			local parent = node:parent()
			if parent then
				table.insert(node_stack, parent)
				select_node(parent)
			end
		end, { desc = "Expand treesitter selection" })

		-- shrink: go back to previous node
		vim.keymap.set("v", "<bs>", function()
			if #node_stack > 1 then
				table.remove(node_stack)
				select_node(node_stack[#node_stack])
			else
				vim.cmd("normal! \27") -- escape visual
			end
		end, { desc = "Shrink treesitter selection" })
	end,
}
