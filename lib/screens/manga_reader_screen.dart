import 'package:flutter/material.dart';
import '../services/manga_service.dart';

class MangaReaderScreen extends StatefulWidget {
  final String mangaName;
  final String folderName;

  const MangaReaderScreen({super.key, required this.mangaName, required this.folderName});

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
    try {
      pages = await MangaService.loadMangaPages(widget.folderName);
      setState(() {});
    } catch (e) {
      print("Error loading manga pages: $e");
    }
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
      appBar: AppBar(title: Text(widget.mangaName)),
      body: pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _goToNextPage(); // Swipe left to go forward
          } else if (details.primaryVelocity! > 0) {
            _goToPreviousPage(); // Swipe right to go back
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                pages[currentPage],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.broken_image, size: 50));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goToPreviousPage,
                ),
                Text("${currentPage + 1}/${pages.length}"),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _goToNextPage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
