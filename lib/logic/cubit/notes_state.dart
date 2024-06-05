part of 'notes_cubit.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoadedState extends NotesState {
  final List<NoteModel> notes;

  NotesLoadedState(this.notes);
}

class AddNoteLoadingState extends NotesState {}

class AddNoteErrorState extends NotesState {
  final String error;

  AddNoteErrorState(this.error);
}