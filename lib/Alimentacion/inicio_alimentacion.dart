import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class InicioAlimentacion extends StatefulWidget {
  const InicioAlimentacion({super.key});

  @override
  State<InicioAlimentacion> createState() => _InicioAlimentacionState();
}

class _InicioAlimentacionState extends State<InicioAlimentacion> {
  int _selectedIndex = 1;
  
  // Lista de tarjetas de información
  final List<InfoCard> _infoCards = [
    InfoCard(
      title: 'Información Frutas',
      description: 
          'Descubre cómo ciertos alimentos influyen en tu estado de ánimo,'
          'energía y salud general. Esta herramienta te guía para elegir'
          'frutas que ayudan a reducir el estrés, mejorar la concentración'
          'y fortalecer tu sistema inmunológico.',
      imageUrl: 'assets/ALIMENTACION/FrutasInf.jpg',
      route: '/alimentacion/informacion_frutas', // Updated route path
    ),
    InfoCard(
      title: 'Seguimiento de proceso',
      description: 
          'Monitorea tu peso, controla tus macros' 
          '(proteínas, grasas y carbohidratos) y añade frutas a' 
          ' tu alimentación diaria para alcanzar tus metas de forma saludable.',
      imageUrl: 'assets/ALIMENTACION/SEGUIMIENTO.png',
      route: '/alimentacion/seguimiento',
    ),
    InfoCard(
      title: 'Foro',
      description: 
          'Recurso bienestar es una plataforma donde se almacenará y '
          'organizará información proveniente de diferentes usuarios. Estos '
          'recursos incluirán una amplia variedad de datos, estrategias, y '
          'experiencias compartidas por otros usuarios que también están en la '
          'búsqueda de mejorar su bienestar.',
      imageUrl: 'assets/ALIMENTACION/social_media.jpg',
      route: '/alimentacion/foro',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navegar a Módulos
      context.go('/modulos');
    } else if (index == 2) {
      // Navegar a Perfil
      context.go('/perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ALIMENTACION/Fondo_Inicio.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light overlay for better readability
          Container(color: const Color.fromARGB(255, 206, 206, 206).withOpacity(0.7)),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'ALIMENTACIÓN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 18, 167),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Scrollable cards in vertical layout
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _infoCards.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: SizedBox(
                          width: cardWidth,
                          child: _buildInfoCard(_infoCards[index]),
                        ),
                      );
                    },
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
        primaryColor: const Color.fromARGB(255, 148, 66, 255), // Color naranja para alimentación
      ),
    );
  }

  Widget _buildInfoCard(InfoCard card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Navegar a la ruta correspondiente
          context.go(card.route);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // This is the key change - only take up needed space
          children: [
            // Image - proporción más pequeña para aspecto vertical
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                card.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Title with colored background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
              ),
              child: Text(
                card.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 75, 18, 167),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Description
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                card.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.3,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo para las tarjetas de información
class InfoCard {
  final String title;
  final String description;
  final String imageUrl;
  final String route;

  InfoCard({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.route,
  });
}