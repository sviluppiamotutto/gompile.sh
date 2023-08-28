#!/bin/bash

# This script contains platform and architecture variables and utilities.

if [ -z "$PLAT_ARCH_SH_INCLUDED" ]; then

    readonly PLAT_ARCH_SH_INCLUDED=yes

    # List of supported platform and architecture pairs using "go tool dist list".
    SUPPORTED_PAIRS=($(go tool dist list))

    # List of available platforms and architectures.
    AVAILABLE_PLATFORMS=()

    for pair in "${SUPPORTED_PAIRS[@]}"; do
        # Split pair by /.
        IFS='/' read -ra pair_split <<<"$pair"
        # Get platform from pair.
        platform=${pair_split[0]}
        # Check if platform is already in AVAILABLE_PLATFORMS, if it is, skip it.
        if contains "${AVAILABLE_PLATFORMS[*]}" "$platform"; then
            continue
        fi
        # Add platform to AVAILABLE_PLATFORMS.
        AVAILABLE_PLATFORMS+=("$platform")
    done

    # List of available architectures.
    AVAILABLE_ARCHITECTURES=()

    for pair in "${SUPPORTED_PAIRS[@]}"; do
        # Split pair by /.
        IFS='/' read -ra pair_split <<<"$pair"
        # Get architecture from pair.
        architecture=${pair_split[1]}
        # Check if architecture is already in AVAILABLE_ARCHITECTURES, if it is, skip it.
        if contains "${AVAILABLE_ARCHITECTURES[*]}" "$architecture"; then
            continue
        fi
        # Add architecture to AVAILABLE_ARCHITECTURES.
        AVAILABLE_ARCHITECTURES+=("$architecture")
    done

    # Get system platform.
    SYSTEM_PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
    # Get system architecture.
    SYSTEM_ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
fi
