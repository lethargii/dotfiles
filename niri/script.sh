#!/bin/sh
flatpak run io.github.TheWisker.Cavasik &

while !(niri msg windows | grep Cava); do
  sleep 0.1
done

kitty &

papers &

flatpak run org.mozilla.firefox &
