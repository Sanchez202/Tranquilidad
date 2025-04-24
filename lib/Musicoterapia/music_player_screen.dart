import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:convert';

class MusicPlayerScreen extends StatefulWidget {
  final int initialTrackIndex;

  const MusicPlayerScreen({
    super.key,
    this.initialTrackIndex = 0,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://back1-production-67bf.up.railway.app',
    connectTimeout: const Duration(seconds: 15),  
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
   
    validateStatus: (status) => true,
  ));
  bool isLoading = true;
  String error = '';
  List<Map<String, dynamic>> tracks = [];
  
  late int currentTrackIndex = 0;
  bool isPlaying = false;
  bool isLooping = false;
  bool isShuffle = false;
  bool isFavorite = false;
  
  final Map<int, bool> _favoriteTracks = {};
  
  double _progress = 0.0;
  Timer? _timer;
  String currentTime = '0:00';
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  
  final Color purpleColor = const Color(0xFF8E44AD);
  
  @override
  void initState() {
    super.initState();
    currentTrackIndex = widget.initialTrackIndex;
    
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      
        if (state.processingState == ProcessingState.completed) {
          _onTrackComplete();
        }
      }
    });
    
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
          if (_duration.inMilliseconds > 0) {
            _progress = _position.inMilliseconds / _duration.inMilliseconds;
          }
          _updateCurrentTime();
        });
      }
    });
    
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null && mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });
    
    _loadDataWithTimeout();
  }
  
  void _loadDataWithTimeout() {
    Timer(const Duration(seconds: 8), () { 
      if (isLoading && mounted) {
        _loadFallbackTracks();
      }
    });
    
    fetchAudios();
  }
  
  void _loadFallbackTracks() {
    final List<Map<String, dynamic>> fallbackTracks = [
      {
        'id': 1,
        'title': 'Sonido Relajante',
        'artist': 'Música Clásica',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        'coverUrl': 'assets/MUSICOTERAPIA/img_1.jpg',
        'duration': '2:42 min',
        'isAsset': false,
      },
      {
        'id': 2,
        'title': 'Meditación Guiada',
        'artist': 'Relajación',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        'coverUrl': 'assets/MUSICOTERAPIA/img_1.jpg',
        'duration': '3:15 min',
        'isAsset': false,
      },
      {
        'id': 3,
        'title': 'Frecuencia para Dormir',
        'artist': 'Binaural',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        'coverUrl': 'assets/MUSICOTERAPIA/img_1.jpg',
        'duration': '4:30 min',
        'isAsset': false,
      }
    ];
    
    setState(() {
      tracks = List.from(fallbackTracks);
      isLoading = false;
      error = '';
    });
    _loadTrack(0);
  }
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }
  
  Future<void> fetchAudios() async {
    if (!mounted) return;
    
    try {

      try {
        final response = await _dio.get('/v1/audios');
        if (response.statusCode == 200) {
          final responseData = response.data is String 
              ? jsonDecode(response.data) 
              : response.data;
          
          return _processApiResponse(responseData);
        }
      } catch (dioError) {
        print('Error con Dio nativo: $dioError');
      }
      

      final staticData = {
        "status": "success",
        "data": [
          {
            "id": 1,
            "title": "sonido relajante",
            "description": "sonido para relajar tu mente y cuerpo ..",
            "image_file": null,
            "image_public_id": "https://res.cloudinary.com/doiwtlias/image/upload/v1745376960/podcasts/images/mi-primer-podcast_1745376952.jpg",
            "audio_file": "https://res.cloudinary.com/doiwtlias/video/upload/v1745423675/musicoterapia/audios/uikvx8txlm27tyxvtq5k.mp3",
            "audio_public_id": "1",
            "duration": 622,
            "genre_id": 1,
            "album_id": 1,
            "es_binaural": true,
            "frecuencia": 234,
            "created_at": null,
            "updated_at": null,
            "genre": {
              "id": 1,
              "name": "Clásica",
              "description": "Música clásica de grandes compositores"
            },
            "album": {
              "id": 1,
              "title": "Dormir",
              "description": "Música relajante para conciliar el sueño y descansar profundamente"
            }
          }
        ],
        "message": "Audios obtenidos exitosamente"
      };
      
      return _processApiResponse(staticData);
            
    } catch (e) {
      print('Error general en fetchAudios: $e');
      
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }
  
  void _processApiResponse(dynamic responseData) {
    if (!mounted) return;
    
    try {
      if (responseData['status'] == 'success' && responseData['data'] is List) {
        final List<dynamic> audiosList = responseData['data'];
        
        if (audiosList.isNotEmpty) {
          List<Map<String, dynamic>> processedTracks = [];
          
          for (var audio in audiosList) {
            try {
              String audioUrl = audio['audio_file']?.toString() ?? '';
              
              if (audioUrl.isNotEmpty) {
                String imageUrl = audio['image_public_id']?.toString() ?? '';
                
                String artist = 'Artista desconocido';
                if (audio['genre'] != null && audio['genre'] is Map) {
                  artist = audio['genre']['name']?.toString() ?? 'Artista desconocido';
                }
                
                int durationSeconds = 0;
                if (audio['duration'] != null) {
                  durationSeconds = audio['duration'] is int 
                      ? audio['duration'] 
                      : int.tryParse(audio['duration'].toString()) ?? 0;
                }
                String formattedDuration = _formatDurationFromSeconds(durationSeconds);
                
                processedTracks.add({
                  'id': audio['id'] ?? 0,
                  'title': audio['title']?.toString() ?? 'Sin título',
                  'artist': artist,
                  'url': audioUrl,  
                  'coverUrl': imageUrl.isNotEmpty ? imageUrl : 'assets/MUSICOTERAPIA/img_1.jpg',
                  'duration': formattedDuration,
                  'isAsset': false,
                  'es_binaural': audio['es_binaural'] ?? false,
                  'frecuencia': audio['frecuencia'] ?? 0,
                  'album': audio['album']?['title'] ?? 'Álbum desconocido',
                });
              }
            } catch (e) {
              print('Error procesando audio individual: $e');
            }
          }
          
          if (processedTracks.isNotEmpty && mounted) {
            setState(() {
              tracks = processedTracks;
              isLoading = false;
              error = '';
            });
            
            _loadTrack(currentTrackIndex);
            return;
          }
        }
      }
      
      throw Exception('No se pudieron procesar correctamente los datos de audio');
      
    } catch (e) {
      print('Error procesando datos: $e');
      if (mounted) {
        setState(() {
          error = 'Error procesando datos: $e';
          isLoading = false;
        });
      }
    }
  }
  
  String _formatDurationFromSeconds(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} min';
  }
  
  Future<void> _loadTrack(int index) async {
    if (!mounted || tracks.isEmpty) return;
    
    if (index < 0 || index >= tracks.length) {
      index = 0; 
    }
    
    currentTrackIndex = index;
    _updateFavoriteState();
    
    try {
      await _audioPlayer.stop();
      
      final trackUrl = tracks[index]['url'];
      if (trackUrl == null || trackUrl.isEmpty) {
        throw Exception('URL de audio no válida');
      }
      
      print('Intentando reproducir: $trackUrl');
      
      await _audioPlayer.setUrl(trackUrl);
      _duration = await _audioPlayer.duration ?? Duration.zero;
      
      if (mounted) {
        setState(() {});
      }
      
      if (isPlaying) {
        _audioPlayer.play();
      }
    } catch (e) {
      print('Error al cargar el audio: $e');
      if (mounted) {
        _showNotification('Error al cargar el audio. Intentando siguiente pista...');
       
        Future.delayed(Duration(seconds: 1), () {
          _playNextTrack();
        });
      }
    }
  }
  
  void _updateCurrentTime() {
    int minutes = _position.inMinutes;
    int seconds = _position.inSeconds % 60;
    currentTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  
  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }
  
  void _onTrackComplete() {
    if (!mounted) return;
    
    setState(() {
      _progress = 0.0;
    });
    
    if (isLooping) {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.play();
    } else {
      _playNextTrack();
    }
  }
  
  void _togglePlayPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }
  
  void _playPreviousTrack() {
    if (tracks.isEmpty) return;
    
    int newIndex;
    if (isShuffle) {
      newIndex = (currentTrackIndex + (DateTime.now().millisecondsSinceEpoch % (tracks.length - 1)) + 1) % tracks.length;
    } else {
      if (currentTrackIndex > 0) {
        newIndex = currentTrackIndex - 1;
      } else {
        newIndex = tracks.length - 1; 
      }
    }
    
    _loadTrack(newIndex);
  }
  
  void _playNextTrack() {
    if (tracks.isEmpty) return;
    
    int newIndex;
    if (isShuffle) {
      newIndex = (currentTrackIndex + (DateTime.now().millisecondsSinceEpoch % (tracks.length - 1)) + 1) % tracks.length;
    } else {
      if (currentTrackIndex < tracks.length - 1) {
        newIndex = currentTrackIndex + 1;
      } else {
        newIndex = 0; 
      }
    }
    
    _loadTrack(newIndex);
  }
  
  void _updateFavoriteState() {
    if (mounted && tracks.isNotEmpty) {
      setState(() {
        isFavorite = _favoriteTracks[tracks[currentTrackIndex]['id']] ?? false;
      });
    }
  }
  
  void _toggleLooping() {
    if (mounted) {
      setState(() {
        isLooping = !isLooping;
        _audioPlayer.setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
      });
    }
  }
  
  void _toggleShuffle() {
    if (mounted) {
      setState(() {
        isShuffle = !isShuffle;
        _showNotification(isShuffle ? 'Reproducción aleatoria activada' : 'Reproducción aleatoria desactivada');
      });
    }
  }
  
  void _showNotification(String message) {
    if (!mounted) return;
    
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
  
  void _toggleFavorite() {
    if (tracks.isEmpty || !mounted) return;
    
    setState(() {
      isFavorite = !isFavorite;
      _favoriteTracks[tracks[currentTrackIndex]['id']] = isFavorite;
      
      if (isFavorite) {
        _showNotification('${tracks[currentTrackIndex]['title']} añadido a favoritos');
      } else {
        _showNotification('${tracks[currentTrackIndex]['title']} eliminado de favoritos');
      }
    });
  }
  
  void _seekToPosition(double value) {
    final newPosition = Duration(milliseconds: (value * _duration.inMilliseconds).round());
    _audioPlayer.seek(newPosition);
  }

  void _retryConnection() {
    if (!mounted) return;
    
    setState(() {
      error = '';
      isLoading = true;
    });
    fetchAudios();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    if (isLoading) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/MUSICOTERAPIA/fondo_musicoterapia.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF8E44AD),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cargando músicas...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _loadFallbackTracks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E44AD),
                  ),
                  child: const Text('Usar modo offline'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (error.isNotEmpty) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/MUSICOTERAPIA/fondo_musicoterapia.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error al cargar los audios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _retryConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E44AD),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _loadFallbackTracks,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E44AD),
                      ),
                      icon: const Icon(Icons.music_note),
                      label: const Text('Modo Offline'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Map<String, dynamic> currentTrack = tracks[currentTrackIndex];
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/MUSICOTERAPIA/fondo_musicoterapia.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100), 
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Text(
                                'REPRODUCIENDO AHORA',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                        
                        Container(
                          height: size.height * 0.35,
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                          child: Hero(
                            tag: 'player-cover',
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(10),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: currentTrack['isAsset'] == true
                                  ? Image.asset(
                                      currentTrack['coverUrl'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/MUSICOTERAPIA/img_1.jpg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.network(
                                      currentTrack['coverUrl'],
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF8E44AD),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/MUSICOTERAPIA/img_1.jpg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentTrack['title'] ?? 'Sin título',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          currentTrack['artist'] ?? 'Artista desconocido',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (currentTrack['es_binaural'] == true)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                              decoration: BoxDecoration(
                                                color: purpleColor.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                'Binaural ${currentTrack['frecuencia']}Hz',
                                                style: TextStyle(
                                                  color: purpleColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? purpleColor : Colors.black,
                                      size: 30,
                                    ),
                                    onPressed: _toggleFavorite,
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                  activeTrackColor: purpleColor,
                                  inactiveTrackColor: Colors.black.withAlpha(10),
                                  thumbColor: purpleColor,
                                  overlayColor: purpleColor.withAlpha(150),
                                ),
                                child: Slider(
                                  value: _progress.clamp(0.0, 1.0),
                                  onChanged: _seekToPosition,
                                ),
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      currentTime,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_duration),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 15),
                              
                              // Controls
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.shuffle,
                                      color: isShuffle ? Colors.black : Colors.black.withAlpha(100),
                                      size: 22,
                                    ),
                                    onPressed: _toggleShuffle,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      color: Colors.black,
                                      size: 35,
                                    ),
                                    onPressed: _playPreviousTrack,
                                  ),
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      onPressed: _togglePlayPause,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.skip_next,
                                      color: Colors.black,
                                      size: 35,
                                    ),
                                    onPressed: _playNextTrack,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      isLooping ? Icons.repeat_one : Icons.repeat,
                                      color: isLooping ? Colors.black : Colors.black.withAlpha(100),
                                      size: 22,
                                    ),
                                    onPressed: _toggleLooping,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              
                              if (currentTrack['album'] != null)
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.album,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Álbum: ${currentTrack['album']}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
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
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}