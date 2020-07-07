#!/bin/bash

countdown() {
  secs=$1
  shift
  msg=$@
  while [ $secs -gt 0 ]
  do
    printf "\r\033[KWaiting %.d seconds $msg" $((secs--))
    sleep 1
  done
  echo
}
        
for i in *".mkv"
do
    countdown 20 "Press Ctrl-C to stop"
    echo "####################"
    printf "/n"
    echo "Converting $i"
    echo "####################"
    printf "\n\n"
    ffmpeg -i "$i"  -map 0:0 -map 0:1 -map 0:3 -c:v libx265 -crf 25 -preset medium -c:a copy -c:s copy  "${i%%".mkv"}_x265_AAC.mkv"
    mv "$i" "${i%%".mkv"}.old"
    echo "####################\n\nDONE\n"
done
