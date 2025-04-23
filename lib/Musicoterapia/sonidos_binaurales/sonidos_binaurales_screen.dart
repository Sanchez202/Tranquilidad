import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class SonidosBinauralesScreen extends StatefulWidget {
  const SonidosBinauralesScreen({super.key});

  @override
  State<SonidosBinauralesScreen> createState() => _SonidosBinauralesScreenState();
}

class _SonidosBinauralesScreenState extends State<SonidosBinauralesScreen> {
  int _selectedIndex = 1;
  int _selectedTabIndex = 3; // Seleccionamos "SONIDOS BINAURALES" por defecto
  final List<String> _tabs = ['GENEROS', 'ÁLBUMS', 'PODCAST', 'SONIDOS BINAURALES', 'PLAYLIST', 'ME GUSTA'];
  
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  
  // Controller para el carrusel
  final PageController _carouselController = PageController();
  int _currentCarouselPage = 0;
  Timer? _carouselTimer;
  
  // Variable para controlar la dirección del carrusel
  bool _isForwardDirection = true;
  
  // Imágenes para el carrusel
  final List<String> _carouselImages = [
    'assets/MUSICOTERAPIA/binaural1.jpg',
    'assets/MUSICOTERAPIA/binaural2.jpg',
    'assets/MUSICOTERAPIA/binaural3.jpg',
  ];
  
  // Lista de todos los sonidos binaurales disponibles
  final List<SonidoBinauralItem> _allSonidosBinaurales = [
    // Sonidos binaurales populares
    SonidoBinauralItem(
      'Ondas Alfa',
      'Relajación profunda 8-12 Hz',
      'assets/MUSICOTERAPIA/binaural_9.jpg',
      1,
      author: 'BrainWave Studio',
      frequency: '10 Hz',
      benefits: 'Mejora la relajación y reduce el estrés',
      duration: '30:00',
    ),
    SonidoBinauralItem(
      'Ondas Delta',
      'Sueño profundo 0.5-4 Hz',
      'assets/MUSICOTERAPIA/binaural_2.jpg',
      2,
      author: 'MindSound',
      frequency: '2 Hz',
      benefits: 'Favorece el sueño REM y la recuperación',
      duration: '45:00',
    ),
    SonidoBinauralItem(
      'Ondas Theta',
      'Meditación profunda 4-8 Hz',
      'assets/MUSICOTERAPIA/binaural_3.jpg',
      3,
      author: 'Cerebral Harmony',
      frequency: '6 Hz',
      benefits: 'Aumenta la creatividad y meditación profunda',
      duration: '25:15',
    ),
    SonidoBinauralItem(
      'Ondas Beta',
      'Enfoque y concentración 12-30 Hz',
      'assets/MUSICOTERAPIA/binaural_8.jpg',
      4,
      author: 'Focus Audio',
      frequency: '20 Hz',
      benefits: 'Mejora la concentración y estado de alerta',
      duration: '20:30',
    ),
    
    // Sonidos binaurales destacados
    SonidoBinauralItem(
      'Ondas Gamma',
      'Cognición superior 30-100 Hz',
      'assets/MUSICOTERAPIA/binaural_5.jpg',
      5,
      author: 'Neural Boost',
      frequency: '40 Hz',
      benefits: 'Estimula la actividad mental y el rendimiento cognitivo',
      duration: '15:45',
    ),
    SonidoBinauralItem(
      'Mezcla 432 Hz',
      'Frecuencia natural armónica',
      'assets/MUSICOTERAPIA/binaural_6.jpg',
      6,
      author: 'Natural Frequency',
      frequency: '432 Hz',
      benefits: 'Sintoniza con las vibraciones naturales del universo',
      duration: '35:20',
    ),
    SonidoBinauralItem(
      'Sanación Chakras',
      'Alineamiento energético',
      'assets/MUSICOTERAPIA/binaural_7.jpg',
      7,
      author: 'Chakra Balance',
      frequency: 'Variable',
      benefits: 'Equilibra los centros energéticos del cuerpo',
      duration: '40:10',
    ),
    SonidoBinauralItem(
      'Solfeggio 528 Hz',
      'Frecuencia de sanación celular',
      'assets/MUSICOTERAPIA/binaural_10.jpg',
      8,
      author: 'DNA Repair',
      frequency: '528 Hz',
      benefits: 'Conocida como la frecuencia del amor y transformación',
      duration: '50:30',
    ),
        SonidoBinauralItem(
      'Meditacion Chakra 58 Hz',
      'Frecuencia de sanación celular',
      'assets/MUSICOTERAPIA/binaural_1.jpg',
      9,
      author: 'Repair Balance',
      frequency: '300 Hz',
      benefits: 'Conocida como la frecuencia del sueño',
      duration: '50:30',
    ),
        SonidoBinauralItem(
      'Ondas Gamma 700 Hz',
      'Frecuencia de sanación celular',
      'assets/MUSICOTERAPIA/binaural_4.jpg',
      10,
      author: 'DNA Repair',
      frequency: '228 Hz',
      benefits: 'Conocida como la frecuencia de la transformación',
      duration: '50:30',
    ),
  ];

