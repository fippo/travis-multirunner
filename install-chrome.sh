#!/usr/bin/env bash
# Install chrome.
# Arguments: $1=target URL, $2=target path
#
# The script expects to run in the script home dir, and uses
# the subdir "browser-tmp" as a temporary directory.
#
FNAME=chrome-linux.zip

# cleanup any old files (shouldn't happen on travis)
rm -rf ./browser-tmp
mkdir ./browser-tmp

# get the files
(cd ./browser-tmp; wget -O $FNAME $1)
unzip -d ./browser-tmp ./browser-tmp/$FNAME

# make the target directory
mkdir -p $2
mv ./browser-tmp/chrome-linux/* $2
rm -rf ./browser-tmp
