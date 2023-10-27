import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webtoon_crawler_app/main.dart';

import '../../domain/entity/manga_entry.dart';
import '../../domain/service/api_service.dart';
import '../../exceptions/unauthorized_exception.dart';
import '../widget/manga_card.dart';
import 'chapters_view.dart';
import 'login_view.dart';

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

  Widget _buildSkeletonCard() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
                height: 15,  // Approximate size of the text
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSkeletonLayout(int itemCount) {
    return SingleChildScrollView(
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr],
        rowSizes: List.generate(itemCount ~/ 2, (index) => auto),
        children: List.generate(itemCount, (index) {
          return GridPlacement(
            columnStart: index % 2,
            rowStart: index ~/ 2,
            child: _buildSkeletonCard(),
          );
        }),
      ),
    );
  }

  Widget buildFutureManga() {
    return FutureBuilder<List<MangaEntry>>(
        future: futureMangaEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonLayout(6);
          } else if (snapshot.hasError) {
            if (snapshot.error is UnauthorizedException) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              });

              return const Center(child: Text('Unauthorized'));
            } else {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

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
