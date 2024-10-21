import 'package:flutter/material.dart';
import 'periodic_table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sinalário Químico',
      theme: ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(218, 211, 189, 25),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  List<String> buttonNames = [
    'Carbono',
    'Elemento Químico',
    'Laboratório Químico',
    'Química Inorgânica',
    'Química Orgânica',
    'Átomos',
    'Nêutron',
    'Próton',
    'Ácido',
    'Básico/Alcaino',
    'Íon Positivo',
    'Íon Negativo',
    'Líquido',
    'Sólido',
    'Gasoso',
    'Alumínio',
    'Cálcio',
    'Chumbo',
    'Cobre',
    'Cromo',
    'Ferro',
    'Hidrogênio',
    'Hidroxila',
    'Lítio',
    'Magnésio',
    'Mercúrio',
    'Potássio',
    'Sódio',
    'Sulfato',
    'Zinco',
  ];

  
  List<String> buttons = [];
  List<String> filteredButtons = [];

  @override
  void initState() {
    super.initState();
    
    buttons = List.generate(buttonNames.length, (index) => buttonNames[index]);
    filteredButtons = buttons; 
  }

  void _filterButtons(String query) {
    setState(() {
      filteredButtons = buttons
          .where((button) =>
              button.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScreen(
      title: 'Sinalário Químico',
      content: 'Conteúdo da Tela Principal',
      currentScreen: 1,
      onSearch: _filterButtons,
      filteredButtons: filteredButtons,
      filteredTitles: [],
      searchTitles: [], 
    );
  }
}

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final List<String> searchTitles = [
    'Laboratório Químico',
    'Copo de Bécker',
    'Erlenmeyer',
    'Pipeta',
    'Proveta',
    'Bureta',
    'Bico de Bunsen',
    'Balança Analítica',
    'Balança Semi-analítica',
    'Espátula',
    'Grau e Pistilo',
    'Termômetro',
    'Jaleco',
    'Luvas de proteção',
    'Óculos de segurança',
    'Lava Olhos',
  ];
  List<String> filteredTitles = [];

  @override
  void initState() {
    super.initState();
    filteredTitles = searchTitles; 
  }

  void _filterTitles(String query) {
    setState(() {
      filteredTitles = searchTitles
          .where((title) => title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScreen(
      title: 'Laboratório',
      content: 'Conteúdo da Tela 2',
      currentScreen: 2,
      onSearch: _filterTitles,
      filteredButtons: [],
      filteredTitles: filteredTitles,
      searchTitles: searchTitles, 
    );
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return PeriodicTablePage();
  }
}

class CommonScreen extends StatelessWidget {
  final String title;
  final String content;
  final int currentScreen;
  final Function(String)? onSearch;
  final List<String> filteredButtons;
  final List<String> filteredTitles;
  final List<String> searchTitles;

  const CommonScreen({
    super.key,
    required this.title,
    required this.content,
    required this.currentScreen,
    this.onSearch,
    this.filteredButtons = const [],
    this.filteredTitles = const [],
    this.searchTitles = const [], 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
            child: Container(
              color: const Color.fromRGBO(92, 106, 59, 1),
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Exo',
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20.0),
                    ),
                    child: Container(
                      color: const Color.fromRGBO(146, 150, 113, 25),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CategoryButton(
                            title: 'Conceitos Gerais',
                            isSelected: currentScreen == 1,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                          ),
                          CategoryButton(
                            title: 'Laboratório',
                            isSelected: currentScreen == 2,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Screen2()),
                              );
                            },
                          ),
                          CategoryButton(
                            title: 'Tabela Periódica',
                            isSelected: currentScreen == 3,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Screen3()),
                              );
                            },
                          ),
                 
                          
                          
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (currentScreen == 1 || currentScreen == 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  labelText: 'Pesquisar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          const SizedBox(height: 10),
          if (currentScreen == 1)
            Expanded(
              child: ButtonGrid(buttons: filteredButtons),
            ),
          if (currentScreen == 2)
            Expanded(
              child: VidrariaGrid(
                filteredTitles: filteredTitles,
                searchTitles: searchTitles,
              ),
            ),
        ],
      ),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  final List<String> buttons;

  const ButtonGrid({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(92, 106, 59, 25),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  GifDialog(index: index, isFromCategory1: true),
            );
          },
          child: Text(
            buttons[index],
            style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontFamily: 'Montserrat',
          fontSize: 15,
          fontWeight: FontWeight.w800
          ),
          ),
        );
      },
    );
  }
}

