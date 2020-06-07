#!/bin/bash

for i in *".mkv"
do
    ffmpeg -i "$i" -map 0:0 -map 0:1 -map 0:2 -c:v libx265 -crf 28 -preset fast -c:a libfdk_aac  -b:a 160k -c:s copy  "${i%%".mkv"}_x265_AAC.mkv"
    mv "$i" "${i%%".mkv"}.old"
    sleep 18
done
