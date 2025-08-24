import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

void main_page() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Maui Binding Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _deviceInfo = "";
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter += 2;
    });
  }

  void _checkDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.deviceInfo as AndroidDeviceInfo;
      _deviceInfo = "Device: ${deviceInfo.model}\nAndroid: ${deviceInfo.version.release}\nSDK: ${deviceInfo.version.sdkInt}\nBrand: ${deviceInfo.brand}";
    } else if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.deviceInfo as IosDeviceInfo;
      _deviceInfo = "Device: ${deviceInfo.model}\niOS: ${deviceInfo.systemVersion}\nName: ${deviceInfo.name}";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("~LOG~ Building Main Page");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkDeviceInfo,
              child: Text("Check Device Info"),
            ),
            Text(_deviceInfo),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
