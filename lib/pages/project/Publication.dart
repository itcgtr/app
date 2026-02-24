import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:app_gtr/Environment.dart';
import 'package:app_gtr/navigators/Routes.dart';
import 'package:app_gtr/themes/Theme_Data.dart';
import 'package:app_gtr/navigators/Navigator_Left.dart';

void main() {
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: const Publication_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Publication_Page extends StatefulWidget {
  const Publication_Page({super.key});

  @override
  State<Publication_Page> createState() => _Publication_PageState();
}

class _Publication_PageState extends State<Publication_Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Publication Page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  Text('Template Page'), //
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
