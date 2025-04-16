import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class MeGustaScreen extends StatefulWidget {
  const MeGustaScreen({Key? key}) : super(key: key);

  @override
  State<MeGustaScreen> createState() => _MeGustaScreenState();
}

class _MeGustaScreenState extends State<MeGustaScreen> {
  late List<Map<String, dynamic>> favoritesList;
  late List<Map<String, dynamic>> filteredList;
  final TextEditingController _searchController = TextEditingController();
  // Lista para mantener el estado de favorito de cada canción
  late List<bool> songFavorites;

  @override
  void initState() {
    super.initState();
    favoritesList = _getFavoritesList();
    filteredList = List.from(favoritesList);
    // Inicializar la lista de favoritos para cada canción
    songFavorites = List.generate(favoritesList.length, (index) => true); // Todas inician como favoritas
    
    _searchController.addListener(() {
      _filterSongs(_searchController.text);
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  // Método para filtrar canciones según el texto de búsqueda
  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(favoritesList);
      } else {
        filteredList = favoritesList
            .where((song) => song['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Método para obtener la lista de canciones favoritas
  List<Map<String, dynamic>> _getFavoritesList() {
    return [
      {
        'title': 'Weightless',
        'duration': '3:30',
        'image': 'assets/MUSICOTERAPIA/img_album11.jpg',
        'number': 1
      },
      {
        'title': 'Pure Tranquility',
        'duration': '4:45',
        'image': 'assets/MUSICOTERAPIA/img_6.jpg',
        'number': 2
      },
      {
        'title': 'Mindful Journey',
        'duration': '5:12',
        'image': 'assets/MUSICOTERAPIA/img6_album.jpg',
        'number': 3
      },
      {
        'title': 'Peaceful Harmony',
        'duration': '3:55',
        'image': 'assets/MUSICOTERAPIA/img_3.jpg',
        'number': 4
      },
      {
        'title': 'Inner Balance',
        'duration': '4:20',
        'image': 'assets/MUSICOTERAPIA/img3_album.jpg',
        'number': 5
      },
      {
        'title': 'Serenity Now',
        'duration': '3:15',
        'image': 'assets/MUSICOTERAPIA/img_7.jpg',
        'number': 6
      },
      {
        'title': 'Good Morning',
        'duration': '3:15',
        'image': 'assets/MUSICOTERAPIA/img_album7.jpg',
        'number': 7
      },
      {
        'title': 'Bye',
        'duration': '3:15',
        'image': 'assets/MUSICOTERAPIA/img_album9.jpg',
        'number': 8
      },
      {
        'title': 'Come on',
        'duration': '3:15',
        'image': 'assets/MUSICOTERAPIA/img_3.jpg',
        'number': 9
      },
      {
        'title': 'Arya',
        'duration': '3:15',
        'image': 'assets/MUSICOTERAPIA/img1_album.jpg',
        'number': 10
      },
      {
        'title': 'Slow dancing in the dark',
        'duration': '3:15',
        'image': 'assets/MUSICOTERAPIA/img_album5.jpg',
        'number': 11
      },
      {
        'title': 'Run',
        'duration': '3:15',
        'image': 'assets/MUSICOTERAPIA/img_11.jpg',
        'number': 12
      },
    ];
  }

  // Método para mostrar notificaciones con Snackbar
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9575CD),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
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
          Container(color: Colors.white.withOpacity(0.7)),


          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header and back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => context.go('/musicoterapia/playlist'),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'TUS ME GUSTA',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Invisible widget to balance the row
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 20),
                        hintText: 'Buscar',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                
                // Reproducir button y botón compartir
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Botón reproducir
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9575CD),
                            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            // Reproducir toda la lista
                            context.push('/reproductor_me_gusta', extra: {
                              'trackIndex': 0,
                              'tracks': filteredList,
                            });
                          },
                          child: const Text('REPRODUCIR'),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Botón compartir (nuevo)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Implementar funcionalidad para compartir
                            // La notificación ha sido eliminada
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Canciones header
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CANCIONES',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // List of songs - modified for better image handling
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final song = filteredList[index];
                      return ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade300, // Fallback color
                          ),
                          clipBehavior: Clip.antiAlias, // Ensures image clips properly
                          child: Image.asset(
                            song['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Improved error handler that displays track number
                              debugPrint('Error loading image for track ${song['number']}: $error');
                              return Center(
                                child: Text(
                                  '${song['number']}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          song['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          // Añadir subtítulo dinámico para cada canción
                          index % 3 == 0 ? 'Reading Time • ${song['duration']}' :
                          index % 3 == 1 ? 'Book Sounds • ${song['duration']}' :
                          'Focus Read • ${song['duration']}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        // Botones de acción a la derecha
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Corazón favorito para cada canción (nuevo)
                            IconButton(
                              icon: Icon(
                                songFavorites[index] ? Icons.favorite : Icons.favorite_border,
                                color: songFavorites[index] ? const Color(0xFF9575CD) : Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  songFavorites[index] = !songFavorites[index];
                                });
                                
                                // Mostrar notificación con el nombre de la pista
                                _showNotification(
                                  '"${song['title']}" ' + 
                                  (songFavorites[index] 
                                    ? 'añadido a Tus Me Gusta' 
                                    : 'eliminado de Tus Me Gusta')
                                );
                              },
                            ),
                            // Botón de reproducción
                            IconButton(
                              icon: const Icon(
                                Icons.play_circle_outline,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () {
                                // Navegar a la pantalla del reproductor con la pista seleccionada
                                context.push('/reproductor_me_gusta', extra: {
                                  'trackIndex': index,
                                  'tracks': filteredList,
                                });
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navegar a la pantalla del reproductor con la pista seleccionada
                          context.push('/reproductor_me_gusta', extra: {
                            'trackIndex': index,
                            'tracks': filteredList,
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}