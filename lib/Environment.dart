// flutter build web --release
import 'package:flutter/foundation.dart';

String TITLE = 'GTR Application';

String DEPARTMENT_NAME_EN = "Department of Telecommunications and Network Engineering";
String DEPARTMENT_NAME_FR = "Génie des Télécommunications et Réseaux";

// stage
// String HOST_API = 'http://127.0.0.1:8000';
// String MINIO_PUBLIC = 'http://gtr-server:9000/public';

// product
String HOST_API = 'https://api.gtr.muysengly.com';
String MINIO_PUBLIC = 'http://sss.gtr.muysengly.com/public';

String LOGO_ITC = "$MINIO_PUBLIC/assets/logo_itc.png";
String LOGO_GTR = "$MINIO_PUBLIC/assets/logo_gtr.png";
String BACKGROUND = "$MINIO_PUBLIC/assets/background.png";

List<String> BANNERS = [
  "$MINIO_PUBLIC/assets/banner/image_1.jpeg",
  "$MINIO_PUBLIC/assets/banner/image_2.jpeg",
  "$MINIO_PUBLIC/assets/banner/image_3.png", //
];
