import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../iniciosesion/home.dart';
import '../mapasueños/iniciomapa.dart';
import '../mapasueños/iniciomapados.dart';
import '../mapasueños/canva.dart';
import '../mapasueños/seguimiento.dart';
import '../mapasueños/iniciolibros.dart';
import '../mapasueños/categoriaArte.dart';
import '../mapasueños/vistalibros.dart';
import '../rutinasEjercicios/inicioRutina.dart';
import '../atencionprofesional/home.dart';
import '../musicoterapia/inicio_musicoterapia.dart';
import '../musicoterapia/album_detail_screen.dart';
import '../musicoterapia/music_player_screen.dart';
import '../musicoterapia/Albuums/albuum_principal.dart';
import '../musicoterapia/Albuums/album_elegido.dart';
import '../musicoterapia/Albuums/reproducor_album.dart';
import '../musicoterapia/podcast/podcast_screen.dart';
import '../musicoterapia/podcast/podcast_listados.dart';
import '../musicoterapia/podcast/grabar_podcast.dart';
import '../musicoterapia/podcast/biblioteca_podcast.dart';
import '../musicoterapia/podcast/video_podcast.dart';
import '../musicoterapia/podcast/reproductor_podcast.dart';
import '../musicoterapia/sonidos_binaurales/sonidos_binaurales_screen.dart';
import '../musicoterapia/sonidos_binaurales/reproductor_binaural.dart';
import '../musicoterapia/playlist/playlist_screen.dart';
import '../Musicoterapia/playlist/canciones_playlist.dart';
import '../Musicoterapia/playlist/reproductor_playlist.dart';
import '../musicoterapia/me_gusta/me_gusta_screen.dart';
import '../musicoterapia/me_gusta/reproductor_me_gusta.dart';
import '../alimentacion/test_bienestar.dart';
import '../alimentacion/inicio_alimentacion.dart';
import '../alimentacion/informacion_frutas.dart';
import '../alimentacion/seguimiento.dart';
import 'package:tranquilidad_app/alimentacion/foro.dart';
import '../iniciosesion/perfil.dart';
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen(); // Pantalla inicial
      },
      routes: [
        GoRoute(
          path: 'inicio',
          builder: (BuildContext context, GoRouterState state) {
            return mapa();
          },
        ),
        GoRoute(
  path: '/perfil',
  builder: (BuildContext context, GoRouterState state) {
    return ProfilePage();
  },
),

        ////MAPA DE SUEÑOS ////
        GoRoute(
          path: 'iniciomapados',
          builder: (BuildContext context, GoRouterState state) {
            return IniciomapaDos(); // Vista a la que quieres ir
          },
        ),
        GoRoute(
          path: 'iniciolibros',
          builder: (BuildContext context, GoRouterState state) {
            return iniciolibros(); // Vista a la que quieres ir
          },
        ),
         GoRoute(
          path: 'canva',
          builder: (BuildContext context, GoRouterState state) {
            return CanvasEditor(); // Vista a la que quieres ir
          },
        ),
         GoRoute(
          path: 'seguimiento',
          builder: (BuildContext context, GoRouterState state) {
            return TaskBoard(); // Vista a la que quieres ir
          },
        ),
        
        //rutinaa
        GoRoute(
          path: 'inicioRutina',
          builder: (BuildContext context, GoRouterState state) {
            return InicioRutinaScreen(); // Vista a la que quieres ir
          },
        ),
         GoRoute(
          path: 'categoriaArte',
          builder: (BuildContext context, GoRouterState state) {
            return categoria(); // Vista a la que quieres ir
          },
        ),
       
         GoRoute(
  path: 'detalles-libro/:bookId',
  builder: (BuildContext context, GoRouterState state) {
    // Obtener el ID del libro de los parámetros de la ruta
    final bookId = int.parse(state.pathParameters['bookId'] ?? '0');
    return DetallesLibroScreen(bookId: bookId);
  },
),
         
       
        ////Atencion Profesional ////
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return HomenScreen(); // Vista a la que quieres ir
          },
        ),
        /////MUSICOTERAPIA////
        GoRoute(
          path: 'inicio_musicoterapia',
          builder: (BuildContext context, GoRouterState state) {
            return const InicioMusicoterapia();
          },
        ),
        GoRoute(
          path: 'album_detail/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = int.parse(state.pathParameters['id']!);
            final extra = state.extra as Map<String, dynamic>;

            return AlbumDetailScreen(
              albumId: id,
              title: extra['title'] as String,
              subtitle: extra['subtitle'] as String,
              imageUrl: extra['imageUrl'] as String,
              isAsset: extra['isAsset'] as bool,
            );
          },
        ),

        GoRoute(
          path: 'album_elegido/:albumId',
          builder: (BuildContext context, GoRouterState state) {
            final albumId = int.parse(state.pathParameters['albumId'] ?? '0');
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>? ?? {};

            return AlbumElegidoScreen(
              albumId: albumId,
              title: extra['title'] ?? 'Álbum',
              subtitle: extra['subtitle'] ?? '',
              imageUrl: extra['imageUrl'] ?? '',
              isAsset: extra['isAsset'] ?? false,
            );
          },
        ),

        GoRoute(
          path: 'player',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;

            return MusicPlayerScreen(
              albumId: extra['albumId'] as int,
              albumTitle: extra['albumTitle'] as String,
              albumArtist: extra['albumArtist'] as String,
              coverUrl: extra['coverUrl'] as String,
              isAsset: extra['isAsset'] as bool,
              trackIndex: extra['trackIndex'] as int,
              tracks: (extra['tracks'] as List).cast<Map<String, dynamic>>(),
            );
          },
        ),

        GoRoute(
          path: 'reproducor_album',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;

            return ReproductorAlbumScreen(playbackData: extra);
          },
        ),

        GoRoute(
          path: 'musicoterapia',
          builder: (BuildContext context, GoRouterState state) {
            return const InicioMusicoterapia();
          },
        ),

        GoRoute(
          path: 'musicoterapia/albums',
          builder: (BuildContext context, GoRouterState state) {
            return const AlbumPrincipal();
          },
        ),
        GoRoute(
          path: 'album_principal',
          builder: (BuildContext context, GoRouterState state) {
            return const AlbumPrincipal();
          },
        ),

        GoRoute(
          path: 'musicoterapia/podcast',
          builder: (BuildContext context, GoRouterState state) {
            return const PodcastScreen(); // Pantalla para podcast
          },
        ),
        GoRoute(
          path: 'musicoterapia/sonidos_binaurales',
          builder: (BuildContext context, GoRouterState state) {
            return const SonidosBinauralesScreen();
          },
        ),
        GoRoute(
          path: 'musicoterapia/playlist',
          builder: (BuildContext context, GoRouterState state) {
            return const PlaylistScreen();
          },
        ),
        GoRoute(
          path: 'musicoterapia/me_gusta',
          builder: (BuildContext context, GoRouterState state) {
            return const MeGustaScreen();
          },
        ),
        GoRoute(
          path: 'reproductor_me_gusta',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;
            return ReproductorMeGustaScreen(
              trackIndex: extra['trackIndex'] as int,
              tracks: (extra['tracks'] as List).cast<Map<String, dynamic>>(),
            );
          },
        ),
        GoRoute(
          path: 'musicoterapia/playlist/canciones',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;

            return CancionesPlaylistScreen(
              title: extra['title'] as String,
              subtitle: extra['subtitle'] as String,
              coverUrl: extra['coverUrl'] as String,
              isAsset: extra['isAsset'] as bool,
              playlistId: extra['playlistId'] as int,
              trackCount: extra['trackCount'] as int,
              duration: extra['duration'] as String,
              creator: extra['creator'] as String,
              isUserCreated: extra['isUserCreated'] as bool? ?? false,
            );
          },
        ),
        GoRoute(
          path: 'musicoterapia/playlist/reproductor',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>;

            return ReproductorPlaylistScreen(
              playlistId: extra['playlistId'] as int,
              playlistTitle: extra['playlistTitle'] as String,
              playlistCreator: extra['playlistCreator'] as String,
              coverUrl: extra['coverUrl'] as String,
              isAsset: extra['isAsset'] as bool,
              trackIndex: extra['trackIndex'] as int,
              tracks: (extra['tracks'] as List).cast<Map<String, dynamic>>(),
            );
          },
        ),
