import 'package:flutter/material.dart';

import '../../logic/models/note_model.dart';
import '../views/edit_view.dart';

class TaskCard extends StatelessWidget {
  final NoteModel noteModel;
  final VoidCallback onDelete;

  const TaskCard({super.key, required this.noteModel, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditScreen(noteModel: noteModel),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: ListTile(
          title: Text(
            noteModel.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(noteModel.date),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
