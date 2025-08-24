#!/bin/sh

# Function to show usage
show_usage() { 
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -f, --no-flutter-build    Skip Flutter build step"
    echo "  -n, --no-native-build     Skip native build step (Android.Native and iOS.Native)"
    echo "  --do-binding-build        Include Binding build step (Android.Binding and iOS.Binding)"
    echo "  --ios                     Build only iOS components"
    echo "  --an                      Build only Android components"
    echo "  --help                    Show this help message"
    echo ""
    echo "Platform-specific builds:"
    echo "  --ios: Builds Flutter (iOS), iOS.Native, iOS.Binding, and MAUI (iOS target)"
    echo "  --an:  Builds Flutter (Android), Android.Native, Android.Binding, and MAUI (Android target)"
    echo "  No platform flag: Builds all components for both platforms"
}

# Function to handle errors
handle_error() {
    echo "Error: Script failed on line $1"
    exit 1
}

# Set up error trap
trap 'handle_error $LINENO' ERR

# Exit on any error
set -e

# Default values
SKIP_FLUTTER_BUILD=false
SKIP_NATIVE_BUILD=false
BUILD_BINDING=false
BUILD_PLATFORM=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--no-flutter-build) SKIP_FLUTTER_BUILD=true ;;
        -n|--no-native-build) SKIP_NATIVE_BUILD=true ;;
        --do-binding-build) BUILD_BINDING=true ;;
        --ios) BUILD_PLATFORM="ios" ;;
        --an) BUILD_PLATFORM="android" ;;
        --help) show_usage; exit 0 ;;
        *) echo "Unknown parameter: $1"; echo ""; show_usage; exit 1 ;;
    esac
    shift
done

if [ "$SKIP_FLUTTER_BUILD" = false ]; then
  echo "Running flutter app build"
  if [ "$BUILD_PLATFORM" = "ios" ]; then
    (cd flutter_app && ./build.sh ios)
  elif [ "$BUILD_PLATFORM" = "android" ]; then
    (cd flutter_app && ./build.sh android)
  else
    (cd flutter_app && ./build.sh)
  fi
fi

if [ "$SKIP_NATIVE_BUILD" = false ]; then
  if [ "$BUILD_PLATFORM" = "ios" ]; then
    echo "Running iOS.Native build only"
    (cd iOS.Native && ./build.sh)
  elif [ "$BUILD_PLATFORM" = "android" ]; then
    echo "Running Android.Native build only"
    (cd Android.Native && ./build.sh)
  else
    echo "Running Android.Native build"
    (cd Android.Native && ./build.sh)

    echo "Running iOS.Native build"
    (cd iOS.Native && ./build.sh)
  fi
fi

echo "Deleting all bin/ and obj/"
find . -type d \( -name bin -o -name obj \) -exec rm -rf {} +

echo "Restoring Binding solutions"
if [ "$BUILD_PLATFORM" = "ios" ]; then
  dotnet restore iOS.Binding/iOS.Binding.csproj
elif [ "$BUILD_PLATFORM" = "android" ]; then
  dotnet restore Android.Binding/Android.Binding.csproj
else
  dotnet restore Android.Binding/Android.Binding.csproj
  dotnet restore iOS.Binding/iOS.Binding.csproj
fi

if [ "$BUILD_BINDING" = true ]; then
  echo "Building Binding solutions"
  if [ "$BUILD_PLATFORM" = "ios" ]; then
    dotnet build iOS.Binding/iOS.Binding.csproj
  elif [ "$BUILD_PLATFORM" = "android" ]; then
    dotnet build Android.Binding/Android.Binding.csproj
  else
    dotnet build Android.Binding/Android.Binding.csproj
    dotnet build iOS.Binding/iOS.Binding.csproj
  fi
fi