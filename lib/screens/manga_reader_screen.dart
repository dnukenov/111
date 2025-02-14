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
    pages = await MangaService.loadMangaPages(widget.folderName);
    setState(() {});
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
          : Column(
        children: [
          Expanded(
            child: Image.asset(
              pages[currentPage],
              fit: BoxFit.contain,
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
    );
  }
}
