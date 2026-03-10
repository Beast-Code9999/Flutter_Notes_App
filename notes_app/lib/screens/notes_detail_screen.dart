import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/models/note.dart';

class NotesDetailScreen extends StatefulWidget {
  final Note note;
  final int index;
  final Function(int, Note) onEdit;

  const NotesDetailScreen({
    super.key,
    required this.note,
    required this.index,
    required this.onEdit
  });

  @override
  State<NotesDetailScreen> createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {
  final box = Hive.box<Note>('notes');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<Note> box, _) {

        // get updated note
        final note = box.getAt(widget.index);

        if (note == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text("Note not found")),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(note.title),
            actions: [
              IconButton( // Edit button
                onPressed: () {
                  widget.onEdit(widget.index, note); // calls on _showEditDialog as an argument
                },
                icon: Icon(Icons.edit),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(note.content),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}