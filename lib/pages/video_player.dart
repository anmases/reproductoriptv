import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:wakelock/wakelock.dart';


class VideoPlayer extends StatefulWidget {
  final String url;
  const VideoPlayer({super.key, required this.url});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late Future<void> initialization;
  late VlcPlayerController controller;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    controller = VlcPlayerController.network(widget.url, hwAcc: HwAcc.auto);
    initialization = controller.initialize();
    _hideSystemUI();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return FutureBuilder<void>(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: GestureDetector(
              onTap: _toggleSystemUI,
              child: Center(
                child: AspectRatio(
                  aspectRatio: screenSize.width / screenSize.height,
                  child: VlcPlayer(
                    controller: controller,
                    aspectRatio: screenSize.width / screenSize.height,
                    placeholder: const CircularProgressIndicator(),
                  ),
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

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _showSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  void _toggleSystemUI() {
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      _hideSystemUI();
    } else {
      _showSystemUI();
    }
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    controller.dispose();
    _showSystemUI(); // Restaura la UI del sistema cuando el widget se destruye
  }
}