import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
import '../../map/presentation/map_screen.dart';
=======
 main

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout() async {
    await TokenStorage.instance.clearToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
        title: const Text('KABJ - Mapa'),
=======
        title: const Text('KABJ - Home'),
 main
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
      body: const MapScreen(),
=======
      body: const Center(
        child: Text('Bienvenido, capataz.'),
      ),
 main
    );
  }
}
