import 'package:flutter/material.dart';
import 'package:video_player_app/constants.dart';
import 'package:video_player_app/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController pageController = PageController();
  bool isDark = true;

  void skipVideo(String type) {
    if (type == "forward") {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: isDark ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      title: 'Video Streamer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
              },
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
          centerTitle: false,
          title: const Text('Video Streamer'),
        ),
        body: PageView.builder(
          controller: pageController,
          itemBuilder: (context, index) => Center(
            child: VideoPlayerWidget(
              skipVideo: skipVideo,
              videoUrl: Constants.getVideoLink(Constants.videoIds[index]),
              index: index,
            ),
          ),
          itemCount: Constants.videoIds.length,
        ),
      ),
    );
  }
}
