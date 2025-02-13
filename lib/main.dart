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
      {'name': 'Naruto', 'folder': 'naruto'},
      {'name': 'One Piece', 'folder': 'one_piece'},
      {'name': 'Attack on Titan', 'folder': 'aot'},
      {'name': 'Demon Slayer', 'folder': 'demon_slayer'},
      {'name': 'Dragon Ball', 'folder': 'dbz'},
      {'name': 'Tokyo Ghoul', 'folder': 'tokyo_ghoul'},
      {'name': 'Death Note', 'folder': 'death_note'},
      {'name': 'Bleach', 'folder': 'bleach'},
      {'name': 'Jujutsu Kaisen', 'folder': 'jjk'},
      {'name': 'Hunter x Hunter', 'folder': 'hxh'},
    ];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 cards per row
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
          childAspectRatio: 0.5,
        ),
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          final manga = mangaList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaReaderScreen(mangaName: manga['name']!, folderName: manga['folder']!),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/manga/${manga['folder']}/cover.jpg',
                    fit: BoxFit.cover,
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
                    color: Colors.black54,
                    child: Text(
                      manga['name']!,
                      style: const TextStyle(
                        fontSize: 8,
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
  final String folderName;
  const MangaReaderScreen({Key? key, required this.mangaName, required this.folderName}) : super(key: key);

  @override
  _MangaReaderScreenState createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends State<MangaReaderScreen> {
  List<String> pages = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadMangaPages();
  }

  Future<void> _loadMangaPages() async {
    String mangaPath = 'assets/manga/${widget.folderName}';

    List<String> possiblePages = List.generate(20, (index) => '$mangaPath/page_${index + 1}.jpg');

    setState(() {
      pages = possiblePages;
    });
  }

  void _goToNextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
      });
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.mangaName} - Page ${currentPage + 1}')),
      body: pages.isNotEmpty
          ? GestureDetector(
        onTapUp: (details) {
          double screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx > screenWidth / 2) {
            _goToNextPage(); // Tap Right → Next Page
          } else {
            _goToPreviousPage(); // Tap Left → Previous Page
          }
        },
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                pages[currentPage],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Изображение не найдено'));
                },
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Page ${currentPage + 1} of ${pages.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
