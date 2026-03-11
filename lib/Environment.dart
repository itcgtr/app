// flutter build web --release
import 'package:flutter/foundation.dart';

String TITLE = 'GTR Application';

String DEPARTMENT_NAME_EN = "Department of Telecommunications and Network Engineering";
String DEPARTMENT_NAME_FR = "Génie des Télécommunications et Réseaux";

String HOST_API = kReleaseMode ? 'https://apigtr.muysengly.com' : 'http://127.0.0.1:8000';
String MINIO_PUBLIC = kReleaseMode ? 'https://sssgtr.muysengly.com/public' : 'http://gtr-server:9000/public';
