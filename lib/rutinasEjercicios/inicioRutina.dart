import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class InicioRutinaScreen extends StatefulWidget {
  const InicioRutinaScreen({super.key});

  @override
  State<InicioRutinaScreen> createState() => _InicioRutinaScreenState();
}

class _InicioRutinaScreenState extends State<InicioRutinaScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navegar a Módulos
    } else if (index == 2) {
      // Navegar a Perfil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondo_tranquilidad.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.1)),
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                


                const SizedBox(height: 25),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildExerciseCard(
                        context,
                        'Técnicas respiración',
                        Icons.air,
                        'https://i.ibb.co/5KjW0yX/breathing.jpg', // Ejemplo de imagen
                        Colors.blue[200]!,
                      ),
                      _buildExerciseCard(
                        context,
                        'Meditación',
                        Icons.self_improvement,
                        'https://i.ibb.co/3zQY7Xk/meditation.jpg',
                        Colors.green[200]!,
                      ),
                      _buildExerciseCard(
                        context,
                        'Estiramientos',
                        Icons.directions_run,
                        'https://i.ibb.co/0jQY7Xk/stretching.jpg',
                        Colors.orange[200]!,
                      ),
                      _buildExerciseCard(
                        context,
                        'Favoritos',
                        Icons.favorite,
                        'https://i.ibb.co/0jQY7Xk/favorites.jpg',
                        Colors.red[200]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: const Color(0xFF59009A),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context, 
    String title, 
    IconData icon, 
    String imageUrl,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagen de fondo
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: color.withOpacity(0.2),
                child: Icon(icon, size: 50, color: color),
              ),
            ),
          ),
          // Gradiente para el texto
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Contenido
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Seleccionaste: $title'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(120, 40),
                      ),
                      child: const Text('Ver más'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}