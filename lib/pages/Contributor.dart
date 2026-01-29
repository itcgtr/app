import 'package:flutter/material.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/routes/Left_Navigator.dart';

void main() {
  runApp(const About());
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HOST_API, //
      theme: Theme_Data.get_theme(),
      home: const Contributor_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Contributor_Page extends StatefulWidget {
  const Contributor_Page({super.key});

  @override
  State<Contributor_Page> createState() => _Contributor_PageState();
}

class _Contributor_PageState extends State<Contributor_Page> {
  @override
  void initState() {
    super.initState();
    print('About Page Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('About Page Content Here'), //
          ],
        ),
      ),
    );
  }
}
