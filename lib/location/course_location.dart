import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/pages/course_detail.dart';
import 'package:microlearning/pages/courses.dart';

class CourseLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/courses', '/courses/:courseId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        if (state.uri.pathSegments.contains('courses'))
          const BeamPage(
            key: ValueKey('courses'),
            title: 'Courses',
            child: CoursesPage(),
            type: BeamPageType.noTransition,
          ),
        if (state.pathParameters.containsKey('courseId'))
          BeamPage(
            key: ValueKey('course-${state.pathParameters['courseId']}'),
            title: 'Courses',
            child: CourseDetailPage(courseId: '${state.pathParameters['courseId']}'),
            type: BeamPageType.noTransition,
          ),
      ];
}
