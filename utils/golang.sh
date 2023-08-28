#!/bin/bash

# This script initializes go environment.

if [ -z "$GOLANG_SH_INCLUDED" ]; then

    readonly GOLANG_SH_INCLUDED=yes

    # Check if go is installed.
    if ! command -v go &>/dev/null; then
        echo "go is not installed."
        exit 1
    fi
fi
