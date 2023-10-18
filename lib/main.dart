import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webtoon_crawler_app/views/screens/manga_view.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: MangaEntriesScreen(),
    );
  }
}
