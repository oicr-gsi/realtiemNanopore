#!/bin/bash
cd output

find . -name "*.zip" -exec unzip {} \; >/dev/null
find . \( -type f -size +0 -iname "*.png" -o -iname "*.html" \) -printf "non-zero file size: %f\n"
find . -type f -iname "*.txt" -exec md5sum {} \;