  List<BinauralCategory> _categories = [];
  List<SonidoBinauralItem> _searchResultSonidos = [];

  @override
  void initState() {
    super.initState();
    _initializeCategories();
    
    // Configurar listener para la búsqueda
    _searchController.addListener(_onSearchChanged);
    
    // Iniciar el carrusel automático
    _startCarouselTimer();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_carouselController.hasClients) {
        // Lógica para cambiar la dirección
        if (_isForwardDirection) {
          // Movimiento hacia adelante (1->2->3)
          if (_currentCarouselPage < _carouselImages.length - 1) {
            _currentCarouselPage++;
          } else {
            // Cuando llegamos al final, cambiamos la dirección
            _isForwardDirection = false;
            _currentCarouselPage--;
          }
        } else {
          // Movimiento hacia atrás (3->2->1)
          if (_currentCarouselPage > 0) {
            _currentCarouselPage--;
          } else {
            // Cuando llegamos al inicio, cambiamos la dirección
            _isForwardDirection = true;
            _currentCarouselPage++;
          }
        }
        
        _carouselController.animateToPage(
          _currentCarouselPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _initializeCategories() {
    _categories = [
      BinauralCategory(
        'Sonidos Binaurales Populares',
        _allSonidosBinaurales.sublist(0, 4),
      ),
      BinauralCategory(
        'Sonidos Binaurales Destacados',
        _allSonidosBinaurales.sublist(4),
      ),
    ];
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchQuery = '';
        _searchResultSonidos = [];
      });
      return;
    }

    // Búsqueda de sonidos binaurales
    final matchingSonidos = _allSonidosBinaurales.where((sonido) {
      return sonido.title.toLowerCase().contains(query) || 
             sonido.subtitle.toLowerCase().contains(query) ||
             sonido.author.toLowerCase().contains(query) ||
             sonido.frequency.toLowerCase().contains(query) ||
             sonido.benefits.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _isSearching = true;
      _searchQuery = query;
      _searchResultSonidos = matchingSonidos;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchResultSonidos = [];
    });
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
        context.go('/musicoterapia/podcast');
        break;
      case 3: // SONIDOS BINAURALES
        // Ya estás en la vista de sonidos binaurales
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
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/MUSICOTERAPIA/fondo_musicoterapia.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light overlay for better readability
          Container(color: const Color.fromARGB(255, 209, 187, 224).withAlpha(179)),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'SONIDOS BINAURALES',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Search Bar
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
                        hintText: 'Buscar sonidos binaurales',
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
                
                // Tab Bar (solo visible cuando no está buscando)
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
                                          ? const Color(0xFF9575CD)
                                          : const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: _selectedTabIndex == index 
                                          ? FontWeight.bold 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  if (_selectedTabIndex == index)
                                    Container(
                                      height: 3,
                                      width: 30,
                                      color: const Color(0xFF9575CD),
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
                
                // Content: Search Results o Sonidos Binaurales con Carrusel integrado
                Expanded(
                  child: _isSearching
                    ? _buildSearchResults()
                    : _buildContentWithCarousel(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: const Color(0xFF9575CD),
      ),
    );
  }

