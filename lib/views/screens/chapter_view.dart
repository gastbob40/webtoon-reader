import 'package:flutter/cupertino.dart';

import '../../domain/entity/chapter_entry.dart';
import '../../domain/service/ApiService.dart';

class ChapterPage extends StatefulWidget {
  final ChapterEntry chapterEntry;

  ChapterPage({required this.chapterEntry});

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  final ApiService apiService = ApiService();
  late Future<List<String>> futureImage;

  @override
  void initState() {
    super.initState();
    futureImage = apiService.getImagesFromPage(widget.chapterEntry.url);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Chapter ${widget.chapterEntry.chapter}'),
        ),
        child: FutureBuilder<List<String>>(
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
                      final imageUrl = images[index];
                      return ImageContainer(imageUrl: imageUrl);
                    });
              }
            }));
  }
}

class ImageContainer extends StatelessWidget {
  final String imageUrl;

  const ImageContainer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return const Center(
        child: CupertinoActivityIndicator(
          animating: true,
          radius: 20.0,
        ),
      );
    });
  }
}
