#!/bin/bash

RECYCLE_BIN="/tmp/recycle"

if [[ ! -d "$RECYCLE_BIN" ]];then
    mkdir -p "$RECYCLE_BIN"
fi

function walk() {
    FILENAME=$(pwd)/$(basename $1)
    if [[ -d $FILENAME ]];then
        cd $FILENAME
        for file in `ls -1a -I "." -I ".."`
        do
            walk "$FILENAME/$file"
        done
        cd ..
    fi
    if [[ -f $FILENAME ]];then
        INODE=$(stat -c %i $FILENAME)
        FILE_DIR=$(dirname $FILENAME)
        FILE=$(basename $FILENAME)
        mv "$FILENAME" "$RECYCLE_BIN/$INODE"
        echo "$INODE $FILE_DIR $FILE" >> "$RECYCLE_BIN/.restore"
    fi
}

for file in "$@"
do
    walk $file
done
echo "File(s) were moved to $RECYCLE_BIN"