flatpak update --assumeyes --noninteractive
pkcon refresh force
nb_updates=$(pkcon get-updates | grep Disp | wc -l)
if [ "$nb_updates" -gt "0" ]; then
  pkcon update -d && pkcon offline-trigger && pkcon offline-get-prepared
  notify-send --icon=preferences-system-symbolic -u critical -h string:x-canonical-private-synchronous:reboot_notif "Mise à jour" "Le système doit être redémarré"
else
  notify-send --icon=selection-mode-symbolic -u critical -h string:x-canonical-private-synchronous:reboot_notif "Mise à jour" "Le système est à jour"
fi
pkill -SIGRTMIN+1 waybar
