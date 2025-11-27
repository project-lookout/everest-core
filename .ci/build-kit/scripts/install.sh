#!/bin/sh

ninja -C "$EXT_MOUNT/build" install
retVal=$?

if [ $retVal -ne 0 ]; then
    echo "Installation failed with return code $retVal"
    exit $retVal
fi

# Ensure everest-core binary is in the dist directory
# Check if binary exists in build directory but not in dist
if [ ! -f "$EXT_MOUNT/dist/bin/everest-core" ] && [ ! -f "$EXT_MOUNT/dist/libexec/everest/everest-core" ]; then
    echo "everest-core binary not found in dist, searching in build directory..."
    EVEREST_CORE=$(find "$EXT_MOUNT/build" -name "everest-core" -type f -executable 2>/dev/null | head -1)
    if [ -n "$EVEREST_CORE" ] && [ -f "$EVEREST_CORE" ]; then
        echo "Found everest-core in build directory: $EVEREST_CORE"
        mkdir -p "$EXT_MOUNT/dist/bin"
        cp "$EVEREST_CORE" "$EXT_MOUNT/dist/bin/everest-core"
        chmod +x "$EXT_MOUNT/dist/bin/everest-core"
        echo "Copied everest-core to $EXT_MOUNT/dist/bin/everest-core"
    else
        echo "WARNING: everest-core binary not found in build directory either!"
        echo "Build directory contents:"
        find "$EXT_MOUNT/build" -name "*everest*" -o -name "*core*" | head -20
    fi
fi
