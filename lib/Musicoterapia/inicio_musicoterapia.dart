import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class InicioMusicoterapia extends StatefulWidget {
  const InicioMusicoterapia({super.key});

  @override
  State<InicioMusicoterapia> createState() => _InicioMusicoterapiaState();
}

class _InicioMusicoterapiaState extends State<InicioMusicoterapia> {
  int _selectedIndex = 1;
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['GENEROS', 'ÁLBUMS', 'PODCAST', 'SONIDOS BINAURALES', 'PLAYLIST', 'ME GUSTA'];
  
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  
  // Lista de todos los álbumes disponibles
  final List<AlbumItem> _allAlbums = [
    // Popular Albums
    AlbumItem(
      'Música Clásica',
      'Lo mejor de la música clásica',
      'assets/MUSICOTERAPIA/img_1.jpg',
      1,
      artist: 'Varios Artistas',
      songs: [
        Song('Nocturno Op. 9 No. 2', 'Chopin', 'assets/MUSICOTERAPIA/img_1.jpg', '4:32'),
        Song('Claro de Luna', 'Beethoven', 'assets/MUSICOTERAPIA/img_1.jpg', '5:10'),
        Song('Las Cuatro Estaciones: Primavera', 'Vivaldi', 'assets/MUSICOTERAPIA/img_1.jpg', '3:25'),
        Song('Canon en D', 'Pachelbel', 'assets/MUSICOTERAPIA/img_1.jpg', '4:40'),
      ],
    ),
    AlbumItem(
      'Jazz & Blues',
      'Relájate con jazz suave',
      'assets/MUSICOTERAPIA/img_2.jpg',
      2,
      artist: 'Colección Jazz',
      songs: [
        Song('Take Five', 'Dave Brubeck', 'assets/MUSICOTERAPIA/img_2.jpg', '5:24'),
        Song('So What', 'Miles Davis', 'assets/MUSICOTERAPIA/img_2.jpg', '9:22'),
        Song('Fly Me To The Moon', 'Frank Sinatra', 'assets/MUSICOTERAPIA/img_2.jpg', '3:10'),
        Song('Autumn Leaves', 'Cannonball Adderley', 'assets/MUSICOTERAPIA/img_2.jpg', '6:46'),
      ],
    ),
    AlbumItem(
      'Sonidos Naturales',
      'Conecta con la naturaleza',
      'assets/MUSICOTERAPIA/img_3.jpg',
      3,
      artist: 'Nature Sounds',
      songs: [
        Song('Lluvia en el Bosque', 'Sounds of Nature', 'assets/MUSICOTERAPIA/img_3.jpg', '8:15'),
        Song('Amanecer en la Playa', 'Nature Ambient', 'assets/MUSICOTERAPIA/img_3.jpg', '10:30'),
        Song('Cascada Tropical', 'Earth Tones', 'assets/MUSICOTERAPIA/img_3.jpg', '7:45'),
        Song('Canto de Aves', 'Forest Melodies', 'assets/MUSICOTERAPIA/img_3.jpg', '6:20'),
      ],
    ),
    AlbumItem(
      'Meditación Guiada',
      'Encuentra tu paz interior',
      'assets/MUSICOTERAPIA/img_4.jpg',
      4,
      artist: 'Mindfulness Masters',
      songs: [
        Song('Respiración Consciente', 'Mindfulness', 'assets/MUSICOTERAPIA/img_4.jpg', '15:20'),
        Song('Paz Interior', 'Serenity Now', 'assets/MUSICOTERAPIA/img_4.jpg', '12:45'),
        Song('Visualización Positiva', 'Inner Journey', 'assets/MUSICOTERAPIA/img_4.jpg', '18:30'),
        Song('Gratitud y Presencia', 'Present Moment', 'assets/MUSICOTERAPIA/img_4.jpg', '10:15'),
      ],
    ),
    
    // Recomendados para ti
    AlbumItem(
      'Música Ambiental',
      'Concentración y relajación',
      'assets/MUSICOTERAPIA/img_5.jpg',
      5,
      artist: 'Ambient Collective',
      songs: [
        Song('Focus Flow', 'Ambient Masters', 'assets/MUSICOTERAPIA/img_5.jpg', '8:40'),
        Song('Deep Work', 'Concentration Sounds', 'assets/MUSICOTERAPIA/img_5.jpg', '11:25'),
        Song('Calma Productiva', 'Productive Mood', 'assets/MUSICOTERAPIA/img_5.jpg', '9:15'),
        Song('Espacio Mental', 'Clear Mind', 'assets/MUSICOTERAPIA/img_5.jpg', '12:50'),
        Song('Weightless', 'Ambient Masters', 'assets/MUSICOTERAPIA/img_5.jpg', '10:30'), // Canción de ejemplo
      ],
    ),
    AlbumItem(
      'Sonidos Binaurales',
      'Equilibra tu energía mental',
      'assets/MUSICOTERAPIA/img_6.jpg',
      6,
      artist: 'BrainSync',
      songs: [
        Song('Ondas Alpha', 'BrainSync', 'assets/MUSICOTERAPIA/img_6.jpg', '30:15'),
        Song('Frecuencia Theta', 'Mind Waves', 'assets/MUSICOTERAPIA/img_6.jpg', '25:40'),
        Song('Delta Profundo', 'Deep Brain', 'assets/MUSICOTERAPIA/img_6.jpg', '45:30'),
        Song('Gamma Focus', 'Brain Power', 'assets/MUSICOTERAPIA/img_6.jpg', '20:10'),
      ],
    ),
    AlbumItem(
      'Piano Instrumental',
      'Música para el alma',
      'assets/MUSICOTERAPIA/img_7.jpg',
      7,
      artist: 'Piano Dreams',
      songs: [
        Song('Lluvia de Estrellas', 'Piano Dreams', 'assets/MUSICOTERAPIA/img_7.jpg', '4:50'),
        Song('Memorias', 'Soul Piano', 'assets/MUSICOTERAPIA/img_7.jpg', '5:25'),
        Song('Atardecer', 'Peaceful Keys', 'assets/MUSICOTERAPIA/img_7.jpg', '6:10'),
        Song('Camino de Luz', 'Piano Journey', 'assets/MUSICOTERAPIA/img_7.jpg', '7:35'),
      ],
    ),
    AlbumItem(
      'Melodías para Dormir',
      'Descansa profundamente',
      'assets/MUSICOTERAPIA/img_8.jpg',
      8,
      artist: 'Sleep Well',
      songs: [
        Song('Nana Nocturna', 'Sweet Dreams', 'assets/MUSICOTERAPIA/img_8.jpg', '8:20'),
        Song('Arrullo Celestial', 'Night Sleep', 'assets/MUSICOTERAPIA/img_8.jpg', '9:45'),
        Song('Sueños Tranquilos', 'Sleep Well', 'assets/MUSICOTERAPIA/img_8.jpg', '11:30'),
        Song('Descanso Profundo', 'Deep Rest', 'assets/MUSICOTERAPIA/img_8.jpg', '12:15'),
      ],
    ),
    
    // Recientes
    AlbumItem(
      'Mantras Curativos',
      'Sabiduría ancestral en sonidos',
      'assets/MUSICOTERAPIA/img_9.jpg',
      9,
      artist: 'Sacred Sounds',
      songs: [
        Song('Om Shanti', 'Sacred Sounds', 'assets/MUSICOTERAPIA/img_9.jpg', '10:15'),
        Song('Mantra Sanador', 'Ancient Wisdom', 'assets/MUSICOTERAPIA/img_9.jpg', '12:30'),
        Song('Canto de Paz', 'Healing Chants', 'assets/MUSICOTERAPIA/img_9.jpg', '8:45'),
        Song('Energía Universal', 'Universal Energy', 'assets/MUSICOTERAPIA/img_9.jpg', '15:20'),
      ],
    ),
    AlbumItem(
      'Frecuencias 432Hz',
      'Armonía para tu ser',
      'assets/MUSICOTERAPIA/img_10.jpg',
      10,
      artist: 'Pure Harmony',
      songs: [
        Song('Armonía Perfecta', 'Pure Harmony', 'assets/MUSICOTERAPIA/img_10.jpg', '20:30'),
        Song('Frecuencia del Universo', 'Cosmic Tune', 'assets/MUSICOTERAPIA/img_10.jpg', '18:15'),
        Song('Resonancia Natural', 'Earth Frequency', 'assets/MUSICOTERAPIA/img_10.jpg', '22:40'),
        Song('Alineación de Chakras', 'Energy Balance', 'assets/MUSICOTERAPIA/img_10.jpg', '25:10'),
      ],
    ),
    AlbumItem(
      'Música para Yoga',
      'Eleva tu práctica',
      'assets/MUSICOTERAPIA/img_11.jpg',
      11,
      artist: 'Yoga Flow',
      songs: [
        Song('Flow Consciente', 'Yoga Flow', 'assets/MUSICOTERAPIA/img_11.jpg', '15:40'),
        Song('Equilibrio y Presencia', 'Present Yoga', 'assets/MUSICOTERAPIA/img_11.jpg', '12:55'),
        Song('Energía Vital', 'Vital Energy', 'assets/MUSICOTERAPIA/img_11.jpg', '14:30'),
        Song('Saludo al Sol', 'Sun Salutation', 'assets/MUSICOTERAPIA/img_11.jpg', '18:25'),
      ],
    ),
  ];