class VidrariaGrid extends StatelessWidget {
  final List<String> filteredTitles;
  final List<String> searchTitles;

  const VidrariaGrid({
    super.key,
    required this.filteredTitles,
    required this.searchTitles,
  });

  @override
  Widget build(BuildContext context) {
    List<String> vidrarias = [
      'assets/images/Laboratorio_quimico.png',
      'assets/images/Becker.png',
      'assets/images/Erlenmeyer.png',
      'assets/images/Pipeta.png',
      'assets/images/Proveta.png',
      'assets/images/bureta.png',
      'assets/images/Bico_de_Bunsen.png',
      'assets/images/Balança_analitica.png',
      'assets/images/Balança_semianalitica.png',
      'assets/images/Espatula.png',
      'assets/images/Grau_e_Pistilo.png',
      'assets/images/Termometro.png',
      'assets/images/Jaleco.png',
      'assets/images/Luvas_de_Proteção.png',
      'assets/images/Oculos_de_Proteção.png',
      'assets/images/Lava_Olhos.png',
    ];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1, 
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: filteredTitles.length,
      itemBuilder: (context, index) {
     
        int imgIndex = searchTitles.indexOf(filteredTitles[index]);
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => GifDialog(
                index: imgIndex,
                isFromCategory1: false,
              ),
            );
          },
                    child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                vidrarias[imgIndex],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover, 
              ),
            ),
          ),
        );
      },
    );
  }
}

class GifDialog extends StatelessWidget {
  final int index;
  final bool isFromCategory1;

  const GifDialog({
    super.key,
    required this.index,
    this.isFromCategory1 = false,
  });

