import 'package:flutter/material.dart';
import 'package:app_gtr/pages/attendance/View_Attendance_001.dart';

import 'package:app_gtr/pages/contributors/Contributor.dart';
import 'package:app_gtr/pages/Contact_Us.dart';
import 'package:app_gtr/pages/Schedule.dart';
import 'package:app_gtr/pages/attendance/QR_Generator_Page.dart';
import 'package:app_gtr/pages/attendance/QR_Scan_Page.dart';

import 'package:app_gtr/pages/courses/Course.dart';
import 'package:app_gtr/pages/department/Alumni.dart';
import 'package:app_gtr/pages/department/Facilities.dart';
import 'package:app_gtr/pages/department/Staffs.dart';
import 'package:app_gtr/pages/department/Students.dart';
import 'package:app_gtr/pages/lab_and_service/Digital_FAB_Lab.dart';
import 'package:app_gtr/pages/lab_and_service/EMC_Lab.dart';
import 'package:app_gtr/pages/lab_and_service/Training.dart';
import 'package:app_gtr/pages/profile/Reset.dart';
import 'package:app_gtr/pages/profile/Sign_In.dart';
import 'package:app_gtr/pages/profile/Sign_Up.dart';
import 'package:app_gtr/pages/program/Associate_Degree.dart';
import 'package:app_gtr/pages/program/Engineer_Degree.dart';
import 'package:app_gtr/pages/project/Capacity_Building_Project.dart';
import 'package:app_gtr/pages/project/Publication.dart';
import 'package:app_gtr/pages/project/Research_Project.dart';

class Routes {
  // anonymous routes
  static Sign_In() => _route(Sign_In_Page());
  static Sign_Up() => _route(Sign_Up_Page());
  static Reset() => _route(Reset_Page());
  static View_Attendance() => _route(View_Attendance_001());
  static QR_Scan() => _route(QR_Scan_Page());
  static QR_Generator() => _route(QR_Generator_Page());

  //
  static Staffs() => _route(Staffs_Page());
  static Students() => _route(Students_Page());
  static Facilities() => _route(Facilities_Page());
  static Alumni() => _route(Alumni_Page());
  //
  static Associate_Degree() => _route(Associate_Degree_Page());
  static Engineer_Degree() => _route(Engineer_Degree_Page());
  //
  static Research_Project() => _route(Research_Project_Page());
  static Capacity_Building_Project() => _route(Capacity_Building_Page());
  static Publication() => _route(Publication_Page());
  //
  static Digital_Fab_Lab() => _route(Digital_Fab_Lab_Page());
  static EMC_Lab() => _route(EMC_Lab_Page());
  static Training() => _route(Training_Page());
  //
  static Contact_Us() => _route(Contact_Us_Page());
  static Schedule() => _route(Schedule_Page());
  //
  static Course() => _route(Course_Page());

  // exposed routes
  static final Map<String, WidgetBuilder> routes = {
    '/about': (context) => const Contributor_Page(), //
  };
}

MaterialPageRoute _route(Widget page) {
  return MaterialPageRoute(
    builder: (bc) => page, //
    settings: RouteSettings(), //
  );
}
