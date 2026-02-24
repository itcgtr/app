import 'package:flutter/material.dart';

import 'package:app_gtr/Environment.dart';
import 'package:app_gtr/navigators/Navigator_Bottom.dart';
import 'package:app_gtr/navigators/Routes.dart';
import 'package:app_gtr/themes/Theme_Data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: const Navigator_Bottom_Page(), //
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
