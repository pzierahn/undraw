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
      title: 'Flutter Demo',
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("UnDraw"),
      ),
      body: ListView.builder(
        itemCount: UnDrawIllustration.values.length,
        // separatorBuilder: (_, __) => const Divider(
        //   height: 40,
        // ),
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
                  title: Text(
                    illustration.name,
                    style: Theme.of(context).textTheme.titleMedium,
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
