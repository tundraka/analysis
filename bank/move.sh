#!/bin/bash
files=$(ls -1 csv)
for file in "${files[@]}"
do
    fileOnly=$(basename $file)
    fileName=$(cut fileOnly
    echo $fileOnly | sed "s/\([0-9]\{4\}\)\([0-9]\{2\}\)-\([0-9]\)\.csv/\1-\2-\3/"
done
