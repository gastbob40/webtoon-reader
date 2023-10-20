import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:webtoon_crawler_app/domain/entity/chapter_entry.dart';
import 'package:webtoon_crawler_app/domain/entity/manga_entry.dart';
import 'package:http/http.dart' as http;

class ImageService {
  Future<String> downloadMangaCover(MangaEntry mangaEntry) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath =
        '${directory.path}/manga-covers/${mangaEntry.mangaSourceId}.webp';

    var uri = Uri.parse(mangaEntry.attributes.cover.webp.large);
    var response = await http.get(uri);

    if (!Directory('${directory.path}/manga-covers').existsSync()) {
      Directory('${directory.path}/manga-covers').createSync(recursive: true);
    }

    if (response.statusCode == 200) {
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download manga cover');
    }
  }

  Future<File> getMangaCoverPath(MangaEntry mangaEntry) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath =
        '${directory.path}/manga-covers/${mangaEntry.mangaSourceId}.webp';
    return File(filePath);
  }

  Future<String> downloadChapterImages(
      ChapterEntry chapterEntry, List<String> images) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/chapter-images/${chapterEntry.id}/';

    if (!Directory('${directory.path}/chapter-images/${chapterEntry.id}')
        .existsSync()) {
      Directory('${directory.path}/chapter-images/${chapterEntry.id}')
          .createSync(recursive: true);
    }

    var i = 0;

    for (var image in images) {
      var extension = image.substring(image.lastIndexOf('.'));

      var uri = Uri.parse(image);
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        File file = File('$filePath$i$extension');
        await file.writeAsBytes(response.bodyBytes);
      } else {
        throw Exception('Failed to download chapter image');
      }

      i++;
    }

    return filePath;
  }

  Future<bool> isChapterDownloaded(ChapterEntry chapterEntry) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/chapter-images/${chapterEntry.id}/';

    return Directory(filePath).existsSync();
  }

  Future<List<File>> getChapterImages(ChapterEntry chapterEntry) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/chapter-images/${chapterEntry.id}/';

    var files = Directory(filePath).listSync();
    files.sort((a, b) {
      // Extract the file name without extension
      String fileNameA = a.path.split('/').last.split('.').first;
      String fileNameB = b.path.split('/').last.split('.').first;

      // Convert the file names to numbers
      int numberA = int.tryParse(fileNameA) ?? 0;
      int numberB = int.tryParse(fileNameB) ?? 0;

      // Compare the numbers
      return numberA.compareTo(numberB);
    });

    print(files);

    return files
        .map((e) => File(e.path))
        .toList();
  }
}
