import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDismissed;
  final VoidCallback onLongPress;

  const NoteItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDismissed,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id), 
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDismissed(),

      child: ListTile(
        title: Text(
          note.title
        ),

        onTap: onTap, // declared as parameter in constructor
        onLongPress: onLongPress, // declared as parameter in constructor
      )
    );
  }
}