  List<AlbumCategory> _categories = [];
  List<AlbumItem> _searchResultAlbums = [];
  List<SongWithAlbum> _searchResultSongs = [];

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
      AlbumCategory(
        'Popular Generos',
        _allAlbums.sublist(0, 4),
      ),
      AlbumCategory(
        'Recomendados para ti',
        _allAlbums.sublist(4, 8),
      ),
      AlbumCategory(
        'Recientes',
        _allAlbums.sublist(8),
      ),
    ];
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchQuery = '';
        _searchResultAlbums = [];
        _searchResultSongs = [];
      });
      return;
    }

    // Búsqueda de álbumes
    final matchingAlbums = _allAlbums.where((album) {
      return album.title.toLowerCase().contains(query) || 
             album.subtitle.toLowerCase().contains(query) ||
             album.artist.toLowerCase().contains(query);
    }).toList();

    // Búsqueda de canciones - Ahora busca también por título exacto de canción
    final matchingSongs = <SongWithAlbum>[];
    
    // Primero buscar canciones que coincidan con la consulta
    for (var album in _allAlbums) {
      for (var songIndex = 0; songIndex < album.songs.length; songIndex++) {
        final song = album.songs[songIndex];
        
        // Comprobar si el título de la canción contiene la consulta
        if (song.title.toLowerCase().contains(query) || 
            song.artist.toLowerCase().contains(query)) {
          matchingSongs.add(SongWithAlbum(song, album, songIndex));
        }
      }
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query;
      _searchResultAlbums = matchingAlbums;
      _searchResultSongs = matchingSongs;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchResultAlbums = [];
      _searchResultSongs = [];
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
      // Ya estás en la vista de géneros (inicio_musicoterapia.dart)
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
          Container(color: Colors.white.withOpacity(0.7)),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'GENEROS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Search Bar con texto a la izquierda (junto a la lupa)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.start, // Texto alineado a la izquierda
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar generos',
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
                
                const SizedBox(height: 20),
                
                // Content: Search Results or Album Categories
                Expanded(
                  child: _isSearching
                    ? _buildSearchResults()
                    : _buildAlbumCategoriesView(),
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

  Widget _buildSearchResults() {
    if (_searchResultAlbums.isEmpty && _searchResultSongs.isEmpty) {
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
        // Songs results - Mostramos primero las canciones para darles prioridad
        if (_searchResultSongs.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'CANCIONES',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9575CD),
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _searchResultSongs.length,
            itemBuilder: (context, index) {
              final songWithAlbum = _searchResultSongs[index];
              return _buildSongListItem(songWithAlbum);
            },
          ),
        ],

        // Albums results
        if (_searchResultAlbums.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'ALBUMS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9575CD),
              ),
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: _searchResultAlbums.length,
              itemBuilder: (context, index) {
                final album = _searchResultAlbums[index];
                return _buildMusicCard(
                  context,
                  album.title,
                  album.subtitle,
                  album.imageUrl,
                  album.id,
                  isAsset: true,
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSongListItem(SongWithAlbum songWithAlbum) {
    final song = songWithAlbum.song;
    final album = songWithAlbum.album;
    final songIndex = songWithAlbum.index;
    
    return GestureDetector(
      onTap: () {
        // Navegar al reproductor de música con la canción seleccionada
        _navigateToMusicPlayer(album, songIndex);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Song image
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                song.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${song.artist} • ${album.title}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Duration and play button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  song.duration,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                const Icon(
                  Icons.play_circle_filled,
                  color: Color(0xFF9575CD),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMusicPlayer(AlbumItem album, int songIndex) {
    // Preparar la lista de canciones para el reproductor
    final trackList = album.songs.map((song) {
      return {
        'title': song.title,
        'artist': song.artist,
        'duration': song.duration,
        'coverUrl': song.imageUrl,
        'isAsset': true,
      };
    }).toList();
    
    // Navegar al reproductor usando go_router
    context.go('/player', extra: {
      'albumId': album.id,
      'albumTitle': album.title,
      'albumArtist': album.artist,
      'coverUrl': album.imageUrl,
      'isAsset': true,
      'trackIndex': songIndex,
      'tracks': trackList,
    });
  }

  Widget _buildAlbumCategoriesView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildAlbumCategory(category.title, category.albums);
      },
    );
  }

  Widget _buildAlbumCategory(String categoryTitle, List<AlbumItem> albums) {
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
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return _buildMusicCard(
                context,
                albums[index].title,
                albums[index].subtitle,
                albums[index].imageUrl,
                albums[index].id,
                isAsset: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMusicCard(
    BuildContext context,
    String title,
    String subtitle,
    String imageUrl,
    int albumId,
    {bool isAsset = false}
  ) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página de detalle del álbum
        context.go('/album_detail/$albumId', extra: {
          'title': title,
          'subtitle': subtitle,
          'imageUrl': imageUrl,
          'isAsset': isAsset,
        });
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: isAsset 
                  ? Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.music_note, size: 50, color: Colors.grey[500]),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Modelos de datos
class AlbumItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int id;
  final String artist;
  final List<Song> songs;

  AlbumItem(
    this.title,
    this.subtitle,
    this.imageUrl,
    this.id,
    {this.artist = 'Varios Artistas',
    this.songs = const []}
  );
}

class Song {
  final String title;
  final String artist;
  final String imageUrl;
  final String duration;

  Song(this.title, this.artist, this.imageUrl, this.duration);
}

class SongWithAlbum {
  final Song song;
  final AlbumItem album;
  final int index;  // Índice de la canción en el álbum

  SongWithAlbum(this.song, this.album, this.index);
}

class AlbumCategory {
  final String title;
  final List<AlbumItem> albums;

  AlbumCategory(this.title, this.albums);
}