import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:app_gtr/Environment.dart';
import 'package:app_gtr/themes/Theme_Data.dart';
import 'package:app_gtr/utilities/Debug.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(), //
      home: const View_Attendance_001(), //
      debugShowCheckedModeBanner: false, //
    );
  }
}

class View_Attendance_001 extends StatefulWidget {
  const View_Attendance_001({super.key});

  @override
  State<View_Attendance_001> createState() => _View_Attendance_001State();
}

class _View_Attendance_001State extends State<View_Attendance_001> {
  //
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );
  Timer? _debounce;
  TextEditingController controller_search = TextEditingController();
  ScrollController controller_listview = ScrollController();

  //

  int LIMIT = 100;
  bool is_search = false;
  bool has_more = true;

  List<Map<String, dynamic>> data_all = [];

  //

  void on_search() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      await dio
          .post(
            '/attendance/read', //
            data: FormData.fromMap({
              'query': controller_search.text, //
              'offset': 0,
              'limit': LIMIT,
            }),
          )
          .then((r) {
            data_all = List<Map<String, dynamic>>.from(r.data);
            controller_listview.jumpTo(0);
            has_more = true;
            setState(() {});
          })
          .catchError((e) {});
    });
    //
  }

  void load_more() async {
    if (!has_more) return;
    dio
        .post(
          '/attendance/read', //
          data: FormData.fromMap({
            'query': controller_search.text, //
            'offset': data_all.length,
          }),
        )
        .then((r) {
          has_more = (r.data is List) ? (r.data.length >= LIMIT) : false;
          data_all.addAll(List<Map<String, dynamic>>.from(r.data));
          setState(() {});
        })
        .catchError((e) {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller_search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: is_search
            ? TextField(
                controller: controller_search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  border: InputBorder.none, //
                ),
                onChanged: (v) {
                  on_search();
                },
              )
            : Text("View Attendance"), //
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          if (!is_search)
            IconButton(
              onPressed: () {
                is_search = true;
                setState(() {});
              },
              icon: Icon(Icons.search),
            ),
          if (is_search)
            IconButton(
              onPressed: () {
                is_search = false;
                controller_search.clear();
                on_search();
              },
              icon: Icon(Icons.close),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 0, bottom: 8),
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft, //
                        child: Text(
                          "Student Name", //
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 50, //
                      alignment: Alignment.center,
                      child: Text(
                        "Code", //
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 50, //
                      alignment: Alignment.center,
                      child: Text(
                        "Type", //
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: 100, //
                      alignment: Alignment.center,
                      child: Text(
                        "Scan At", //
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 8),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      controller: controller_listview,
                      itemCount: data_all.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (c, i) {
                        if (i == data_all.length) {
                          if (!has_more) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(child: Text("Loaded ${data_all.length}/${data_all.length} items")),
                            );
                          }

                          load_more();

                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft, //
                                child: Text(data_all[i]['student_name'] ?? '', overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Container(
                              width: 50, //
                              alignment: Alignment.center,
                              child: Text(data_all[i]['code'] ?? ''), //
                            ),
                            Container(
                              width: 50, //
                              alignment: Alignment.center,
                              child: Text(data_all[i]['type'] ?? ''),
                            ),
                            Container(
                              width: 100, //
                              alignment: Alignment.center,
                              child: Text(data_all[i]['scan_at'] ?? ''),
                            ),
                            SizedBox(width: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {}, //
      //   child: const Icon(Icons.download),
      // ),
    );
  }
}
