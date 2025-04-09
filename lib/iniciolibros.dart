import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class iniciolibros extends StatelessWidget {
  const iniciolibros({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Categories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const TranquilidadApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TranquilidadApp extends StatefulWidget {
  const TranquilidadApp({super.key});
  @override
  State<TranquilidadApp> createState() => _TranquilidadAppState();
}

class _TranquilidadAppState extends State<TranquilidadApp> {
  int _selectedIndex = 1; // Índice para la barra de navegación inferior
  final Color lightPurple = Color(0xFF9575CD); // Color morado claro principal

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lista de categorías para el carrusel con URLs de imágenes específicas
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Arte',
      'icon': Icons.palette,
      'color': Color(0xFFBBDEFB), // Azul pastel
      'imageUrl': 'https://i.ibb.co/GKszgX1/Whats-App-Image-2024-11-13-at-3-49-57-PM.jpg', // Imagen para Arte
    },
    {
      'title': 'Meditación',
      'icon': Icons.self_improvement,
      'color': Color(0xFFC8E6C9), // Verde pastel
      'imageUrl': 'https://i.ibb.co/70qkNjZ/Whats-App-Image-2024-11-13-at-3-54-18-PM.jpg', // Imagen para Meditación
    },
    {
      'title': 'Naturaleza',
      'icon': Icons.nature,
      'color': Color(0xFFB2DFDB), // Teal pastel
      'imageUrl': 'https://i.ibb.co/wFBm0872/Whats-App-Image-2024-11-13-at-3-59-12-PM.jpg', // Imagen para Naturaleza
    },
    {
      'title': 'Poesía',
      'icon': Icons.format_quote,
      'color': Color(0xFFE1BEE7), // Morado pastel
      'imageUrl': 'https://i.ibb.co/tMFS1cw2/Whats-App-Image-2024-11-13-at-4-00-57-PM.jpg', // Imagen para Poesía
    },
    {
      'title': 'Superación Personal',
      'icon': Icons.trending_up,
      'color': Color(0xFFFFE0B2), // Naranja pastel
      'imageUrl': 'https://i.ibb.co/SDY8SS5J/Whats-App-Image-2024-11-13-at-3-43-13-PM.jpg', // Imagen para Superación Personal
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.ibb.co/k6Hx7FSM/caa5c962-c5c1-4319-a78a-a9d9e92a17d3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Color overlay to improve text readability
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Content - Using padding to avoid overlapping with AppBar
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 120, // Additional padding for AppBar
              bottom: 80, // Additional bottom padding for NavBar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Favorites card separate at the top
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildFavoritesCard(context),
                ),
                
                const SizedBox(height: 25),
                
                // Categories Title - MEJORADO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          lightPurple.withOpacity(0.8),
                          lightPurple.withOpacity(0.2),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'CATEGORÍAS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Carrusel con indicadores
                Container(
                  height: 190,
                  child: InfiniteCarousel(),
                ),
                
                const SizedBox(height: 20), // Espacio reducido
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
  
  // Favorites Card - Separate design
  Widget _buildFavoritesCard(BuildContext context) {
    final Color favoriteColor = Color(0xFFF8BBD0); // Rosa pastel para favoritos
    
    return Card(
      elevation: 6,
      shadowColor: favoriteColor.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: favoriteColor.withOpacity(0.3), width: 1),
      ),
      color: Colors.black.withOpacity(0.7),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: favoriteColor.withOpacity(0.2),
        highlightColor: favoriteColor.withOpacity(0.1),
        onTap: () {
          // Handle favorites tap
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add the image at the top
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Image.network(
                'https://i.ibb.co/5hWt3wTf/Whats-App-Image-2024-11-13-at-4-03-57-PM.jpg',
                height: 150, // Altura reducida
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  Container(
                    height: 110, // Altura reducida
                    color: favoriteColor.withOpacity(0.3),
                    child: Center(child: Icon(Icons.image_not_supported)),
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12), // Padding reducido
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8), // Padding reducido
                        decoration: BoxDecoration(
                          color: favoriteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: favoriteColor.withOpacity(0.5),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 20, // Tamaño reducido
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'FAVORITOS',
                        style: TextStyle(
                          fontSize: 15, // Tamaño reducido
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle favorites explore
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightPurple,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10), // Padding reducido
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18, // Tamaño reducido
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget mejorado para el carrusel infinito con indicadores de posición
class InfiniteCarousel extends StatefulWidget {
  @override
  _InfiniteCarouselState createState() => _InfiniteCarouselState();
}

class _InfiniteCarouselState extends State<InfiniteCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  final Color lightPurple = Color(0xFF9575CD);
  Timer? _autoScrollTimer;
  
  // Lista de categorías para el carrusel con URLs de imágenes específicas
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Arte',
      'icon': Icons.palette,
      'color': Color(0xFFBBDEFB), // Azul pastel
      'imageUrl': 'https://i.ibb.co/GKszgX1/Whats-App-Image-2024-11-13-at-3-49-57-PM.jpg', // Imagen para Arte
    },
    {
      'title': 'Meditación',
      'icon': Icons.self_improvement,
      'color': Color(0xFFC8E6C9), // Verde pastel
      'imageUrl': 'https://i.ibb.co/70qkNjZ/Whats-App-Image-2024-11-13-at-3-54-18-PM.jpg', // Imagen para Meditación
    },
    {
      'title': 'Naturaleza',
      'icon': Icons.nature,
      'color': Color(0xFFB2DFDB), // Teal pastel
      'imageUrl': 'https://i.ibb.co/wFBm0872/Whats-App-Image-2024-11-13-at-3-59-12-PM.jpg', // Imagen para Naturaleza
    },
    {
      'title': 'Poesía',
      'icon': Icons.format_quote,
      'color': Color(0xFFE1BEE7), // Morado pastel
      'imageUrl': 'https://i.ibb.co/tMFS1cw2/Whats-App-Image-2024-11-13-at-4-00-57-PM.jpg', // Imagen para Poesía
    },
    {
      'title': 'Superación Personal',
      'icon': Icons.trending_up,
      'color': Color(0xFFFFE0B2), // Naranja pastel
      'imageUrl': 'https://i.ibb.co/SDY8SS5J/Whats-App-Image-2024-11-13-at-3-43-13-PM.jpg', // Imagen para Superación Personal
    },
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Inicializamos el controlador en la página del medio para permitir desplazamiento bidireccional
    _pageController = PageController(
      initialPage: categories.length * 100, // Un número grande para simular infinito
      viewportFraction: 0.5, // Muestra dos elementos a la vez parcialmente
    );
    
    // Actualizar el indicador de página cuando cambia
    _pageController.addListener(() {
      int page = _pageController.page!.round() % categories.length;
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
    
    // Opcionalmente: auto-scroll
    _startAutoScroll();
  }
  
  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _pageController.page!.round() + 1,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carrusel con PageView
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              // Usamos el módulo para obtener el índice real de la categoría
              final actualIndex = index % categories.length;
              final category = categories[actualIndex];
              
              return Container(
                width: 160,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: _buildCategoryCard(
                  context: context,
                  title: category['title'],
                  icon: category['icon'],
                  color: category['color'],
                  imageUrl: category['imageUrl'], // Pasamos la URL de la imagen específica
                ),
              );
            },
          ),
        ),
        
        // Indicadores de posición
        Container(
          margin: EdgeInsets.only(top: 16),
          height: 30,
          child: _buildPageIndicator(),
        ),
      ],
    );
  }
  
  // Construir los indicadores de posición
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        categories.length,
        (index) => _buildPageDot(index),
      ),
    );
  }
  
  // Construir cada punto del indicador
  Widget _buildPageDot(int index) {
    bool isActive = _currentPage == index;
    
    // Obtenemos el color de la categoría para usarlo en el indicador
    Color dotColor = categories[index]['color'];
    
    return GestureDetector(
      onTap: () {
        // Al hacer clic en un punto, navega a esa página
        _pageController.animateToPage(
          _pageController.page!.toInt() - (_currentPage - index),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: isActive ? 12 : 8,
        width: isActive ? 12 : 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? dotColor : Colors.white.withOpacity(0.5),
          border: Border.all(
            color: isActive ? dotColor.withOpacity(0.8) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: dotColor.withOpacity(0.5),
              blurRadius: 6,
              spreadRadius: 1,
            )
          ] : null,
        ),
      ),
    );
  }
  
  // Category Card para el Carrusel - MEJORADO con imagen específica
  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String imageUrl, // Nuevo parámetro para la URL de la imagen
  }) {
    return Card(
      elevation: 6,
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      color: Colors.black.withOpacity(0.7),
      child: Stack(
        children: [
          // Imagen a tamaño completo con desvanecimiento
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Imagen - Ahora usando la URL de imagen específica para cada categoría
                Image.network(
                  imageUrl, // Usamos la URL específica para esta categoría
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    Container(
                      color: color.withOpacity(0.3),
                      child: Center(child: Icon(Icons.image_not_supported)),
                    ),
                ),
                // Gradiente que se desvanece en la parte inferior
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: [0.0, 0.5, 0.65, 0.8, 0.95],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon y título
                  Expanded(
                    child: Row(
                      children: [
                        // Icono
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Título
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
    );
  }
}