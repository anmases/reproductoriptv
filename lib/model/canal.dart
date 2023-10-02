class Canal {
  String id;
  String name;
  String logo;
  String group;
  String _url;

  Canal({
    required this.id,
    required this.name,
    required this.logo,
    required this.group,
    required String url,
  }): _url = url.trim();

  String get url => _url;

  set url(String value) => _url = value.trim();
}
