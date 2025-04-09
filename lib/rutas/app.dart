import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../iniciosesion/home.dart';
import '../mapasueños/iniciomapa.dart';
import '../mapasueños/iniciomapados.dart'; // Asegúrate que esta clase existe
import '../mapasueños/iniciolibros.dart';
import '../rutinasEjercicios/inicioRutina.dart';

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
        //rutinaa
        GoRoute(
          path: 'inicioRutina',
          builder: (BuildContext context, GoRouterState state) {
            return InicioRutinaScreen(); // Vista a la que quieres ir
          },
        ),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
