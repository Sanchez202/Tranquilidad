import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  int _selectedIndex = 1;
  int _selectedTabIndex = 2; // Seleccionamos "PODCAST" por defecto
  final List<String> _tabs = ['GÉNEROS', 'ÁLBUMS', 'PODCAST', 'SONIDOS BINAURALES', 'PLAYLIST', 'ME GUSTA'];
  
  // Definir color púrpura constante para uso en toda la clase
  final Color purpleColor = const Color(0xFF9575CD);
  
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  
  // Lista de podcasts para los contenedores principales
  final List<PodcastItem> _mainPodcasts = [
    PodcastItem(
      'Afirmaciones',
      'Podcast',
      'assets/MUSICOTERAPIA/podcast1.jpg',
      1,
    ),
    PodcastItem(
      'Autoestima',
      'Explorar podcast',
      'assets/MUSICOTERAPIA/podcast2.jpg',
      2,
    ),
    PodcastItem(
      'Meditación',
      'Técnicas',
      'assets/MUSICOTERAPIA/podcast3.jpg',
      3,
    ),
    PodcastItem(
      'Nuestro estudio',
      'Crea tu propio podcast',
      'assets/MUSICOTERAPIA/podcast4.jpg',
      4,
    ),
    PodcastItem(
      '',
      '',
      'assets/MUSICOTERAPIA/microphone.jpg',
      5,
    ),
  ];

  // Lista de imágenes para el carrusel horizontal
  final List<String> _horizontalImages = [
    'assets/MUSICOTERAPIA/binaural_3.jpg',
    'assets/MUSICOTERAPIA/binaural_10.jpg',
    'assets/MUSICOTERAPIA/binaural_2.jpg',
    'assets/MUSICOTERAPIA/binaural_5.jpg',
    'assets/MUSICOTERAPIA/binaural_9.jpg',
    'assets/MUSICOTERAPIA/binaural_8.jpg',
    'assets/MUSICOTERAPIA/binaural_7.jpg',
    'assets/MUSICOTERAPIA/binaural_4.jpg',
    'assets/MUSICOTERAPIA/binaural_6.jpg',
    'assets/MUSICOTERAPIA/img_7.jpg',
  ];
  
  // Lista de títulos para el carrusel horizontal
  final List<String> _horizontalTitles = [
    'Sonidos Relajantes',
    'Historias para Dormir',
    'Música Terapéutica',
    'Mindfulness',
    'Meditación Guiada',
    'Frecuencias Sanadoras',
    'Viaje Astral',
    'Sonidos de la Naturaleza',
    'Armonía del Alma',
    'Ondas Cerebrales',
  ];

  // Lista de subtítulos para el carrusel horizontal
  final List<String> _horizontalSubtitles = [
    'Relájate y descansa',
    'Sueños placenteros',
    'Sana con sonidos',
    'Atención plena',
    'Meditación profunda',
    'Frecuencias curativas',
    'Expansión de conciencia',
    'Conexión natural',
    'Equilibrio interior',
    'Estimulación cerebral',
  ];

  // Estado para los corazones (favoritos)
  List<bool> _favorites = List.generate(5, (index) => false);

  @override
  void initState() {
    super.initState();
    
    // Configurar listener para la búsqueda
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
    });
  }

  // Función para mostrar notificación
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: purpleColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      _favorites[index] = !_favorites[index];
    });
    
    // Mostrar notificación apropiada basada en el estado del favorito
    if (_favorites[index]) {
      _showNotification('${_mainPodcasts[index].title} añadido a favoritos');
    } else {
      _showNotification('${_mainPodcasts[index].title} eliminado de favoritos');
    }
  }

  // Nuevo método para navegar a PodcastListadosScreen
  void _navigateToPodcastDetails(PodcastItem podcast) {
    context.push('/podcast_listados', extra: {
      'title': podcast.title,
      'subtitle': podcast.subtitle,
      'imageUrl': podcast.imageUrl,
      'isAsset': true,
      'podcastId': podcast.id,
    });
  }

  // Método modificado para navegar desde el carrusel horizontal con nombres personalizados
  void _navigateFromCarousel(int index) {
    // Creamos un PodcastItem temporal para las imágenes del carrusel con nombres personalizados
    final carouselPodcast = PodcastItem(
      _horizontalTitles[index],
      _horizontalSubtitles[index],
      _horizontalImages[index],
      100 + index, // ID único para cada elemento del carrusel
    );
    
    _navigateToPodcastDetails(carouselPodcast);
  }

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

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    
    // Navegar a la vista correspondiente según la pestaña seleccionada
    switch (index) {
      case 0: // GENEROS
        context.go('/musicoterapia');
        break;
      case 1: // ALBUMS
        context.go('/musicoterapia/albums');
        break;
      case 2: // PODCAST
        // Ya estás en la vista de podcast
        break;
      case 3: // SONIDOS BINAURALES
        context.go('/musicoterapia/sonidos_binaurales');
        break;
      case 4: // PLAYLIST
        context.go('/musicoterapia/playlist');
        break;
      case 5: // ME GUSTA
        context.go('/musicoterapia/me_gusta');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Background image - mantenemos el fondo original
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/MUSICOTERAPIA/fondo_musicoterapia.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light overlay for better readability
          Container(color: Colors.white.withOpacity(0.7)),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'PODCAST',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Search Bar - mantenemos la barra de búsqueda original
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar podcast',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _isSearching 
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                
                // MODIFICADO: Tab Bar igual que en InicioMusicoterapia
                if (!_isSearching)
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: List.generate(_tabs.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: GestureDetector(
                              onTap: () => _onTabSelected(index),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _tabs[index],
                                    style: TextStyle(
                                      color: _selectedTabIndex == index 
                                          ? purpleColor
                                          : Colors.grey,
                                      fontWeight: _selectedTabIndex == index 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  if (_selectedTabIndex == index)
                                    Container(
                                      height: 3,
                                      width: 30,
                                      color: purpleColor,
                                      margin: const EdgeInsets.only(top: 5),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // Contenido principal con scroll - AQUÍ ESTÁ LA PARTE MODIFICADA
                Expanded(
                  child: _isSearching
                    ? _buildSearchResults()
                    : _buildNewPodcastView(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: purpleColor,
      ),
    );
  }

  Widget _buildSearchResults() {
    // Mantenemos el componente de resultados de búsqueda original
    if (_searchQuery.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 70, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'Busca tus podcasts favoritos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 70, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'No se encontraron resultados para "$_searchQuery"',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNewPodcastView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Título de sección - Cambiado a capitalización inicial
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Podcast Populares',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Primer contenedor con imagen, corazón y botón play
        _buildPodcastContainer(0),
        
        // Segundo contenedor con imagen, corazón y botón play
        _buildPodcastContainer(1),
        
        // Texto "Explorar Podcast" antes del contenedor horizontal
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Explorar Podcast',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Carrusel horizontal de imágenes (MODIFICADO PARA AÑADIR NAVEGACIÓN)
        Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // Quitamos el borde como solicitado
            color: Colors.grey.withOpacity(0.1),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _horizontalImages.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              return Container(
                width: 110,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(_horizontalImages[index]),
                    fit: BoxFit.cover,
                  ),
                  // Añadimos sombra para dar profundidad
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  // Añadimos un borde para definir mejor la imagen
                  border: Border.all(
                    color: Colors.white.withOpacity(0.7),
                    width: 2,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _navigateFromCarousel(index),
                    splashColor: purpleColor.withOpacity(0.3),
                    highlightColor: Colors.transparent,
                    child: const SizedBox.expand(),
                  ),
                ),
              );
            },
          ),
        ),
        
        // NUEVA SECCIÓN: Separador visual con texto mejorado y sin botón "Ver todos"
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: const Text(
            'Recomendados para ti',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Cambiado a negro como solicitado
            ),
          ),
        ),
        
        // Tercer contenedor con imagen, corazón y botón play
        _buildPodcastContainer(2),
        
        // Cuarto contenedor (MODIFICADO: Quitado el botón de corazón, solo dejamos el botón +)
        Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(_mainPodcasts[3].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Overlay oscuro para mejorar legibilidad del texto
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.7, 1.0],
                  ),
                ),
              ),
              
              // Título y subtítulo
              Positioned(
                left: 15,
                bottom: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mainPodcasts[3].title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _mainPodcasts[3].subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // ELIMINADO: Ya no hay botón de corazón en este contenedor
              
              // Botón + colocado en la misma posición que el botón play
              Positioned(
                bottom: 15,
                right: 15,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: purpleColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Pequeño espacio antes del footer para no pegarlo demasiado
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildPodcastContainer(int index) {
    final podcast = _mainPodcasts[index];
    
    // Si es el último podcast (el quinto), no se navega
    // En este caso es el elemento con el botón "+"
    bool isLastPodcast = index == 4;
    
    return GestureDetector(
      onTap: isLastPodcast ? null : () => _navigateToPodcastDetails(podcast),
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(podcast.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Overlay oscuro para mejorar legibilidad del texto
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.7, 1.0],
                ),
              ),
            ),
            
            // Título y subtítulo
            Positioned(
              left: 15,
              bottom: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    podcast.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón de corazón (favorito)
            Positioned(
              top: 15,
              left: 15,
              child: GestureDetector(
                onTap: () => _toggleFavorite(index),
                child: Icon(
                  _favorites[index] ? Icons.favorite : Icons.favorite_border,
                  color: _favorites[index] ? purpleColor : Colors.white,
                  size: 28,
                ),
              ),
            ),
            
            // Botón de reproducción
            Positioned(
              bottom: 15,
              right: 15,
              child: GestureDetector(
                onTap: isLastPodcast ? null : () => _navigateToPodcastDetails(podcast),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: purpleColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class PodcastItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int id;

  PodcastItem(
    this.title,
    this.subtitle,
    this.imageUrl,
    this.id,
  );
}