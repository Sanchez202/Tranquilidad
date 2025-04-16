import 'package:flutter/material.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'dart:async';
import 'package:tranquilidad_app/Musicoterapia/sonidos_binaurales/sonidos_binaurales_screen.dart';
import 'package:go_router/go_router.dart';

class ReproductorBinaural extends StatefulWidget {
  final int audioId;
  final String audioTitle;
  final String audioCreator;
  final String coverUrl;
  final bool isAsset;
  final int trackIndex;
  final List<Map<String, dynamic>> tracks;

  const ReproductorBinaural({
    Key? key,
    required this.audioId,
    required this.audioTitle,
    required this.audioCreator,
    required this.coverUrl,
    required this.isAsset,
    required this.trackIndex,
    required this.tracks,
  }) : super(key: key);

  @override
  State<ReproductorBinaural> createState() => _ReproductorBinauralState();
}

class _ReproductorBinauralState extends State<ReproductorBinaural> {
  late int currentTrackIndex;
  bool isPlaying = true;
  bool isLooping = false;
  bool isShuffle = false;
  bool isFavorite = false; // Estado para botón de corazón

  // Para almacenar el estado de favoritos de cada pista
  final Map<int, bool> _favoriteTracks = {};

  // Para simular la reproducción
  double _progress = 0.0;
  late Timer _timer;
  late String currentTime;

  // Color morado para el corazón y la barra de reproducción
  final Color purpleColor = const Color(0xFF8E44AD);

