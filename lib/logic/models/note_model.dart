import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 1)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String date;
  @HiveField(2)
  String? firestoreId;  // Add this field

  NoteModel({required this.title, required this.date, this.firestoreId});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'firestoreId': firestoreId,
    };
  }

  static NoteModel fromMap(Map<String, dynamic> map) {
    return NoteModel(
      title: map['title'],
      date: map['date'],
      firestoreId: map['firestoreId'],
    );
  }
}
