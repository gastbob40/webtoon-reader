import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon_crawler_app/domain/entity/chapter_entry.dart';
import 'package:webtoon_crawler_app/domain/entity/manga_entry.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webtoon_crawler_app/domain/service/ImageService.dart';

class ApiService {
  final _baseUrl = 'http://localhost:8000';
  final Dio _dio;
  final ImageService imageService = ImageService();

  final _mangaEntriesKey = 'manga_entries';
  final _chaptersEntryKey = 'chapters_entry_';

  ApiService() : _dio = Dio();

  Future<List<MangaEntry>> getMangaEntries() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    return connectivityResult == ConnectivityResult.none
        ? _fetchMangaEntriesFromLocalStorage()
        : _fetchMangaEntriesFromAPI();
  }

  Future<List<MangaEntry>> _fetchMangaEntriesFromAPI() async {
    try {
      final response = await _dio.get('$_baseUrl/manga_entries');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final List<MangaEntry> mangaEntries =
            jsonList.map((jsonData) => MangaEntry.fromJson(jsonData)).toList();

        final prefs = await SharedPreferences.getInstance();
        final jsonData =
            json.encode(mangaEntries.map((e) => e.toJson()).toList());
        await prefs.setString(_mangaEntriesKey, jsonData);

        await Future.wait(
            mangaEntries.map((e) => imageService.downloadMangaCover(e)));

        return mangaEntries;
      } else {
        throw Exception('Failed to load manga entries');
      }
    } catch (e) {
      throw Exception('Error fetching manga entries: $e');
    }
  }

  Future<List<MangaEntry>> _fetchMangaEntriesFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMangaEntries = prefs.getString(_mangaEntriesKey);

    if (savedMangaEntries == null) return [];

    return json.decode(savedMangaEntries);
  }

  Future<List<ChapterEntry>> getChapters(int mangaSourceId) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    return connectivityResult == ConnectivityResult.none
        ? _fetchChaptersFromLocalStorage(mangaSourceId)
        : _fetchChaptersFromAPI(mangaSourceId);
  }

  Future<List<ChapterEntry>> _fetchChaptersFromAPI(int mangaSourceId) async {
    try {
      final response = await _dio.get('$_baseUrl/chapters/$mangaSourceId');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final List<ChapterEntry> chapters = jsonList
            .map((jsonData) => ChapterEntry.fromJson(jsonData))
            .toList();

        chapters.sort((a, b) => b.chapter.compareTo(a.chapter));

        final prefs = await SharedPreferences.getInstance();
        final jsonData = json.encode(chapters.map((e) => e.toJson()).toList());
        await prefs.setString('$_chaptersEntryKey$mangaSourceId', jsonData);

        return chapters;
      } else {
        throw Exception('Failed to load chapters');
      }
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }

  Future<List<ChapterEntry>> _fetchChaptersFromLocalStorage(
      int mangaSourceId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedChapters = prefs.getString('$_chaptersEntryKey$mangaSourceId');

    if (savedChapters == null) return [];

    List<dynamic> chapters = json.decode(savedChapters);

    return chapters.map((e) => ChapterEntry.fromJson(e)).toList();
  }

  Future<List<String>> getImagesFromPage(String page) async {
    try {
      final response = await _dio.get('$_baseUrl/images?link=$page');
      if (response.statusCode == 200) {
        // return as a list of string
        return response.data.map<String>((e) => e.toString()).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }
}
