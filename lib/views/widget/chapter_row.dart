import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webtoon_crawler_app/domain/entity/chapter_entry.dart';
import 'package:webtoon_crawler_app/domain/entity/manga_entry.dart';
import 'package:webtoon_crawler_app/domain/service/api_service.dart';
import 'package:webtoon_crawler_app/domain/service/image_service.dart';

import '../screens/chapter_view.dart';

class MangaChapterRow extends StatefulWidget {
  final MangaEntry manga;
  final ChapterEntry chapter;

  const MangaChapterRow(
      {super.key, required this.manga, required this.chapter});

  @override
  _MangaChapterRowState createState() => _MangaChapterRowState();
}

class _MangaChapterRowState extends State<MangaChapterRow> {
  final ImageService imageService = ImageService();

  @override
  void initState() {
    super.initState();
  }

  void onChapterTapped(BuildContext context) {
    final chapter = widget.chapter;
    imageService.isChapterDownloaded(chapter).then((isDownloaded) => {
      if (isDownloaded) {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => ChapterPage(chapterEntry: chapter)))
      } else {
        Fluttertoast.showToast(msg: "You must download the chapter first")
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;
    final manga = widget.manga;

    return GestureDetector(
      onTap: () => onChapterTapped(context),
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
            MangaChapterIndicator(chapter: chapter, manga: manga),
          ],
        ),
      ),
    );
  }
}

class MangaChapterIndicator extends StatefulWidget {
  final ChapterEntry chapter;
  final MangaEntry manga;

  const MangaChapterIndicator(
      {super.key, required this.manga, required this.chapter});

  @override
  _MangaChapterIndicatorState createState() => _MangaChapterIndicatorState();
}

class _MangaChapterIndicatorState extends State<MangaChapterIndicator> {
  final ImageService imageService = ImageService();
  final ApiService apiService = ApiService();

  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildDownloadIndicator(ChapterEntry chapter) {
    return FutureBuilder<bool>(
      future: imageService.isChapterDownloaded(chapter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.download);
        } else if (!snapshot.hasData) {
          return const Icon(Icons.download);
        } else {
          final isDownloaded = snapshot.data!;
          return GestureDetector(
              onTap: () {
                if (!isDownloaded) {
                  setState(() {
                    isDownloading = true;
                  });

                  Fluttertoast.showToast(msg: "Getting chapter images");

                  apiService.getImagesFromPage(chapter.url).then((imageUrls) async => {
                    Fluttertoast.showToast(msg: "Downloading chapter images"),
                    await imageService.downloadChapterImages(chapter, imageUrls),

                    setState(() {
                      isDownloading = false;
                    }),

                    Fluttertoast.showToast(msg: "Chapter images downloaded"),
                  });
                }
              },
              child: isDownloaded
                  ? const Icon(CupertinoIcons.cloud_fill)
                  : const Icon(CupertinoIcons.cloud_download));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;
    final manga = widget.manga;

    if (chapter.locked != null) {
      return const Icon(Icons.lock, color: Colors.red);
    }
    final readChapter = manga.readChapter?.chapter ?? -1;

    final downloadIndicator = isDownloading
        ? const CupertinoActivityIndicator()
        : _buildDownloadIndicator(chapter);

    return readChapter >= chapter.chapter
        ? Row(children: [
            downloadIndicator,
            SizedBox.fromSize(size: const Size(5, 0)),
            const Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green),
          ])
        : downloadIndicator;
  }
}
