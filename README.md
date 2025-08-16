# MAUI Flutter Binding

A complete example of integrating Flutter applications within .NET MAUI applications for both Android and iOS platforms.

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
- **Android Studio** with Android SDK 34
- **Android NDK 27.0+**
- **.NET 9.0 SDK**
- **Visual Studio Code** or **Visual Studio for Mac**

### Flutter Environment
- **Flutter 3.32.8+**
- **Dart 3.8.1+**
- **Kotlin 2.1.0+** (for Android)

### iOS Specific
- **Objective Sharpie** for iOS binding generation
  ```bash
  # Install via Visual Studio for Mac or download from Microsoft
  ```

### Android Specific  
- **Android NDK 27.0+**
  ```bash
  # Install via Android Studio SDK Manager
  # Or set ANDROID_NDK_ROOT environment variable
  ```

## 🚀 Quick Start

### 1. Clone and Setup
```bash
git clone <your-repo-url>
cd MauiFlutterBinding
```

### 2. Build Everything
```bash
# Build all components (Flutter + Android + iOS + MAUI)
./build_all.sh
```

### 3. Run MAUI Demo
```bash
# Open in IDE
dotnet build MauiDemoApp/MauiDemoApp.csproj
```

## 🔧 Step-by-Step Build Process

### 1. Flutter App
```bash
cd flutter_app
flutter pub get
flutter build aar --release          # For Android
flutter build ios-framework --release # For iOS
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
```bash
dotnet build MauiFlutterBinding.sln --configuration Release
```

## 🔍 Configuration Details

### Android Configuration
- **Minimum SDK**: API 26 (Android 8.0)
- **Target SDK**: API 34 (Android 14)
- **Kotlin Version**: 2.1.0
- **NDK Version**: 27.0+

### iOS Configuration  
- **Minimum iOS**: 15.6
- **Target iOS**: 17.2
- **Xcode**: 15+

### Flutter Configuration
- **Version**: 3.32.8
- **Build Mode**: Release (for production)
- **Plugins**: device_info_plus 11.3.0

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
flutter attach # When MAUI app is running in debug mode
```

## 📝 Key Features Implemented

- ✅ **Flutter View Embedding**: Flutter app runs as native view
- ✅ **Bidirectional Communication**: MAUI ↔ Flutter messaging
- ✅ **Platform APIs**: Access to device info via Flutter plugins
- ✅ **Release Build**: Optimized for production deployment
- ✅ **Multi-Architecture**: ARM64, ARMv7, x86_64 support

## 🔧 Troubleshooting

### Common Issues

**NDK Version Mismatch**
```bash
# Check NDK version
ls $ANDROID_HOME/ndk/
# Ensure 27.0+ is available
```

**Kotlin Version Issues**
```bash
# Update build.gradle
kotlin_version = '2.1.0'
```

**iOS Simulator Issues**
```bash
# For iOS simulator testing, use debug build
flutter build ios-framework --debug
```

**Missing Dependencies**
```bash
# Clean and rebuild
./build_all.sh
```

## 📚 Resources

- [Flutter Integration Guide](https://docs.flutter.dev/add-to-app)
- [MAUI Documentation](https://docs.microsoft.com/en-us/dotnet/maui/)
- [Xamarin Binding Documentation](https://docs.microsoft.com/en-us/xamarin/android/platform/binding-java-library/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the complete build process
5. Submit a pull request

## 📄 License

[MIT License](LICENSE)
