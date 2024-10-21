import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinalario/main.dart';

class PeriodicTablePage extends StatefulWidget {
  const PeriodicTablePage({super.key});

  @override
  _PeriodicTablePageState createState() => _PeriodicTablePageState();
}

class _PeriodicTablePageState extends State<PeriodicTablePage> {
  List<Widget> _elements = [];
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _elements = _generateElements();
  }

  List<Widget> _generateElements() {
    List<Widget> elements = [];
    for (var i = 0; i < PenConfig.tableRows; i++) {
      for (var j = 0; j < PenConfig.tableCols; j++) {
        var key = '${j}x$i';
        var tmpElement = PenData.elementsData[key];

        if (PenData.elementsData.containsKey(key)) {
          if (tmpElement['name'] != 'rFrom' && tmpElement['name'] != 'rTo') {
            elements.add(ElementWidget(
              tmpElement,
              onTap: () {
                setState(() {
                  selectedImagePath = tmpElement['imagePath'];
                });
              },
            ));
          } else {
            elements.add(ReferenceWidget(
              to: tmpElement['name'] != 'rFrom',
              symbol: tmpElement['symbol'],
            ));
          }
        } else {
          elements.add(const BlankWidget());
        }
      }
    }
    return elements;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabela Periódica', style: TextStyle(color: Color.fromARGB(255, 235, 233, 233)),),
        
        backgroundColor: const Color.fromRGBO(98, 111, 65, 1), foregroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(218, 211, 189, 25),
      body: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            minScale: 0.2,
            maxScale: 6.0,
            child: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: PenConfig.itemGap.toDouble(),
                    mainAxisSpacing: PenConfig.itemGap.toDouble(),
                    crossAxisCount: PenConfig.tableCols,
                    children: _elements,
                  ),
                ),
              ],
            ),
          ),
          if (selectedImagePath != null)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImagePath = null;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          selectedImagePath!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              selectedImagePath = null;
                            });
                          },
                        ),
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
}

class ElementWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const ElementWidget(this.data, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool small = MediaQuery.of(context).size.width < 800;
    return Container(
      width: PenConfig.itemSize.dx,
      height: PenConfig.itemSize.dy,
      padding: EdgeInsets.all(PenConfig.itemGap.toDouble() / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PenConfig.itemRadius.toDouble()),
        color: PenData.stateOfMatter[data['state']]['color'],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: FittedBox(
          fit: BoxFit.none,
          child: Column(
            children: [
              if (!small)
                Text(
                  data['atomicNumber'].toString(),
                  style: TextStyle(
                    fontSize: small ? 6 : 6,
                    fontWeight: FontWeight.w900,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              Text(
                data['symbol'].toString(),
                style: TextStyle(
                  fontSize: small ? 25 : 25,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'LibraFont',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReferenceWidget extends StatelessWidget {
  final bool to;
  final String symbol;

  const ReferenceWidget({super.key, required this.to, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PenConfig.itemSize.dx,
      height: PenConfig.itemSize.dy,
      color: Colors.transparent,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: to ? Alignment.center : Alignment.centerRight,
        child: Column(
          children: [
            Text(
              symbol,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(92, 106, 59, 25),
                fontFamily: 'LibraFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlankWidget extends StatelessWidget {
  const BlankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PenConfig.itemSize.dx,
      height: PenConfig.itemSize.dy,
      color: Colors.transparent,
    );
  }
}



class Utils {
  static void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class PenColors {
  static const scaffold = Color(0xFF1a1b1d);
}

class PenConfig {
  static const int tableCols = 18;
  static const int tableRows = 10;
  static num itemGap = 10;
  static num itemRadius = 10;
  static final Offset itemSize = Offset(100, 170);
}

class PenData {
  static final Map elementsData = {
    '0x0': {'symbol': 'H', 'state': 2, 'atomicNumber': 1, 'name': 'Hydrogen', 'imagePath': 'assets/elements/Hidrogenioo.png'},
    '17x0': {'symbol': 'He', 'state': 0, 'atomicNumber': 2, 'name': 'Helium', 'imagePath':'assets/elements/Helio.png'},
    '0x1': {'symbol': 'Li', 'state': 2, 'atomicNumber': 3, 'name': 'Lithium', 'imagePath': 'assets/elements/Litioo.png'},
    '1x1': {'symbol': 'Be', 'state': 1, 'atomicNumber': 4, 'name': 'Beryllium', 'imagePath': 'assets/elements/Berilio.png'},
    '12x1': {'symbol': 'B', 'state': 1, 'atomicNumber': 5, 'name': 'Boron', 'imagePath': 'assets/elements/Boro.png'},
    '13x1': {'symbol': 'C', 'state': 2, 'atomicNumber': 6, 'name': 'Carbon', 'imagePath': 'assets/elements/Carbono.png'},
    '14x1': {'symbol': 'N', 'state': 0, 'atomicNumber': 7, 'name': 'Nitrogen', 'imagePath': 'assets/elements/Nitrogenio.png'},
    '15x1': {'symbol': 'O', 'state': 0, 'atomicNumber': 8, 'name': 'Oxygen', 'imagePath': 'assets/elements/Oxigenio.png'},
    '16x1': {'symbol': 'F', 'state': 0, 'atomicNumber': 9, 'name': 'Fluorine', 'imagePath': 'assets/elements/Fluor.png'},
    '17x1': {'symbol': 'Ne', 'state': 0, 'atomicNumber': 10, 'name': 'Neon', 'imagePath': 'assets/elements/Neonio.png'},
    '0x2': {'symbol': 'Na', 'state': 2, 'atomicNumber': 11, 'name': 'Sodium', 'imagePath': 'assets/elements/Sodio.png'},
    '1x2': {'symbol': 'Mg', 'state': 2, 'atomicNumber': 12, 'name': 'Magnesium', 'imagePath': 'assets/elements/Magnesio.png'},
    '12x2': {'symbol': 'Al', 'state': 2, 'atomicNumber': 13, 'name': 'Aluminium', 'imagePath': 'assets/elements/Aluminio.png'},
    '13x2': {'symbol': 'Si', 'state': 1, 'atomicNumber': 14, 'name': 'Silicon', 'imagePath': 'assets/elements/Silicio.png'},
    '14x2': {'symbol': 'P', 'state': 1, 'atomicNumber': 15, 'name': 'Phosphorus', 'imagePath': 'assets/elements/Fosforo.png'},
    '15x2': {'symbol': 'S', 'state': 1, 'atomicNumber': 16, 'name': 'Sulfur', 'imagePath': 'assets/elements/Enxofre.png'},
    '16x2': {'symbol': 'Cl', 'state': 0, 'atomicNumber': 17, 'name': 'Chlorine', 'imagePath': 'assets/elements/Cloro.png'},
    '17x2': {'symbol': 'Ar', 'state': 0, 'atomicNumber': 18, 'name': 'Argon', 'imagePath': 'assets/elements/Argonio.png'},
    '0x3': {'symbol': 'K', 'state': 2, 'atomicNumber': 19, 'name': 'Potassium', 'imagePath': 'assets/elements/Potassio.png'},
    '1x3': {'symbol': 'Ca', 'state': 2, 'atomicNumber': 20, 'name': 'Calcium', 'imagePath': 'assets/elements/Calcio.png'},
    '2x3': {'symbol': 'Sc', 'state': 1, 'atomicNumber': 21, 'name': 'Scandium', 'imagePath': 'assets/elements/Escandio.png'},
    '3x3': {'symbol': 'Ti', 'state': 1, 'atomicNumber': 22, 'name': 'Titanium', 'imagePath': 'assets/elements/Titanio.png'},
    '4x3': {'symbol': 'V', 'state': 1, 'atomicNumber': 23, 'name': 'Vanadium', 'imagePath': 'assets/elements/Vanadio.png'},
    '5x3': {'symbol': 'Cr', 'state': 2, 'atomicNumber': 24, 'name': 'Chromium', 'imagePath': 'assets/elements/Cromo.png'},
    '6x3': {'symbol': 'Mn', 'state': 1, 'atomicNumber': 25, 'name': 'Manganese', 'imagePath': 'assets/elements/Manganes.png'},
    '7x3': {'symbol': 'Fe', 'state': 2, 'atomicNumber': 26, 'name': 'Iron', 'imagePath': 'assets/elements/Ferro.png'},
    '8x3': {'symbol': 'Co', 'state': 1, 'atomicNumber': 27, 'name': 'Cobalt', 'imagePath': 'assets/elements/Cobalto.png'},
    '9x3': {'symbol': 'Ni', 'state': 1, 'atomicNumber': 28, 'name': 'Nickel', 'imagePath': 'assets/elements/Niquel.png'},
    '10x3': {'symbol': 'Cu', 'state': 2, 'atomicNumber': 29, 'name': 'Copper', 'imagePath': 'assets/elements/Cobre.png'},
    '11x3': {'symbol': 'Zn', 'state': 1, 'atomicNumber': 30, 'name': 'Zinc', 'imagePath': 'assets/elements/Zinco.png'},
    '12x3': {'symbol': 'Ga', 'state': 1, 'atomicNumber': 31, 'name': 'Gallium', 'imagePath': 'assets/elements/Galio.png'},
    '13x3': {'symbol': 'Ge', 'state': 1, 'atomicNumber': 32, 'name': 'Germanium', 'imagePath': 'assets/elements/Germanio.png'},
    '14x3': {'symbol': 'As', 'state': 1, 'atomicNumber': 33, 'name': 'Arsenic', 'imagePath': 'assets/elements/Arsenio.png'},
    '15x3': {'symbol': 'Se', 'state': 1, 'atomicNumber': 34, 'name': 'Selenium', 'imagePath': 'assets/elements/Selenio.png'},
    '16x3': {'symbol': 'Br', 'state': 1, 'atomicNumber': 35, 'name': 'Bromine', 'imagePath': 'assets/elements/Bromo.png'},
    '17x3': {'symbol': 'Kr', 'state': 0, 'atomicNumber': 36, 'name': 'Krypton', 'imagePath': 'assets/elements/Criptonio.png'},
    '0x4': {'symbol': 'Rb', 'state': 1, 'atomicNumber': 37, 'name': 'Rubidium', 'imagePath': 'assets/elements/Rubidio.png'},
    '1x4': {'symbol': 'Sr', 'state': 1, 'atomicNumber': 38, 'name': 'Strontium', 'imagePath': 'assets/elements/Estroncio.png'},
    '2x4': {'symbol': 'Y', 'state': 1, 'atomicNumber': 39, 'name': 'Yttrium', 'imagePath': 'assets/elements/Itrio.png'},
    '3x4': {'symbol': 'Zr', 'state': 1, 'atomicNumber': 40, 'name': 'Zirconium', 'imagePath': 'assets/elements/Zirconio.png'},
    '4x4': {'symbol': 'Nb', 'state': 1, 'atomicNumber': 41, 'name': 'Niobium', 'imagePath': 'assets/elements/Niobio.png'},
    '5x4': {'symbol': 'Mo', 'state': 1, 'atomicNumber': 42, 'name': 'Molybdenum', 'imagePath': 'assets/elements/Molibdemio.png'},
    '6x4': {'symbol': 'Tc', 'state': 1, 'atomicNumber': 43, 'name': 'Technetium', 'imagePath': 'assets/elements/Tecnesio.png'},
    '7x4': {'symbol': 'Ru', 'state': 1, 'atomicNumber': 44, 'name': 'Ruthenium', 'imagePath': 'assets/elements/Rutenio.png'},
    '8x4': {'symbol': 'Rh', 'state': 1, 'atomicNumber': 45, 'name': 'Rhodium', 'imagePath': 'assets/elements/Rodio.png'},
    '9x4': {'symbol': 'Pd', 'state': 1, 'atomicNumber': 46, 'name': 'Palladium', 'imagePath': 'assets/elements/Paladio.png'},
    '10x4': {'symbol': 'Ag', 'state': 1, 'atomicNumber': 47, 'name': 'Silver', 'imagePath': 'assets/elements/Prata.png'},
    '11x4': {'symbol': 'Cd', 'state': 1, 'atomicNumber': 48, 'name': 'Cadmium', 'imagePath': 'assets/elements/Cadmio.png'},
    '12x4': {'symbol': 'In', 'state': 1, 'atomicNumber': 49, 'name': 'Indium', 'imagePath': 'assets/elements/Indio.png'},
    '13x4': {'symbol': 'Sn', 'state': 1, 'atomicNumber': 50, 'name': 'Tin', 'imagePath': 'assets/elements/Estanho.png'},
    '14x4': {'symbol': 'Sb', 'state': 1, 'atomicNumber': 51, 'name': 'Antimony', 'imagePath': 'assets/elements/Antimonio.png'},
    '15x4': {'symbol': 'Te', 'state': 1, 'atomicNumber': 52, 'name': 'Tellurium', 'imagePath': 'assets/elements/Telurio.png'},
    '16x4': {'symbol': 'I', 'state': 1, 'atomicNumber': 53, 'name': 'Iodine', 'imagePath': 'assets/elements/Iodo.png'},
    '17x4': {'symbol': 'Xe', 'state': 0, 'atomicNumber': 54, 'name': 'Xenon', 'imagePath': 'assets/elements/Xenonio.png'},
    '0x5': {'symbol': 'Cs', 'state': 1, 'atomicNumber': 55, 'name': 'Cesium', 'imagePath': 'assets/elements/Cesio.png'},
    '1x5': {'symbol': 'Ba', 'state': 1, 'atomicNumber': 56, 'name': 'Barium', 'imagePath': 'assets/elements/Bario.png'},
    '3x8': {'symbol': 'La', 'state': 1, 'atomicNumber': 57, 'name': 'Lanthanum', 'imagePath': 'assets/elements/Lantanio.png'},
    '4x8': {'symbol': 'Ce', 'state': 1, 'atomicNumber': 58, 'name': 'Cerium', 'imagePath': 'assets/elements/Cerio.png'},
    '5x8': {'symbol': 'Pr', 'state': 1, 'atomicNumber': 59, 'name': 'Praseodymium', 'imagePath': 'assets/elements/Preseodimio.png'},
    '6x8': {'symbol': 'Nd', 'state': 1, 'atomicNumber': 60, 'name': 'Neodymium', 'imagePath': 'assets/elements/Neodimio.png'},
    '7x8': {'symbol': 'Pm', 'state': 1, 'atomicNumber': 61, 'name': 'Promethium', 'imagePath': 'assets/elements/Promecio.png'},
    '8x8': {'symbol': 'Sm', 'state': 1, 'atomicNumber': 62, 'name': 'Samarium', 'imagePath': 'assets/elements/Samario.png'},
    '9x8': {'symbol': 'Eu', 'state': 1, 'atomicNumber': 63, 'name': 'Europium', 'imagePath': 'assets/elements/Europio.png'},
    '10x8': {'symbol': 'Gd', 'state': 1, 'atomicNumber': 64, 'name': 'Gadolinium', 'imagePath': 'assets/elements/Gadolinio.png'},
    '11x8': {'symbol': 'Tb', 'state': 1, 'atomicNumber': 65, 'name': 'Terbium', 'imagePath': 'assets/elements/Terbio.png'},
    '12x8': {'symbol': 'Dy', 'state': 1, 'atomicNumber': 66, 'name': 'Dysprosium', 'imagePath': 'assets/elements/Disprosio.png'},
    '13x8': {'symbol': 'Ho', 'state': 1, 'atomicNumber': 67, 'name': 'Holmium', 'imagePath': 'assets/elements/Holmio.png'},
    '14x8': {'symbol': 'Er', 'state': 1, 'atomicNumber': 68, 'name': 'Erbium', 'imagePath': 'assets/elements/Erbio.png'},
    '15x8': {'symbol': 'Tm', 'state': 1, 'atomicNumber': 69, 'name': 'Thulium', 'imagePath': 'assets/elements/Tulio.png'},
    '16x8': {'symbol': 'Yb', 'state': 1, 'atomicNumber': 70, 'name': 'Ytterbium', 'imagePath': 'assets/elements/Iterbio.png'},
    '17x8': {'symbol': 'Lu', 'state': 1, 'atomicNumber': 71, 'name': 'Lutetium', 'imagePath': 'assets/elements/Lutessio.png'},
    '3x5': {'symbol': 'Hf', 'state': 1, 'atomicNumber': 72, 'name': 'Hafnium', 'imagePath': 'assets/elements/Hafnio.png'},
    '4x5': {'symbol': 'Ta', 'state': 1, 'atomicNumber': 73, 'name': 'Tantalum', 'imagePath': 'assets/elements/Tantalo.png'},
    '5x5': {'symbol': 'W', 'state': 1, 'atomicNumber': 74, 'name': 'Tungsten', 'imagePath': 'assets/elements/Tungstenio.png'},
    '6x5': {'symbol': 'Re', 'state': 1, 'atomicNumber': 75, 'name': 'Rhenium', 'imagePath': 'assets/elements/Renio.png'},
    '7x5': {'symbol': 'Os', 'state': 1, 'atomicNumber': 76, 'name': 'Osmium', 'imagePath': 'assets/elements/Osmio.png'},
    '8x5': {'symbol': 'Ir', 'state': 1, 'atomicNumber': 77, 'name': 'Iridium', 'imagePath': 'assets/elements/Iridio.png'},
    '9x5': {'symbol': 'Pt', 'state': 1, 'atomicNumber': 78, 'name': 'Platinum', 'imagePath': 'assets/elements/Platina.png'},
    '10x5': {'symbol': 'Au', 'state': 1, 'atomicNumber': 79, 'name': 'Gold', 'imagePath': 'assets/elements/Ouro.png'},
    '11x5': {'symbol': 'Hg', 'state': 2, 'atomicNumber': 80, 'name': 'Mercury', 'imagePath': 'assets/elements/Mercurio.png'},
    '12x5': {'symbol': 'Tl', 'state': 1, 'atomicNumber': 81, 'name': 'Thallium', 'imagePath': 'assets/elements/Talio.png'},
    '13x5': {'symbol': 'Pb', 'state': 2, 'atomicNumber': 82, 'name': 'Lead', 'imagePath': 'assets/elements/Chumbo.png'},
    '14x5': {'symbol': 'Bi', 'state': 1, 'atomicNumber': 83, 'name': 'Bismuth', 'imagePath': 'assets/elements/Bismuto.png'},
    '15x5': {'symbol': 'Po', 'state': 1, 'atomicNumber': 84, 'name': 'Polonium', 'imagePath': 'assets/elements/Polonio.png'},
    '16x5': {'symbol': 'At', 'state': 1, 'atomicNumber': 85, 'name': 'Astatine', 'imagePath': 'assets/elements/Astato.png'},
    '17x5': {'symbol': 'Rn', 'state': 0, 'atomicNumber': 86, 'name': 'Radon', 'imagePath': 'assets/elements/Radonio.png'},
    '0x6': {'symbol': 'Fr', 'state': 1, 'atomicNumber': 87, 'name': 'Francium', 'imagePath': 'assets/elements/Francio.png'},
    '1x6': {'symbol': 'Ra', 'state': 1, 'atomicNumber': 88, 'name': 'Radium', 'imagePath': 'assets/elements/Radio.png'},
    '3x9': {'symbol': 'Ac', 'state': 1, 'atomicNumber': 89, 'name': 'Actinium', 'imagePath': 'assets/elements/Actinio.png'},
    '4x9': {'symbol': 'Th', 'state': 1, 'atomicNumber': 90, 'name': 'Thorium', 'imagePath': 'assets/elements/Torio.png'},
    '5x9': {'symbol': 'Pa', 'state': 1, 'atomicNumber': 91, 'name': 'Protactinium', 'imagePath': 'assets/elements/Protactinio.png'},
    '6x9': {'symbol': 'U', 'state': 1, 'atomicNumber': 92, 'name': 'Uranium', 'imagePath': 'assets/elements/Uranio.png'},
    '7x9': {'symbol': 'Np', 'state': 1, 'atomicNumber': 93, 'name': 'Neptunium', 'imagePath': 'assets/elements/Neptunio.png'},
    '8x9': {'symbol': 'Pu', 'state': 1, 'atomicNumber': 94, 'name': 'Plutonium', 'imagePath': 'assets/elements/Plutonio.png'},
    '9x9': {'symbol': 'Am', 'state': 1, 'atomicNumber': 95, 'name': 'Americium', 'imagePath': 'assets/elements/Americo.png'},
    '10x9': {'symbol': 'Cm', 'state': 1, 'atomicNumber': 96, 'name': 'Curium', 'imagePath': 'assets/elements/Curio.png'},
    '11x9': {'symbol': 'Bk', 'state': 1, 'atomicNumber': 97, 'name': 'Berkelium', 'imagePath': 'assets/elements/Berquelio.png'},
    '12x9': {'symbol': 'Cf', 'state': 1, 'atomicNumber': 98, 'name': 'Californium', 'imagePath': 'assets/elements/Californio.png'},
    '13x9': {'symbol': 'Es', 'state': 1, 'atomicNumber': 99, 'name': 'Einsteinium', 'imagePath': 'assets/elements/Einstenio.png'},
    '14x9': {'symbol': 'Fm', 'state': 3, 'atomicNumber': 100, 'name': 'Fermium', 'imagePath': 'assets/elements/Fermio.png'},
    '15x9': {'symbol': 'Md', 'state': 3, 'atomicNumber': 101, 'name': 'Mendelevium', 'imagePath': 'assets/elements/Mendelevio.png'},
    '16x9': {'symbol': 'No', 'state': 3, 'atomicNumber': 102, 'name': 'Nobelium', 'imagePath': 'assets/elements/Nobelio.png'},
    '17x9': {'symbol': 'Lr', 'state': 3, 'atomicNumber': 103, 'name': 'Lawrencium', 'imagePath': 'assets/elements/Laurencio.png'},
    '3x6': {'symbol': 'Rf', 'state': 3, 'atomicNumber': 104, 'name': 'Rutherfordium', 'imagePath': 'assets/elements/Rutherfordio.png'},
    '4x6': {'symbol': 'Db', 'state': 3, 'atomicNumber': 105, 'name': 'Dubnium', 'imagePath': 'assets/elements/Dubnio.png'},
    '5x6': {'symbol': 'Sg', 'state': 3, 'atomicNumber': 106, 'name': 'Seaborgium', 'imagePath': 'assets/elements/Seaborgio.png'},
    '6x6': {'symbol': 'Bh', 'state': 3, 'atomicNumber': 107, 'name': 'Bohrium', 'imagePath': 'assets/elements/Bohrio.png'},
    '7x6': {'symbol': 'Hs', 'state': 3, 'atomicNumber': 108, 'name': 'Hassium', 'imagePath': 'assets/elements/Hassio.png'},
    '8x6': {'symbol': 'Mt', 'state': 3, 'atomicNumber': 109, 'name': 'Meitnerium', 'imagePath': 'assets/elements/Meitnerio.png'},
    '9x6': {'symbol': 'Ds', 'state': 3, 'atomicNumber': 110, 'name': 'Darmstadtium', 'imagePath': 'assets/elements/Darmstadtio.png'},
    '10x6': {'symbol': 'Rg', 'state': 3, 'atomicNumber': 111, 'name': 'Roentgenium', 'imagePath': 'assets/elements/Roentgenio.png'},
    '11x6': {'symbol': 'Cn', 'state': 3, 'atomicNumber': 112, 'name': 'Copernicium', 'imagePath': 'assets/elements/Copernicio.png'},
    '12x6': {'symbol': 'Nh', 'state': 3, 'atomicNumber': 113, 'name': 'Nihonium', 'imagePath': 'assets/elements/Nihonio.png'},
    '13x6': {'symbol': 'Fl', 'state': 3, 'atomicNumber': 114, 'name': 'Flerovium', 'imagePath': 'assets/elements/Flerovio.png'},
    '14x6': {'symbol': 'Mc', 'state': 3, 'atomicNumber': 115, 'name': 'Moscovium', 'imagePath': 'assets/elements/Moscovio.png'},
    '15x6': {'symbol': 'Lv', 'state': 3, 'atomicNumber': 116, 'name': 'Livermorium', 'imagePath': 'assets/elements/Livermorio.png'},
    '16x6': {'symbol': 'Ts', 'state': 3, 'atomicNumber': 117, 'name': 'Tennessine', 'imagePath': 'assets/elements/Tenesso.png'},
    '17x6': {'symbol': 'Og', 'state': 3, 'atomicNumber': 118, 'name': 'Oganesson', 'imagePath': 'assets/elements/Oganessonio.png'},
    '2x5': {'symbol': '*', 'name': 'rFrom'},
    '2x6': {'symbol': '**', 'name': 'rFrom'},
    '2x8': {'symbol': '*', 'name': 'rTo'},
    '2x9': {'symbol': '**', 'name': 'rTo'}
  };
  
  static final List stateOfMatter = [
    {'type': 'Gas', 'color': const Color.fromRGBO(92, 106, 59, 25),},
    {'type': 'Solid', 'color': const Color.fromRGBO(92, 106, 59, 25),},
    {'type': 'Liquid', 'color': const Color.fromARGB(231, 83, 20, 92),},
    {'type': 'Unknown', 'color': const Color.fromRGBO(92, 106, 59, 25),},
  ];

  static final List naturalOccurrence = [
    {'type': 'Primordial',},
    {'type': 'From decay',},
    {'type': 'Synthetic',},
  ];
}