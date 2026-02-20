// flutter build web --release
import 'package:flutter/foundation.dart';

String TITLE = "GTR App";

String DEPARTMENT_NAME_EN = "Department of Telecommunications and Network Engineering";
String DEPARTMENT_NAME_FR = "Génie des Télécommunications et Réseaux";

String HOST_API = kDebugMode ? 'http://127.0.0.1:8000' : 'https://api.codeshift.me';
// String HOST_API = 'https://api.codeshift.me';

String MINIO = kDebugMode ? 'https://dev_pub.codeshift.me' : 'https://pub.codeshift.me';
// String MINIO = 'https://pub.codeshift.me';
String MINIO_PUBLIC = '$MINIO/public';
