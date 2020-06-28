#!/bin/bash

for i in *".mkv"
do
    mkvmerge -o "${i%%".mkv"}_x265_AAC.mkv" -d 0 -a jpn "$i" \
    --language 0:eng --track-name 0:English "${i%%".mkv"}.ass"
done
