#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 [PLATFORM]"
    echo "PLATFORM options:"
    echo "  ios       Build iOS frameworks only"
    echo "  android   Build Android AAR only"
    echo "  (none)    Build both platforms (default)"
}

# Parse arguments
PLATFORM=""
case $1 in
    ios) PLATFORM="ios" ;;
    android) PLATFORM="android" ;;
    --help) show_usage; exit 0 ;;
    "") PLATFORM="all" ;;
    *) echo "Unknown platform: $1"; echo ""; show_usage; exit 1 ;;
esac

echo "Check flutter"
fvm flutter doctor

if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "all" ]; then
    echo "Build ios frameworks"
    fvm flutter build ios-framework --no-profile
    echo "Mixing debug build for simulator with release build"
    rm -R build/ios/framework/Release/App.xcframework/ios-arm64_x86_64-simulator
    cp -R build/ios/framework/Debug/App.xcframework/ios-arm64_x86_64-simulator build/ios/framework/Release/App.xcframework/ios-arm64_x86_64-simulator
fi

if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "all" ]; then
    echo "Build android aar"
    fvm flutter build aar --no-profile
fi