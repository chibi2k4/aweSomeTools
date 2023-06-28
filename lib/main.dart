import 'package:aweSomeTools/snippet_editor_page.dart';
import 'package:flutter/material.dart';
import 'port_blocker_page.dart';
import 'home_page.dart';
import 'settings_page.dart';

void main() {
  runApp(UtilApp());
}

class UtilApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aweSomeTools',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    HomePage(),
    SettingsPage(),
    PortBlockerPage(),
    SnippetEditorPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                child: Text('Home'),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              TextButton(
                child: Text('Settings'),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              TextButton(
                child: Text('Port Blocker'),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              TextButton(
                child: Text('Snippet Editor'),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
    );
  }
}
