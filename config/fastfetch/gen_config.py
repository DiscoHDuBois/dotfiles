import getpass
import json
import socket
import sys

out = sys.argv[1]
K, V = 14, 30
TOT = K + 1 + V + 2
R, W, D = "{#94}", "{#94}", "{#90}"

top = "╭" + "─" * (TOT - 2) + "╮"
bot = "╰" + "─" * (TOT - 2) + "╯"


def box():
    return {"type": "custom", "format": D + top}


def end():
    return {"type": "custom", "format": D + bot}


def row(mod, icon, label, fmt, icon_col=R, label_col=W):
    return {
        "type": mod,
        "key": f"{D}│ {icon_col}{icon} {label_col}{label.ljust(K - 4)}",
        "format": f"{{#}}{fmt}" + D + " │",
    }


user = getpass.getuser()
host = socket.gethostname()
pad = (K - 4) + 1 + V - len(user) - 1

cfg = {
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
    "logo": {
        "type": "auto",
        "source": "~/.config/fastfetch/lain.png",
        "width": 30,
        "padding": {"top": 1, "left": 1, "right": 3},
    },
    "display": {
        "separator": " ",
        "color": {"keys": "", "output": "white"},
        "percent": {"type": 1},
    },
    "modules": [
        "break",
        box(),
        row("os", "", "OS", "{name} {version-id<4}{arch<13}", label_col=R),
        row("kernel", "", "Kernel", "{release<30}", label_col=R),
        row("packages", "\U000f03d6", "Packages", "{all<30}"),
        row(
            "display",
            "\U000f0379",
            "Display",
            "{width}x{height}  {refresh-rate>3} Hz" + " " * 13,
        ),
        row("wm", "", "WM", "{pretty-name<30}"),
        row("terminal", "", "Terminal", "{pretty-name<30}"),
        end(),
        "break",
        box(),
        row("cpu", "", "CPU", "{name<30}"),
        row("gpu", "\U000f08ae", "GPU", "{name<30}"),
        row(
            "memory",
            "\U000f035b",
            "Memory",
            "{used>9} / {total<9} {percentage>5}   ",
        ),
        end(),
        "break",
        {"type": "colors", "symbol": "circle", "paddingLeft": 2},
    ],
}

with open(out, "w") as f:
    json.dump(cfg, f, ensure_ascii=False, indent=2)