  @override
  Widget build(BuildContext context) {
    String gifPath= ''; 
    String title = '';
    String explanation = '';
    
   
    if (isFromCategory1) {
      
      switch (index) {
        case 0:
          gifPath = 'assets/gifs/Carbono.gif';
          title = 'Carbono';
          explanation = 'Carbono é o elemento com número atômico 6.';
          break;
        case 1:
          gifPath = 'assets/gifs/Elemento_quimico.gif'; 
          title = 'Elemento Químico';
          explanation = 'Elemento químico é o conjunto formado por átomos que apresentam o mesmo número atômico.';
          break;
        case 2:
          gifPath = 'assets/gifs/Laboratorio_quimico.gif'; 
          title = 'Laboratório Químico';
          explanation = 'Laboratório Químico é o lugar onde os cientistas e pesquisadores vão fazer experiências e pesquisas.';
          break;
          case 3:
          gifPath = 'assets/gifs/Quimica_inorganica.gif'; 
          title = 'Química Inorgânica';
          explanation = 'Química Inorgânica é a área da Química não baseada no carbono.';
          break;
          case 4:
          gifPath = 'assets/gifs/Quimica_organica.gif'; 
          title = 'Quimica Orgânica';
          explanation = 'Química Orgânica é a área da Química baseada no carbono.';
          break;
          case 5:
          gifPath = 'assets/gifs/Atomos.gif'; 
          title = 'Átomos';
          explanation = 'Átomo é uma unidade básica de matéria que consiste num núcleo central de carga elétrica positiva envolto por uma nuvem de eletrões de carga negativa.';
          break;
          case 6:
          gifPath = 'assets/gifs/Neutron.gif'; 
          title = 'Nêutron';
          explanation = 'Nêutron é a partícula elementar de carga nula.';
          break;
          case 7:
          gifPath = 'assets/gifs/Proton.gif'; 
          title = 'Próton';
          explanation = 'Próton é a partícula subatómica com carga elétrica positiva que se encontra no núcleo de um átomo, juntamente com os neutrons.';
          break;
          case 8:
          gifPath = 'assets/gifs/Acido.gif'; 
          title = 'Ácido';
          explanation = 'Ácido é aquela substância que tem capacidade de doar ions de hidrogénio (H+) em solução aquosa.';
          break;
          case 9:
          gifPath = 'assets/gifs/Basico.gif'; 
          title = 'Básico/Alcalino';
          explanation = 'Básico é aquela substãncia que libertam ions (OH-) em meio aquoso.';
          break;
          case 10:
          gifPath = 'assets/gifs/Ion_positivo.gif'; 
          title = 'Íon Positivo';
          explanation = 'Íon positivo tem carga positiva. Perdeu elétron. Também chamado de cátion.';
          break;
          case 11:
          gifPath = 'assets/gifs/Ion_negativo.gif'; 
          title = 'Íon Negativo';
          explanation = 'Íon negativo tem uma carga negativa. Ganhou elétron. Também chamado de ânodo.';
          break;
          case 12:
          gifPath = 'assets/gifs/Liquido.gif'; 
          title = 'Líquido';
          explanation = 'Quando as suas moléculas estão mais afastadas (o que dá maleabilidade).';
          break;
          case 13:
          gifPath = 'assets/gifs/Solido.gif'; 
          title = 'Sólido';
          explanation = 'Quando suas moléculas estão bem juntinhas (reunidas e organizadas).';
          break;
          case 14:
          gifPath = 'assets/gifs/Gasoso.gif'; 
          title = 'Gasoso';
          explanation = 'Quando há maior afastamento das moléculas surge o estado gasoso (átomos dispersos).';
          break;
          case 15:
          gifPath = 'assets/gifs/Aluminio.gif'; 
          title = 'Alumínio';
          explanation = 'Alumínio é o elemento com número atômico 13.';
          break;
          case 16:
          gifPath = 'assets/gifs/Calcio.gif'; 
          title = 'Cálcio';
          explanation = 'Cálcio é o elemento com número atômico 20.';
          break;
          case 17:
          gifPath = 'assets/gifs/Chumbo.gif'; 
          title = 'Chumbo';
          explanation = 'Chumbo é o elemento com número atômico 82.';
          break;
          case 18:
          gifPath = 'assets/gifs/Cobre.gif'; 
          title = 'Cobre';
          explanation = 'Cobre é o elemento com número atômico 29.';
          break;
          case 19:
          gifPath = 'assets/gifs/Cromo.gif'; 
          title = 'Cromo';
          explanation = 'Cromo é o elemento com número atômico 24.';
          break;
          case 20:
          gifPath = 'assets/gifs/Ferro.gif'; 
          title = 'Ferro';
          explanation = 'Ferro é o elemento com número atômico 26.';
          break;
          case 21:
          gifPath = 'assets/gifs/Hidrogenio.gif'; 
          title = 'Hidrogênio';
          explanation = 'Hidrogênio é o elemento com número atômico 1.';
          break;
          case 22:
          gifPath = 'assets/gifs/Hidroxila.gif'; 
          title = 'Hidroxila';
          explanation = 'Hidroxila é um grupo funcional com fórmula química OH-.';
          break;
          case 23:
          gifPath = 'assets/gifs/Litio.gif'; 
          title = 'Lítio';
          explanation = 'Lítio é o elemento com número atômico 3.';
          break;
          case 24:
          gifPath = 'assets/gifs/Magnesio.gif'; 
          title = 'Magnésio';
          explanation = 'Magnésio é o elemento com número atômico 12.';
          break;
          case 25:
          gifPath = 'assets/gifs/Mercurio.gif'; 
          title = 'Mercúrio';
          explanation = 'Mercúrio é o elemento com número atômico 80.';
          break;
          case 26:
          gifPath = 'assets/gifs/Potassio.gif'; 
          title = 'Potássio';
          explanation = 'Potássio é o elemento com número atômico 19.';
          break;
          case 27:
          gifPath = 'assets/gifs/Sodio.gif'; 
          title = 'Sódio';
          explanation = 'Sódio é o elemento com número atômico 11.';
          break;
          case 28:
          gifPath = 'assets/gifs/Sulfato.gif'; 
          title = 'Sulfato';
          explanation = 'Sulfato é um ânion com a fórmula química SO4 2-.';
          break;
          case 29:
          gifPath = 'assets/gifs/Zinco.gif'; 
          title = 'Zinco';
          explanation = 'Zinco é o elemento com número atômico 30.';
          break;

        default:
          title = 'Título do GIF ${index + 1}';
          explanation = 'Texto explicativo para o GIF ${index + 1}';
          break;
      }
    } else {
      
      switch (index) {
        case 0:
          gifPath = 'assets/gifs/Laboratorio_quimico.gif'; 
          title = 'Laboratório Químico';
          explanation = 'O laboratório químico é um espaço dedicado à realização de experimentos e análises.';
          break;
        case 1:
          gifPath = 'assets/gifs/Becker.gif'; 
          title = 'Copo de Becker';
          explanation = 'O Becker é uma vidraria versátil, principalmente usada para fazer reações entre soluções.';
          break;
        case 2:
          gifPath = 'assets/gifs/Erlenmeyer.gif'; 
          title = 'Erlenmeyer';
          explanation = 'O Erlenmeyer é uma vidraria usada para misturar o conteúdo sem derramamento na agitação.';
          break;
        case 3:
          gifPath = 'assets/gifs/Pipeta.gif'; 
          title = 'Pipeta';
          explanation = 'A pipeta é usada para medir volumes com precisão.';
          break;
        case 4:
          gifPath = 'assets/gifs/Proveta.gif'; 
          title = 'Proveta';
          explanation = 'A proveta mede volume de líquidos com baixa precisão.';
          break;
        case 5:
          gifPath = 'assets/gifs/Bureta.gif'; 
          title = 'Bureta';
          explanation = 'A bureta é uma vidraria usada na titulação, mede volumes com precisão.';
          break;
        case 6:
          gifPath = 'assets/gifs/Bico-de-Bunsen.gif'; 
          title = 'Bico de Bunsen';
          explanation = 'O bico de Bunsen é usado para aquecer substâncias por meio da combustão de gás.';
          break;
        case 7:
          gifPath = 'assets/gifs/Balança-Analitica.gif'; 
          title = 'Balança Analítica';
          explanation = 'Uma balança analítica é usada para medir massas com alta precisão, até 0,0001g.';
          break;
        case 8:
          gifPath = 'assets/gifs/Balança-semianalitica.gif'; 
          title = 'Balança Semi-analítica';
          explanation = 'Uma balança semi-analítica mede massas até a casa dos miligramas (0,001g)';
          break;
        case 9:
          gifPath = 'assets/gifs/Espatula.gif'; 
          title = 'Espátula';
          explanation = 'A espátula serve para transferir pequenas quantidades de substâncias sólidas.';
          break;
        case 10:
          gifPath = 'assets/gifs/Grau e Pistilo.gif'; 
          title = 'Grau e Pistilo';
          explanation = 'O grau e pistilo é usado para moer, esmagar ou triturar substâncias sólidas.';
          break;
        case 11:
          gifPath = 'assets/gifs/Termometro.gif'; 
          title = 'Termômetro';
          explanation = 'O termômetro é usado para medir temperaturas.';
          break;
        case 12:
          gifPath = 'assets/gifs/Jaleco.gif'; 
          title = 'Jaleco';
          explanation = 'O jaleco é usado para proteger o usuário de respingos e evitar a contaminação das roupas e da pele.';
          break;
        case 13:
          gifPath = 'assets/gifs/Luvas.gif'; 
          title = 'Luvas de Proteção';
          explanation = 'As luvas protegem as mãos e pulsos do operador de substâncias perigosas para a pele.';
          break;
        case 14:
          gifPath = 'assets/gifs/Óculos de segurança.gif'; 
          title = 'Óculos de Segurança';
          explanation = 'Os óculos protegem os olhos de respingos de substâncias químicas e partículas.';
          break;
        case 15:
          gifPath = 'assets/gifs/Lava Olhos.gif'; 
          title = 'Lava Olhos';
          explanation = 'O lava olhos é usado para lavar os olhos em caso de contato com substâncias tóxicas.';
          break;

        default:
          title = 'Título do GIF ${index + 1}';
          explanation = 'Texto explicativo para o GIF ${index + 1}';
          break;
      }
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Exo'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Image.asset(gifPath),
          const SizedBox(height: 10),
          Text(
            explanation,
            style: const TextStyle(fontSize: 16, fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Fechar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
          fontFamily: 'EXO'
        ),
      ),
    );
  }
}
