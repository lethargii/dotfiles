muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep [MUTED] | wc -l)
if [ "$muted" -eq "0" ]; then
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F ' ' '{print $2*100}' | xargs -I[] notify-send -e --icon=audio-volume-medium-symbolic -u critical -h string:x-canonical-private-synchronous:volume_notif -h int:value:[] "Volume" "[]%"
else
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F ' ' '{print $2*100}' | xargs -I[] notify-send -e --icon=audio-volume-muted-symbolic -u critical -h string:x-canonical-private-synchronous:volume_notif -h int:value:0 "Volume" "0%"
fi
