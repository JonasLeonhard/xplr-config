version = "0.21.1"

---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
---@diagnostic enable

-- xpm Package manager:
local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path .. ";" .. xpm_path .. "/?.lua;" .. xpm_path .. "/?/init.lua"
os.execute(string.format("[ -e '%s' ] || git clone '%s' '%s'", xpm_path, xpm_url, xpm_path))

-- require plugins:
require("xpm").setup({
	plugins = {

		"dtomvan/xpm.xplr",
		"sayanarijit/fzf.xplr",
		"sayanarijit/tri-pane.xplr",
		"sayanarijit/type-to-nav.xplr",
		"sayanarijit/zoxide.xplr",
		"sayanarijit/trash-cli.xplr",
		"prncss-xyz/icons.xplr",
		{
			"dtomvan/extra-icons.xplr",
			after = function()
				xplr.config.general.table.row.cols[2] = { format = "custom.icons_dtomvan_col_1" }
			end,
		},
	},
	auto_install = true,
	auto_cleanup = true,
})

require("type-to-nav").setup()

require("tri-pane").setup({
	layout_key = "T", -- In switch_layout mode
	as_default_layout = true,
	left_pane_width = { Percentage = 15 },
	middle_pane_width = { Percentage = 65 },
	right_pane_width = { Percentage = 20 },
	left_pane_renderer = nil,
	right_pane_renderer = nil,
})

require("trash-cli").setup({
	trash_bin = "trash-put",
	trash_mode = "delete",
	trash_key = "d",
	restore_bin = "trash-restore",
	restore_mode = "delete",
	restore_key = "r",
	trash_list_bin = "trash-list",
	trash_list_selector = "fzf -m | cut -d' ' -f3-",
})

require("zoxide").setup({
	bin = "zoxide",
	mode = "default",
	key = "c",
})

require("fzf").setup({
	mode = "default",
	key = "ctrl-f",
	bin = "fzf",
	args = "--preview 'pistol {}'",
	recursive = true, -- If true, search all files under $PWD
	enter_dir = false, -- Enter if the result is directory
})

-- Config:
xplr.config.general.show_hidden = true

xplr.config.general.panel_ui.default.border_type = "Plain"
xplr.config.general.panel_ui.default.border_style.fg = { Rgb = { 147, 153, 178 } }

-- Custom Commands: 'open'
xplr.config.modes.builtin.default.key_bindings.on_key.o = {
	help = "$open XPLR_FOCUS_PATH",
	messages = {
		{
			BashExecSilently0 = [===[
        PTH="${XPLR_FOCUS_PATH:?}"
        open $PTH
      ]===],
		},
	},
}
