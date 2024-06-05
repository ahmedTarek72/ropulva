import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/notes_cubit.dart';

import '../../logic/models/note_model.dart';
import 'task_card.dart';

class buildItems extends StatelessWidget {
  const buildItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state is NotesLoadedState) {
          List<NoteModel> notes = state.notes;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return TaskCard(
                noteModel: notes[index],
                onDelete: () {
                  BlocProvider.of<NotesCubit>(context).deleteNoteAt(index);
                },
              );
            },
          );
        } else if (state is AddNoteLoadingState || state is NotesInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AddNoteErrorState) {
          return Center(child: Text('Failed to add note: ${state.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
