engine=$(ibus engine)
if [ "$engine" == "mozc-on" ]; then
  echo ja
else
  echo $engine | awk -F ':' '{print $2}'
fi
