import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_app/constants.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final int index;
  final Function(String) skipVideo;

  const VideoPlayerWidget(
      {super.key,
      required this.videoUrl,
      required this.index,
      required this.skipVideo});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with TickerProviderStateMixin {
  int index = 0;
  bool isDisplayed = true;

  VideoPlayerController? _controller;
  Duration _currentPosition = Duration.zero;

  late Animation<double> _animation;
  late Animation<double> _forwardAnimation;

  int maxFailedLoadAttempts = 3;
  bool isFirst = true;
  int exactMin = 0;
  int exactSeconds = 0;
  int playedMin = 0;
  int playedSeconds = 0;
  bool _showAnimation = false;
  bool forwardShowAnimation = false;
  late AnimationController _animationController;
  late AnimationController forwardAnimationController;

  animationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    forwardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showAnimation = false;
        });
      }
    });
    forwardAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          forwardShowAnimation = false;
        });
      }
    });

    // Define the animation curve
    final curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Define the animation
    _animation = Tween<double>(begin: 1, end: 0.5).animate(curve);
    _forwardAnimation = Tween<double>(begin: 1, end: 0.5).animate(curve);

    // Start the animation
  }

  @override
  void initState() {
    super.initState();
    index = widget.index;
    setState(() {});
    videoLoad();
    animationController();
  }

  void videoLoad() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..initialize().then((_) {
        _controller!.addListener(() {
          setState(() {
            _currentPosition = _controller!.value.position;
            if (_currentPosition.inSeconds ==
                _controller!.value.duration.inSeconds) {
              exactMin = 0;
              exactSeconds = 0;
              playedSeconds = 0;
              playedMin = 0;
              _controller!.pause();

              index = index + 1;

              return;
            }

            if (_currentPosition.inSeconds % 60 == 0) {
              playedSeconds = 0;
              playedMin = _currentPosition.inSeconds ~/ 60;
            } else if (_currentPosition.inSeconds < 60) {
              playedSeconds = _currentPosition.inSeconds;
              playedMin = 0;
            } else {
              playedSeconds = _currentPosition.inSeconds % 60;
              playedMin = playedMin = _currentPosition.inSeconds ~/ 60;
            }
          });
        });

        exactSeconds = _controller!.value.duration.inSeconds % 60;
        exactMin = _controller!.value.duration.inSeconds ~/ 60;
        _controller!.setLooping(true);
        setState(() {
          _controller!.play();
        });
      });
  }

///////////////////////////////////////////////////////////
  /// ENABLE AND DISABLE ICONS DISPLAY ON VIDEO SCREEN
  ///
  void setDisplay() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isDisplayed = !isDisplayed;
      });
    });
  }

