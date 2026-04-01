#!/bin/python3
import subprocess
boutons = {
        'Poweroff': [
            'systemctl poweroff',
            '/usr/share/icons/Adwaita/symbolic/actions/system-shutdown-symbolic.svg'
            ],
        'Reboot': [
            'systemctl reboot',
            '/usr/share/icons/Adwaita/symbolic/actions/system-reboot-symbolic.svg'
            ],
        'Logout': [
            'niri msg action quit',
            '/usr/share/icons/Adwaita/symbolic/actions/system-log-out-symbolic.svg'
            ],
        'Lock': [
            'gtklock --background /usr/share/backgrounds/default.png',
            '/usr/share/icons/Adwaita/symbolic/status/system-lock-screen-symbolic.svg'
            ]
        }

wofi_options = [
        '--show dmenu',
        '--allow-images',
        '--columns=2',
        '--conf="/home/lethargii/.config/waybar/config_powermenu"',
        '--style=/home/lethargii/.config/waybar/style_powermenu.css'
        ]
lines = '\n'.join([f"img:{bouton[1][1]}:text:{bouton[0]}" for bouton in boutons.items()])
choice = subprocess.run(
        f"echo '{lines}' | wofi {' '.join(wofi_options)}",
        shell=True,
        capture_output=True,
        text=True).stdout.split(':')[-1][:-1]
if (choice in boutons.keys()):
    subprocess.run(f"{boutons[choice][0]}", shell=True)
