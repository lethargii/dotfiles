#!/usr/bin/env bash
flatpak update --assumeyes --noninteractive
if [ $(which dnf) ] ; then
  echo "dnf"
fi
#nb_updates=$(pkcon get-updates | grep -E '(Disponible|Correction|Sécurité|Amélioration)' | wc -l)
nb_updates=$(dnf check-update | grep fc | wc -l)
if [ "$nb_updates" -gt "0" ]; then
  pkcon refresh force && pkcon update --only-download -y && pkcon offline-trigger && pkcon offline-get-prepared
  notify-send --icon=preferences-system-symbolic -u critical -h string:x-canonical-private-synchronous:reboot_notif "Mise à jour" "Le système doit être redémarré"
else
  notify-send --icon=selection-mode-symbolic -u critical -h string:x-canonical-private-synchronous:reboot_notif "Mise à jour" "Le système est à jour"
fi
pkill -SIGRTMIN+1 waybar
