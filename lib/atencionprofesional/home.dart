import 'package:flutter/material.dart';
import 'Citas.dart';
import 'Profesionales.dart';
import 'Recursos.dart';
import 'Notificaciones.dart';
import 'Paquetes.dart';

class HomenScreen extends StatelessWidget {
  const HomenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_HomeItem> items = [
      _HomeItem("Citas", Icons.calendar_month, "assets/Atencion-Profesional/cita.jpeg"),
      _HomeItem("Profesionales", Icons.person, "assets/Atencion-Profesional/profesionales.jpeg"),
      _HomeItem("Recursos", Icons.show_chart, "assets/Atencion-Profesional/recursos.jpeg"),
      _HomeItem("Notificaciones", Icons.notifications, "assets/Atencion-Profesional/notificaciones.jpeg"),
      _HomeItem("Paquetes", Icons.money, "assets/Atencion-Profesional/paquetes.jpeg"),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/Atencion-Profesional/logo_tranquilidad.png',
          height: 60,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/Atencion-Profesional/fondo.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 16, right: 16, bottom: 70),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 4 / 3,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Widget page;

                    switch (item.title) {
                      case 'Citas':
                        page = CitasScreen();
                        break;
                      case 'Profesionales':
                        page = ProfesionalesScreen();
                        break;
                      case 'Recursos':
                        page = RecursosScreen();
                        break;
                      case 'Notificaciones':
                        page = NotificacionesScreen();
                        break;
                      case 'Paquetes':
                        page = PaquetesScreen();
                        break;
                      default:
                        return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(item.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          left: 10,
                          bottom: 10,
                          child: Row(
                            children: [
                              Icon(item.icon, color: Colors.white, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(81, 56, 56, 56).withOpacity(0.9),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Módulos'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _HomeItem {
  final String title;
  final IconData icon;
  final String imagePath;

  _HomeItem(this.title, this.icon, this.imagePath);
}