  @override
  void initState() {
    super.initState();
    currentTrackIndex = widget.trackIndex;

    // Simulación de reproducción
    _startTimer();
    _updateCurrentTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
          _updateCurrentTime();
        } else {
          _onTrackComplete();
        }
      });
    });
  }

  void _updateCurrentTime() {
    // Extraer solo los minutos y segundos de la duración
    String fullDuration =
        widget.tracks[currentTrackIndex]['duration'] as String;
    List<String> parts = fullDuration.split(':');
    int totalSeconds =
        (int.parse(parts[0]) * 60) + int.parse(parts[1].split(' ')[0]);

    int currentSeconds = (totalSeconds * _progress).floor();
    int minutes = currentSeconds ~/ 60;
    int seconds = currentSeconds % 60;

    currentTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _onTrackComplete() {
    _progress = 0.0;

    if (isLooping) {
      // Mantener la misma pista
      _startTimer();
    } else {
      // Pasar a la siguiente pista
      _playNextTrack();
    }
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;

      if (isPlaying) {
        _startTimer();
      } else {
        _timer.cancel();
      }
    });
  }

  void _playPreviousTrack() {
    setState(() {
      _progress = 0.0;
      _timer.cancel();

      if (currentTrackIndex > 0) {
        currentTrackIndex--;
      } else {
        currentTrackIndex = widget.tracks.length - 1;
      }

      // Actualizar el estado de favorito basado en la nueva pista
      _updateFavoriteState();

      if (isPlaying) {
        _startTimer();
      }
    });
  }

  void _playNextTrack() {
    setState(() {
      _progress = 0.0;
      _timer.cancel();

      if (currentTrackIndex < widget.tracks.length - 1) {
        currentTrackIndex++;
      } else {
        currentTrackIndex = 0;
      }

      // Actualizar el estado de favorito basado en la nueva pista
      _updateFavoriteState();

      if (isPlaying) {
        _startTimer();
      }
    });
  }

  // Método para actualizar el estado del botón de favorito según la pista actual
  void _updateFavoriteState() {
    // Verificar si esta pista ya está marcada como favorita
    isFavorite = _favoriteTracks[currentTrackIndex] ?? false;
  }

  void _toggleLooping() {
    setState(() {
      isLooping = !isLooping;
    });
  }

  void _toggleShuffle() {
    setState(() {
      isShuffle = !isShuffle;
    });
  }

  // Método para mostrar notificaciones
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

  // Función para alternar favorito
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;

      // Guardar el estado de favorito para esta pista específica
      _favoriteTracks[currentTrackIndex] = isFavorite;

      // Mostrar notificación según el estado actual
      if (isFavorite) {
        _showNotification(
          '${widget.tracks[currentTrackIndex]['title']} añadido a favoritos',
        );
      } else {
        _showNotification(
          '${widget.tracks[currentTrackIndex]['title']} eliminado de favoritos',
        );
      }
    });
  }

  // Método corregido para la navegación usando GoRouter
  void _navigateToSonidosBinaurales() {
    // Detener el timer para liberar recursos
    _timer.cancel();

    // Usar go_router para navegar a la pantalla de sonidos binaurales
    context.go('/musicoterapia/sonidos_binaurales');
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentTrack = widget.tracks[currentTrackIndex];
    final size = MediaQuery.of(context).size;

    // Reemplazamos WillPopScope (deprecado) con PopScope (actual)
    return PopScope(
      canPop: false, // Impide que el sistema cierre la pantalla
      onPopInvoked: (didPop) {
        // Si didPop es falso, significa que la navegación fue bloqueada
        if (!didPop) {
          _navigateToSonidosBinaurales();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar:
            const CustomAppBar(), // Mantenemos la AppBar normal sin parámetros adicionales
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            // Usando únicamente la imagen de fondo sin gradiente morado
            image: DecorationImage(
              image: AssetImage('assets/MUSICOTERAPIA/fondo_musicoterapia.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            // Overlay ligero para mejorar legibilidad
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
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
                          // Back button and title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                  ),
                                  onPressed: _navigateToSonidosBinaurales,
                                ),
                                Text(
                                  'SONIDO BINAURAL',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Espacio para mantener centrado el título
                                const SizedBox(width: 48),
                              ],
                            ),
                          ),

                          // Album cover
                          Container(
                            height: size.height * 0.35,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 15.0,
                            ),
                            child: Hero(
                              tag: 'player-cover',
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child:
                                      widget.isAsset
                                          ? Image.asset(
                                            widget.tracks[currentTrackIndex]['coverUrl'] ??
                                                widget.coverUrl,
                                            fit: BoxFit.cover,
                                          )
                                          : Image.network(
                                            widget.tracks[currentTrackIndex]['coverUrl'] ??
                                                widget.coverUrl,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                            ),
                          ),

                          // Track info with heart button
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Track title, artist and favorite button
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title and artist column
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentTrack['title'],
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
                                            widget.tracks[currentTrackIndex]['author'] ??
                                                widget.audioCreator,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Favorite button - Ahora morado en lugar de rosado
                                    IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isFavorite
                                                ? purpleColor
                                                : Colors.black,
                                        size: 30,
                                      ),
                                      onPressed: _toggleFavorite,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Progress bar - Ahora morada en lugar de blanca
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 4,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                    ),
                                    overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 10,
                                    ),
                                    activeTrackColor: purpleColor,
                                    inactiveTrackColor: Colors.black
                                        .withOpacity(0.3),
                                    thumbColor: purpleColor,
                                    overlayColor: purpleColor.withOpacity(0.3),
                                  ),
                                  child: Slider(
                                    value: _progress,
                                    onChanged: (value) {
                                      setState(() {
                                        _progress = value;
                                        _updateCurrentTime();
                                      });
                                    },
                                  ),
                                ),

                                // Time indicators - Ahora en negro
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentTime,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        currentTrack['duration'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Controls - Ahora todos en negro
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        isShuffle
                                            ? Icons.shuffle
                                            : Icons.shuffle,
                                        color:
                                            isShuffle
                                                ? Colors.black
                                                : Colors.black.withOpacity(0.6),
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
                                    // Botón de pausa/reproducción - Invertido (negro con icono blanco)
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
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
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
                                        isLooping
                                            ? Icons.repeat_one
                                            : Icons.repeat,
                                        color:
                                            isLooping
                                                ? Colors.black
                                                : Colors.black.withOpacity(0.6),
                                        size: 22,
                                      ),
                                      onPressed: _toggleLooping,
                                    ),
                                  ],
                                ),
                                // Espacio al final para evitar cortes
                                const SizedBox(height: 10),
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
          ),
        ),
      ),
    );
  }
}
