local c = require("themes/" .. "catppuccin_mocha")

local handle = assert(io.popen("xdotool get_num_desktops", "r"))
local num = assert(handle:read('*a'))
handle:close()

local widgets = {}

local theme = {
  foreground = c.white,
  background = c.yellow,
  secondary = c.green,
  fade = c.surface2,
  fade2 = c.surface0
}

widgets.battery = {
  color = {
    foreground = theme.foreground,
    background = theme.background,
  },
  action = {
    lclick = "powerprofilesctl set power-saver && dunstify -h string\\:x-dunst-stack-tag\\:power-mode Power-saver mode",
    mclick = "powerprofilesctl set balanced && dunstify -h string\\:x-dunst-stack-tag\\:power-mode Balanced mode",
    rclick = "powerprofilesctl set performance && dunstify -h string\\:x-dunst-stack-tag\\:power-mode Performance mode",
  },
  command = "./battery.sh",
  len = 2,
  interval = 10,
  inner_gap = 1,
}

widgets.workspace = {
  color = {
    foreground = theme.fade,
    background = theme.background,
    focus = theme.foreground,
    occupied = theme.secondary
  },
  action = {
    lclick = "xdotool set_desktop $(lua ./switch-workspace.lua)",
    rclick = "xdotool set_desktop_for_window $(xdotool getwindowfocus) $(lua ./switch-workspace.lua)$"
  },
  command = "lua ./workspace.lua",
  len = num + 1,--+ (num + 1) * 1,
  interval = 0.1,
  inner_gap = 1,
}

widgets.date = {
  color = {
    foreground = theme.foreground,
    background = theme.background
  },
  action = {
    lclick = "alacritty -e calcurse",
  },
  command = "echo  $(date \"+%m.%d %a\")",
  len = 6,
  interval = 10,
  inner_gap = 1,
}

widgets.time = {
  color = {
    foreground = theme.foreground,
    background = theme.background
  },
  action = {
    lclick = "alacritty -e tty-clock -s -c -C 5 -D",
  },
  command = "echo \" $(date \"+%H:%M\")\"",
  len = 4,
  interval = 1,
  inner_gap = 1,
}

widgets.volume = {
  color = {
    foreground = theme.foreground,
    background = theme.background
  },
  action = {
    lclick = "amixer set Master toggle -q",
    scrollup = "amixer set Master 5%+ -q",
    scrolldown = "amixer set Master 5%- -q"
  },
  command = "./vol.sh",
  len = 9,
  interval = 1,
  inner_gap = 1,
}

widgets.backlight = {
  color = {
    foreground = theme.foreground,
    background = theme.background
  },
  action = {
    lclick = "light -S 20",
    scrollup = "light -A 5",
    scrolldown = "light -U 5"
  },
  command = "echo  $(light -G | cut -d . -f 1)",
  len = 2,
  interval = 1,
  inner_gap = 1
}

widgets.memory = {
  color = {
    foreground = theme.foreground,
    background = theme.background
  },
  action = {
    lclick = "alacritty htop",
  },
  command = "echo  $(free -h --mega | awk '/^Mem:/ {print $3 \"/\" $2}')",
  len = 6,
  interval = 1,
  inner_gap = 1,
}

widgets.windowname = {
  color = {
    foreground = theme.secondary,
    background = theme.background
  },
  command = "echo $(xdotool getwindowfocus | xargs xdotool getwindowname | sd 'qutebrowser' 'qutebrowser' | cut -c 1-16 ) ...",
  len = 10,
  interval = 1,
  inner_gap = 1
}

widgets.wifi = {
  color = {
    foreground = theme.secondary,
    background = theme.background
  },
  action = {
    lclick = "alacritty nmtui",
  },
  command = "echo 直 $(cat /sys/class/net/w*/operstate)",
  len = 5,
  interval = 10,
  inner_gap = 1
}

widgets.music = {
  color = {
    foreground = theme.secondary,
    background = theme.background,
    control = theme.foreground,
    bar = theme.fade2
  },
  action = {
    scrollup = "playerctl position 5+",
    scrolldown = "playerctl position 5-"
  },
  command = "lua ./music.lua",
  len = 14,
  interval = 0.1,
  inner_gap = 0
}

widgets.volumebar = {
  color = {
    foreground = theme.secondary,
    background = theme.background,
    muted = theme.fade,
    high = theme.foreground,
    barbg = theme.fade2
  },
  action = {
    lclick = "amixer set Master toggle -q",
    scrollup = "amixer set Master 5%+ -q",
    scrolldown = "amixer set Master 5%- -q"
  },
  command = "lua ./volumebar.lua",
  len = 8,
  interval = 0.1,
  inner_gap = 1
}

widgets.cava = {
  color = {
    foreground = theme.foreground,
    background = theme.background
  },
  command = "lua ./cava.lua",
  len = 10,
  interval = 0,
  inner_gap = 1
}

return widgets
