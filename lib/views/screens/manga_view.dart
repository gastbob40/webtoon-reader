import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:webtoon_crawler_app/main.dart';

import '../../domain/entity/manga_entry.dart';
import '../../domain/service/api_service.dart';
import '../widget/manga_card.dart';
import 'chapters_view.dart';

class MangaEntriesScreen extends StatefulWidget {
  const MangaEntriesScreen({super.key});

  @override
  _MangaEntriesScreenState createState() => _MangaEntriesScreenState();
}

class _MangaEntriesScreenState extends State<MangaEntriesScreen> {
  final ApiService apiService = ApiService();
  late Future<List<MangaEntry>> futureMangaEntries;

  @override
  void initState() {
    super.initState();
    futureMangaEntries = apiService.getMangaEntries();
  }

  Widget buildFutureManga() {
    return FutureBuilder<List<MangaEntry>>(
        future: futureMangaEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No manga entries found.'));
          } else {
            return SingleChildScrollView(
              child: LayoutGrid(
                  columnSizes: [1.fr, 1.fr],
                  // Adjust as needed for your design
                  rowSizes: List.generate(
                      snapshot.data!.length ~/ 2, (index) => auto),
                  // Automatic row sizes
                  children: [
                    for (var index = 0; index < snapshot.data!.length; index++)
                      GridPlacement(
                          columnStart: index % 2,
                          rowStart: index ~/ 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => MangaChapterView(
                                    mangaEntry: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            child: MangaCard(
                              mangaEntry: snapshot.data![index],
                            ),
                          ))
                  ]),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Manga Entries'),
      ),
      child: SafeArea(child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              setState(() {
                futureMangaEntries = apiService.getMangaEntries();
              });
            },
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: buildFutureManga(),
          )
        ],
      )),
    );
  }
}
