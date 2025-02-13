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
      {'name': 'Naruto', 'image': 'assets/manga/Naruto.jpg'},
      {'name': 'One Piece', 'image': 'assets/manga/op.jpg'},
      {'name': 'Attack on Titan', 'image': 'assets/manga/aot.jpg'},
      {'name': 'Demon Slayer', 'image': 'assets/manga/dem_.jpg'},
      {'name': 'Dragon Ball', 'image': 'assets/manga/drb.jpg'},
      {'name': 'Tokyo Ghoul', 'image': 'assets/manga/tg.jpg'},
      {'name': 'Death Note', 'image': 'assets/manga/dth.jpg'},
      {'name': 'Bleach', 'image': 'assets/manga/bl.jpg'},
      {'name': 'Jujutsu Kaisen', 'image': 'assets/manga/jk.jpg'},
      {'name': 'Hunter x Hunter', 'image': 'assets/manga/hxh.jpg'},
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Количество колонок
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.75, // Изменение пропорций карточки
      ),
      itemCount: mangaList.length,
      itemBuilder: (context, index) {
        final manga = mangaList[index];
        return Card(
          color: manga['image'] == '' ? Colors.grey : null, // Серый цвет, если нет изображения
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Если есть изображение, показываем его
              manga['image'] != ''
                  ? AspectRatio(
                      aspectRatio: 1, // Подстраиваем изображение к квадратной карточке
                      child: Image.asset(manga['image']!, fit: BoxFit.cover),
                    )
                  : Container(height: 80, color: Colors.grey), // Серый контейнер, если нет изображения
              const SizedBox(height: 10),
              Text(
                manga['name']!,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Меньший размер шрифта
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
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
