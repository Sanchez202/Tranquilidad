import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tranquilidad_app/widgets/custom_app_bar.dart';
import 'package:tranquilidad_app/widgets/custom_nav_bar.dart';

class InformacionFrutas extends StatefulWidget {
  const InformacionFrutas({super.key});

  @override
  State<InformacionFrutas> createState() => _InformacionFrutasState();

  
}

class _InformacionFrutasState extends State<InformacionFrutas> {
  int _selectedIndex = 1;

  // Lista de frutas con su información en el orden especificado
  final List<FruitInfo> _fruitList = [
    FruitInfo(
      name: 'Manzana',
      description:
          'Las manzanas son conocidas por ser una buena fuente de fibra, especialmente pectina, que puede ayudar a mantener niveles saludables de colesterol. También contienen antioxidantes como quercetina, que puede tener propiedades antiinflamatorias.',
      classification: 'Fruta pomácea, cultivada en todo el mundo y disponible en una variedad de colores y sabores.',
      averageWeight: '150-250 gramos',
      color: 'Varía entre rojo, verde y amarillo',
      commonUses: 'Consumo crudo, cocido, en jugos y compotas',
      imageUrl: 'assets/ALIMENTACION/manzana_verde.png',
    ),
    FruitInfo(
      name: 'Banano',
      description:
          'Los bananos son una excelente fuente de potasio, un mineral crucial para la función muscular y nerviosa. También contienen vitamina B6, que es importante para la salud del cerebro y la producción de hemoglobina.',
      classification: 'Fruta tropical que crece en climas cálidos y se consume ampliamente en todo el mundo.',
      averageWeight: '120-150 gramos',
      color: 'Amarillo cuando maduro',
      commonUses: 'Consumo crudo, en batidos, postres y horneados',
      imageUrl: 'assets/Alimentacion/banano.png',
    ),
    FruitInfo(
      name: 'Mango',
      description:
          'El mango es rico en vitaminas A y C, potasio y fibra. Contiene antioxidantes como la quercetina, el ácido fólico y el beta-caroteno, que contribuyen a una buena salud.',
      classification: 'Fruta tropical de hueso originaria del sur de Asia.',
      averageWeight: '200-300 gramos',
      color: 'Verde, amarillo, naranja o rojo según madurez',
      commonUses: 'Consumo fresco, batidos, salsas, ensaladas y postres',
      imageUrl: 'assets/Alimentacion/mango.png',
    ),
    FruitInfo(
      name: 'Maracuyá',
      description:
          'El maracuyá es rico en vitamina C, vitamina A y fibra. Sus semillas contienen ácidos grasos esenciales. Tiene propiedades antioxidantes y puede ayudar a reducir la ansiedad.',
      classification: 'Fruta tropical de la familia Passifloraceae.',
      averageWeight: '50-80 gramos',
      color: 'Amarillo o morado según la variedad',
      commonUses: 'Jugos, postres, salsas y cócteles',
      imageUrl: 'assets/Alimentacion/maracuya.png',
    ),
    FruitInfo(
      name: 'Pera',
      description:
          'Las peras son una buena fuente de fibra soluble e insoluble, lo que contribuye a la salud digestiva. Contienen vitamina C, K y cobre, además de antioxidantes que ayudan a combatir el daño celular.',
      classification: 'Fruta pomácea con textura granulada y sabor dulce.',
      averageWeight: '150-200 gramos',
      color: 'Verde, amarillo o rojizo según la variedad',
      commonUses: 'Consumo fresco, en ensaladas, horneados y conservas',
      imageUrl: 'assets/Alimentacion/pera.png',
    ),
    FruitInfo(
      name: 'Naranja',
      description:
          'Las naranjas son famosas por su alto contenido de vitamina C, que fortalece el sistema inmunológico. También son ricas en fibra y contienen compuestos vegetales beneficiosos como los flavonoides.',
      classification: 'Fruta cítrica cultivada en regiones cálidas y subtropicales de todo el mundo.',
      averageWeight: '130-180 gramos',
      color: 'Naranja brillante cuando madura',
      commonUses: 'Consumo fresco, jugos, mermeladas y repostería',
      imageUrl: 'assets/Alimentacion/naranja.png',
    ),
    FruitInfo(
      name: 'Uvas',
      description:
          'Las uvas son ricas en antioxidantes como el resveratrol, que puede tener beneficios para la salud del corazón. También contienen vitamina K, potasio y varios antioxidantes beneficiosos.',
      classification: 'Fruta de baya que crece en racimos en la vid.',
      averageWeight: '5-10 gramos por uva',
      color: 'Verde, rojo, púrpura o negro, según la variedad',
      commonUses: 'Consumo fresco, vino, pasas, jugos y mermeladas',
      imageUrl: 'assets/Alimentacion/uvas.png',
    ),
    FruitInfo(
      name: 'Mora',
      description:
          'Las moras son ricas en vitamina C, fibra y antioxidantes. Contienen compuestos que pueden ayudar a combatir la inflamación y mejorar la memoria.',
      classification: 'Fruta del bosque de la familia Rubus.',
      averageWeight: '3-5 gramos por unidad',
      color: 'Negro brillante cuando madura',
      commonUses: 'Consumo fresco, mermeladas, postres y batidos',
      imageUrl: 'assets/Alimentacion/mora.png',
    ),
    FruitInfo(
      name: 'Kiwi',
      description:
          'El kiwi proporciona más del 100% de la ingesta diaria recomendada de vitamina C. Es rico en fibra dietética, vitamina K, vitamina E y folato, que contribuyen a la salud general.',
      classification: 'Baya comestible de la enredadera Actinidia deliciosa.',
      averageWeight: '50-80 gramos',
      color: 'Marrón exterior y verde brillante interior',
      commonUses: 'Consumo fresco, ensaladas de frutas, postres y smoothies',
      imageUrl: 'assets/Alimentacion/kiwi.png',
    ),
    FruitInfo(
      name: 'Sandía',
      description:
          'La sandía es refrescante y muy hidratante, compuesta por un 92% de agua. Contiene licopeno, un antioxidante que puede proteger contra ciertos tipos de cáncer y enfermedades cardíacas.',
      classification: 'Fruta de la familia de las cucurbitáceas, relacionada con calabazas y pepinos.',
      averageWeight: '5-15 kilogramos',
      color: 'Piel verde con franjas, pulpa roja o amarilla',
      commonUses: 'Consumo fresco, zumos, ensaladas y postres helados',
      imageUrl: 'assets/Alimentacion/sandia.png',
    ),
    FruitInfo(
      name: 'Piña',
      description:
          'La piña contiene bromelina, una enzima con propiedades antiinflamatorias. Es rica en manganeso, que apoya el metabolismo y la función antioxidante, y en vitamina C que impulsa el sistema inmunológico.',
      classification: 'Fruta tropical compuesta, formada por múltiples frutas fusionadas alrededor de un tallo central.',
      averageWeight: '1-2 kilogramos',
      color: 'Piel marrón y pulpa amarilla dorada',
      commonUses: 'Consumo fresco, jugos, postres y platos salados',
      imageUrl: 'assets/Alimentacion/piña.png',
    ),
    FruitInfo(
      name: 'Ciruela',
      description:
          'Las ciruelas contienen muchos antioxidantes y son conocidas por su efecto beneficioso sobre la digestión. Son ricas en vitaminas A, C y K, además de potasio y fibra.',
      classification: 'Fruta de hueso del género Prunus.',
      averageWeight: '30-100 gramos según variedad',
      color: 'Rojo, morado, amarillo o verde según la variedad',
      commonUses: 'Consumo fresco, secas (ciruelas pasas), mermeladas y postres',
      imageUrl: 'assets/Alimentacion/Ciruelas.png',
    ),
    FruitInfo(
      name: 'Frutos Rojos',
      description:
          'Los frutos rojos (arándanos, moras, fresas y frambuesas) son excepcionalmente ricos en antioxidantes y vitamina C. Ayudan a combatir la inflamación y pueden mejorar la salud cerebral.',
      classification: 'Conjunto de pequeñas frutas de bosque con alto contenido de antocianinas.',
      averageWeight: 'Variable según el tipo (1-20 gramos por unidad)',
      color: 'Tonos rojos, azules y morados',
      commonUses: 'Consumo fresco, postres, batidos, mermeladas y repostería',
      imageUrl: 'assets/Alimentacion/Frutos_rojos.png',
    ),
    FruitInfo(
      name: 'Papaya',
      description:
          'La papaya contiene papaína, una enzima que ayuda a la digestión de proteínas. Es rica en vitamina C, vitamina A, folato y potasio, además de contener antioxidantes beneficiosos.',
      classification: 'Fruta tropical originaria de México y América Central.',
      averageWeight: '500-1000 gramos',
      color: 'Piel amarilla-verdosa, pulpa naranja o rojiza',
      commonUses: 'Consumo fresco, ensaladas, batidos y como ablandador de carnes',
      imageUrl: 'assets/Alimentacion/Papaya.png',
    ),
    FruitInfo(
      name: 'Higo',
      description:
          'Los higos son ricos en fibra, potasio, calcio y magnesio. Contienen antioxidantes y compuestos fenólicos que pueden tener propiedades antiinflamatorias y anticancerígenas.',
      classification: 'Fruto de la higuera, técnicamente una infrutescencia.',
      averageWeight: '40-60 gramos',
      color: 'Verde, morado o negro según variedad y madurez',
      commonUses: 'Consumo fresco, secos, en postres y platos salados',
      imageUrl: 'assets/Alimentacion/Higo.png',
    ),
    FruitInfo(
      name: 'Granada',
      description:
          'La granada es rica en antioxidantes polifenoles, especialmente punicalagins y punicalinas. Estos compuestos pueden reducir la inflamación y proteger contra enfermedades.',
      classification: 'Fruta de arbusto originaria de la región de Irán hasta el Himalaya.',
      averageWeight: '150-200 gramos',
      color: 'Exterior rojizo, semillas internas rojas brillantes',
      commonUses: 'Consumo de los arilos, jugos, salsas y en cocina internacional',
      imageUrl: 'assets/Alimentacion/Granada.png',
    ),
    FruitInfo(
      name: 'Grosella',
      description:
          'Las grosellas son ricas en vitamina C, antioxidantes y minerales como el potasio y el manganeso. Tienen propiedades antiinflamatorias y pueden ayudar a fortalecer el sistema inmunológico.',
      classification: 'Bayas pequeñas del género Ribes.',
      averageWeight: '1-2 gramos por unidad',
      color: 'Rojo, negro o blanco según la variedad',
      commonUses: 'Mermeladas, jaleas, zumos, postres y salsas',
      imageUrl: 'assets/Alimentacion/Grosella.png',
    ),
    FruitInfo(
      name: 'Mandarina',
      description:
          'Las mandarinas son excelentes fuentes de vitamina C y contienen flavonoides que actúan como antioxidantes. Son bajas en calorías y contienen fibra que ayuda a la digestión.',
      classification: 'Fruta cítrica de la familia de las rutáceas.',
      averageWeight: '80-120 gramos',
      color: 'Naranja intenso cuando madura',
      commonUses: 'Consumo fresco, zumos, postres y mermeladas',
      imageUrl: 'assets/Alimentacion/Mandarina.png',
    ),
    FruitInfo(
      name: 'Coco',
      description:
          'El coco es rico en grasas saludables, especialmente ácidos grasos de cadena media que pueden proporcionar energía rápida. La pulpa del coco contiene fibra y minerales como manganeso, cobre y hierro.',
      classification: 'Técnicamente una drupa, no una nuez, es la fruta del cocotero.',
      averageWeight: '1.5-2.5 kilogramos',
      color: 'Marrón exterior, pulpa blanca y agua transparente',
      commonUses: 'Agua, leche, aceite, pulpa, en cocina, postres y cosméticos',
      imageUrl: 'assets/Alimentacion/Coco.png',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navegar a Módulos
      context.go('/modulos');
    } else if (index == 2) {
      // Navegar a Perfil
      context.go('/perfil');
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
                image: AssetImage("assets/ALIMENTACION/fONDO_FRUTAS.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light overlay for better readability
          Container(color: const Color.fromARGB(255, 206, 206, 206).withOpacity(0.7)),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'INFORMACIÓN DE FRUTAS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 18, 167),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                // Grid of fruit cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58, // Aún más reducido para evitar desbordamiento
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _fruitList.length,
                      itemBuilder: (context, index) {
                        return _buildFruitCard(_fruitList[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        primaryColor: const Color.fromARGB(255, 148, 66, 255),
      ),
    );
  }

  Widget _buildFruitCard(FruitInfo fruit) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fruit Image - Modificado para mostrar la imagen completa
          Container(
            height: 120,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                fruit.imageUrl,
                height: 100,
                fit: BoxFit.contain, // Cambiado a contain para ver la imagen completa
              ),
            ),
          ),
          
          // Fruit Name
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              fruit.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 75, 18, 167),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Fruit Information in a scrollable container with pyramid layout
          // Cambiado a fondo blanco
          Expanded(
            child: Container(
              color: Colors.white, // Fondo blanco para el contenedor de texto
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Descripción
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        fruit.description,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    
                    // Clasificación
                    Container(
                      width: MediaQuery.of(context).size.width * 0.38,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: _buildInfoSection('Clasificación:', fruit.classification),
                    ),
                    
                    // Peso promedio
                    Container(
                      width: MediaQuery.of(context).size.width * 0.32,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: _buildInfoSection('Peso promedio:', fruit.averageWeight),
                    ),
                    
                    // Color
                    Container(
                      width: MediaQuery.of(context).size.width * 0.26,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: _buildInfoSection('Color:', fruit.color),
                    ),
                    
                    // Usos comunes
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: _buildInfoSection('Usos comunes:', fruit.commonUses),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: content,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Modelo para la información de frutas
class FruitInfo {
  final String name;
  final String description;
  final String classification;
  final String averageWeight;
  final String color;
  final String commonUses;
  final String imageUrl;

  FruitInfo({
    required this.name,
    required this.description, 
    required this.classification,
    required this.averageWeight,
    required this.color,
    required this.commonUses,
    required this.imageUrl,
  });
}