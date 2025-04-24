import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      home: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://i.ibb.co/KjD2BVH7/Whats-App-Image-2025-04-21-at-11-17-07-AM-1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content overlay with semi-transparent background
            Container(
               color: Colors.black.withOpacity(0.3), // Filtro personalizado
            ),
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome message
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                      child: Column(
                        children: [
                          Text(
                            "Bienvenido a Tranquilidad",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Encuentra paz y equilibrio interior",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Vertical scrolling cards
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 16),
                        children: [
                          // Mapa de Sueños Card
                          _buildFeatureCard(
                            context,
                            title: "Mapa de Sueños",
                            description: "Visualiza y planifica tus objetivos de descanso",
                            imagePath: "https://images.unsplash.com/photo-1475274047050-1d0c0975c63e",
                            route: '/inicio',
                            icon: Icons.nightlight_round,
                          ),
                          const SizedBox(height: 16),
                          
                          // Rutina Card
                          _buildFeatureCard(
                            context,
                            title: "Rutina",
                            description: "Establece hábitos saludables para tu día a día",
                            imagePath: "https://images.unsplash.com/photo-1506126613408-eca07ce68773",
                            route: '/inicioRutina',
                            icon: Icons.calendar_today,
                          ),
                          const SizedBox(height: 16),
                          
                          // Musicoterapia Card
                          _buildFeatureCard(
                            context,
                            title: "Musicoterapia",
                            description: "Relájate con sonidos que equilibran tu mente",
                            imagePath: "https://images.unsplash.com/photo-1511379938547-c1f69419868d",
                            route: '/inicio_musicoterapia',
                            icon: Icons.music_note,
                          ),
                          const SizedBox(height: 16),
                          
                          // Alimentación Card
                          _buildFeatureCard(
                            context,
                            title: "Alimentación",
                            description: "Mejora tu bienestar con nutrición consciente",
                            imagePath: "https://images.unsplash.com/photo-1498837167922-ddd27525d352",
                            route: '/test_bienestar',
                            icon: Icons.restaurant_menu,
                          ),
                          const SizedBox(height: 16),
                          
                          // Atención Profesional Card
                          _buildFeatureCard(
                            context,
                            title: "Atención Profesional",
                            description: "Consulta con especialistas en bienestar emocional",
                            imagePath: "https://images.unsplash.com/photo-1573497620053-ea5300f94f21",
                            route: '/home',
                            icon: Icons.health_and_safety,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
    required String route,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Card background image
              Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Card content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left side with icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right side with text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Arrow icon
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}