///////////////////////////////////////////////////////////
  /// ENABLE AND DISABLE ICONS DISPLAY ON VIDEO SCREEN
  ///
  void setDisplayautomatic() {
    setState(() {
      isDisplayed = !isDisplayed;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _controller!.dispose();
  }

///////////////////////////////////////////////////////////
  /// CHANGE ORIENTAION TO PORTRAIT WHEN BACK BUTTON CLICKED
  ///

///////////////////////////////////////////////////////////
  /// SEEK 5 SECONDS FORWARD VIDEO
  ///
  void seekForward() {
    Duration currentPosition = _controller!.value.position;
    Duration newPosition = currentPosition + const Duration(seconds: 5);
    _controller!.seekTo(newPosition);
    setState(() {});
  }

///////////////////////////////////////////////////////////
  /// SEEK 5 SECONDS BACKWARD VIDEO
  ///
  void seekbackward() {
    Duration currentPosition = _controller!.value.position;
    if (currentPosition > const Duration(seconds: 5)) {
      Duration newPosition = currentPosition - const Duration(seconds: 5);
      _controller!.seekTo(newPosition);
      setState(() {});
    }
  }

///////////////////////////////////////////////////////////
  /// SEEK TO SPECIFIC POSITION  VIDEO
  ///
  void seekToPosition(Duration position) {
    _controller!.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return _controller!.value.isInitialized
        ? SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
                Positioned.fill(
                    child: InkWell(
                  onTap: setDisplayautomatic,
                  child: Container(),
                )),
                if (isDisplayed)
                  Positioned.fill(
                      child: InkWell(
                    onTap: setDisplayautomatic,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.3, 1.0],
                        ),
                      ),
                    ),
                  )),
                if (isDisplayed)
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: _controller!.value.isBuffering
                            ? const SizedBox(
                                height: 35,
                                width: 35,
                                child: CircularProgressIndicator())
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: _controller!.value.position <
                                              const Duration(seconds: 5)
                                          ? null
                                          : () {
                                              if (index > 0) {
                                                widget.skipVideo("backward");
                                              }
                                            },
                                      child: previousVideoIcon(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _controller!.value.isPlaying
                                              ? _controller!.pause()
                                              : _controller!.play();
                                        });
                                        if (_controller!.value.isPlaying) {
                                          setDisplay();
                                        }
                                      },
                                      child: pauseVideoIcon(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        widget.skipVideo("forward");
                                      },
                                      child: nextVideoIcon(),
                                    ),
                                  ],
                                ),
                              ),
                      )),
                Positioned.fill(
                    right: MediaQuery.of(context).size.width * .7,
                    child: InkWell(
                        onTap: setDisplayautomatic,
                        onDoubleTap: () {
                          setState(() {
                            _showAnimation = true;
                            _animationController.reset();
                            _animationController.forward();
                          });

                          setDisplayautomatic();
                          seekbackward();
                        },
                        child: _showAnimation
                            ? AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          width: 100,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10000),
                                                    bottomRight:
                                                        Radius.circular(10000)),
                                            shape: BoxShape.rectangle,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "<< 5s ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : null)),
                Positioned.fill(
                    left: MediaQuery.of(context).size.width * .7,
                    child: InkWell(
                        onTap: setDisplayautomatic,
                        onDoubleTap: () {
                          setState(() {
                            forwardShowAnimation = true;
                            forwardAnimationController.reset();
                            forwardAnimationController.forward();
                          });

                          setDisplayautomatic();
                          seekForward();
                        },
                        child: forwardShowAnimation
                            ? AnimatedBuilder(
                                animation: _forwardAnimation,
                                builder: (context, child) {
                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(
                                          width: 100,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10000),
                                                    bottomLeft:
                                                        Radius.circular(10000)),
                                            shape: BoxShape.rectangle,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "5s >>",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : null)),
                if (isDisplayed)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: Slider(
                      value: _currentPosition.inSeconds.toDouble(),
                      min: 0,
                      max: _controller!.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        var position = Duration(seconds: value.toInt());
                        seekToPosition(position);
                      },
                    ),
                  ),
                if (isDisplayed)
                  Positioned(
                      left: MediaQuery.of(context).size.width * .035,
                      bottom: MediaQuery.of(context).size.height * .13,
                      child: Text(
                        "${playedMin > 0 ? '$playedMin:$playedSeconds' : "0:$playedSeconds"} / ${exactMin > 0 ? '$exactMin:$exactSeconds' : exactSeconds}",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

///////////////////////////////////////////////////////////
  /// PAUSE VIDEO ICON
  ///
  CircleAvatar pauseVideoIcon() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.black.withOpacity(.3),
      child: Icon(
        _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /// PREVIOUS VIDEO ICON
  ///

  CircleAvatar previousVideoIcon() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.black.withOpacity(.3),
      child: Icon(
        Icons.skip_previous,
        size: 30,
        color: index <= 0 ? Colors.grey : Colors.white,
      ),
    );
  }

///////////////////////////////////////////////////////////
  /// NEXT VIDEO ICON
  ///
  CircleAvatar nextVideoIcon() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.black.withOpacity(.3),
      child: Icon(
        Icons.skip_next_sharp,
        size: 30,
        color: index >= Constants.videoIds.length ? Colors.grey : Colors.white,
      ),
    );
  }
}
