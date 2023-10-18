import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../domain/entity/chapter_entry.dart';
import '../../domain/entity/manga_entry.dart';
import '../../domain/service/ApiService.dart';
import 'chapter_view.dart';

class MangaChapterView extends StatefulWidget {
  final MangaEntry mangaEntry;

  const MangaChapterView({super.key, required this.mangaEntry});

  @override
  _MangaChapterViewState createState() => _MangaChapterViewState();
}

class _MangaChapterViewState extends State<MangaChapterView> {
  final ApiService apiService = ApiService();
  late Future<List<ChapterEntry>> futureChapters;

  @override
  void initState() {
    super.initState();
    futureChapters = apiService.getChapters(widget.mangaEntry.mangaSourceId);
  }

  Widget _buildIndicator(ChapterEntry chapter) {
    if (chapter.locked != null) {
      return const Icon(Icons.lock, color: Colors.red);
    }
    final readChapter = widget.mangaEntry.readChapter?.chapter ?? -1;

    return readChapter >= chapter.chapter
        ? const Icon(Icons.check_circle, color: Colors.green)
        : const Row(
            children: [Icon(Icons.download), Icon(Icons.download_done)]);
  }

  Widget _buildChapterRow(ChapterEntry chapter) {
    return GestureDetector(
      onTap: () {
        apiService.getImagesFromPage(chapter.url).then((value) => {
              Fluttertoast.showToast(
                  msg: "Got ${value.length} images",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  fontSize: 16.0)
            });
      }, // Disabled if chapter is locked
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chapter ${chapter.chapter}',
              style: TextStyle(
                color: chapter.locked != null
                    ? CupertinoColors.systemGrey
                    : CupertinoColors.activeBlue,
              ),
            ),
            _buildIndicator(chapter),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.mangaEntry.attributes.title),
      ),
      child: SafeArea(
          child: FutureBuilder<List<ChapterEntry>>(
              future: futureChapters,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No chapter found.'));
                } else {
                  final chapters = snapshot.data!;
                  return ListView.builder(
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      return _buildChapterRow(chapter);
                    },
                  );
                }
              })),
    );
  }
}
