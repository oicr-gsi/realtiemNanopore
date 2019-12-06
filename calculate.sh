#!/bin/bash

find . -name "*.zip"
find . -name "*.zip" -exec unzip {} -d nanoplot_test \; >/dev/null
cd nanoplot_test
find . \( -type f -size +0 -iname "*.png" -o -iname "*.html" \) -printf "non-zero file size: %f\n"
find . -type f -iname "*.txt" -exec md5sum {} \;
