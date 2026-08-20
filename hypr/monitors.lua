-- Personal monitor layout, loaded after Omarchy's defaults.
local dell = "desc:Dell Inc. DELL U2713H C6F0K3850JCL"

hl.env("GDK_SCALE", "2")

-- Fallback for displays that do not have a machine-specific rule below.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Keep the Dell to the left of the internal ThinkPad display.
hl.monitor({ output = dell, mode = "2560x1440@59.95", position = "0x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "2560x1440@60.01", position = "2560x480", scale = 1.6 })

for workspace = 6, 8 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = dell })
end
