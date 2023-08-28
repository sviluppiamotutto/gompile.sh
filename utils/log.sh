#!/bin/bash

# This script contains logging utilities.

if [ -z "$LOG_SH_INCLUDED" ]; then

    readonly LOG_SH_INCLUDED=yes

    # log() logs a message to stdout.
    log() {
        echo "$1"
    }

    # log_error() logs an error message to stderr.
    log_error() {
        echo "$1" >&2
    }

    # new_line() prints a new line to the console.
    new_line() {
        echo
    }

    # log_and_new_line() logs a message to the console and prints a new line.
    log_and_new_line() {
        log "$1"
        new_line
    }
fi
