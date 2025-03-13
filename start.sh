#!/bin/bash

# Linux or Darwin (MacOS)
os_name=$(uname)

if [ "$os_name" == "Linux" ]; then
    ./scripts/linux.sh
elif [ "$os_name" == "Darwin" ]; then
    ./scripts/macos.sh
else
    echo "could not determine OS"
fi

