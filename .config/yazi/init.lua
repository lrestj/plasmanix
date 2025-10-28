require("bookmarks"):setup({
	last_directory = { enable = true, persist = false },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	notify = {
		enable = true,
		timeout = 2,
		message = {
			new = "Nová záložka '<key>' -> '<folder>'",
			delete = "Záložka '<key>' vymazána",
			delete_all = "Záložky vymazány",
		},
	},
})
