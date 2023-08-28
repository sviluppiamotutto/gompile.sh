#!/bin/bash

VERSION="0.0.1"

# This script compiles the project for specified platform.

# Base directory of the script.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Source utils scripts.
source "$SCRIPT_DIR/utils/log.sh"
source "$SCRIPT_DIR/utils/list.sh"
source "$SCRIPT_DIR/utils/plat_arch.sh"

# Set ALL to false by default.
ALL=false
# Set ARCHIVE to false by default.
ARCHIVE=false

if [ -z ${COMPILE_PATH} ]; then
    # Set COMPILE_PATH to current directory, change this according to your project main package path.
    COMPILE_PATH=$(pwd)
fi

# compile() compiles the project for specified platform, $1 is the platform and $2 is the architecture.
compile() {

    if [ ! -d "${COMPILE_PATH}" ]; then
        log_error "Invalid path: ${COMPILE_PATH}"
        exit 1
    fi

    PLATFORM=$1
    ARCH=$2

    # Check if platform is passed.
    if [ -z "$PLATFORM" ]; then
        log_error "Platform is not specified."
        exit 1
    fi

    # Check if architecture is passed.
    if [ -z "$ARCH" ]; then
        log_error "Architecture is not specified."
        exit 1
    fi

    # Check if platform and architecture pair is supported using contains().
    if ! contains "${SUPPORTED_PAIRS[*]}" "$PLATFORM/$ARCH"; then
        log_and_new_line "Unsupported platform and architecture pair: $PLATFORM/$ARCH, skipping..."
        return
    fi

    log "Building for $PLATFORM $ARCH..."

    # Set output directory.
    if [ -z "$OUTPUT" ]; then
        output_dir="bin/$PLATFORM/$ARCH"
    else
        output_dir="$OUTPUT"
    fi

    # Create output directory if it doesn't exist.
    if [ ! -d "$output_dir" ]; then
        mkdir -p "$output_dir"
    fi

    # Set output file name, it takes the name of the current directory + platform and architecture.
    output_file_name="$(basename "$COMPILE_PATH")_${PLATFORM}_${ARCH}"

    # Set output file path.
    output_file_path="$output_dir/$output_file_name"

    # Remove whitespaces from output file name.
    output_file_path=$(echo "$output_file_path" | tr -d '[:space:]')

    # Append .exe to output file name if platform is Windows.
    if [ "$PLATFORM" = "windows" ]; then
        output_file_path="$output_file_path.exe"
    fi

    # Remove previous build if it exists.
    if [ -f "$output_file_path" ]; then
        rm "$output_file_path"
    fi

    # Build the project.
    env GOOS=$PLATFORM GOARCH=$ARCH go build -o "$output_file_path" $COMPILE_PATH

    log "Build completed."

    if [ "$ARCHIVE" = true ]; then
        # Check if tar is installed.
        if ! command -v tar &>/dev/null; then
            log_error "tar is not installed."
            exit 1
        fi

        # Archive the build.
        tar -czvf "$output_file_path.tar.gz" "$output_file_path"

        log "Build archived."

        # Remove build.
        rm "$output_file_path"
    fi
}

# ask_os_arch_and_compile() asks the user for platform and architecture and compiles the project.
ask_os_arch_and_compile() {

    # Show platform options.
    echo "Please select a platform:"
    for ((i = 0; i < ${#AVAILABLE_PLATFORMS[@]}; i++)); do
        echo "$(($i + 1))) ${AVAILABLE_PLATFORMS[$i]}"
    done

    # Read user input until it is valid.
    read -p "Enter your choice: " choice

    # check if user input is valid.
    if [ -z "$choice" ] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#AVAILABLE_PLATFORMS[@]} ]; then
        echo "Invalid choice."
        exit 1
    fi

    PLATFORM=${AVAILABLE_PLATFORMS[$(($choice - 1))]}

    new_line

    # Show architecture options.
    echo "Please select an architecture:"
    for ((i = 0; i < ${#AVAILABLE_ARCHITECTURES[@]}; i++)); do
        # Check if platform and architecture pair is supported, if it is, skip it.
        if ! contains "${SUPPORTED_PAIRS[*]}" "$PLATFORM/${AVAILABLE_ARCHITECTURES[$i]}"; then
            continue
        fi
        echo "$(($i + 1))) ${AVAILABLE_ARCHITECTURES[$i]}"
    done

    # Read user input.
    read -p "Enter your choice: " choice

    # check if user input is valid.
    if [ -z "$choice" ] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#AVAILABLE_ARCHITECTURES[@]} ]; then
        log_error "Invalid choice."
        exit 1
    fi

    ARCH=${AVAILABLE_ARCHITECTURES[$(($choice - 1))]}

    new_line

    # Compile for specified platform.
    compile $PLATFORM $ARCH
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    -all | -a)
        ALL=true
        shift
        ;;
    -interactive | -i)
        ask_os_arch_and_compile
        exit 0
        ;;
    -h | -help)
        echo "Usage: compile.sh [options]"
        echo "Compiles a Go binary. If no options are passed, it will use the current directory as the project main package path and compile for the current system."
        echo "Binary takes the name of the current directory."
        echo "Options:"
        echo "  -all          | -a      Build for all platforms."
        echo "  -architecture | -arch   Architecture to build for."
        echo "  -archive      | -A      Archive the build."
        echo "  -interactive  | -i      Ask for platform and architecture."
        echo "  -output       | -o      Output directory."
        echo "  -path         | -p      Path to project main package."
        echo "  -platform     | -os     Platform to build for."
        echo "  -version      | -v      Show version."
        echo "  -help         | -h      Show this help message."
        exit 0
        ;;
    -path | -p)
        COMPILE_PATH="$2"
        shift
        shift
        ;;
    -output | -o)
        OUTPUT="$2"
        shift
        shift
        ;;
    -platform | -os)
        SYSTEM_PLATFORM="$2"
        shift
        shift
        ;;
    -arch | -architecture)
        SYSTEM_ARCH="$2"
        shift
        shift
        ;;
    -archive | -A)
        ARCHIVE=true
        shift
        ;;
    -v | -version)
        echo "compile.sh version $VERSION"
        exit 0
        ;;
    *)
        log_error "Unknown option: $key"
        exit 1
        ;;
    esac
done

# Check if all platforms should be built.
if [ "$1" = "all" ]; then
    ALL=true
fi

if [ "$ALL" = true ]; then
    # Build for all platforms.
    for platform in "${AVAILABLE_PLATFORMS[@]}"; do
        for architecture in "${AVAILABLE_ARCHITECTURES[@]}"; do
            compile $platform $architecture
        done
    done
    exit 0
else
    # Ask user for platform and architecture.
    compile $SYSTEM_PLATFORM $SYSTEM_ARCH
fi

exit 0
