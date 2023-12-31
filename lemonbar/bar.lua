#!/usr/bin/lua

local lemonbar = "lemonbar -d -p -o eDP-1"
local height = 20
local outer_gap = 6
os.execute("bspc config window_gap " .. outer_gap
  .. " && bspc config top_padding " .. height + outer_gap * 2)
local font_names = "Comic Mono Nerd Font,LXGW Wen Kai Mono"
local font_size = 10

local layout = require("layout")

local x = outer_gap
local width

local function fonts(names)
  local output = ""
  for font in names:gmatch("([^,]+)") do
    output = output .. " -f \"" .. font .. "\"-" .. font_size
  end
  return output
end

local function actions(widget)
  if widget.action == nil then
    return ""
  end
  local output = ""
  if widget.action.lclick ~= nil then
    output = output .. "%{A:" .. widget.action.lclick .. ":}"
    I = I + 1
  end
  if widget.action.mclick ~= nil then
    output = output .. "%{A2:" .. widget.action.mclick .. ":}"
    I = I + 1
  end
  if widget.action.rclick ~= nil then
    output = output .. "%{A3:" .. widget.action.rclick .. ":}"
    I = I + 1
  end
  if widget.action.scrollup ~= nil then
    output = output .. "%{A4:" .. widget.action.scrollup .. ":}"
    I = I + 1
  end
  if widget.action.scrolldown ~= nil then
    output = output .. "%{A5:" .. widget.action.scrolldown .. ":}"
    I = I + 1
  end
  return output
end

for _, widget in ipairs(layout.left) do
  I = 0
  width = (2 * widget.inner_gap + widget.len) * font_size  * 1.5
  if widget.command == "lua ./workspace.lua" then
    os.execute("echo " .. x + widget.inner_gap * font_size * 1.5 / 2 .. " > ~/.config/lemonbar/.x")
    os.execute("echo " .. width - widget.inner_gap * font_size * 1.5 .. " > ~/.config/lemonbar/.width")
  end
  os.execute("while true; do echo \""
    .. actions(widget)
    .. string.rep(' ', widget.inner_gap) .. "$("
    .. widget.command
    .. ") " .. ("%{A}"):rep(I) .. "\" ; sleep "
    .. widget.interval .. "; done | "
    .. lemonbar
    .. fonts(font_names)
    .. " -F \"#"
    .. widget.color.foreground
    .. "\" -B \"#"
    .. widget.color.background
    .. "\" -g " .. ("%d"):format(width)
    .. "x" .. height
    .. "+" .. ("%d"):format(x)
    .. "+" .. outer_gap .. " &")
  x = x + width + outer_gap
end

x = 1366 - outer_gap

for _, widget in ipairs(layout.right) do
  I = 0
  width = (2 * widget.inner_gap + widget.len) * (font_size * 1.5)
  x = x - width
  os.execute("while true; do echo \""
    .. actions(widget)
    .. string.rep(' ', widget.inner_gap) .. "$("
    .. widget.command
    .. ") " .. ("%{A}"):rep(I) .. "\" ; sleep "
    .. widget.interval .. "; done | "
    .. lemonbar
    .. fonts(font_names)
    .. " -F \"#"
    .. widget.color.foreground
    .. "\" -B \"#"
    .. widget.color.background
    .. "\" -g " .. ("%d"):format(width)
    .. "x" .. height
    .. "+" .. ("%d"):format(x)
    .. "+" .. outer_gap .. " &")
  x = x - outer_gap
end
