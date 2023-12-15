--package.loaded["theme2"] = nil
local util = require("theme2.util")
require("theme2").setup(
  {
    default = {
      bg       = "#000000",
      fg       = "#eeeeee",
      func     = "#FFD2A7",
      string   = util.adjust("#A8FF60", 0, -10, 0),
      field    = "#c6c5fe",
      keyword  = "#96CBFE",
      number   = util.adjust("#FF73FD", 0, -10, 0),
--      type     = util.rotate(color_base, 200),
      --search   = "#2F2F00",
--      title    = util.rotate(color_base, 180),
    },
    my_transformations = function(c)
      return {
        comment = "#7C7C7C",
        bg_cursorline = util.lighten(c.bg, 4), -- #1d1d1d
        fg = "#f6f3e8"
            }
        end,
    styles = {
      keywords = { italic = true },
      comments = { italic = true }
    }
  }
)
require("theme2").load()
