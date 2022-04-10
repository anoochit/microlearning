import 'package:shared_preferences/shared_preferences.dart';

Future<void> setCourseRoute(String courseId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('courseId', courseId);
}

Future<String?> getCourseRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('courseId');
}
