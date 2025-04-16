import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 1;
  int _selectedTabIndex = 4; // Seleccionamos "PLAYLIST" por defecto
  final List<String> _tabs = ['GENEROS', 'ÁLBUMS', 'PODCAST', 'SONIDOS BINAURALES', 'PLAYLIST', 'ME GUSTA'];
  final Color purpleColor = const Color(0xFF9575CD);
  
  // Variable para controlar la visibilidad del botón flotante
  bool _showFloatingButton = true;
  
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  
  // Lista de imágenes disponibles para nuevas playlists
  final List<String> _playlistImages = [
    'assets/MUSICOTERAPIA/img_1.jpg',
    'assets/MUSICOTERAPIA/img_3.jpg',
    'assets/MUSICOTERAPIA/img_7.jpg',
    'assets/MUSICOTERAPIA/img_8.jpg',
    'assets/MUSICOTERAPIA/img_11.jpg',
    'assets/MUSICOTERAPIA/img_album8.jpg',
    'assets/MUSICOTERAPIA/img_album11.jpg',
    'assets/MUSICOTERAPIA/img6_album.jpg',
  ];
  
  // Lista de todas las playlists disponibles
  List<PlaylistItem> _allPlaylists = [
    // Playlists populares
    PlaylistItem(
      'Meditación Matutina',
      'Comenzar el día con calma',
      'assets/MUSICOTERAPIA/img_11.jpg',
      1,
      creator: 'Tranquilidad App',
      trackCount: 8,
      duration: '45:30',
    ),
    PlaylistItem(
      'Concentración Profunda',
      'Mejora tu enfoque',
      'assets/MUSICOTERAPIA/img_album8.jpg',
      2,
      creator: 'Focus Mind',
      trackCount: 6,
      duration: '52:15',
    ),
    PlaylistItem(
      'Antes de Dormir',
      'Relajación nocturna',
      'assets/MUSICOTERAPIA/img_8.jpg',
      3,
      creator: 'Sleep Well',
      trackCount: 5,
      duration: '65:20',
    ),
    PlaylistItem(
      'Música para Leer',
      'Melodías sin letra',
      'assets/MUSICOTERAPIA/img_1.jpg',
      4,
      creator: 'Reading Time',
      trackCount: 10,
      duration: '90:45',
    ),
    
    // Playlists creadas por ti
    PlaylistItem(
      'Mi Colección',
      'Mis favoritos',
      'assets/MUSICOTERAPIA/img_album11.jpg',
      5,
      creator: 'Tú',
      trackCount: 12,
      duration: '78:40',
      isUserCreated: true,
    ),
    PlaylistItem(
      'Para Meditar',
      'Selección personal',
      'assets/MUSICOTERAPIA/img_7.jpg',
      6,
      creator: 'Tú',
      trackCount: 7,
      duration: '42:15',
      isUserCreated: true,
    ),
    PlaylistItem(
      'Naturaleza',
      'Sonidos de la tierra',
      'assets/MUSICOTERAPIA/img6_album.jpg',
      7,
      creator: 'Tú',
      trackCount: 9,
      duration: '63:30',
      isUserCreated: true,
    ),
    PlaylistItem(
      'Mix Relajante',
      'Combinación de géneros',
      'assets/MUSICOTERAPIA/img_3.jpg',
      8,
      creator: 'Tú',
      trackCount: 15,
      duration: '85:10',
      isUserCreated: true,
    ),
  ];

  List<PlaylistCategory> _categories = [];
  List<PlaylistItem> _searchResultPlaylists = [];

  @override
  void initState() {
    super.initState();
    _initializeCategories();
    
    // Configurar listener para la búsqueda
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _initializeCategories() {
    _categories = [
      PlaylistCategory(
        'Playlists Populares',
        _allPlaylists.where((playlist) => !playlist.isUserCreated).toList(),
      ),
      PlaylistCategory(
        'Tus Playlists',
        _allPlaylists.where((playlist) => playlist.isUserCreated).toList(),
      ),
    ];
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchQuery = '';
        _searchResultPlaylists = [];
      });
      return;
    }

    // Búsqueda de playlists
    final matchingPlaylists = _allPlaylists.where((playlist) {
      return playlist.title.toLowerCase().contains(query) || 
             playlist.subtitle.toLowerCase().contains(query) ||
             playlist.creator.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _isSearching = true;
      _searchQuery = query;
      _searchResultPlaylists = matchingPlaylists;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchResultPlaylists = [];
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
        context.go('/musicoterapia/sonidos_binaurales');
        break;
      case 4: // PLAYLIST
        // Ya estás en la vista de playlist
        break;
      case 5: // ME GUSTA
        context.go('/musicoterapia/me_gusta');
        break;
    }
  }

  // Nueva función para mostrar notificaciones personalizadas con animación
  void _showAnimatedNotification(String message) {
    // Ocultar el botón flotante
    setState(() {
      _showFloatingButton = false;
    });
    
    // Mostrar notificación central
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 60,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: purpleColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    // Insertar en overlay
    Overlay.of(context).insert(overlayEntry);

    // Remover la notificación después de un tiempo y mostrar el botón nuevamente
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
      setState(() {
        _showFloatingButton = true;
      });
    });
  }

  // Método para añadir una nueva playlist - simplificado para evitar congelamiento
  void _addNewPlaylist(String title, String description, String imageUrl) {
    try {
      // Generar un nuevo ID simple
      int newId = _allPlaylists.length + 1;
      
      // Crear la nueva playlist con valores predeterminados simples
      PlaylistItem newPlaylist = PlaylistItem(
        title.isEmpty ? "Nueva Playlist" : title,
        description.isEmpty ? "Mi colección" : description,
        imageUrl,
        newId,
        creator: 'Tú',
        trackCount: 0,
        duration: '00:00',
        isUserCreated: true,
      );
      
      // Actualizar la lista de playlists
      setState(() {
        _allPlaylists.add(newPlaylist);
        // Recrear las categorías
        _categories = [
          PlaylistCategory(
            'Playlists Populares',
            _allPlaylists.where((playlist) => !playlist.isUserCreated).toList(),
          ),
          PlaylistCategory(
            'Tus Playlists',
            _allPlaylists.where((playlist) => playlist.isUserCreated).toList(),
          ),
        ];
      });
      
      // Mostrar notificación animada de éxito
      _showAnimatedNotification('Playlist creada con éxito');
      
    } catch (e) {
      print('Error al crear playlist: $e');
      // Mostrar notificación animada de error
      _showAnimatedNotification('Ocurrió un error al crear la playlist. Inténtalo nuevamente.');
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
          Container(color: Colors.white.withOpacity(0.7)),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'PLAYLIST',
                  style: TextStyle(
                    fontSize: 30,
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
                        hintText: 'Buscar playlist',
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
                
                // Content: Search Results or Playlist Categories
                Expanded(
                  child: _isSearching
                    ? _buildSearchResults()
                    : _buildPlaylistCategoriesView(),
                ),
              ],
            ),
          ),
        ],
      ),
      // Botón flotante con animación de aparición/desaparición
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: _showFloatingButton ? FloatingActionButton.extended(
          key: const ValueKey<String>('create_button'),
          onPressed: () {
            // Acción simplificada para crear una nueva playlist
            _showCreatePlaylistSimpleDialog();
          },
          backgroundColor: purpleColor,
          foregroundColor: Colors.white, 
          label: const Text('Crear Playlist'),
          icon: const Icon(Icons.add),
        ) : null,
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: purpleColor,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResultPlaylists.isEmpty) {
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      itemCount: _searchResultPlaylists.length,
      itemBuilder: (context, index) {
        final playlist = _searchResultPlaylists[index];
        return _buildPlaylistListItem(playlist);
      },
    );
  }

  Widget _buildPlaylistCategoriesView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildPlaylistCategory(category.title, category.playlists);
      },
    );
  }

  Widget _buildPlaylistCategory(String categoryTitle, List<PlaylistItem> playlists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            categoryTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Lista de playlists
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            return _buildPlaylistListItem(playlists[index]);
          },
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPlaylistListItem(PlaylistItem playlist) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToPlaylistDetail(playlist.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Imagen pequeña de la playlist
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  playlist.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Información de la playlist
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      playlist.subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          playlist.creator,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${playlist.trackCount} canciones',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Botón de reproducir MODIFICADO: más pequeño y del color del contenedor
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  // Color que coincide con el fondo de la card (blanco)
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () => _navigateToPlaylistDetail(playlist.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPlaylistDetail(int playlistId) {
    // Encontrar la playlist seleccionada
    final playlist = _allPlaylists.firstWhere((p) => p.id == playlistId);
    
    // Navegar a la vista de canciones de la playlist usando go_router
    context.go('/musicoterapia/playlist/canciones', extra: {
      'playlistId': playlist.id,
      'title': playlist.title,
      'subtitle': playlist.subtitle,
      'creator': playlist.creator,
      'coverUrl': playlist.imageUrl,
      'isAsset': true,
      'trackCount': playlist.trackCount,
      'duration': playlist.duration,
      'isUserCreated': playlist.isUserCreated,
    });
  }

  // Diálogo simplificado para crear playlist (evita congelamiento)
  void _showCreatePlaylistSimpleDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String selectedImageUrl = _playlistImages[0]; // Default image
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear nueva playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Nombre de tu playlist',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Imagen predeterminada seleccionada'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Crear nueva playlist de forma simple
                Navigator.pop(context);
                _addNewPlaylist(
                  titleController.text,
                  descriptionController.text,
                  selectedImageUrl
                );
                // La notificación ahora se muestra desde _addNewPlaylist
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
                foregroundColor: Colors.white, 
              ),
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }
}

// Modelos de datos para Playlists
class PlaylistItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int id;
  final String creator;
  final int trackCount;
  final String duration;
  final bool isUserCreated;

  PlaylistItem(
    this.title,
    this.subtitle,
    this.imageUrl,
    this.id,
    {this.creator = 'Tranquilidad App',
    this.trackCount = 0,
    this.duration = '00:00',
    this.isUserCreated = false}
  );
}

class PlaylistCategory {
  final String title;
  final List<PlaylistItem> playlists;

  PlaylistCategory(this.title, this.playlists);
}