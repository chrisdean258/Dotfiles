from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "st"

def togglegroup(qtile):
    other = cur_group_partner(qtile)
    qtile.current_group.screen.set_group(other)

def cur_group_partner(qtile):
    return qtile.groups[int(qtile.current_group.name) ^ 1]

def sendit(qtile):
    other = cur_group_partner(qtile)
    qtile.current_window.togroup(other.name)

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "Escape", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "p", lazy.spawn("dmenu_run"), desc="Run command launcher"),

    Key([mod], "g", lazy.spawn("browser"), desc="Run firefox"),
    Key([mod], "Tab", lazy.function(togglegroup), desc="Toggle group"),
    Key([mod, "shift"], "Tab", lazy.function(sendit), desc="Toggle window group"),
]


groups = [Group(i) for i in "01"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )
layout_theme = {
    "border_width": 1,
    "margin": 0,
    "border_focus": "002a3b",
    "border_normal": "222222",
}


class DWM(layout.Tile):
    @property
    def master_length(self):
        return 1 + (len(self.clients) >= 4)

    @master_length.setter
    def master_length(self, value):
        pass


class FriendlyMax(layout.Max):
    def configure(self, *args, **kwargs):
        super().configure(*args, **kwargs)
        if len(self.clients) == 1:
            self.group.qtile.cmd_next_layout()

layouts = [
    DWM(**layout_theme, ratio=0.5),
    FriendlyMax(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

class BatteryFmt:
    def format(self, percent, char, hour, min, *args, **kwargs):
        # {'char': 'V', 'percent': 0.46375753149534416, 'watt': 10.294998, 'hour': 2, 'min': 43}
        percent = round(percent * 100)
        num = percent // 10
        bat = f"[{'░'*num}{' '*(10-num)}]"
        if percent == 100:
            return f"{bat} {percent}%"
        time = f"{hour}:{min}"
        charging = "remaining" if char == 'V' else "until charged"
        return f"{bat} {percent}% ({time} {charging})"

def CmdTextBox(cmd, *args, **kwargs):
    rv = widget.TextBox(*args, **kwargs)
    rv.add_callbacks( { "Button1": lazy.spawn(cmd) })
    return rv

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.WindowName(foreground="000000"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),

                CmdTextBox("st -e vim /home/chris/.config/qtile/config.py", "Config"),
                widget.TextBox("|"),
                CmdTextBox("st -e tail -f /home/chris/.local/share/qtile/qtile.log", "Errors"),
                widget.TextBox("|"),
                widget.Battery(format=BatteryFmt(), show_short_text=False),
                widget.TextBox("|"),
                widget.Clock(format="%Y-%m-%d %H:%M"),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
