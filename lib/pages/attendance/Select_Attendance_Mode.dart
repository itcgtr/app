import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/navigators/Navigator_Left.dart';
import 'package:gtr_app/navigators/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';

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
      home: const Select_Attendance_Mode(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Select_Attendance_Mode extends StatefulWidget {
  const Select_Attendance_Mode({super.key});

  @override
  State<Select_Attendance_Mode> createState() => _Select_Attendance_ModeState();
}

class _Select_Attendance_ModeState extends State<Select_Attendance_Mode> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Attendance Mode"),
        actions: [
          // IconButton(icon: const Icon(Icons.search), onPressed: () {}), //
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.qr_code), //
                    title: Text('Associat\'s Degreefasfasdf', overflow: TextOverflow.ellipsis, maxLines: 1),
                    onTap: () {
                      //
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.school_outlined), //
                    title: Text('Associat\'s Degreefasfasdf', overflow: TextOverflow.ellipsis, maxLines: 1),
                    onTap: () {
                      //
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.school_outlined), //
                    title: Text('Associat\'s Degreefasfasdf', overflow: TextOverflow.ellipsis, maxLines: 1),
                    onTap: () {
                      //
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      drawer: const Navigator_Left(),
    );
  }
}
