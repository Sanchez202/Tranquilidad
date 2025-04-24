import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({Key? key}) : super(key: key);

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  List<Fruta> frutasAleatorias = [];

  @override
  void initState() {
    super.initState();
    cargarFrutasAleatorias();
  }

  void cargarFrutasAleatorias() {
    frutasDisponibles.shuffle();
    frutasAleatorias = frutasDisponibles.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 1,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/modulos');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/usuario');
          }
        },
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ALIMENTACION/Fondo_Test.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 5),
                const Text(
                  'SEGUIMIENTO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 18, 167), // Puedes cambiar a cualquier color que quieras
                  ),
                ),

                const SizedBox(height: 20),
                resumenNutricional(),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      for (var fruta in frutasAleatorias)
                        seguimientoItem(
                          context,
                          image: fruta.image,
                          title: fruta.title,
                          kcal: fruta.kcal,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: 10, // Ajusta el ancho del botón aquí
                          height: 36, // Ajusta la altura si lo deseas
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple, // Cambia el color del botón aquí
                              foregroundColor: Colors.white, // Color del texto
                              textStyle: const TextStyle(fontSize: 14), // Tamaño de texto más pequeño si quieres
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Bordes redondeados opcionales
                              ),
                            ),
                            onPressed: () {
                              context.go('/alimentacion/informacion_frutas');
                            },
                            child: const Text('Ver más'),
                          ),
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

  Widget resumenNutricional() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  ),
                  const Text(
                    '000 / 000 Peso',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                barraNutriente('Proteínas', 0.4, const Color.fromARGB(255, 252, 48, 201), '80g'),
                barraNutriente('Grasas', 0.3, Colors.redAccent, '65g'),
                barraNutriente('Carbohidratos', 0.6, const Color.fromARGB(255, 68, 158, 231), '300g'),
              ],
            ),
          ),
      ],
    );
  }

        Widget barraNutriente(String titulo, double porcentaje, Color color, String cantidad) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    LinearProgressIndicator(
                      value: porcentaje,
                      color: color.withOpacity(0.8),
                      backgroundColor: Colors.grey[300],
                      minHeight: 20,
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            cantidad,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 26, 25, 25),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }


      Widget seguimientoItem(
        BuildContext context, {
        required String image,
        required String title,
        required int kcal,
        String? extra,
      }) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detalle');
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 3,
            color: Colors.white.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Image.asset(image, width: 50),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          extra ?? 'Recomendado $kcal kcal',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
}

class Fruta {
  final String image;
  final String title;
  final int kcal;

  Fruta({required this.image, required this.title, required this.kcal});
}

final List<Fruta> frutasDisponibles = [
  Fruta(image: 'assets/ALIMENTACION/banano.png', title: 'Banano', kcal: 432),
  Fruta(image: 'assets/ALIMENTACION/manzana.png', title: 'Manzana', kcal: 518),
  Fruta(image: 'assets/ALIMENTACION/sandia.png', title: 'Sandía', kcal: 350),
  Fruta(image: 'assets/ALIMENTACION/pera.png', title: 'Pera', kcal: 210),
  Fruta(image: 'assets/ALIMENTACION/uvas.png', title: 'Uvas', kcal: 290),
  Fruta(image: 'assets/ALIMENTACION/papaya.png', title: 'Papaya', kcal: 310),
  Fruta(image: 'assets/ALIMENTACION/uvas.png', title: 'Ciruela', kcal: 46),
  Fruta(image: 'assets/ALIMENTACION/Coco.png', title: 'Coco', kcal: 354),
  Fruta(image: 'assets/ALIMENTACION/Frutos_rojos.png', title: 'Frutos Rojos', kcal: 55),
  Fruta(image: 'assets/ALIMENTACION/Granada.png', title: 'Granada', kcal: 83),
  Fruta(image: 'assets/ALIMENTACION/Grosella.png', title: 'Grosella', kcal: 56),
  Fruta(image: 'assets/ALIMENTACION/Higo.png', title: 'Higo', kcal: 74),
  Fruta(image: 'assets/ALIMENTACION/kiwi.png', title: 'Kiwi', kcal: 41),
  Fruta(image: 'assets/ALIMENTACION/Mandarina.png', title: 'Mandarina', kcal: 53),
  Fruta(image: 'assets/ALIMENTACION/mango.png', title: 'Mango', kcal: 60),
  Fruta(image: 'assets/ALIMENTACION/maracuya.png', title: 'Maracuya', kcal: 97),
  Fruta(image: 'assets/ALIMENTACION/mora.png', title: 'Mora', kcal: 43),
  Fruta(image: 'assets/ALIMENTACION/naranja.png', title: 'Naranja', kcal: 47),
  Fruta(image: 'assets/ALIMENTACION/papaya.png', title: 'Papaya', kcal: 43),
  Fruta(image: 'assets/ALIMENTACION/piña.png', title: 'Piña', kcal: 50),
];
