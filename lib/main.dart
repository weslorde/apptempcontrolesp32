import 'package:flutter/material.dart';

import 'src/shared/themes/themes.dart';
import 'widgets/bottomNavigationBar_Widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  void changeThemeMode() {
    setState(() {
      if (themeMode == ThemeMode.dark) {
        themeMode = ThemeMode.light;
      } else {
        themeMode = ThemeMode.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: dartTheme,
      home: MyHomePage(changeThemeMode: changeThemeMode),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.changeThemeMode});

  final void Function() changeThemeMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onNavBarClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: selectedIndex, onNavBarClicked: onNavBarClicked),
      appBar: AppBar(
        title: const Text('Teste'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '...',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.changeThemeMode,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
