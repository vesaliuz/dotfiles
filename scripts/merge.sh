#!/bin/bash

for i in *".mkv"
do
    mkvmerge -o "${i%%".mkv"}_x265_AAC.mkv" -d 0 -a jpn -s 3 --default-track 3:1\
    "$i"
    mv "$i" "${i%%".mkv"}.old"
done
