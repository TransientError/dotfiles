require("bookmarks"):setup {
  last_directory = { enable = true, persist = false, mode = "dir" },
}

require("relative-motions"):setup {
  show_numbers = 'relative',
  show_motion = true,
}
