import 'package:flutter/material.dart';

class CitasScreen extends StatelessWidget {
  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_CitaItem> items = [
      _CitaItem("Agendar Cita", Icons.add_circle, "assets/images/agendar-cita.jpeg"),
      _CitaItem("Citas Programadas", Icons.event_note, "assets/images/citas-programadas.jpeg"),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Citas'),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/fondo.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 120), // Espacio debajo del AppBar
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item.imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 20,
                                child: Row(
                                  children: [
                                    Icon(item.icon, color: Colors.white, size: 28),
                                    const SizedBox(width: 10),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(81, 56, 56, 56).withOpacity(0.9),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Índice de "Inicio"
        onTap: (index) {
          if (index == 0) {
            // Aquí puedes agregar Navigator.pushNamed(context, '/modulos');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            // Aquí puedes agregar Navigator.pushNamed(context, '/perfil');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Módulos'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _CitaItem {
  final String title;
  final IconData icon;
  final String imagePath;

  _CitaItem(this.title, this.icon, this.imagePath);
}