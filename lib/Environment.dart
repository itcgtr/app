// flutter build web --release
import 'package:flutter/foundation.dart';

String TITLE = 'GTR Application';

String DEPARTMENT_NAME_EN = "Department of Telecommunications and Network Engineering";
String DEPARTMENT_NAME_FR = "Génie des Télécommunications et Réseaux";

// fastapi URL
String HOST_API = kDebugMode ? 'http://127.0.0.1:8000' : 'https://api.codeshift.me';

// minio URL public
String MINIO_PUBLIC = kDebugMode ? 'http://gtr-server:9000/public' : 'https://sss.gtr.muysengly.com/public';

String LOGO_ITC = "$MINIO_PUBLIC/assets/logo_itc.png";
String LOGO_GTR = "$MINIO_PUBLIC/assets/logo_gtr.png";
String BACKGROUND = "$MINIO_PUBLIC/assets/background.png";

List<String> BANNERS = [
  "$MINIO_PUBLIC/assets/banner/image_1.jpeg",
  "$MINIO_PUBLIC/assets/banner/image_2.jpeg",
  "$MINIO_PUBLIC/assets/banner/image_3.png", //
];
