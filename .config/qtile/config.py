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
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "st"


def matching_group(qtile, group=None):
    group = group or qtile.current_group
    idx = qtile.groups.index(group)
    idx = (idx + len(qtile.groups) // 2) % len(qtile.groups)
    return qtile.groups[idx]


def toggle_groups(qtile):
    other = matching_group(qtile)
    qtile.current_group.screen.set_group(other)


def sendit(qtile):
    other = matching_group(qtile)
    qtile.current_window.togroup(other.name)


keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "j", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "control"], "j", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Switch window focus to other pane(s) of stack
    Key([mod], "Tab", lazy.function(toggle_groups),
        desc="Switch focus to matching group for screen"),
    Key([mod, "shift"], "Tab", lazy.function(sendit),
        desc="Send window to matching group in screen"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "p", lazy.spawn("dmenu_run"), desc="Run launcher"),

    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "Escape", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),

    Key([mod], "g", lazy.spawn("chrome"), desc="Opens Chrome"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggels whether a window is floating"),
    Key([mod], "v", lazy.spawn("vol -5%"), desc="Lower the volume"),
    Key([mod, "shift"], "v", lazy.spawn("vol +5%"), desc="Raise the volume"),

]


g1 = [Group(i) for i in "12"]
g2 = [Group(chr(ord(i.name) + len(g1))) for i in g1]

groups = g1 + g2
for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),

        Key([mod, "control"], i.name, lazy.window.togroup(i.name),
            desc="Move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

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


screens = [
    Screen(
        bottom=bar.Bar(
            widgets=[
                widget.GroupBox(**widget_defaults),
                widget.Prompt(**widget_defaults),
                widget.WindowName(foreground="#000000"),
                widget.TextBox("Configure", name="default",
                               mouse_callbacks={"Button1": edit_config},
                               **widget_defaults),
                widget.Backlight(backlight_name="intel_backlight", **widget_defaults),
                b,
                widget.Clock(format='%Y-%m-%d %a %I:%M %p', **widget_defaults),
            ],
            size=24,
        ),
    ),
    Screen(
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


@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    qtile.cmd_restart()


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
    {'match': lambda name, cls, r: "zoom" in cls and not name.startswith("Zoom")},
])
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"
