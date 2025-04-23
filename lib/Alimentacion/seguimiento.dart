import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';
import 'package:tranquilidad_app/Alimentacion/informacion_frutas.dart';

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
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Alimentacion/uva.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Text(
                'Seguimiento',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/alimentacion/informacion_frutas');                        },
                        child: const Text('Ver más'),
                      ),
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
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  ),
                  const Text(
                    '1514 / 2000 kcal',
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
              barraNutriente('Proteínas', 0.4, const Color.fromARGB(255, 252, 48, 201)),
              barraNutriente('Grasas', 0.3, Colors.redAccent),
              barraNutriente('Carbohidratos', 0.6, const Color.fromARGB(255, 68, 158, 231)),
            ],
          ),
        ),
      ],
    );
  }

  Widget barraNutriente(String titulo, double porcentaje, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: porcentaje,
            color: color,
            backgroundColor: Colors.grey[300],
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget seguimientoItem(BuildContext context,
      {required String image,
      required String title,
      required int kcal,
      String? extra,
      IconData icon = Icons.add}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detalle');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 3,
        child: ListTile(
          leading: Image.asset(image, width: 50),
          title: Text(title),
          subtitle: Text(extra ?? 'Recomendado $kcal kcal'),
          trailing: Icon(icon, color: Colors.deepPurple),
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
  Fruta(image: 'assets/Alimentacion/banano.png', title: 'Banano', kcal: 432),
  Fruta(image: 'assets/Alimentacion/manzana.png', title: 'Manzana', kcal: 518),
  Fruta(image: 'assets/Alimentacion/sandia.png', title: 'Sandía', kcal: 350),
  Fruta(image: 'assets/Alimentacion/pera.png', title: 'Pera', kcal: 210),
  Fruta(image: 'assets/Alimentacion/uvas.png', title: 'Uvas', kcal: 290),
  Fruta(image: 'assets/Alimentacion/papaya.png', title: 'Papaya', kcal: 310),
  Fruta(image: 'assets/Alimentacion/Ciruela.png', title: 'Ciruela', kcal: 310),
  Fruta(image: 'assets/Alimentacion/Coco.png', title: 'Coco', kcal: 310),
  Fruta(image: 'assets/Alimentacion/Frutos_rojos.png', title: 'Frutos Rojos', kcal: 310),
  Fruta(image: 'assets/Alimentacion/Granada.png', title: 'Granada', kcal: 310),
  Fruta(image: 'assets/Alimentacion/Grosella.png', title: 'Grosella', kcal: 310),
  Fruta(image: 'assets/Alimentacion/Higo.png', title: 'Higo', kcal: 310),
  Fruta(image: 'assets/Alimentacion/kiwi.png', title: 'Kiwi', kcal: 310),
  Fruta(image: 'assets/Alimentacion/Mandarina.png', title: 'Mandarina', kcal: 310),
  Fruta(image: 'assets/Alimentacion/mango.png', title: 'Mango', kcal: 310),
  Fruta(image: 'assets/Alimentacion/maracuya.png', title: 'Maracuya', kcal: 310),
  Fruta(image: 'assets/Alimentacion/mora.png', title: 'Mora', kcal: 310),
  Fruta(image: 'assets/Alimentacion/naranja.png', title: 'Naranja', kcal: 310),
  Fruta(image: 'assets/Alimentacion/papaya.png', title: 'Papaya', kcal: 310),
  Fruta(image: 'assets/Alimentacion/pina.png', title: 'Piña', kcal: 310),
];
