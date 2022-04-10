import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microlearning/pages/utils.dart';
import 'package:microlearning/services/authentication_service.dart';
import 'package:microlearning/services/firestore_service.dart';
import 'package:video_player/video_player.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({Key? key, required this.courseId}) : super(key: key);

  final String courseId;

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  CourseController courseController = Get.put(CourseController());

  bool isEnroll = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.pause();
    courseController.vidoeUrl.value = "";
    //videoPlayerController.dispose();
    //chewieController.dispose();
  }

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
        child: (widget.courseId == null)
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inbox_outlined, size: 80),
                    const Text(
                      "ไม่พบข้อมูล",
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.offNamed("/course");
                      },
                      child: const Text("กลับไปหน้ารายวิชา"),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 970,
                    child: FutureBuilder(
                      future: firebaseFirestore.collection("courses").doc(widget.courseId).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        // has error
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.inbox_outlined, size: 80),
                                Text(
                                  "ไม่พบข้อมูล",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          );
                        }

                        // loading
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 2,
                            child: const Center(
                              child: Text('กำลังโหลดข้อมูลรายวิชา...'),
                            ),
                          );
                        }

                        // has data and get topics
                        var doc = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //title
                            Text(doc!['title'], style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 16),

                            // video
                            GetBuilder<CourseController>(
                              id: 'video',
                              init: CourseController(),
                              builder: (controller) {
                                String url =
                                    (controller.vidoeUrl.value == "") ? doc['video'] : controller.vidoeUrl.value;
                                log("load video = " + url);

                                // init video controller
                                videoPlayerController = VideoPlayerController.network(url)..initialize();
                                chewieController = ChewieController(
                                  videoPlayerController: videoPlayerController,
                                  aspectRatio: getScale(),
                                  placeholder: Container(
                                    color: Colors.black,
                                  ),
                                  materialProgressColors: ChewieProgressColors(
                                    playedColor: Colors.lightGreen,
                                    bufferedColor: Colors.deepPurple,
                                    handleColor: Colors.white,
                                    backgroundColor: Colors.grey,
                                  ),
                                  autoPlay: false,
                                  looping: false,
                                  showOptions: true,
                                );

                                // show video
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: AspectRatio(
                                    aspectRatio: getScale(),
                                    child: Chewie(
                                      controller: chewieController,
                                    ),
                                  ),
                                );

                                //return VideoPlayer(url: url);
                              },
                            ),
                            const SizedBox(height: 16),

                            // decription
                            const Text("รายละเอียด", style: TextStyle(fontSize: 24)),
                            const SizedBox(height: 16),
                            Text(doc['description']),
                            const SizedBox(height: 16),

                            // check user enroll & course enroll able
                            (doc['enable'] == false)
                                ? ElevatedButton(onPressed: () {}, child: const Text("ยังไม่เปิดให้ลงทะเบียน"))
                                // check signin
                                : (isSignIn())
                                    // already signin check user has enroll & paid
                                    ? FutureBuilder(
                                        future: firebaseFirestore
                                            .collection("enrolls")
                                            .doc(firebaseAuth.currentUser!.uid.toString() + "_" + widget.courseId)
                                            .get(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                          // loading
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          // has error
                                          if (snapshot.hasError) {
                                            return Text(snapshot.error.toString());
                                          }

                                          // has data
                                          var enroll = snapshot.data;

                                          if (enroll!.exists) {
                                            if (enroll['paid'] == false) {
                                              // user not paid show paid button
                                              return ElevatedButton(
                                                onPressed: () {
                                                  Beamer.of(context).beamToNamed("/payment");
                                                },
                                                child: const Text("กรุณาชำระเงิน"),
                                              );
                                            }

                                            return Container();
                                          } else {
                                            return ElevatedButton(
                                              child: const Text("ลงทะเบียน"),
                                              onPressed: () {
                                                // ask for enroll
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    content: const Text("คุณต้องการลงทะเบียนในรายวิชานี้ใช่หรือไม่?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          // pop dialog
                                                          Beamer.of(context).popRoute();
                                                        },
                                                        child: const Text("ไม่ใช่"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          // pop dialog
                                                          Beamer.of(context).popRoute();
                                                          // enroll
                                                          firebaseFirestore
                                                              .collection("enrolls")
                                                              .doc(firebaseAuth.currentUser!.uid.toString() +
                                                                  "_" +
                                                                  widget.courseId)
                                                              .set({
                                                            "courseId": widget.courseId,
                                                            "courseTitle": doc['title'],
                                                            "coursePrice": doc['price'],
                                                            "userId": firebaseAuth.currentUser!.uid,
                                                            "paid": false,
                                                            "createAt": DateTime.now().millisecondsSinceEpoch,
                                                          });

                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                            content: Text(
                                                                "ลงทะเบียนเรียบร้อยแล้ว กรุณาชำระเงินและแจ้งการโอนเงิน..."),
                                                            duration: Duration(seconds: 3),
                                                          ));
                                                        },
                                                        child: const Text("ใช่"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          Beamer.of(context).beamToNamed("/signin");
                                        },
                                        child: const Text("กรุณาล็อกอินเพื่อลงทะเบียน"),
                                      ),

                            // topics
                            const SizedBox(height: 16),
                            FutureBuilder(
                              future: firebaseFirestore
                                  .collection("courses")
                                  .doc(widget.courseId)
                                  .collection("topics")
                                  .get(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> topicSnapshot) {
                                // has error
                                if (topicSnapshot.hasError) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text("ไม่พบข้อมูล"),
                                    ],
                                  );
                                }

                                // loading
                                if (topicSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                // show topics
                                var topics = topicSnapshot.data!.docs;
                                if (topics.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("เนื้อหา", style: TextStyle(fontSize: 24)),
                                      const SizedBox(height: 16),
                                      Column(
                                        children: topics.map((topic) {
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            child: InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.movie,
                                                      size: 32,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      topic['title'],
                                                      maxLines: 2,
                                                      //style: const TextStyle(fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                // course enbale enroll and already enroll
                                                if ((doc['enable'] == true) && (isEnroll == true)) {
                                                  chewieController.pause();
                                                  courseController.vidoeUrl.value = topic['video'];
                                                  courseController.update(['video']);
                                                }
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),

                            const SizedBox(height: 32),
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

  double videoContainerRatio = 0.5;
  double getScale() {
    double videoRatio = videoPlayerController.value.aspectRatio;

    if (videoRatio < videoContainerRatio) {
      return videoContainerRatio / videoRatio;
    } else {
      return videoRatio / videoContainerRatio;
    }
  }
}

class CourseTopic {
  String title;
  String description;
  String video;
  CourseTopic({
    required this.title,
    required this.description,
    required this.video,
  });
}

class CourseController extends GetxController {
  RxString vidoeUrl = "".obs;
}

// class VideoPlayer extends StatefulWidget {
//   const VideoPlayer({Key? key, required this.url}) : super(key: key);

//   final String url;

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {
//   @override
//   void dispose() {
//     chewieController.pause();
//     videoPlayerController.dispose();
//     chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController = VideoPlayerController.network(widget.url)..initialize();
//     chewieController = ChewieController(
//       videoPlayerController: videoPlayerController,
//       aspectRatio: getScale(),
//       placeholder: Container(
//         color: Colors.black,
//       ),
//       materialProgressColors: ChewieProgressColors(
//         playedColor: Colors.red,
//         handleColor: Colors.white,
//         backgroundColor: Colors.grey,
//         bufferedColor: Colors.lightGreen,
//       ),
//       autoPlay: false,
//       looping: false,
//       showOptions: true,
//       allowFullScreen: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: AspectRatio(
//         aspectRatio: getScale(),
//         child: Chewie(
//           controller: chewieController,
//         ),
//       ),
//     );
//   }

//   double videoContainerRatio = 0.5;

//   double getScale() {
//     double videoRatio = videoPlayerController.value.aspectRatio;

//     if (videoRatio < videoContainerRatio) {
//       return videoContainerRatio / videoRatio;
//     } else {
//       return videoRatio / videoContainerRatio;
//     }
//   }
// }
