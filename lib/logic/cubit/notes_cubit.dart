import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/note_model.dart';

part 'notes_state.dart';

// class NotesCubit extends Cubit<NotesState> {
//   NotesCubit() : super(NotesInitial()) {
//     getNotes(); // Load notes when the cubit is created
//   }

//   List<NoteModel>? notes;

//   void addNote(NoteModel noteModel) async {
//     emit(AddNoteLoadingState());
//     try {
//       var notesBox = await Hive.openBox<NoteModel>('notes');
//       await notesBox.add(noteModel);

//       // Add note to Firestore
//       await FirebaseFirestore.instance.collection('notes').add(noteModel.toMap());

//       getNotes(); // Fetch notes after adding a new one
//     } catch (e) {
//       emit(AddNoteErrorState(e.toString()));
//     }
//   }

//   void getNotes() async {
//     try {
//       var notesBox = Hive.box<NoteModel>('notes');
//       notes = notesBox.values.toList();

//       // Fetch notes from Firestore

//       emit(NotesLoadedState(notes!)); // Emit a state with the loaded notes
//     } catch (e) {
//       emit(AddNoteErrorState(e.toString()));
//     }
//   }

//   void deleteNoteAt(int index) async {
//     try {
//       var notesBox = Hive.box<NoteModel>('notes');
//       var note = notes![index];
//       await notesBox.deleteAt(index);

//       // Delete note from Firestore
//       var firestoreNotes = await FirebaseFirestore.instance
//           .collection('notes')
//           .where('title', isEqualTo: note.title)
//           .where('date', isEqualTo: note.date)
//           .get();
//       for (var doc in firestoreNotes.docs) {
//         await doc.reference.delete();
//       }

//       getNotes(); // Fetch notes after deleting one
//     } catch (e) {
//       emit(AddNoteErrorState(e.toString()));
//     }
//   }

//   void updateNote(int key, NoteModel updatedNote) async {
//     try {
//       var notesBox = Hive.box<NoteModel>('notes');
//       await notesBox.put(key, updatedNote);

//       // Update note in Firestore
//       var firestoreNotes = await FirebaseFirestore.instance
//           .collection('notes')
//           .where('title', isEqualTo: updatedNote.title)
//           .where('date', isEqualTo: updatedNote.date)
//           .get();
//       for (var doc in firestoreNotes.docs) {
//         await doc.reference.update(updatedNote.toMap());
//       }

//       getNotes(); // Fetch notes after updating one
//     } catch (e) {
//       emit(AddNoteErrorState(e.toString()));
//     }
//   }
// }
class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial()) {
    getNotes(); // Load notes when the cubit is created
  }

  List<NoteModel>? notes;

  void addNote(NoteModel noteModel) async {
    emit(AddNoteLoadingState());
    try {
      var notesBox = await Hive.openBox<NoteModel>('notes');
      var noteIndex = await notesBox.add(noteModel);

      // Add note to Firestore
      var docRef = await FirebaseFirestore.instance
          .collection('notes')
          .add(noteModel.toMap());

      // Update noteModel with Firestore document ID and store it back in Hive
      noteModel.firestoreId = docRef.id;
      await notesBox.put(noteIndex, noteModel);

      getNotes(); // Fetch notes after adding a new one
    } catch (e) {
      emit(AddNoteErrorState(e.toString()));
    }
  }

  void getNotes() async {
    try {
      var notesBox = Hive.box<NoteModel>('notes');
      notes = notesBox.values.toList();

      emit(NotesLoadedState(notes!)); // Emit a state with the loaded notes
    } catch (e) {
      emit(AddNoteErrorState(e.toString()));
    }
  }

  void deleteNoteAt(int index) async {
    try {
      var notesBox = Hive.box<NoteModel>('notes');
      var note = notes![index];
      await notesBox.deleteAt(index);

      // Delete note from Firestore
      if (note.firestoreId != null) {
        await FirebaseFirestore.instance
            .collection('notes')
            .doc(note.firestoreId)
            .delete();
      }

      getNotes(); // Fetch notes after deleting one
    } catch (e) {
      emit(AddNoteErrorState(e.toString()));
    }
  }

  void updateNoteAt(int index, NoteModel updatedNote) async {
    try {
      var notesBox = Hive.box<NoteModel>('notes');

      // Ensure the index is valid
      if (index < 0 || index >= notesBox.length) {
        throw RangeError('Invalid index');
      }

      var existingNote = notesBox.getAt(index);

      if (existingNote == null) {
        throw RangeError('No note found at the given index');
      }

      // Update note in Hive
      await notesBox.putAt(index, updatedNote);

      // Update note in Firestore
      if (existingNote.firestoreId != null) {
        updatedNote.firestoreId = existingNote.firestoreId;
        await FirebaseFirestore.instance
            .collection('notes')
            .doc(existingNote.firestoreId)
            .update(updatedNote.toMap());
      }

      getNotes(); // Fetch notes after updating one
    } catch (e) {
      emit(AddNoteErrorState(e.toString()));
    }
  }
}
