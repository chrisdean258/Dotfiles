#!/usr/bin/env python3
from functools import wraps
from typing import List  # noqa: F401

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
import os
import subprocess

mod = "mod4"
terminal = "st"


def matching_group(qtile, group=None):
    group = group or qtile.current_group
    idx = qtile.groups.index(group) ^ 1
    return qtile.groups[idx]


def toggle_groups(qtile):
    other = matching_group(qtile)
    qtile.current_group.screen.set_group(other)


def sendit(qtile):
    other = matching_group(qtile)
    qtile.current_window.togroup(other.name)


m_ = [mod]
ms = [mod, "shift"]
mc = [mod, "control"]
mcs = [mod, "control", "shift"]
mods = [m_, ms, mc, mcs]

applications = {
    "Return": "st",
    "p": ("dmenu_run", "dmenu_pass"),
    "g": ("browser", "browser --private-window"),
    "v": ("vol -5%", "vol +5%"),
    "b": ("bt", "bt -d", "bt h21", "bt wh"),
    "d": ("discord", "d"),
    "a": "audio",
}

try:
    num_screens = int(
        subprocess.check_output(
            "xrandr | grep ' connected' | wc -l", shell=True, timeout=1
        )
    )
except Exception:
    num_screens = 2


groups = [Group(str(i + 1)) for i in range(num_screens * 2)]

keys = [
    Key(["mod4"], "k", lazy.layout.down()),
    Key(m_, "j", lazy.layout.up()),
    Key(mc, "k", lazy.layout.shuffle_down()),
    Key(mc, "j", lazy.layout.shuffle_up()),
    Key(m_, "Tab", lazy.function(toggle_groups)),
    Key(ms, "Tab", lazy.function(sendit)),
    Key(m_, "l", lazy.layout.increase_ratio()),
    Key(m_, "h", lazy.layout.decrease_ratio()),
    Key(ms, "Return", lazy.layout.toggle_split()),
    Key(m_, "space", lazy.next_layout()),
    Key(m_, "Escape", lazy.window.kill()),
    Key(mc, "r", lazy.restart()),
    Key(mc, "q", lazy.shutdown()),
    Key(m_, "f", lazy.window.toggle_floating()),
    Key([], "F11", lazy.group["scratchpad"].dropdown_toggle("calculator")),
    Key([], "F12", lazy.group["scratchpad"].dropdown_toggle("st")),
    Key(m_, "s", lazy.group["scratchpad"].dropdown_toggle("spotify")),
]
for k, cmds in applications.items():
    if isinstance(cmds, str):
        cmds = (cmds,)
    for m, cmd in zip(mods, cmds):
        if cmd is not None:
            keys.append(Key(m, k, lazy.spawn(cmd)))


for group in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                group.name,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            Key(
                [mod, "shift"],
                group.name,
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    group.name),
            ),
            Key(
                [mod, "control"],
                group.name,
                lazy.window.togroup(group.name),
                desc="Move focused window to group {}".format(group.name),
            ),
        ]
    )

layout_theme = {
    "border_width": 1,
    "margin": 0,
    "border_focus": "121212",
    "border_normal": "000000",
}

groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown("calculator", "st -e ipython3"),
            DropDown("st", "st"),
            DropDown(
                "spotify",
                "spotify",
                x=0.05,
                y=0,
                width=0.9,
                height=0.9,
            ),
        ],
    )
)


class DWM(layout.Tile):
    def configure(self, *args, **kwargs):
        expt = 1 + (len(self.clients) >= 4)
        if self.master != expt:
            self.master = expt
            self.group.layout_all()
        super().configure(*args, **kwargs)


class FriendlyMax(layout.Max):
    def configure(self, *args, **kwargs):
        super().configure(*args, **kwargs)
        if len(self.clients) == 1:
            self.group.qtile.cmd_next_layout()


layouts = [
    DWM(**layout_theme, ratio=0.5),
    FriendlyMax(**layout_theme),
]

widget_defaults = {
    "font": "monospace",
    "fontsize": 12,
    "padding": 3,
    "foreground": "#5d5d5d",
}
extension_defaults = widget_defaults.copy()


