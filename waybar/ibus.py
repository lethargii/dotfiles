#!/bin/python3
import subprocess
command = "ibus read-config | grep preload-engines | awk -F ': ' '{print $2}' -"
engines = eval(subprocess.run(command, shell=True, capture_output=True, text=True).stdout)
engine_current = eval(subprocess.run('echo \\"$(ibus engine)\\"', shell=True, capture_output=True, text=True).stdout)
engine_next = engines[(engines.index(engine_current) + 1) % 3]
subprocess.run(f"ibus engine {engine_next}", shell=True)
