import 'package:flutter/material.dart';
import '../models/manga_model.dart';
import 'manga_reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  final List<MangaModel> mangaList = [
    // Manga (Japanese)
    MangaModel(name: 'Naruto', folder: 'naruto'),
    MangaModel(name: 'One Piece', folder: 'one_piece'),
    MangaModel(name: 'Attack on Titan', folder: 'aot'),
    MangaModel(name: 'Demon Slayer', folder: 'demon_slayer'),
    MangaModel(name: 'Dragon Ball', folder: 'dbz'),
    MangaModel(name: 'Bleach', folder: 'bleach'),
    MangaModel(name: 'Jujutsu Kaisen', folder: 'jjk'),
    MangaModel(name: 'Hunter x Hunter', folder: 'hxh'),
    MangaModel(name: 'Death Note', folder: 'death_note'),
    MangaModel(name: 'Tokyo Ghoul', folder: 'tokyo_ghoul'),

    // Manhua (Chinese)
    MangaModel(name: 'The King\'s Avatar', folder: 'kings_avatar'),
    MangaModel(name: 'Tales of Demons and Gods', folder: 'tdg'),
    MangaModel(name: 'Battle Through the Heavens', folder: 'btth'),
    MangaModel(name: 'Soul Land', folder: 'soul_land'),
    MangaModel(name: 'Martial Peak', folder: 'martial_peak'),

    // Manhwa (Korean)
    MangaModel(name: 'Solo Leveling', folder: 'solo_leveling'),
    MangaModel(name: 'The Beginning After The End', folder: 'tbate'),
    MangaModel(name: 'Tower of God', folder: 'tower_of_god'),
    MangaModel(name: 'Noblesse', folder: 'noblesse'),
    MangaModel(name: 'God of High School', folder: 'gohs'),
  ];

  List<MangaModel> filterManga(String category) {
    switch (category) {
      case 'Manga':
        return mangaList.where((manga) => ['naruto', 'one_piece', 'aot', 'demon_slayer', 'dbz', 'bleach', 'jjk', 'hxh', 'death_note', 'tokyo_ghoul'].contains(manga.folder)).toList();
      case 'Manhua':
        return mangaList.where((manga) => ['kings_avatar', 'tdg', 'btth', 'soul_land', 'martial_peak'].contains(manga.folder)).toList();
      case 'Manhwa':
        return mangaList.where((manga) => ['solo_leveling', 'tbate', 'tower_of_god', 'noblesse', 'gohs'].contains(manga.folder)).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Manga'),
            Tab(text: 'Manhua'),
            Tab(text: 'Manhwa'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMangaGrid(filterManga('Manga')),
              _buildMangaGrid(filterManga('Manhua')),
              _buildMangaGrid(filterManga('Manhwa')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMangaGrid(List<MangaModel> mangaList) {
    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
        childAspectRatio: 0.5,
      ),
      itemCount: mangaList.length,
      itemBuilder: (context, index) {
        final manga = mangaList[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MangaReaderScreen(
                mangaName: manga.name,
                folderName: manga.folder,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/manga/${manga.folder}/cover.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 20),
                      ),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(2),
                  color: Colors.black54,
                  child: Text(
                    manga.name,
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
    );
  }
}
