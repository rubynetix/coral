#!/usr/bin/env bash

ESC_1=$(echo $1 | sed -e 's/[]\/$*.^[]/\\&/g')
ESC_2=$(echo $2 | sed -e 's/[]\/$*.^[]/\\&/g')

# This file is both a test file and serves a practical purpose
# Used in testing if two directories are strictly equal
diff <(find $1/ -type f -exec md5sum {} + | sed -e "s/$ESC_1//g" | sort -k 2) \
     <(find $2/ -type f -exec md5sum {} + | sed -e "s/$ESC_2//g" | sort -k 2)
