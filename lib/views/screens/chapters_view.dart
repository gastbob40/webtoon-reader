import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webtoon_crawler_app/domain/service/image_service.dart';
import 'package:webtoon_crawler_app/views/widget/chapter_row.dart';

import '../../domain/entity/chapter_entry.dart';
import '../../domain/entity/manga_entry.dart';
import '../../domain/service/api_service.dart';
import 'chapter_view.dart';

class MangaChapterView extends StatefulWidget {
  final MangaEntry mangaEntry;

  const MangaChapterView({super.key, required this.mangaEntry});

  @override
  _MangaChapterViewState createState() => _MangaChapterViewState();
}

class _MangaChapterViewState extends State<MangaChapterView> {
  final ApiService apiService = ApiService();
  final ImageService imageService = ImageService();
  late Future<List<ChapterEntry>> futureChapters;
  Set<int> loadingChapters = <int>{};

  @override
  void initState() {
    super.initState();
    futureChapters = apiService.getChapters(widget.mangaEntry.mangaSourceId);
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
                      return MangaChapterRow(
                          chapter: chapter, manga: widget.mangaEntry);
                    },
                  );
                }
              })),
    );
  }
}
