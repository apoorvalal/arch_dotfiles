-- Compact personal look and fully opaque application windows.
hl.config({
  general = {
    gaps_in = 1,
    gaps_out = 1,
    border_size = 1,
  },

  decoration = {
    active_opacity = 1.0,
    inactive_opacity = 1.0,
  },
})

-- Keep the custom command runner compact and centered.
o.window("^org\\.omarchy\\.runner$", {
  float = true,
  center = true,
  size = { 900, 260 },
})

-- Override Omarchy's default opacity multipliers with exact full opacity.
local opaque = "1 override 1 override"
o.window({ tag = "default-opacity" }, { opacity = opaque })
o.window({ tag = "terminal" }, { opacity = opaque })
o.window({ tag = "chromium-based-browser" }, { opacity = opaque })
o.window({ tag = "firefox-based-browser" }, { opacity = opaque })
