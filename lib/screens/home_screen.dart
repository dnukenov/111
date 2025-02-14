import 'package:flutter/material.dart';
import '../models/manga_model.dart';
import 'manga_reader_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MangaModel> mangaList = [
      MangaModel(name: 'Naruto', folder: 'naruto'),
      MangaModel(name: 'One Piece', folder: 'one_piece'),
      MangaModel(name: 'Attack on Titan', folder: 'aot'),
      MangaModel(name: 'Demon Slayer', folder: 'demon_slayer'),
      MangaModel(name: 'Dragon Ball', folder: 'dbz'),
      MangaModel(name: 'Tokyo Ghoul', folder: 'tokyo_ghoul'),
      MangaModel(name: 'Death Note', folder: 'death_note'),
      MangaModel(name: 'Bleach', folder: 'bleach'),
      MangaModel(name: 'Jujutsu Kaisen', folder: 'jjk'),
      MangaModel(name: 'Hunter x Hunter', folder: 'hxh'),
    ];

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
