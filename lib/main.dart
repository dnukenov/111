import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Reader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  final List<Widget> _pages = [const ProfileScreen(), const HomeScreen(), const FavoritesScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/avatar.png')),
          SizedBox(height: 10),
          Text('Никнейм пользователя', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mangaList = [
      {'name': 'Naruto', 'image': 'assets/manga/naruto/Naruto.jpg'},
      {'name': 'One Piece', 'image': 'assets/manga/one_piece/op.jpg'},
      {'name': 'Attack on Titan', 'image': 'assets/manga/aot/aot.jpg'},
      {'name': 'Demon Slayer', 'image': 'assets/manga/demon_slayer/dem_.jpg'},
      {'name': 'Dragon Ball', 'image': 'assets/manga/dbz/drb.jpg'},
      {'name': 'Tokyo Ghoul', 'image': 'assets/manga/tokyo_ghoul/tg.jpg'},
      {'name': 'Death Note', 'image': 'assets/manga/death_note/dth.jpg'},
      {'name': 'Bleach', 'image': 'assets/manga/bleach/bl.jpg'},
      {'name': 'Jujutsu Kaisen', 'image': 'assets/manga/jjk/jk.jpg'},
      {'name': 'Hunter x Hunter', 'image': 'assets/manga/hxh/hxh.jpg'},
    ];

    return Padding(
      padding: const EdgeInsets.all(4.0), // Минимальный отступ
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Теперь 4 карточки в ряд
          crossAxisSpacing: 3.0, // Минимальные отступы
          mainAxisSpacing: 3.0,
          childAspectRatio: 0.5, // Карточки стали ещё меньше
        ),
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          final manga = mangaList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaReaderScreen(mangaName: manga['name']!),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5), // Округлённые углы
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    manga['image']!,
                    fit: BoxFit.cover, // Теперь изображение полностью покрывает карточку
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image, size: 20)),
                      );
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(2),
                    color: Colors.black54, // Затемнённый фон под текст
                    child: Text(
                      manga['name']!,
                      style: const TextStyle(
                        fontSize: 8, // Минимальный шрифт
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Избранные манги', style: TextStyle(fontSize: 20)),
    );
  }
}

class MangaReaderScreen extends StatefulWidget {
  final String mangaName;
  const MangaReaderScreen({Key? key, required this.mangaName}) : super(key: key);

  @override
  _MangaReaderScreenState createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends State<MangaReaderScreen> {
  late List<String> pages;

  @override
  void initState() {
    super.initState();
    pages = List.generate(
      10, // Предполагаем 10 страниц на мангу
          (index) => 'assets/manga/${widget.mangaName}/page_${index + 1}.jpg',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mangaName)),
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return Image.asset(
            pages[index],
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Изображение не найдено'));
            },
          );
        },
      ),
    );
  }
}
