import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reproductoriptv/pages/channelList.dart';

import '../model/canal.dart';
import '../pages/video_player.dart';

///Disposición del elemento canal en la lista
class ChannelLayout extends StatelessWidget {
  final FocusNode focusNode = FocusNode();
  final Canal canal;

  ChannelLayout({super.key, required this.canal});

  @override
  Widget build(BuildContext context) {
    //Esto es para cuando esté localizado y se pulse ok
    return Focus(
        focusNode: focusNode,
        onKey: (FocusNode node, RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.select) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayer(url: canal.url),),);
          return KeyEventResult.handled; // Consumir el evento
        }
      }
      return KeyEventResult.ignored; // No consumir el evento
    },
        //Esto es para cuando hay un toque, es decir, se pulsa el táctil o con ratón
        child:InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayer(url: canal.url),),);
      },
          child: Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              children: [
                canal.logo != null && canal.logo.isNotEmpty ? Image.network(
              canal.logo,
              height: 30,
              width: 30,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.tv, size: 30); // Puedes retornar cualquier widget aquí, como un Icono o una Imagen por defecto.
              },
            )
                : const Icon(Icons.tv, size: 30), // Icono por defecto si el logo no está disponible
            const SizedBox(width: 10), // Espacio entre el icono y el nombre
            Text(canal.name ?? 'Sin título'),
            // Puedes agregar otros widgets aquí según tus necesidades
          ],
        ),
      ),
    )
    );
  }
}
///Disposición del elemento grupo en la lista
class GroupLayout extends StatelessWidget{
  final String title;
  final List<Canal>? channels;
  final FocusNode focusNode = FocusNode();

  GroupLayout({super.key, required this.title, required this.channels});

  @override
  Widget build(BuildContext context) {
    //Esto es para cuando esté localizado y se pulse ok
    return Focus(
        focusNode: focusNode,
        onKey: (FocusNode node, RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.select) {
              if(channels != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelList(channels: channels!),),);
              }else{
                print("no hay canales");
              }
              return KeyEventResult.handled; // Consumir el evento
            }
          }
          return KeyEventResult.ignored; // No consumir el evento
        },
        child:
        //Esto es para cuando hay un toque, es decir, se pulsa el táctil o con ratón
        InkWell(
            onTap: (){
              if(channels != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelList(channels: channels!),),);
              }else{
                print("no hay canales");
              }
            },
            child: Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(children: [
                  const Icon(Icons.playlist_play_sharp),
                  Text(title)
                ],)
            )
        )
    );
  }
  
}