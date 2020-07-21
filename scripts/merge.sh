#!/bin/bash

for i in *".mkv"
do
    mkvmerge -o "${i%%".mkv"}.remerged.mkv" -d 0 -a 1 -s 3 --default-track 3:1\
    "$i"
    mv "$i" "${i%%".mkv"}.old"
done
