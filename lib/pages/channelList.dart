import 'package:flutter/material.dart';
import 'package:reproductoriptv/layouts/layouts.dart';

import '../model/canal.dart';


class ChannelList extends StatelessWidget {
  final List<Canal> channels;

  const ChannelList({super.key, required this.channels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canales"), backgroundColor: Colors.amberAccent),
      body:  Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: channels.length,
          itemBuilder: (context, index) {
            final canal = channels[index];

            return ChannelLayout(canal: canal);
          },
        ),
      ),
    );
  }
}