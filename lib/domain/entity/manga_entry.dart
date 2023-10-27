class MangaEntry {
  final int id;
  final int mangaSourceId;
  final int mangaSeriesId;
  final List<int> userTagIds;
  final MangaAttributes attributes;
  final MangaLinks links;
  final ReadChapter? readChapter;
  final MangaSourceChapter? mangaSourceChapter;

  MangaEntry({
    required this.id,
    required this.mangaSourceId,
    required this.mangaSeriesId,
    required this.userTagIds,
    required this.attributes,
    required this.links,
    required this.readChapter,
    required this.mangaSourceChapter,
  });

  factory MangaEntry.fromJson(Map<String, dynamic> json) {
    return MangaEntry(
      id: json['id'],
      mangaSourceId: json['manga_source_id'],
      mangaSeriesId: json['manga_series_id'],
      userTagIds: List<int>.from(json['user_tag_ids']),
      attributes: MangaAttributes.fromJson(json['attributes']),
      links: MangaLinks.fromJson(json['links']),
      readChapter: json['readChapter'] != null
          ? ReadChapter.fromJson(json['readChapter'])
          : null,
      mangaSourceChapter: json['mangaSourceChapter'] != null
          ? MangaSourceChapter.fromJson(json['mangaSourceChapter'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'manga_source_id': mangaSourceId,
        'manga_series_id': mangaSeriesId,
        'user_tag_ids': userTagIds,
        'attributes': attributes.toJson(),
        'links': links.toJson(),
        'readChapter': readChapter?.toJson(),
        'mangaSourceChapter': mangaSourceChapter?.toJson(),
      };

  @override
  String toString() {
    return attributes.title;
  }
}

class MangaAttributes {
  final String title;
  final MangaCover cover;
  final int status;
  final bool unread;
  final String? lastReadAt;
  final LatestChapter? latestChapter;

  MangaAttributes({
    required this.title,
    required this.cover,
    required this.status,
    required this.unread,
    required this.lastReadAt,
    required this.latestChapter,
  });

  factory MangaAttributes.fromJson(Map<String, dynamic> json) {
    return MangaAttributes(
      title: json['title'],
      cover: MangaCover.fromJson(json['cover']),
      status: json['status'],
      unread: json['unread'],
      lastReadAt: json['last_read_at'],
      latestChapter: json['latestChapter'] != null
          ? LatestChapter.fromJson(json['latestChapter'])
          : null
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'cover': cover.toJson(),
        'status': status,
        'unread': unread,
        'last_read_at': lastReadAt,
        'latestChapter': latestChapter?.toJson(),
      };
}

class MangaCover {
  final ImageUrl webp;
  final ImageUrl jpeg;

  MangaCover({
    required this.webp,
    required this.jpeg,
  });

  factory MangaCover.fromJson(Map<String, dynamic> json) {
    return MangaCover(
      webp: ImageUrl.fromJson(json['webp']),
      jpeg: ImageUrl.fromJson(json['jpeg']),
    );
  }

  Map<String, dynamic> toJson() => {
        'webp': webp.toJson(),
        'jpeg': jpeg.toJson(),
      };
}

class ImageUrl {
  final String large;
  final String small;

  ImageUrl({
    required this.large,
    required this.small,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) {
    return ImageUrl(
      large: json['large'],
      small: json['small'],
    );
  }

  Map<String, dynamic> toJson() => {
        'large': large,
        'small': small,
      };
}

class LatestChapter {
  final int id;
  final String url;
  final String chapterIdentifier;
  final double? volume;
  final double chapter;
  final String? title;
  final String releasedAt;
  final dynamic locked;

  LatestChapter({
    required this.id,
    required this.url,
    required this.chapterIdentifier,
    required this.volume,
    required this.chapter,
    required this.title,
    required this.releasedAt,
    required this.locked,
  });

  factory LatestChapter.fromJson(Map<String, dynamic> json) {
    return LatestChapter(
      id: json['id'],
      url: json['url'],
      chapterIdentifier: json['chapterIdentifier'],
      volume: json['volume'],
      chapter: json['chapter'],
      title: json['title'],
      releasedAt: json['releasedAt'],
      locked: json['locked'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'chapterIdentifier': chapterIdentifier,
        'volume': volume,
        'chapter': chapter,
        'title': title,
        'releasedAt': releasedAt,
        'locked': locked,
      };
}

class MangaLinks {
  final String seriesUrl;
  final String mangaSeriesUrl;

  MangaLinks({
    required this.seriesUrl,
    required this.mangaSeriesUrl,
  });

  factory MangaLinks.fromJson(Map<String, dynamic> json) {
    return MangaLinks(
      seriesUrl: json['series_url'],
      mangaSeriesUrl: json['manga_series_url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'series_url': seriesUrl,
        'manga_series_url': mangaSeriesUrl,
      };
}

class ReadChapter {
  final double? volume;
  final double chapter;
  final String? title;

  ReadChapter({
    required this.volume,
    required this.chapter,
    required this.title,
  });

  factory ReadChapter.fromJson(Map<String, dynamic> json) {
    return ReadChapter(
      volume: json['volume'],
      chapter: json['chapter'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
        'volume': volume,
        'chapter': chapter,
        'title': title,
      };
}

class MangaSourceChapter {
  final int id;
  final String url;
  final String chapterIdentifier;
  final double? volume;
  final double chapter;
  final String? title;
  final String releasedAt;
  final dynamic locked;

  MangaSourceChapter({
    required this.id,
    required this.url,
    required this.chapterIdentifier,
    required this.volume,
    required this.chapter,
    required this.title,
    required this.releasedAt,
    required this.locked,
  });

  factory MangaSourceChapter.fromJson(Map<String, dynamic> json) {
    return MangaSourceChapter(
      id: json['id'],
      url: json['url'],
      chapterIdentifier: json['chapterIdentifier'],
      volume: json['volume'],
      chapter: json['chapter'],
      title: json['title'],
      releasedAt: json['releasedAt'],
      locked: json['locked'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'chapterIdentifier': chapterIdentifier,
        'volume': volume,
        'chapter': chapter,
        'title': title,
        'releasedAt': releasedAt,
        'locked': locked,
      };
}
