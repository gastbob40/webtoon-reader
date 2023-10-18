class ChapterEntry {
  final int id;
  final String url;
  final String chapterIdentifier;
  final double? volume;
  final double chapter;
  final String?title;
  final DateTime releasedAt;
  final dynamic locked;

  ChapterEntry({
    required this.id,
    required this.url,
    required this.chapterIdentifier,
    required this.volume,
    required this.chapter,
    required this.title,
    required this.releasedAt,
    required this.locked,
  });

  factory ChapterEntry.fromJson(Map<String, dynamic> json) {
    return ChapterEntry(
      id: json['id'],
      url: json['url'],
      chapterIdentifier: json['chapterIdentifier'],
      volume: (json['volume'] != null) ? json['volume'].toDouble() : null,
      chapter: json['chapter'].toDouble(),
      title: json['title'],
      releasedAt: DateTime.parse(json['releasedAt']),
      locked: json['locked'],
    );
  }

  @override
  String toString() {
    return title ?? chapterIdentifier;
  }
}