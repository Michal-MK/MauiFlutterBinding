# MAUI Flutter Binding

A complete example of integrating Flutter applications within .NET MAUI applications for both Android and iOS platforms.

## 🙏 Credits

This project is based on the excellent work from:
- **Original concept**: [valentinkatic/MauiFlutterBinding](https://github.com/valentinkatic/MauiFlutterBinding)
- **Enhanced version**: [cl3m/MauiFlutterBinding](https://github.com/cl3m/MauiFlutterBinding)

This fork includes updated dependencies, improved build processes, and enhanced documentation.

## 🏗️ Architecture

This project demonstrates how to:
- Embed Flutter apps as native views in MAUI applications
- Create platform-specific bindings for Android and iOS
- Bridge communication between Flutter and MAUI

### Project Structure
```
├── flutter_app/           # Flutter application source
├── Android.Native/        # Android native binding (Kotlin/Java)
├── Android.Binding/       # Xamarin Android binding project  
├── iOS.Native/           # iOS native binding (Swift/Objective-C)
├── iOS.Binding/          # Xamarin iOS binding project
├── MauiDemoApp/          # .NET MAUI demo application
└── build_all.sh          # Complete build script
```

## 📋 Requirements

### Development Environment
- **macOS** (required for iOS development)
- **Xcode 15+** with iOS SDK 17.2+
- **Android Studio** with Android SDK 35+
- **Android NDK 27.0+**
- **.NET 9.0 SDK**
- **Visual Studio Code**

### Flutter Environment
- **Flutter 3.32.8** (Other/newer versions may work, but the kotlin version must be compatible)
- **Kotlin 2.1.0+** (for Android)

### iOS Specific
- **Objective Sharpie** for iOS binding generation [link](https://aka.ms/objective-sharpie)

### Android Specific  
- **Android NDK 27.0+** - usually is installed by default in the android setup, older versions (26.x) will not work, so ensure you have the correct version.

## 🚀 Quick Start


### 1. Build Everything
```bash
# Build all components (Flutter + Android + iOS + MAUI)
./build_all.sh

# Platform-specific builds
./build_all.sh --ios        # iOS only
./build_all.sh --an         # Android only

# Skip phases (useful for development)
./build_all.sh -f           # Skip Flutter build
./build_all.sh -n           # Skip native builds
```

### 2. Run MAUI Demo
```bash
# Open in IDE
dotnet build MauiDemoApp/MauiDemoApp.csproj
```

## 🔧 Step-by-Step Build Process

### 1. Flutter App
```bash
cd flutter_app
./build.sh
```

### 2. Android Native Binding
```bash
cd Android.Native
./build.sh
```
This will:
- Build the Android binding library
- Generate AAR files
- Copy dependencies to `xamarin` folder
- Show dependency analysis

### 3. iOS Native Binding  
```bash
cd iOS.Native
./build.sh
```
This will:
- Build iOS framework
- Create XCFramework
- Generate API definitions with Objective Sharpie
- Copy frameworks to iOS.Binding

### 4. MAUI Application
- all the iOS steps with provisioning need to be addressed as usual, tested on AN only
```bash
dotnet build MauiFlutterBinding.sln --configuration Release
```

## 🔍 Configuration Details

### Android Configuration
- **Minimum SDK**: API 26 (Android 8.0)
- **Target SDK**: API 35 (Android 15)
- **Kotlin Version**: 2.1.0
- **NDK Version**: 27.0+

### iOS Configuration  
- **Minimum iOS**: 15.6
- **Target iOS**: 17.2
- **Xcode**: 15+

### Flutter Configuration
- **Version**: 3.32.8
- **Build Mode**: Both debug and release built automatically
- **Plugins**: device_info_plus 11.3.0

#### Flutter Build Modes
The `./build.sh` script automatically builds **both debug and release** versions of Flutter:

```bash
cd flutter_app
./build.sh  # Builds both debug and release for Android AAR and iOS Framework
```

To switch between debug and release modes, simply update the dependency in `Android.Native/binding/build.gradle`:

```groovy
// For debug mode (enables flutter attach for hot reload):
implementation 'com.example.flutter_app:flutter_debug:1.0'

// For release mode (optimized for production):
implementation 'com.example.flutter_app:flutter_release:1.0'
```

#### ⚠️ iOS Debug Mode Limitation
**iOS debug mode is not supported** when embedding Flutter in MAUI apps. iOS must use release mode:

**For iOS:** Keep `FLUTTER_FRAMEWORKS_PATH="../flutter_app/build/ios/framework/Release"` in `iOS.Native/build.sh`

**For Android:** Can use either debug or release by changing the dependency in `Android.Native/binding/build.gradle`

Debug mode on iOS requires Flutter tooling or Xcode direct execution, which I have no idea how to achieve with MAUI embedding.

## 🛠️ Development Workflow

### Testing Android Binding
```bash
cd Android.Native
./gradlew build
# Open Android.Native in Android Studio to test demoapp
```

### Testing iOS Binding
```bash
cd iOS.Native  
# Open Binding.xcodeproj in Xcode to test
```

### Flutter Hot Reload (Development)
```bash
cd flutter_app
flutter attach # When MAUI app is running with the flutter app built in debug mode
# Or though VS Code
```

## 📄 License

[MIT License](LICENSE)
