#!/bin/bash

# This script contains list utilities.

if [ -z "$LIST_SH_INCLUDED" ]; then

    readonly LIST_SH_INCLUDED=yes

    # contains() checks if an array contains a value.
    contains() {
        [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && return 0 || return 1
    }
fi
