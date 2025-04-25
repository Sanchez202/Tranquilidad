import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MusicApp(initialTrackIndex: 0));
}

// Define routes
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const GenresScreen();
      },
    ),
    GoRoute(
      path: '/player',
      builder: (BuildContext context, GoRouterState state) {
        // Get the initialTrackIndex from extra parameters
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
        final initialTrackIndex = extra['trackIndex'] ?? 0;
        final String genreId = extra['genreId'] ?? 'clasica';
        return MusicPlayerScreen(
          initialTrackIndex: initialTrackIndex,
          genreId: genreId,
        );
      },
    ),
  ],
);

class MusicApp extends StatelessWidget {
  final int initialTrackIndex;

 const MusicApp({
    super.key,
    required this.initialTrackIndex,
  });


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF0E6FF),
        fontFamily: 'Roboto',
      ),
      routerConfig: _router,
    );
  }
}

class API {
  final String baseUrl = 'https://back1-production-67bf.up.railway.app'; // Replace with your actual API URL

  Future<Map<String, dynamic>> getGenre(String genreId) async {
    final response = await http.get(Uri.parse('$baseUrl/genres/$genreId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load genre');
    }
  }

  Future<List<Map<String, dynamic>>> getAllGenres() async {
    final response = await http.get(Uri.parse('$baseUrl/genres'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<Map<String, dynamic>> getAllAudios() async {
    final response = await http.get(Uri.parse('$baseUrl/audios'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load audios');
    }
  }
}

// Genres Screen - Main screen showing all genres
class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  final API api = API();
  List<Map<String, dynamic>> genres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGenres();
  }

  Future<void> loadGenres() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final genresList = await api.getAllGenres();
      
      setState(() {
        genres = genresList;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading genres: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Musicoterapia'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          // Background pattern
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_principal1abastrato.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xFFF0E6FF).withOpacity(0.8),
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      final genre = genres[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to player screen with the genre ID
                          context.go('/player', extra: {
                            'genreId': genre['id'],
                            'trackIndex': 0,
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(genre['image_path'] ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  genre['name'] ?? 'Unknown Genre',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Music Player Screen - Shows tracks for a specific genre
class MusicPlayerScreen extends StatefulWidget {
  final int initialTrackIndex;
  final String genreId;
  
  const MusicPlayerScreen({
    Key? key, 
    this.initialTrackIndex = 0,
    this.genreId = 'clasica',
  }) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final API api = API();
  
  late String genreId;
  String genreName = "Cargando...";
  String albumImageUrl = "";
  String currentTitle = "Bienvenido y disfruta ♫";
  String currentArtist = "Artist";
  List<MusicTrack> tracks = [];
  
  int currentTrackIndex = -1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set the genre ID from the widget parameter
    genreId = widget.genreId;
    // Load data
    loadGenreData().then((_) {
      // Set initial track index after data is loaded
      if (tracks.isNotEmpty) {
        // Make sure the initial index is valid
        int safeIndex = widget.initialTrackIndex;
        if (safeIndex < 0 || safeIndex >= tracks.length) {
          safeIndex = 0;
        }
        selectTrack(safeIndex);
      }
    });
  }

  Future<void> loadGenreData() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // Get genre information
      final genreResponse = await api.getGenre(genreId);
      final genre = genreResponse['data'];
      
      // Get audio tracks for this genre
      final audioResponse = await api.getAllAudios();
      final allAudios = audioResponse['data'] as List;
      
      setState(() {
        genreName = genre['name'] ?? 'Género desconocido';
        albumImageUrl = genre['image_path'] ?? 'assets/images/default-genre.png';
        
        tracks = allAudios
            .where((audio) => audio['genre_id'] == genreId)
            .map((audio) => MusicTrack(
                  id: audio['id'],
                  title: audio['title'] ?? 'Sin título',
                  artist: audio['artist'] ?? 'Artista desconocido',
                  duration: Duration(seconds: audio['duration'] ?? 0),
                  imageUrl: audio['image_url'] ?? albumImageUrl,
                ))
            .toList();
            
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void selectTrack(int index) {
    if (index < 0 || index >= tracks.length) return;

    final track = tracks[index];
    setState(() {
      currentTitle = track.title;
      currentArtist = track.artist;
      currentTrackIndex = index;
    });
  }

  void shareTrack() {
    if (currentTrackIndex >= 0) {
      Share.share('Check out this track: ${tracks[currentTrackIndex].title} by ${tracks[currentTrackIndex].artist}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background pattern
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_principal1abastrato.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Color(0xFFF0E6FF).withOpacity(0.8),
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => context.go('/'),
                        ),
                        Text(
                          'Musicoterapia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Main content
                  Expanded(
                    child: Row(
                      children: [
                        // Sidebar
                        Container(
                          width: 80,
                          color: Colors.white.withOpacity(0.8),
                          child: ListView(
                            children: [
                              SizedBox(height: 40),
                              _buildSidebarItem('Géneros', Icons.music_note),
                              _buildSidebarItem('Álbum', Icons.album),
                              _buildSidebarItem('Podcast', Icons.podcasts),
                              _buildSidebarItem('Binaurales', Icons.surround_sound),
                              _buildSidebarItem('PlayList', Icons.playlist_play),
                              _buildSidebarItem('Me gusta', Icons.favorite),
                              _buildSidebarItem('Buscar', Icons.search),
                            ],
                          ),
                        ),
                        
                        // Main content area
                        Expanded(
                          child: Column(
                            children: [
                              // Purple header
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  genreName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              
                              // Selected item details
                              Container(
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Album cover
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: NetworkImage(currentTrackIndex >= 0 ? 
                                              tracks[currentTrackIndex].imageUrl : albumImageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    
                                    // Title and artist
                                    Text(
                                      currentTitle,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      currentArtist,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    
                                    // Share buttons
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.whatsapp),
                                          onPressed: shareTrack,
                                        ),
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.facebook),
                                          onPressed: shareTrack,
                                        ),
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.instagram),
                                          onPressed: shareTrack,
                                        ),
                                        TextButton(
                                          child: Text('Copiar Link'),
                                          onPressed: () {
                                            // Copy link functionality
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Tracks grid
                              Expanded(
                                child: tracks.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.music_off, size: 48, color: Colors.grey),
                                            SizedBox(height: 16),
                                            Text(
                                              'No hay pistas disponibles en este género',
                                              style: TextStyle(color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GridView.builder(
                                        padding: EdgeInsets.all(16),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 0.75,
                                        ),
                                        itemCount: tracks.length,
                                        itemBuilder: (context, index) {
                                          final track = tracks[index];
                                          final isActive = index == currentTrackIndex;
                                          
                                          return GestureDetector(
                                            onTap: () => selectTrack(index),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: isActive 
                                                        ? Colors.purple.withOpacity(0.4)
                                                        : Colors.black.withOpacity(0.1),
                                                    spreadRadius: isActive ? 2 : 1,
                                                    blurRadius: isActive ? 12 : 8,
                                                  ),
                                                ],
                                                border: isActive
                                                    ? Border.all(color: Colors.purple, width: 2)
                                                    : null,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(14),
                                                        ),
                                                        image: DecorationImage(
                                                          image: NetworkImage(track.imageUrl),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          track.title,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: isActive ? Colors.purple : Colors.black,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          track.artist,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[700],
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: Colors.purple),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MusicTrack {
  final String id;
  final String title;
  final String artist;
  final Duration duration;
  final String imageUrl;

  MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.imageUrl,
  });
}