-- Personal bindings ported from the pre-Quattro Hyprland configuration.

local function rebind(keys, description, dispatcher, options)
  hl.unbind(keys)
  o.bind(keys, description, dispatcher, options)
end

-- Vim-style focus. SUPER+J, SUPER+K, and SUPER+L previously used Omarchy's
-- split toggle, keybinding viewer, and workspace-layout toggle.
rebind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))
rebind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))
rebind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))
rebind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))

-- Safer close shortcut. SUPER+W previously closed the active window.
hl.unbind("SUPER + W")
rebind("SUPER + SHIFT + Q", "Close active window", hl.dsp.window.close())

-- Autorice launchers. SUPER+CTRL+SPACE previously opened the background picker.
rebind(
  "SUPER + CTRL + SPACE",
  "Ephemeral terminal",
  'uwsm-app -- env AUTORICE_EPHEMERAL_TERMINAL=1 xdg-terminal-exec --title="Ephemeral Terminal" --dir="$(omarchy-cmd-terminal-cwd)"'
)
rebind("SUPER + CTRL + ALT + SPACE", "Command runner", "cli-runner")

-- Window and group management.
rebind("SUPER + SLASH", "Toggle split", hl.dsp.layout("togglesplit"))
rebind("SUPER + SHIFT + SLASH", "Show key bindings", "omarchy-menu-keybindings")
rebind("SUPER + T", "Toggle group (tabbed mode)", hl.dsp.group.toggle())

rebind("SUPER + CTRL + SHIFT + LEFT", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
rebind("SUPER + CTRL + SHIFT + RIGHT", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
rebind("SUPER + CTRL + SHIFT + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
rebind("SUPER + CTRL + SHIFT + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

rebind("SUPER + CTRL + SHIFT + COMMA", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
rebind("SUPER + CTRL + SHIFT + PERIOD", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))

-- SUPER+SHIFT+LEFT/RIGHT previously swapped windows in Omarchy.
rebind("SUPER + SHIFT + LEFT", "Move window to group left", hl.dsp.window.move({ into_group = "l" }))
rebind("SUPER + SHIFT + RIGHT", "Move window to group right", hl.dsp.window.move({ into_group = "r" }))
rebind("SUPER + SHIFT + H", "Move window to group left", hl.dsp.window.move({ into_group = "l" }))
rebind("SUPER + SHIFT + L", "Move window to group right", hl.dsp.window.move({ into_group = "r" }))

-- SUPER+ALT+LEFT/RIGHT previously moved windows into groups in Omarchy.
rebind("SUPER + ALT + H", "Switch to previous tab in group", hl.dsp.group.prev())
rebind("SUPER + ALT + L", "Switch to next tab in group", hl.dsp.group.next())
rebind("SUPER + ALT + LEFT", "Switch to previous tab in group", hl.dsp.group.prev())
rebind("SUPER + ALT + RIGHT", "Switch to next tab in group", hl.dsp.group.next())

-- SUPER+SHIFT+E previously opened email; SUPER+SHIFT+S opened Google Maps.
rebind("SUPER + SHIFT + E", "Move window out of group", hl.dsp.window.move({ out_of_group = true }))
rebind("SUPER + SHIFT + S", "Move to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- SUPER+S already toggles the scratchpad in Omarchy's defaults.

-- SUPER+C previously performed universal copy; SUPER+O popped and pinned.
rebind("SUPER + C", "Center floating window", hl.dsp.window.center())
rebind("SUPER + Z", "Pin window on top", hl.dsp.window.pin())

rebind("SUPER + SHIFT + CTRL + L", "Resize wider", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
rebind("SUPER + SHIFT + CTRL + H", "Resize narrower", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
rebind("SUPER + SHIFT + CTRL + K", "Resize shorter", hl.dsp.window.resize({ x = 0, y = -10, relative = true }))
rebind("SUPER + SHIFT + CTRL + J", "Resize taller", hl.dsp.window.resize({ x = 0, y = 10, relative = true }))

-- Applications. Existing Omarchy bindings are explicitly removed where these
-- keys had a different v4 action.
rebind("SUPER + RETURN", "Terminal", { launch = "ghostty" })
-- SUPER+SHIFT+RETURN already launches the default browser.
rebind("SUPER + F", "File manager", { launch = "nautilus --new-window" })
rebind("SUPER + B", "Browser", "omarchy-launch-browser")
rebind("SUPER + SHIFT + B", "Browser (private)", "omarchy-launch-browser --private")
rebind("SUPER + M", "Music", "omarchy-launch-or-focus spotify")
rebind("SUPER + N", "Editor", "omarchy-launch-editor")
rebind("SUPER + SHIFT + T", "Terminal 2", { launch = "alacritty" })
rebind("SUPER + ALT + T", "Activity", { tui = "btop" })
rebind("SUPER + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })

-- Web apps. SUPER+G, SUPER+SHIFT+C, and SUPER+SHIFT+G previously controlled
-- grouping, Calendar, and Signal in Omarchy's defaults.
rebind("SUPER + G", "GitHub", { webapp = "https://github.com/" })
rebind("SUPER + SHIFT + C", "Claude", { webapp = "https://claude.ai/new" })
rebind("SUPER + SHIFT + G", "Gemini", { webapp = "https://aistudio.google.com/prompts/new_chat" })
rebind("SUPER + Y", "YouTube", { webapp = "https://www.youtube.com" })
rebind("SUPER + SHIFT + R", "Radio", { webapp = "https://www.lalten.org/radio" })
