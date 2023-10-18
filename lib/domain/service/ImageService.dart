import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:webtoon_crawler_app/domain/entity/manga_entry.dart';
import 'package:http/http.dart' as http;

class ImageService {
  Future<String> downloadMangaCover(MangaEntry mangaEntry) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/manga-covers/${mangaEntry.mangaSourceId}.webp';

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
    var filePath = '${directory.path}/manga-covers/${mangaEntry.mangaSourceId}.webp';
    return File(filePath);
  }
}