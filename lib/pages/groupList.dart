import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reproductoriptv/layouts/layouts.dart';
import 'package:reproductoriptv/pages/home.dart';

import '../model/canal.dart';
import 'channelList.dart';


class GroupListView extends StatelessWidget {
  final Map<String, List<Canal>> groups;
  final _storage =  const FlutterSecureStorage();

  const GroupListView(this.groups, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Grupos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
              _storage.deleteAll();
              },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: groups.keys.length,
          itemBuilder: (context, index) {
            final String groupTitle = groups.keys.elementAt(index);
            final List<Canal>? channels = groups[groupTitle];
            return GroupLayout(title: groupTitle, channels: channels);
          },
        ),
      ),
    );
  }
}