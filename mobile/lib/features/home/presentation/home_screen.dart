import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';
import '../../map/presentation/map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout() async {
    await TokenStorage.instance.clearToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KABJ - Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: const MapScreen(),
    );
  }
}
