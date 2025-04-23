import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class AlbumElegidoScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isAsset;
  final int albumId;

  const AlbumElegidoScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isAsset,
    required this.albumId,
  });

  @override
  State<AlbumElegidoScreen> createState() => _AlbumElegidoScreenState();
}

class _AlbumElegidoScreenState extends State<AlbumElegidoScreen> {
  bool isFavorite = false;
  late List<Map<String, String>> songList;
  late List<bool> trackFavorites;

  @override
  void initState() {
    super.initState();
    songList = _getSongsForAlbum(widget.albumId);
    trackFavorites = List.generate(songList.length, (index) => false);
  }

  List<Map<String, String>> _getSongsForAlbum(int albumId) {
    switch (albumId) {
      case 1:
        return [
          {'title': 'Weightless', 'duration': '3:30'},
          {'title': 'Pure Tranquility', 'duration': '4:45'},
          {'title': 'Mindful Journey', 'duration': '5:12'},
          {'title': 'Peaceful Harmony', 'duration': '3:55'},
          {'title': 'Inner Balance', 'duration': '4:20'},
          {'title': 'Serenity Now', 'duration': '3:15'},
          {'title': 'Gentle Stream', 'duration': '6:04'},
          {'title': 'Deep Relaxation', 'duration': '4:48'},
        ];
      case 2:
        return [
          {'title': 'Ocean Waves', 'duration': '5:30'},
          {'title': 'Coastal Breeze', 'duration': '4:15'},
          {'title': 'Sunset Meditation', 'duration': '6:22'},
          {'title': 'Beach Harmony', 'duration': '3:48'},
          {'title': 'Seaside Dreams', 'duration': '5:10'},
          {'title': 'Tidal Calm', 'duration': '4:35'},
          {'title': 'Oceanic Flow', 'duration': '5:25'},
          {'title': 'Drifting Tides', 'duration': '4:59'},
        ];
      case 3:
        return [
          {'title': 'Forest Whispers', 'duration': '4:42'},
          {'title': 'Mountain Echo', 'duration': '5:18'},
          {'title': 'Woodland Retreat', 'duration': '3:56'},
          {'title': 'Natural Serenity', 'duration': '6:10'},
          {'title': 'Wilderness Peace', 'duration': '4:30'},
          {'title': 'Gentle Rain', 'duration': '5:05'},
          {'title': 'Wind in Trees', 'duration': '4:22'},
          {'title': 'Dawn Chorus', 'duration': '3:48'},
        ];
      case 4:
        return [
          {'title': 'Starlight Sonata', 'duration': '4:15'},
          {'title': 'Moonbeam Melody', 'duration': '5:22'},
          {'title': 'Celestial Dreams', 'duration': '3:50'},
          {'title': 'Night Harmony', 'duration': '4:38'},
          {'title': 'Cosmic Lullaby', 'duration': '6:12'},
          {'title': 'Astral Journey', 'duration': '5:30'},
          {'title': 'Tranquil Universe', 'duration': '4:45'},
          {'title': 'Stellar Peace', 'duration': '3:58'},
        ];
      case 5:
        return [
          {'title': 'Zen Garden', 'duration': '5:15'},
          {'title': 'Inner Temple', 'duration': '4:30'},
          {'title': 'Mindful Moment', 'duration': '3:48'},
          {'title': 'Spiritual Flow', 'duration': '6:25'},
          {'title': 'Ancient Wisdom', 'duration': '4:52'},
          {'title': 'Meditative Path', 'duration': '5:10'},
          {'title': 'Sacred Space', 'duration': '4:18'},
          {'title': 'Eternal Peace', 'duration': '5:35'},
        ];
      default:
        return [
          {'title': 'Páginas de Calma', 'duration': '6:15'},
          {'title': 'Melodía Literaria', 'duration': '7:22'},
          {'title': 'Concentración Lectora', 'duration': '8:50'},
          {'title': 'Serene Moment', 'duration': '4:10'},
          {'title': 'Tranquil Mind', 'duration': '3:40'},
          {'title': 'Quiet Reflection', 'duration': '5:30'},
          {'title': 'Soothing Sounds', 'duration': '4:45'},
          {'title': 'Relaxation Time', 'duration': '3:55'},
        ];
    }
  }

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

  void _navigateToPlayer(int trackIndex) {
    context.push(
      '/reproducor_album',
      extra: {
        'albumId': widget.albumId,
        'albumTitle': widget.title,
        'albumArtist': widget.subtitle,
        'coverUrl': widget.imageUrl,
        'isAsset': widget.isAsset,
        'trackIndex': trackIndex,
        'tracks': songList,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
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
          Container(
            color: Color.fromARGB(255, 209, 187, 224).withAlpha(179), // 0.7 * 255 ≈ 179
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => context.go('/album_principal'),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'album-${widget.albumId}',
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(77), // 0.3 * 255 ≈ 77
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: widget.isAsset
                                ? Image.asset(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    widget.imageUrl,
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
                                    "${songList.length} canciones • 90:45",
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
                            onPressed: () => _navigateToPlayer(0),
                            child: const Text('REPRODUCIR'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(77), // 0.3 * 255 ≈ 77
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                              color: isFavorite
                                ? const Color(0xFF9575CD)
                                : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              _showNotification(isFavorite 
                                ? 'Añadido a Tus Me Gusta' 
                                : 'Eliminado de Tus Me Gusta');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(77), // 0.3 * 255 ≈ 77
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.share, color: Colors.black),
                            onPressed: () {
                              // Implementar funcionalidad de compartir
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Canciones',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 16.0,
                        ),
                        child: InkWell(
                          onTap: () => _navigateToPlayer(index),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: widget.isAsset
                                    ? DecorationImage(
                                        image: AssetImage(widget.imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: NetworkImage(widget.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      songList[index]['title']!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      widget.subtitle,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                songList[index]['duration']!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  trackFavorites[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                  color: trackFavorites[index]
                                    ? const Color(0xFF9575CD)
                                    : Colors.black,
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    trackFavorites[index] = !trackFavorites[index];
                                  });
                                  _showNotification(
                                    '"${songList[index]['title']}" ${trackFavorites[index] 
                                      ? 'añadido a Tus Me Gusta' 
                                      : 'eliminado de Tus Me Gusta'}'
                                  );
                                },
                              ),
                              IconButton(
                                icon: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    size: 14,
                                  ),
                                ),
                                onPressed: () => _navigateToPlayer(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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