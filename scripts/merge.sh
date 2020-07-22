#!/bin/bash

for i in *".mkv"
do
    mkvmerge -o "${i%%".mkv"}.remerged.mkv" -d 0 -a jpn -s eng \
    "$i" 
    mv "$i" "${i%%".mkv"}.old"
done
