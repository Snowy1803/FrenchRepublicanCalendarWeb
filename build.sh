#!/bin/bash
set -e

# Build the project using the Swift SDK for WebAssembly
swift package --swift-sdk swift-6.2.3-RELEASE_wasm js

# Copy the build artifacts to the Bundle directory
cp -r .build/plugins/PackageToJS/outputs/Package/* Bundle/

# Copy the index.html to the Bundle directory
cp index.html Bundle/

echo "Build complete! Artifacts are in the Bundle directory."