def edit_config(qtile):
    cmd = """cp ~/.config/qtile/config.py ~/temp_config.py
            st -e vim ~/.config/qtile/config.py
            diff ~/temp_config.py ~/.config/qtile/config.py || qtile-cmd -o cmd -f restart
            rm ~/temp_config.py
            """
    qtile.cmd_spawn(cmd, shell=True)


def xsession_errors(qtile):
    cmd = "st -e tail -c+1 -f ~/.xsession-errors"
    qtile.cmd_spawn(cmd, shell=True)


def build_string(self, status):
    hours = status.time // 3600
    minutes = (status.time // 60) % 60
    percent = status.percent
    blocks = int(percent * 10)

    time = "" if status.time <= 0 else f" ({hours}:{minutes:02})"
    icon = "[" + ("░" * blocks).ljust(10) + "]"
    percent = f"{int(percent * 100)}%"

    return f" |  {icon} {percent}{time}  | "


b = widget.Battery(**widget_defaults)
b.build_string = build_string.__get__(b)


class CScreen(Screen):
    def __init__(self, *args, default_group=None, **kwargs):
        super().__init__(*args, **kwargs)
        self.default_group = default_group

    def _configure(self, *args, **kwargs):
        super()._configure(*args, **kwargs)
        if self.default_group is not None and self.group.name != self.default_group:
            group = self.qtile.groups_map.get(self.default_group)
            self.set_group(group)


screens = [
    CScreen(
        default_group="1",
        bottom=bar.Bar(
            widgets=[
                widget.GroupBox(**widget_defaults),
                widget.Prompt(**widget_defaults),
                widget.WindowName(foreground="#000000"),
                widget.TextBox(
                    "Configure  | ",
                    name="default",
                    mouse_callbacks={"Button1": edit_config},
                    **widget_defaults,
                ),
                widget.TextBox(
                    "Errors  |",
                    name="default",
                    mouse_callbacks={"Button1": xsession_errors},
                    **widget_defaults,
                ),
                widget.Backlight(
                    backlight_name="intel_backlight", **widget_defaults),
                b,
                widget.Clock(format="%Y-%m-%d %a %I:%M %p", **widget_defaults),
            ],
            size=24,
        ),
    ),
] + [
    CScreen(
        default_group=str(2 * i + 3),
        bottom=bar.Bar(
            widgets=[
                widget.GroupBox(**widget_defaults),
                widget.Prompt(**widget_defaults),
                widget.WindowName(foreground="#000000"),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p", **widget_defaults),
            ],
            size=24,
        ),
    )
    for i in range(num_screens - 1)
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


handled = False


@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    global handled
    if handled:
        return
    handled = True
    os.system("monitor --no4k")
    qtile.call_soon(qtile.cmd_restart)


dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False


def log(f):
    @wraps(f)
    def _(*a, **kw):

        print(f"{f.__name__}(*{repr(a)}, **{repr(kw)})", end=" ")
        rtn = f(*a, **kw)
        print("=", rtn, flush=True)
        return rtn

    return _


def zoom(name, cls, role):
    if name == "zoom" and cls == ("zoom", "zoom"):
        return False
    return "zoom" in cls and not name.startswith(("Zoom", "Settings"))


floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        {"wmclass": "confirm"},
        {"wmclass": "dialog"},
        {"wmclass": "download"},
        {"wmclass": "error"},
        {"wmclass": "file_progress"},
        {"wmclass": "notification"},
        {"wmclass": "splash"},
        {"wmclass": "toolbar"},
        {"wmclass": "gcr-prompter"},
        {"wmclass": "confirmreset"},  # gitk
        {"wmclass": "makebranch"},  # gitk
        {"wmclass": "maketag"},  # gitk
        {"wname": "branchdialog"},  # gitk
        {"wname": "pinentry"},  # GPG key password entry
        {"wmclass": "ssh-askpass"},  # ssh-askpass
        {"wname": "Discord Updater"},  # Discord
        {"wname": "zoom"},  # Zoom
        {"wmclass": "Zoom"},  # Zoom
        {"match": zoom},
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"
