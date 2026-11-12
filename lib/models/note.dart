/// Model data untuk merepresentasikan catatan kuliah.
class Note {
  final String id;
  final String title;
  final DateTime date;
  final String? content; 
  Note({
    required this.id,
    required this.title,
    required this.date,
    this.content,
  });

  /// Mengubah metadata catatan ke format Map (JSON) 
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
      };

  /// Membuat objek Note dari Map (JSON).
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
      );
}