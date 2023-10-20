import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webtoon_crawler_app/domain/service/image_service.dart';

import '../../domain/entity/manga_entry.dart';

class MangaCard extends StatefulWidget {
  final MangaEntry mangaEntry;

  const MangaCard({super.key, required this.mangaEntry});

  @override
  _MangaCardState createState() => _MangaCardState();
}

class _MangaCardState extends State<MangaCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  final ImageService imageService = ImageService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mangaEntry.attributes.title;
    final unread = widget.mangaEntry.attributes.unread;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Stack(children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: FutureBuilder<File>(
                      future: imageService.getMangaCoverPath(widget.mangaEntry),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text('No manga entries found.'));
                        } else {
                          return Image.file(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                      })),
            ),
            if (unread)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _animation.value,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
