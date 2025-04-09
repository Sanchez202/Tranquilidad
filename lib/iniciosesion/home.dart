import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/inicio'),
              child: const Text('Ir al Mapa de Sueños'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/inicioRutina'),
              child: const Text('Ir a rutina'),
            ),
          ],
        ),
      ),
    );
  }
}
