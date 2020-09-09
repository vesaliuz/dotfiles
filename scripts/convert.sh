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
    printf "\n"
    echo "Converting $i"
    echo "####################"
    printf "\n\n"
ffmpeg -i "$i"  -map 0 -c:v libx265 -crf 25 -preset fast -c:a libopus -b:a 128k -c:s copy  "${i%%".mkv"}_x265_Opus.mkv"
    
    # To set sub as default
# ffmpeg -i "$i"  -map 0 -c:v libx265 -crf 25 -preset fast -c:a libopus -b:a 128k -c:s copy -disposition:s:0 default "${i%%".mkv"}_x265_AAC.mkv"
    
    # Downmix to stereo
    # ffmpeg -i "$i"  -map 0 -c:v libx265 -crf 23 -preset medium -c:a libfdk_aac -ac 2 -c:s copy  "${i%%".mkv"}_x265_AAC.mkv"
    
    mv "$i" "${i%%".mkv"}.old"
    printf "####################\n\nDONE\n"
done
echo "Conversion Finished"