  // Método modificado para construir el contenido con el carrusel integrado
  Widget _buildContentWithCarousel() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        // Carrusel simple de imágenes
        _buildSimpleCarousel(),
        
        // Título "Sonidos Binaurales Populares" debajo del carrusel
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Sonidos Binaurales Populares',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Lista de sonidos binaurales populares en formato de pistas
        _buildBinauralTrackList(_categories[0].sonidos),
        
        // Título de Sonidos Binaurales Destacados
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Sonidos Binaurales Destacados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Lista de sonidos binaurales destacados en formato de pistas
        _buildBinauralTrackList(_categories[1].sonidos),
      ],
    );
  }

  // Método para construir lista de pistas (tipo álbum)
  Widget _buildBinauralTrackList(List<SonidoBinauralItem> sonidos) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sonidos.length,
      itemBuilder: (context, index) {
        final sonido = sonidos[index];
        return ListTile(
          // Miniatura del sonido binaural
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                sonido.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 25, color: Colors.grey),
                ),
              ),
            ),
          ),
          title: Text(
            sonido.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            '${sonido.author} • ${sonido.frequency} • ${sonido.duration}',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          // Botón de reproducción estilizado
          trailing: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 15,
              ),
              padding: EdgeInsets.zero,
              iconSize: 18,
              onPressed: () {
                _navigateToSonidoBinauralPlayer(sonido.id);
              },
            ),
          ),
          onTap: () {
            _navigateToSonidoBinauralPlayer(sonido.id);
          },
        );
      },
    );
  }

  // Carrusel simple de imágenes sin botón de play y sin indicadores
  Widget _buildSimpleCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _carouselController,
            itemCount: _carouselImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    _carouselImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10), // Espacio después del carrusel
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResultSonidos.isEmpty) {
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

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        // Resultado de búsqueda de sonidos binaurales en formato de pistas
        if (_searchResultSonidos.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'SONIDOS BINAURALES',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9575CD),
              ),
            ),
          ),
          _buildBinauralTrackList(_searchResultSonidos),
        ],
      ],
    );
  }

void _navigateToSonidoBinauralPlayer(int sonidoId) {
  // Encontrar el sonido binaural seleccionado
  final sonido = _allSonidosBinaurales.firstWhere((s) => s.id == sonidoId);
  
  // Índice del track seleccionado
  final trackIndex = _allSonidosBinaurales.indexOf(sonido);
  
  // Convertir la lista de sonidos a un formato que ReproductorBinaural pueda entender
  final tracks = _allSonidosBinaurales.map((s) => {
    'id': s.id,
    'title': s.title,
    'duration': s.duration,
    'coverUrl': s.imageUrl, // Agregar la URL de la imagen
    'author': s.author,     // Agregar el autor
  }).toList();
  
  // Navegar al reproductor usando go_router
  context.go('/reproductor_binaural', extra: {
    'sonidoId': sonido.id,
    'title': sonido.title,
    'author': sonido.author,
    'coverUrl': sonido.imageUrl,
    'isAsset': true,
    'trackIndex': trackIndex,
    'tracks': tracks,
  });
}
}

// Modelos de datos para Sonidos Binaurales
class SonidoBinauralItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int id;
  final String author;
  final String frequency;
  final String benefits;
  final String duration;

  SonidoBinauralItem(
    this.title,
    this.subtitle,
    this.imageUrl,
    this.id,
    {this.author = 'Autor Desconocido',
    this.frequency = 'Variable',
    this.benefits = '',
    this.duration = '00:00'}
  );
}

class BinauralCategory {
  final String title;
  final List<SonidoBinauralItem> sonidos;

  BinauralCategory(this.title, this.sonidos);
}