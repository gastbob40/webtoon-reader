import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webtoon_crawler_app/domain/service/image_service.dart';

import '../../domain/entity/chapter_entry.dart';
import '../../domain/service/api_service.dart';

class ChapterPage extends StatefulWidget {
  final ChapterEntry chapterEntry;

  ChapterPage({required this.chapterEntry});

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  final ApiService apiService = ApiService();
  final ImageService imageService = ImageService();
  late Future<List<File>> futureImage;

  @override
  void initState() {
    super.initState();
    futureImage = imageService.getChapterImages(widget.chapterEntry);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Chapter ${widget.chapterEntry.chapter}'),
        ),
        child: FutureBuilder<List<File>>(
            future: futureImage,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No chapter found.'));
              } else {
                final images = snapshot.data!;
                return ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final imageFile = images[index];
                      return Image.file(
                        imageFile,
                        fit: BoxFit.contain,
                      );
                    });
              }
            }));
  }
}
