import 'package:http/http.dart' as http;

import '../model/canal.dart';



Future<Map<String, List<Canal>>> fetchM3U(String url) async {
  final response = await http.get(Uri.parse(url));

  final lines = response.body.split('\n');

  Map<String, List<Canal>> groups = {};
  String id = "";
  String name = "";
  String logo = "";
  String group = "";

  for (int i = 0; i < lines.length - 1; i++) {
    if (lines[i].startsWith('#EXTINF')) {
      final matchId = RegExp(r'tvg-id="(.*?)"').firstMatch(lines[i]);
      final matchName = RegExp(r'" tvg-name="(.*?)"').firstMatch(lines[i]);
      final matchLogo = RegExp(r'tvg-logo="(.*?)"').firstMatch(lines[i]);
      final matchGroup = RegExp(r'group-title="(.*?)"').firstMatch(lines[i]);

      id = matchId?.group(1) ?? '';
      name = matchName?.group(1) ?? '';
      logo = matchLogo?.group(1) ?? '';
      group = matchGroup?.group(1) ?? '';
    } else if (lines[i].startsWith('http')) {
      final canal = Canal(
        id: id,
        name: name,
        logo: logo,
        group: group,
        url: lines[i],
      );
      // Agrega el canal al grupo correspondiente
      groups.putIfAbsent(group, () => []).add(canal);

      // Reiniciar los campos después de agregarlos
      id = "";
      name = "";
      logo = "";
      group = "";
    }
  }

  return groups;
}