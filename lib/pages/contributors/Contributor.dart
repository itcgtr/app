import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/pages/contributors/Update_Form.dart';
import 'package:gtr_app/pages/contributors/View_Form.dart';
import 'package:gtr_app/themes/Theme_Data.dart';
import 'package:gtr_app/navigators/Routes.dart';
import 'package:gtr_app/navigators/Navigator_Left.dart';
import 'package:gtr_app/utilities/Debug.dart';

void main() {
  runApp(const Contributor());
}

class Contributor extends StatelessWidget {
  const Contributor({super.key});
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
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  Timer? _debounce;

  FlutterSecureStorage secure_storage = FlutterSecureStorage();
  String? access_token;

  List<Map<String, dynamic>> all_data = [];
  List<Map<String, dynamic>> search_data = [];

  bool is_search = false;

  TextEditingController c_search = TextEditingController();

  bool is_admin = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
    access_token = await secure_storage.read(key: 'access_token');
    debug("Access Token: $access_token");

    if (access_token != null) {
      dio.options.headers['Authorization'] = 'Bearer $access_token';
    }

    await dio
        .post(
          "/contributor/read", //
          data: FormData.fromMap({}),
        )
        .then((r) {
          // debug("Contributor Data: ${r.data}");
          all_data = List<Map<String, dynamic>>.from(r.data);
          search_data = List<Map<String, dynamic>>.from(r.data);
          if (!mounted) return;
          setState(() {});
        });

    if (is_search) {
      on_search(c_search.text);
    }
  }

  void on_search(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (all_data.isEmpty) {
        search_data = [];
        setState(() {});
        return;
      }
      final searchLower = value.toLowerCase();
      search_data = all_data.where((d) {
        for (var key in d.keys) {
          if (d[key]?.toString().toLowerCase().contains(searchLower) ?? false) {
            return true;
          }
        }
        return false;
      }).toList();
      setState(() {});
    });
  }

  void on_reorder(int old_order, int new_order) async {
    if (new_order > old_order) new_order -= 1;

    int old_order_value = search_data[old_order]['order'];
    int new_order_value = search_data[new_order]['order'];

    search_data.insert(new_order, search_data.removeAt(old_order));

    await dio
        .post(
          "/contributor/reorder", //
          data: FormData.fromMap({
            "old_order": old_order_value, //
            "new_order": new_order_value, //
          }),
        )
        .then((r) {
          init();
        });

    setState(() {});
  }

  void on_edit(int index) async {
    //
    debug(search_data[index]);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              input_json: {
                'id': search_data[index]['_id']['\$oid'] ?? '', //
                'name': search_data[index]['name'] ?? '', //
                'position': search_data[index]['position'] ?? '',
                'description': search_data[index]['description'] ?? '', //
              },
            ),
          ),
        )
        .then((output_json) async {
          debug("Output JSON: $output_json");
          if (output_json != null) {
            await dio.post(
              "/contributor/update", //
              data: FormData.fromMap({
                "id": output_json['id'], //
                "name": output_json['name'], //
                "position": output_json['position'], //
                "description": output_json['description'], //
              }),
            );
          }
          init();
          show_snackbar(context: context, message: "Update successful", color: Colors.green);
        })
        .catchError((e) {
          show_snackbar(context: context, message: "Update failed", color: Colors.red);
        });
  }

  void on_delete(int i) async {
    //
    await dio
        .post(
          "/contributor/delete", //
          data: FormData.fromMap({
            "id": search_data[i]['_id']['\$oid'] ?? '', //
          }),
        )
        .then((r) {
          init();
          show_snackbar(context: context, message: "Delete successful", color: Colors.green);
        })
        .catchError((e) {
          show_snackbar(context: context, message: "Delete failed", color: Colors.red);
        });

    Navigator.of(context).pop(); // Dismiss dialog
  }

  void on_check_admin() async {
    if (access_token == null) {
      show_snackbar(context: context, message: "Please sign in first", color: Colors.red);
      return;
    }

    await dio
        .post(
          "/credential/read", //
          data: FormData.fromMap({}),
        )
        .then((r) {
          // debug(r.data);
          if (r.data['is_admin'] == true) {
            is_admin = true;
            setState(() {});
            show_snackbar(context: context, message: "Admin access granted", color: Colors.green);
          } else {
            show_snackbar(context: context, message: "Admin access denied", color: Colors.red);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: is_search
            ? TextField(
                controller: c_search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  border: InputBorder.none, //
                ),
                onChanged: (value) {
                  on_search(value);
                },
              )
            : Text("Contributors"), //
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
                c_search.clear();
                search_data = List<Map<String, dynamic>>.from(all_data);
                setState(() {});
              },
              icon: Icon(Icons.close),
            ),
          //
          if (!is_admin)
            IconButton(
              onPressed: () {
                // check if user is admin
                debug("Checking admin status...");
                on_check_admin();
              },
              icon: Icon(Icons.edit),
            ),
          if (is_admin)
            IconButton(
              onPressed: () {
                is_admin = false;
                setState(() {});
              },
              icon: Icon(Icons.close),
            ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            footer: SizedBox(height: 80),
            onReorder: on_reorder,
            children: [
              for (int i = 0; i < search_data.length; i++)
                ListTile(
                  key: ValueKey(search_data[i]['order']),
                  contentPadding: const EdgeInsets.only(left: 8, right: 8),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      is_search || !is_admin
                          ? SizedBox.shrink() //
                          : ReorderableDragStartListener(index: i, child: Icon(Icons.drag_indicator)),
                      SizedBox(width: 8),
                      search_data[i]['image'] == null
                          ? Image.network(LOGO_GTR, width: 50, height: 50, fit: BoxFit.cover) //
                          : Image.network('$MINIO_PUBLIC/${search_data[i]['image']}', width: 50, height: 50, fit: BoxFit.cover), //
                    ],
                  ),
                  title: Text(search_data[i]['name'] ?? ''),
                  subtitle: Text(search_data[i]['position'] ?? ''),
                  trailing: !is_admin
                      ? SizedBox.shrink() //
                      : IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => on_edit(i), //
                        ),
                  // view details
                  onTap: () {
                    debug("Tapped on ${search_data[i]['name']}");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => View_Form(
                          input_json: {
                            'image': search_data[i]['image'] ?? '', //
                            'name': search_data[i]['name'] ?? '', //
                            'position': search_data[i]['position'] ?? '', //
                            'description': search_data[i]['description'] ?? '', //
                          },
                        ),
                      ),
                    );
                  },
                  // delete
                  onLongPress: () {
                    debug("Long pressed on ${search_data[i]['name']}");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete ${search_data[i]['name']}'),
                          content: Text('Are you sure?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                            TextButton(
                              onPressed: () => on_delete(i), //
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !is_admin
          ? SizedBox.shrink() //
          : SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'add',
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      onPressed: () async {
                        await dio
                            .post(
                              "/contributor/create", //
                              data: FormData.fromMap({}),
                            )
                            .then((r) {
                              init();
                            });
                      },
                      tooltip: 'Add new contributor',
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
        // behavior: SnackBarBehavior.floating,
        // margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
}
