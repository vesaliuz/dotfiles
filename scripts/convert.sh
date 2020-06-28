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
    echo "Continue"
    ffmpeg -i "$i" -map 0:0 -map 0:2 -map 0:3 -c:v libx265 -crf 28 -preset fast -c:a copy -c:s copy  "${i%%".mkv"}_x265_AAC.mkv"
    mv "$i" "${i%%".mkv"}.old"
    
done
