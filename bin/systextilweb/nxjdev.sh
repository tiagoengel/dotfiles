#!/bin/sh

PROJECT_FILE=$1

if [ "$PROJECT_FILE" == "" ]; then
    PROJECT_FILE=$(ls *.prj)
    if [ "$PROJECT_FILE" == "" ]; then
        echo "Invalid folder! No .prj file found"
        exit 1
    fi
    PROJECT_FILE="$PWD/$PROJECT_FILE"
fi

echo "java -cp /usr/local/share/NXJ/nxj-systextil.jar nxj.systextil.StartIDE $PROJECT_FILE"
java -version
java -cp /usr/local/share/NXJ/nxj-systextil.jar nxj.systextil.StartIDE "$PROJECT_FILE" > /dev/null 2>&1 &

