import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:microlearning/pages/utils.dart';
import 'package:microlearning/services/firestore_service.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appbarTitle(context),
      ),
      body: SafeArea(
        left: true,
        right: true,
        bottom: true,
        top: true,
        minimum: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 960,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("รายวิชา", style: TextStyle(fontSize: 28)),
                      const SizedBox(height: 16),

                      // list courses as grideview
                      FirestoreQueryBuilder(
                        query: firebaseFirestore.collection("courses"),
                        builder: (context, snapshot, child) {
                          // error
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }

                          // loading
                          if (snapshot.isFetching) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 2,
                              child: const Center(
                                child: Text('กำลังโหลดข้อมูลรายวิชา...'),
                              ),
                            );
                          }

                          // has data
                          var numberOfColumn = 3;
                          return ResponsiveBuilder(
                            builder: (context, sizingInformation) {
                              if (sizingInformation.isDesktop) {
                                numberOfColumn = 3;
                              } else if (sizingInformation.isTablet) {
                                numberOfColumn = 2;
                              } else {
                                numberOfColumn = 1;
                              }

                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: <Widget>[
                                  for (var course in snapshot.docs)
                                    SizedBox(
                                        width: (constraints.maxWidth / numberOfColumn) - 8,
                                        child: CourseCard(course: course)),
                                ],
                              );
                            },
                          );
                        },
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({Key? key, required this.course}) : super(key: key);

  final QueryDocumentSnapshot course;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          child: Stack(
            children: [
              Image(
                image: NetworkImage(course["image"]),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: constraints.maxWidth,
                  color: Colors.white.withOpacity(0.95),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      (course['price'] != null)
                          ? (course['price'] == 0)
                              ? const Text("ฟรี", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                              : Text("฿${course['price']}", style: const TextStyle(color: Colors.green))
                          : const Text("ฟรี", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Beamer.of(context).beamToNamed("/courses/${course.id}");
            // Get.to(
            //   () => CourseDetailPage(courseId: course.id),
            //   routeName: "course_detail",
            //   transition: Transition.noTransition,
            // );
          },
        ),
      );
    });
  }
}
