#!/bin/python3
import subprocess
import json
nb_updates_flat = int(
        subprocess.run(
            "flatpak remote-ls --updates | wc -l",
            shell=True,
            capture_output=True,
            text=True
            ).stdout
        )
subprocess.run("pkcon refresh force", shell=True, capture_output=True)
nb_updates = int(
        subprocess.run(
            "pkcon get-updates | grep Disp | wc -l",
            shell=True,
            capture_output=True,
            text=True).stdout)
res = {
        "text":
        f"{nb_updates} system updates\n{nb_updates_flat} flatpak updates",
        "alt":
        f"{"no_updates" if nb_updates + nb_updates_flat == 0 else "updates"}"
        }
print(json.dumps(res))
