<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# UnDraw Illustrations Flutter Plugin

This is a Flutter plugin for integrating [UnDraw illustrations](https://undraw.co/illustrations) into your Flutter applications. It
provides a simple and efficient way to use UnDraw's open-source illustrations in your projects.

## Features

- Easy integration with Flutter applications.
- Supports all UnDraw illustrations.
- Allows customization of illustrations with primary color of your theme.
- Efficient fetching and caching of illustrations.

## Installation

To use this plugin, add `undraw` as
a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

```yaml
dependencies:
  undraw: ^1.0.0
```

## Usage

Here is a simple example of how to use the plugin:

```dart
import 'package:flutter/material.dart';
import 'package:undraw/undraw.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnDraw Illustrations',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UnDraw Illustrations'),
      ),
      body: ListView.builder(
        itemCount: UnDrawIllustration.values.length,
        itemBuilder: (context, inx) {
          final illustration = UnDrawIllustration.values[inx];

          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                ListTile(
                  title: SelectableText(
                    illustration.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),
                UnDraw(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  illustration: illustration,
                  color: colorScheme.primary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```
