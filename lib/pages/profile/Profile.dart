import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_gtr/pages/profile/Update_Form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:app_gtr/Environment.dart';
import 'package:app_gtr/utilities/Debug.dart';
import 'package:app_gtr/navigators/Routes.dart';
import 'package:app_gtr/themes/Theme_Data.dart';
import 'package:app_gtr/navigators/Navigator_Left.dart';

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
      home: const Profile_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  //
  @override
  void initState() {
    debug('Profile Page Loaded');
    super.initState();
    init();
  }

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: HOST_API, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  FlutterSecureStorage secure_storage = FlutterSecureStorage();
  String? access_token;

  Map<String, dynamic> credential_data = {};

  //
  void init() async {
    credential_data = {};

    access_token = await secure_storage.read(key: 'access_token');
    // debug('Access Token: $access_token');

    if (access_token != null) {
      dio.options.headers['Authorization'] = 'Bearer $access_token';

      await dio
          .post(
            '/credential/read', //
            data: FormData.fromMap({}),
          )
          .then((r) {
            // debug('Credential Data: ${r.data}');
            credential_data = Map<String, dynamic>.from(r.data);
            setState(() {});
          })
          .catchError((e) {});
    }
    setState(() {});
  }

  //
  void on_qr_scan() async {
    Navigator //
        .of(context)
        .push(Routes.QR_Scan())
        .then((output) async {
          if (output != null) {
            await dio
                .post(
                  "/attendance/qr_scan",
                  data: FormData.fromMap({
                    "code": output, //
                  }),
                )
                .then((r) {
                  show_snackbar(context: context, message: 'Scan Successful', color: Colors.green);
                })
                .catchError((e) {
                  show_snackbar(context: context, message: 'Scan Failed: $e', color: Colors.red);
                });
          }
        });
  }

  //
  void on_edit_id() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'ID', //
              input: credential_data['id'] ?? '',
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'id': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_edit_name() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'Name', //
              input: credential_data['name'] ?? '',
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'name': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_edit_phone() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'Phone Number', //
              input: credential_data['phone_number'] ?? '',
              keyboard_type: TextInputType.phone,
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'phone_number': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_edit_email() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'Email', //
              input: credential_data['email'] ?? '',
              keyboard_type: TextInputType.emailAddress,
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'email': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_edit_address() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'Address', //
              input: credential_data['address'] ?? '',
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'address': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_edit_username() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'Username', //
              input: credential_data['username'] ?? '',
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'username': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_edit_password() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'Password', //
              input: '',
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'password': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_edit_telegram() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Update_Form(
              title: 'Telegram ID', //
              input: credential_data['telegram_id'] ?? '',
              keyboard_type: TextInputType.number,
            ),
          ),
        )
        .then((output) async {
          debug(output);
          if (output == null) return;
          await dio
              .post(
                '/credential/update', //
                data: FormData.fromMap({'telegram_id': output}),
              )
              .then((r) {
                init();
                show_snackbar(context: context, message: 'Update Success', color: Colors.green);
              })
              .catchError((e) {
                show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
              });
        });
  }

  //
  void on_upload_profile_image() async {
    //
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    await dio
        .post(
          '/credential/upload', //
          data: FormData.fromMap({
            'background_image': MultipartFile.fromBytes(
              await image.readAsBytes(), //
              filename: image.name,
            ),
          }),
        )
        .then((r) {
          init();
          show_snackbar(context: context, message: 'Update Success', color: Colors.green);
        })
        .catchError((e) {
          show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
        });
  }

  //
  void on_upload_background_image() async {
    //
    // upload background image
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    // if no image selected
    if (image == null) return;

    // upload image to server
    await dio
        .post(
          '/credential/upload', //
          data: FormData.fromMap({
            'profile_image': MultipartFile.fromBytes(
              await image.readAsBytes(), //
              filename: image.name,
            ),
          }),
        )
        .then((r) {
          init();
          show_snackbar(context: context, message: 'Update Success', color: Colors.green);
        })
        .catchError((e) {
          show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  // background and profile
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            width: 600,
                            height: 200, //
                            child:
                                credential_data['background_image'] ==
                                    null //
                                ? Image.network(BACKGROUND, fit: BoxFit.cover)
                                : Image.network(
                                    '$MINIO_PUBLIC/${credential_data['background_image']}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Image.network(BACKGROUND, fit: BoxFit.cover),
                                  ),
                          ),
                          if (access_token != null)
                            IconButton(
                              onPressed: () => on_upload_background_image(),
                              icon: Icon(Icons.upload_outlined, color: Colors.blue),
                            ),
                        ],
                      ),

                      // profile
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: credential_data['profile_image'] == null
                                ? Image.network(LOGO_GTR, fit: BoxFit.cover) //
                                : Image.network(
                                    '$MINIO_PUBLIC/${credential_data['profile_image']}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Image.network(LOGO_GTR, fit: BoxFit.cover),
                                  ), //
                          ),
                          if (access_token != null)
                            IconButton(
                              onPressed: () => on_upload_profile_image(),
                              icon: Icon(Icons.upload_outlined, color: Colors.blue),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // sign in and sign up buttons
                  if (access_token == null) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Sign_In()).then((_) => init());
                          },
                          child: Text('Sign In'),
                        ), //
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Sign_Up()).then((v) {
                              if (v == true) {
                                Navigator.of(context).push(Routes.Sign_In()).then((_) => init());
                              }
                            });
                          },
                          child: Text('Sign Up'),
                        ), //
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Reset()).then((v) {
                              if (v == true) {
                                Navigator.of(context).push(Routes.Sign_In()).then((_) => init());
                              }
                            });
                          },
                          child: Text('Reset'),
                        ), //
                      ],
                    ),
                  ],

                  // teacher's tools
                  if (access_token != null && credential_data['is_teacher'] == true) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // QR attendance
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.QR_Generator());
                          },
                          child: Text('QR Generate'),
                        ), //
                        // face attendance
                        // OutlinedButton(onPressed: () {}, child: Text('Face Attendance')), //
                      ],
                    ),
                  ],

                  // student's tools
                  if (access_token != null && credential_data['is_teacher'] != true) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () => on_qr_scan(), //
                          child: Text('QR Scan'),
                        ), //
                        //
                      ],
                    ),
                  ],

                  SizedBox(height: 8),

                  ExpansionTile(
                    title: Text('Information', style: TextStyle(fontWeight: FontWeight.bold)),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    initiallyExpanded: true,
                    children: [
                      //
                      Row(
                        children: [
                          Icon(Icons.badge), //
                          SizedBox(width: 8, height: 40),
                          Text("ID: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(credential_data['id'] ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_id(),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.person), //
                          SizedBox(width: 8, height: 40),
                          Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(credential_data['name'] ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_name(),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.phone), //
                          SizedBox(width: 8, height: 40),
                          Text("Phone: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(credential_data['phone'] ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_phone(),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.email), //
                          SizedBox(width: 8, height: 40),
                          Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(credential_data['email'] ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_email(),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.place), //
                          SizedBox(width: 8, height: 40),
                          Text("Address: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(credential_data['address'] ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_address(),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // credential
                  ExpansionTile(
                    title: Text('Credential', style: TextStyle(fontWeight: FontWeight.bold)),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    initiallyExpanded: kDebugMode,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person), //
                          SizedBox(width: 8, height: 40),
                          Text("Username: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(credential_data['username'] ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_username(),
                            ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.security_rounded), //
                          SizedBox(width: 8, height: 40),
                          Text("Password: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(access_token != null ? "**********" : ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_password(),
                            ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(Icons.telegram), //
                          SizedBox(width: 8, height: 40),
                          Text("Telegram ID: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(credential_data['telegram_id'] ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              icon: Icon(Icons.edit), //
                              onPressed: () => on_edit_telegram(),
                            ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // sign out button
                  if (access_token != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            secure_storage.delete(key: 'access_token');
                            init();
                          },
                          child: Text('Sign Out', style: TextStyle(color: Colors.red)),
                        ), //
                      ],
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
      ),
    );
}
