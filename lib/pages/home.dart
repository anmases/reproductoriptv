import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/canal.dart';
import 'fetchM3u.dart';
import 'groupList.dart';




class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<String, List<Canal>>? _groups;
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();
  final storage =  const FlutterSecureStorage();
  bool _showError = false;


  @override
  void initState() {
    super.initState();
    checkStorage();
  }

  Future<void> checkStorage() async{
    setState(() => _isLoading = true);
    final link = await storage.read(key: 'link');
    if (link != null){
      final groups = await fetchM3U(link);
      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupListView(groups)));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loadM3U() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _groups = await fetchM3U(_controller.text);
      await storage.write(key: 'link', value: _controller.text);
    } catch (e) {
      // Manejar el error
    }

    setState(() {
      _isLoading = false;
      if (_groups == null || _groups!.isEmpty) {
        _showError = true; // Aquí, _showError es una variable de estado booleana
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showError) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Inserte un M3U válido!')),
        );
      });
      _showError = false; // Restablece el indicador de error
    }
    return Scaffold(
      backgroundColor:  const Color(0xFFffffbf),
      body:  _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (_groups != null && _groups!.isNotEmpty)
            ? GroupListView(_groups!)
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Introduce la URL del archivo M3U aquí',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _loadM3U,
                child: const Text('Cargar M3U'),
              ),
          ],
        ),
            ),
    );
  }
}