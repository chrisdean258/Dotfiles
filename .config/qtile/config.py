# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
import os

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
    "g": ("browser", "browser --incognito"),
    "v": ("vol -5%", "vol +5%"),
    "b": "bt",
    "d": "discord",
}

groups = [Group(i) for i in "1234"]

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
]
for k, cmds in applications.items():
    if isinstance(cmds, str):
        cmds = (cmds,)
    for m, cmd in zip(mods, cmds):
        keys.append(Key(m, k, lazy.spawn(cmd)))


for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        Key([mod, "control"], i.name, lazy.window.togroup(i.name),
            desc="Move focused window to group {}".format(i.name)),
    ])

groups.append(ScratchPad("scratchpad", [
    DropDown("calculator", "gnome-calculator -m advanced",
             width=0.304167, height=0.5, x=(1 - 0.304167) / 2,),
    DropDown("st", "st"),
]))

layout_theme = {
    "border_width": 1,
    "margin": 2,
    "border_focus": "121212",
    "border_normal": "000000"
}


class DWM(layout.Tile):
    def configure(self, *args, **kwargs):
        expt = 2 if len(self.clients) >= 4 else 1
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
    'font': 'monospace',
    'fontsize': 12,
    'padding': 3,
    'foreground': '#5d5d5d'
}
extension_defaults = widget_defaults.copy()


def edit_config(qtile):
    cmd = "st -e vim ~/.config/qtile/config.py && qtile-cmd -o cmd -f restart"
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
    icon = "[" + ('░' * blocks).ljust(10) + "]"
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
        default_group='1',
        bottom=bar.Bar(
            widgets=[
                widget.GroupBox(**widget_defaults),
                widget.Prompt(**widget_defaults),
                widget.WindowName(foreground="#000000"),
                widget.TextBox("Configure  | ", name="default",
                               mouse_callbacks={"Button1": edit_config},
                               **widget_defaults),
                widget.TextBox("Errors  | ", name="default",
                               mouse_callbacks={"Button1": xsession_errors},
                               **widget_defaults),
                widget.Backlight(backlight_name="intel_backlight", **widget_defaults),
                b,
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', **widget_defaults),
            ],
            size=24,
        ),
    ),
    CScreen(
        default_group='3',
        bottom=bar.Bar(
            widgets=[
                widget.GroupBox(**widget_defaults),
                widget.Prompt(**widget_defaults),
                widget.WindowName(foreground="#000000"),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', **widget_defaults),
            ],
            size=24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
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


floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
    {'wname': 'Discord Updater'},  # Discord
    {'match': lambda name, cls, r: "zoom" in cls and not name.startswith(("Zoom", "Settings"))},
])
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"