GoRoute(
  path: '/reproductor_binaural',
  builder: (context, state) {
    final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
    
    // Usar la lista de tracks completa que viene en los extras
    final List<Map<String, dynamic>> tracks = extras['tracks'] as List<Map<String, dynamic>>;
    final int trackIndex = extras['trackIndex'] as int;
    
    return ReproductorBinaural(
      audioId: extras['sonidoId'] as int,
      audioTitle: extras['title'] as String,
      audioCreator: extras['author'] as String,
      coverUrl: extras['coverUrl'] as String,
      isAsset: extras['isAsset'] as bool,
      trackIndex: trackIndex,
      tracks: tracks,
    );
  },
),
GoRoute(
  path: '/podcast_listados',
  builder: (context, state) {
    // Extraer los parámetros enviados
    final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
    
    return PodcastListadosScreen(
      title: params['title'] as String,
      subtitle: params['subtitle'] as String,
      imageUrl: params['imageUrl'] as String,
      isAsset: params['isAsset'] as bool,
      podcastId: params['podcastId'] as int,
    );
  },
),
GoRoute(
  path: '/musicoterapia/podcast/reproductor_podcast',
  builder: (context, state) {
    final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
    return PodcastPlayerScreen(
      podcastId: params['podcastId'] as int,
      podcastTitle: params['podcastTitle'] as String,
      podcastHost: params['podcastHost'] as String,
      coverUrl: params['coverUrl'] as String,
      isAsset: params['isAsset'] as bool,
      episodeIndex: params['episodeIndex'] as int,
      episodes: params['episodes'] as List<Map<String, dynamic>>,
    );
  },
),
        GoRoute(
          path: '/musicoterapia/podcast/grabar_podcast',
          builder: (context, state) {
            return const GrabarPodcast();
          },
        ),
        GoRoute(
  path: '/musicoterapia/podcast/video_podcast',
  builder: (context, state) => const VideoPodcast(),
),
        GoRoute(
          path: '/musicoterapia/podcast/biblioteca_podcast',
          builder: (context, state) {
            return const BibliotecaPodcast();
          },
        ),
        //MUSICOTERAPIA//
      //ALIMENTACION//
                GoRoute(
          path: 'test_bienestar',
          builder: (BuildContext context, GoRouterState state) {
            return const TestBienestar();
          },
        ),
            GoRoute(
        path: '/inicio_alimentacion',
        builder: (context, state) => const InicioAlimentacion(),
          ),
          GoRoute(
        path: '/alimentacion/informacion_frutas',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const InformacionFrutas(),

        ),
      ),
          GoRoute(
          path: '/alimentacion/seguimiento',
          builder: (context, state) => const SeguimientoScreen(),
        ),

          GoRoute(
        path: '/informacion_frutas',
        builder: (context, state) => const InformacionFrutas(),
      ),


      GoRoute(
        path: '/alimentacion/foro',
        builder: (context, state) => const ForumScreen(),
      ),
        
      GoRoute(
        path: '/alimentacion/seguimiento',  // Nueva ruta añadida
        builder: (context, state) => const InformacionFrutas(),  // Nueva pantalla que se abrirá
      ),
        //ALIMENTACION//

      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
