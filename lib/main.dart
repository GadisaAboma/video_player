import 'package:flutter/material.dart';
import 'package:video_player/constants.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> videoIds = [
    "eFDFooCflDdkcFcYxeKDSXeyW00FA00nXeOoMJeakvVSA",
    "w9qAyPlIaEAaeSuoB36r22xutGF800mXxZ00skcDKsjFc",
    "g5CwrZaaTWYdjb2peU818fzGkSvASW00tHnziQAQJq5I",
    "WrEk1kQpRcqAeTGCnrU00nJOUekJesdIL43NrYz01RYc",
    "zNvlO3QKLbe5Yu0101yQO8SRUDeycIL01cLOB02dhAvjhho",
    "TU4tu02tS7702jWUDVk5275JZvlNgv5WmyT6kLcV6awDw",
    "WVy89Zrbw15xAy8nFAGRljwAGGZq36BwNZSckOz1HU4",
    "ApFgkkaJc1SPL64C7XF2dA00Nh1iny00Dr67kVZxRptfQ"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Video Streamer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Video Streamer'),
        ),
        body: PageView.builder(
          itemBuilder: (context, index) => Center(
            child: VideoPlayerWidget(
                videoUrl: Constants.getVideoLink(videoIds[index])),
          ),
          itemCount: videoIds.length,
        ),
      ),
    );
  }
}
