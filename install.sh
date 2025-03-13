#!/bin/bash

# Linux or Darwin (MacOS)
OS_NAME=$(uname)

if [ "$OS_NAME" == "Linux" ]; then
    ./scripts/linux.sh
elif [ "$OS_NAME" == "Darwin" ]; then
    ./scripts/macos.sh
else
    echo "could not determine OS"
fi

