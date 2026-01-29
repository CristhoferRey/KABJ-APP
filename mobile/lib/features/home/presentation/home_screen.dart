import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
import '../../map/presentation/map_screen.dart';
import '../../summary/presentation/summary_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
import '../../map/presentation/map_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
import '../../map/presentation/map_screen.dart';
=======
 main
 main
 main
main
 main
 main
 main
 main
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
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
 main
main
 main
 main
 main
 main
 main
        title: const Text('KABJ - Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SummaryScreen()),
              );
            },
          ),
          IconButton(
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
        title: const Text('KABJ - Mapa'),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
        title: const Text('KABJ - Mapa'),
=======
        title: const Text('KABJ - Home'),
 main
 main
        actions: [
          IconButton(
 main
 main
main
 main
 main
 main
main
 main
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
codex/initialize-project-scaffolding-for-fastapi-and-flutter-db7lmb
      body: const MapScreen(),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-74q9ry
      body: const MapScreen(),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ec05v8
      body: const MapScreen(),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
      body: const MapScreen(),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
      body: const MapScreen(),
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
      body: const MapScreen(),
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
      body: const MapScreen(),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
      body: const MapScreen(),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
      body: const MapScreen(),
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-70pu3t
      body: const MapScreen(),
=======
      body: const Center(
        child: Text('Bienvenido, capataz.'),
      ),
 main
 main
 main
 main
main
 main
 main
main
 main
 main
    );
  }
}
