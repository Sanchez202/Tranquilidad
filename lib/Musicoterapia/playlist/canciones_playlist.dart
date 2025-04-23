import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class CancionesPlaylistScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String coverUrl;
  final bool isAsset;
  final int playlistId;
  final int trackCount;
  final String duration;
  final String creator;
  final bool isUserCreated;

  const CancionesPlaylistScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.coverUrl,
    required this.isAsset,
    required this.playlistId,
    required this.trackCount,
    required this.duration,
    required this.creator,
    this.isUserCreated = false,
  });

  @override
  State<CancionesPlaylistScreen> createState() =>
      _CancionesPlaylistScreenState();
}

class _CancionesPlaylistScreenState extends State<CancionesPlaylistScreen> {
  bool isFavorite = false;
  late List<Map<String, dynamic>> songList;
  // Mapa para controlar los favoritos de cada canción
  Map<int, bool> songFavorites = {};

  @override
  void initState() {
    super.initState();
    songList = _getSongsForPlaylist(widget.playlistId);
    // Inicializar todos los favoritos en falso
    for (int i = 0; i < songList.length; i++) {
      songFavorites[i] = false;
    }
  }

  // Método para mostrar notificaciones
  // Método para mostrar notificaciones con Snackbar (modificado)
  void _showNotification(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
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

  // Método para obtener canciones específicas según el ID de la playlist
  List<Map<String, dynamic>> _getSongsForPlaylist(int playlistId) {
    switch (playlistId) {
      case 1: // Meditación Matutina
        return [
          {
            'title': 'Amanecer Tranquilo',
            'duration': '5:20',
            'artist': 'Zen Masters',
            'isFavorite': false,
          },
          {
            'title': 'Primeros Rayos',
            'duration': '4:45',
            'artist': 'Morning Light',
            'isFavorite': false,
          },
          {
            'title': 'Despertar Consciente',
            'duration': '6:12',
            'artist': 'Mindful Journey',
            'isFavorite': false,
          },
          {
            'title': 'Energía del Alba',
            'duration': '5:35',
            'artist': 'Dawn Chorus',
            'isFavorite': false,
          },
          {
            'title': 'Respiración Matinal',
            'duration': '7:18',
            'artist': 'Breath Work',
            'isFavorite': false,
          },
          {
            'title': 'Calma Interior',
            'duration': '4:30',
            'artist': 'Inner Peace',
            'isFavorite': false,
          },
          {
            'title': 'Claridad Mental',
            'duration': '6:25',
            'artist': 'Clear Mind',
            'isFavorite': false,
          },
          {
            'title': 'Gratitud Diaria',
            'duration': '5:15',
            'artist': 'Thankful Heart',
            'isFavorite': false,
          },
        ];
      case 2: // Concentración Profunda
        return [
          {
            'title': 'Enfoque Absoluto',
            'duration': '8:30',
            'artist': 'Focus Mind',
            'isFavorite': false,
          },
          {
            'title': 'Ondas Alpha',
            'duration': '10:15',
            'artist': 'BrainWaves',
            'isFavorite': false,
          },
          {
            'title': 'Productividad Zen',
            'duration': '7:22',
            'artist': 'Deep Work',
            'isFavorite': false,
          },
          {
            'title': 'Flujo Creativo',
            'duration': '9:48',
            'artist': 'Flow State',
            'isFavorite': false,
          },
          {
            'title': 'Concentración Theta',
            'duration': '12:10',
            'artist': 'Brain Power',
            'isFavorite': false,
          },
          {
            'title': 'Precisión Mental',
            'duration': '6:35',
            'artist': 'Mind Tools',
            'isFavorite': false,
          },
        ];
      case 3: // Antes de Dormir
        return [
          {
            'title': 'Nana Nocturna',
            'duration': '9:42',
            'artist': 'Sleep Well',
            'isFavorite': false,
          },
          {
            'title': 'Descanso Profundo',
            'duration': '8:18',
            'artist': 'Deep Sleep',
            'isFavorite': false,
          },
          {
            'title': 'Sueños Tranquilos',
            'duration': '11:56',
            'artist': 'Dream Space',
            'isFavorite': false,
          },
          {
            'title': 'Relajación Nocturna',
            'duration': '7:40',
            'artist': 'Night Peace',
            'isFavorite': false,
          },
          {
            'title': 'Arrullo Delta',
            'duration': '15:30',
            'artist': 'Delta Waves',
            'isFavorite': false,
          },
        ];
      case 4: // Música para Leer
        return [
          {
            'title': 'Páginas de Calma',
            'duration': '6:15',
            'artist': 'Reading Time',
            'isFavorite': false,
          },
          {
            'title': 'Melodía Literaria',
            'duration': '7:22',
            'artist': 'Book Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Concentración Lectora',
            'duration': '8:50',
            'artist': 'Focus Read',
            'isFavorite': false,
          },
          {
            'title': 'Atmósfera de Biblioteca',
            'duration': '9:38',
            'artist': 'Library Vibes',
            'isFavorite': false,
          },
          {
            'title': 'Entre Líneas',
            'duration': '5:12',
            'artist': 'Page Turner',
            'isFavorite': false,
          },
          {
            'title': 'Imaginación Sonora',
            'duration': '7:30',
            'artist': 'Book Journey',
            'isFavorite': false,
          },
          {
            'title': 'Silencio Creativo',
            'duration': '8:45',
            'artist': 'Creative Space',
            'isFavorite': false,
          },
          {
            'title': 'Notas de Estudio',
            'duration': '6:58',
            'artist': 'Study Notes',
            'isFavorite': false,
          },
          {
            'title': 'Mundo de Palabras',
            'duration': '7:10',
            'artist': 'Word Flow',
            'isFavorite': false,
          },
          {
            'title': 'Capítulos Tranquilos',
            'duration': '9:20',
            'artist': 'Chapter Calm',
            'isFavorite': false,
          },
        ];
      case 5: // Mi Colección (usuario)
        return [
          {
            'title': 'Favorite Melody',
            'duration': '4:35',
            'artist': 'Personal Mix',
            'isFavorite': false,
          },
          {
            'title': 'Evening Calm',
            'duration': '6:20',
            'artist': 'Night Collection',
            'isFavorite': false,
          },
          {
            'title': 'Monday Morning',
            'duration': '5:15',
            'artist': 'Week Start',
            'isFavorite': false,
          },
          {
            'title': 'Peaceful Mind',
            'duration': '7:40',
            'artist': 'Mind Collection',
            'isFavorite': false,
          },
          {
            'title': 'Focus Time',
            'duration': '8:10',
            'artist': 'Study Sessions',
            'isFavorite': false,
          },
          {
            'title': 'Gentle Rain',
            'duration': '5:30',
            'artist': 'Nature Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Ocean Waves',
            'duration': '9:45',
            'artist': 'Sea Collection',
            'isFavorite': false,
          },
          {
            'title': 'Forest Birds',
            'duration': '6:15',
            'artist': 'Woodland Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Meditation Bell',
            'duration': '10:20',
            'artist': 'Zen Practice',
            'isFavorite': false,
          },
          {
            'title': 'Dream Sequence',
            'duration': '8:30',
            'artist': 'Sleep Aid',
            'isFavorite': false,
          },
          {
            'title': 'Mountain Wind',
            'duration': '7:25',
            'artist': 'High Places',
            'isFavorite': false,
          },
          {
            'title': 'Starlight',
            'duration': '5:50',
            'artist': 'Night Sky',
            'isFavorite': false,
          },
        ];
      case 6: // Para Meditar
        return [
          {
            'title': 'Respiración Consciente',
            'duration': '9:15',
            'artist': 'Breath Masters',
            'isFavorite': false,
          },
          {
            'title': 'Meditación Guiada',
            'duration': '15:30',
            'artist': 'Meditation Guide',
            'isFavorite': false,
          },
          {
            'title': 'Momento Presente',
            'duration': '7:48',
            'artist': 'Present Moment',
            'isFavorite': false,
          },
          {
            'title': 'Sanación Interior',
            'duration': '12:25',
            'artist': 'Inner Healing',
            'isFavorite': false,
          },
          {
            'title': 'Campanas Tibetanas',
            'duration': '8:40',
            'artist': 'Tibet Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Paz Mental',
            'duration': '10:18',
            'artist': 'Mental Peace',
            'isFavorite': false,
          },
          {
            'title': 'Chakra Balance',
            'duration': '14:30',
            'artist': 'Energy Flow',
            'isFavorite': false,
          },
        ];
      case 7: // Naturaleza
        return [
          {
            'title': 'Lluvia en el Bosque',
            'duration': '8:42',
            'artist': 'Forest Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Amanecer en la Montaña',
            'duration': '7:18',
            'artist': 'Mountain Dawn',
            'isFavorite': false,
          },
          {
            'title': 'Río Cristalino',
            'duration': '9:56',
            'artist': 'River Flow',
            'isFavorite': false,
          },
          {
            'title': 'Viento entre Árboles',
            'duration': '6:10',
            'artist': 'Wind Whispers',
            'isFavorite': false,
          },
          {
            'title': 'Aves del Amanecer',
            'duration': '10:30',
            'artist': 'Morning Birds',
            'isFavorite': false,
          },
          {
            'title': 'Olas en la Playa',
            'duration': '12:45',
            'artist': 'Ocean Waves',
            'isFavorite': false,
          },
          {
            'title': 'Tormenta Lejana',
            'duration': '8:35',
            'artist': 'Storm Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Cascada Tranquila',
            'duration': '11:20',
            'artist': 'Waterfall Peace',
            'isFavorite': false,
          },
          {
            'title': 'Praderas Abiertas',
            'duration': '7:15',
            'artist': 'Open Fields',
            'isFavorite': false,
          },
        ];
      case 8: // Mix Relajante
        return [
          {
            'title': 'Peaceful Piano',
            'duration': '5:15',
            'artist': 'Piano Dreams',
            'isFavorite': false,
          },
          {
            'title': 'Gentle Guitar',
            'duration': '4:30',
            'artist': 'Acoustic Mood',
            'isFavorite': false,
          },
          {
            'title': 'Ocean Breeze',
            'duration': '8:20',
            'artist': 'Sea Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Meditation Flute',
            'duration': '6:45',
            'artist': 'Wind Instruments',
            'isFavorite': false,
          },
          {
            'title': 'Healing Violin',
            'duration': '7:10',
            'artist': 'String Harmony',
            'isFavorite': false,
          },
          {
            'title': 'Rain Sounds',
            'duration': '9:30',
            'artist': 'Nature Elements',
            'isFavorite': false,
          },
          {
            'title': 'Ambient Synth',
            'duration': '5:40',
            'artist': 'Electronic Calm',
            'isFavorite': false,
          },
          {
            'title': 'Soft Bells',
            'duration': '4:15',
            'artist': 'Tone Therapy',
            'isFavorite': false,
          },
          {
            'title': 'Night Ambience',
            'duration': '7:50',
            'artist': 'Evening Mood',
            'isFavorite': false,
          },
          {
            'title': 'Whale Songs',
            'duration': '8:25',
            'artist': 'Ocean Life',
            'isFavorite': false,
          },
          {
            'title': 'Forest Birds',
            'duration': '6:30',
            'artist': 'Woodland Chorus',
            'isFavorite': false,
          },
          {
            'title': 'Creek Flow',
            'duration': '5:20',
            'artist': 'Water Sounds',
            'isFavorite': false,
          },
          {
            'title': 'Wind Chimes',
            'duration': '4:45',
            'artist': 'Gentle Breeze',
            'isFavorite': false,
          },
          {
            'title': 'Deep Resonance',
            'duration': '10:10',
            'artist': 'Sound Healing',
            'isFavorite': false,
          },
          {
            'title': 'Eternal Calm',
            'duration': '9:15',
            'artist': 'Peace Masters',
            'isFavorite': false,
          },
        ];
      default:
        return [
          {
            'title': 'Pista 1',
            'duration': '4:25',
            'artist': 'Artista Desconocido',
            'isFavorite': false,
          },
          {
            'title': 'Pista 2',
            'duration': '3:50',
            'artist': 'Artista Desconocido',
            'isFavorite': false,
          },
          {
            'title': 'Pista 3',
            'duration': '5:15',
            'artist': 'Artista Desconocido',
            'isFavorite': false,
          },
          {
            'title': 'Pista 4',
            'duration': '4:10',
            'artist': 'Artista Desconocido',
            'isFavorite': false,
          },
          {
            'title': 'Pista 5',
            'duration': '3:40',
            'artist': 'Artista Desconocido',
            'isFavorite': false,
          },
        ];
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
                image: AssetImage(
                  "assets/MUSICOTERAPIA/fondo_musicoterapia.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Light overlay for better readability
          Container(
            color: const Color.fromARGB(255, 209, 187, 224).withAlpha(179),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => context.go('/musicoterapia/playlist'),
                    ),
                  ),

                  // Playlist cover and info
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'playlist-${widget.playlistId}',
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(77),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  widget.isAsset
                                      ? Image.asset(
                                        widget.coverUrl,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.network(
                                        widget.coverUrl,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Creado por: ${widget.creator}",
                                style: TextStyle(
                                  color: Colors.black.withAlpha(179),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.music_note,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${songList.length} canciones • ${widget.duration}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Play buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9575CD),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // Navegar a la pantalla del reproductor con toda la playlist
                              context.push(
                                '/musicoterapia/playlist/reproductor',
                                extra: {
                                  'playlistId': widget.playlistId,
                                  'playlistTitle': widget.title,
                                  'playlistCreator': widget.creator,
                                  'coverUrl': widget.coverUrl,
                                  'isAsset': widget.isAsset,
                                  'trackIndex':
                                      0, // Comenzar con la primera pista
                                  'tracks': songList,
                                },
                              );
                            },
                            child: const Text('REPRODUCIR'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(77),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isFavorite
                                      ? const Color(0xFF9575CD)
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });

                              // Mostrar notificación según el estado
                              _showNotification(
                                isFavorite
                                    ? 'Añadido a Tus Me Gusta'
                                    : 'Eliminado de Tus Me Gusta',
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(77),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        if (widget.isUserCreated) ...[
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(77),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Song list title
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    child: Text(
                      'Canciones',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // List of tracks
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image:
                                  widget.isAsset
                                      ? AssetImage(widget.coverUrl)
                                      : NetworkImage(widget.coverUrl)
                                          as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          songList[index]['title']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${songList[index]['artist']!} • ${songList[index]['duration']!}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                songFavorites[index] ?? false
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    songFavorites[index] ?? false
                                        ? const Color(0xFF9575CD)
                                        : Colors.black,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  songFavorites[index] =
                                      !(songFavorites[index] ?? false);
                                });

                                _showNotification(
                                  '"${songList[index]['title']}" ${songFavorites[index]! ? 'añadido a Tus Me Gusta' : 'eliminado de Tus Me Gusta'}',
                                );
                              },
                            ),
                            // Botón de reproducción modificado según la imagen
                            Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                onPressed: () {
                                  // Navegar a la pantalla del reproductor con la pista seleccionada
                                  context.push(
                                    '/musicoterapia/playlist/reproductor',
                                    extra: {
                                      'playlistId': widget.playlistId,
                                      'playlistTitle': widget.title,
                                      'playlistCreator': widget.creator,
                                      'coverUrl': widget.coverUrl,
                                      'isAsset': widget.isAsset,
                                      'trackIndex': index,
                                      'tracks': songList,
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navegar a la pantalla del reproductor con la pista seleccionada
                          context.push(
                            '/musicoterapia/playlist/reproductor',
                            extra: {
                              'playlistId': widget.playlistId,
                              'playlistTitle': widget.title,
                              'playlistCreator': widget.creator,
                              'coverUrl': widget.coverUrl,
                              'isAsset': widget.isAsset,
                              'trackIndex': index,
                              'tracks': songList,
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Espacio al final
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
