

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';


void main() => runApp(VideoPlayer());

class VideoPlayer extends StatefulWidget {
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late Future<void> initialization;
  late VlcPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VlcPlayerController.network('http://cowono.top:8080/live/41679070044426072/6711679070044426/53839.ts');
    initialization = controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Video Demo',
            home: Scaffold(
              body: Center(
                child: VlcPlayer(
                  controller: controller,
                  aspectRatio: controller.value.aspectRatio,
                  placeholder: const CircularProgressIndicator(),
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}