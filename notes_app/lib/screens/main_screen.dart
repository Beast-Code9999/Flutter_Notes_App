import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/notes_detail_screen.dart';
import 'package:notes_app/widgets/note_item.dart';
import 'package:uuid/uuid.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final box = Hive.box<Note>('notes');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final _uuid = Uuid();

  // Show edit dialog and edit notes
  void _showEditDialog( int index, Note note) {
    // prefil text 
    _titleController.text = note.title;
    _contentController.text = note.content;
    
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Note"),
            content: Column(
              mainAxisSize: MainAxisSize.min, // minimum content size
              children: [ // Enter title and content
                TextField( // add title
                  controller: _titleController,
                  decoration: InputDecoration(hintText: "Title"),
                ),
                TextField( // add title
                  controller: _contentController,
                  decoration: InputDecoration(hintText: "Content"),
                )
              ],
            ),
            actions: [
              TextButton( // cancel alert dialog and clear controller
                onPressed: () {
                  _titleController.clear();
                  _contentController.clear();
                  Navigator.pop(context);
                }, 
                child: Text("Cancel")
              ),
              TextButton( // save note and pop alert dialog
                onPressed: () { 
                  // add note if textcontroller is not empty
                  if(_contentController.text.isNotEmpty && _titleController.text.isNotEmpty) {
                    box.putAt(index, Note(
                      id: note.id, // keep the same ID
                      title: _titleController.text,
                      content: _contentController.text,
                      createdAt: note.createdAt, // keep original date
                    ));
                    _titleController.clear();
                    _contentController.clear();
                    Navigator.pop(context);
                  }
                  // to be added
                }, 
                child: Text("Save")
              )
            ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Rebuilds automatically when the Hive box changes
      body: ValueListenableBuilder(
        valueListenable: box.listenable(), // listen to box changes
        builder: (context, Box<Note> box, _) {
          final notes = box.values.toList(); // get current notes from box

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return NoteItem(
                note: notes[index],

                // open note
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => NotesDetailScreen(
                        note: notes[index],
                        index: index,
                        onEdit: _showEditDialog,
                      )
                    )
                  );
                },

                // delete note
                onDismissed: () {
                  box.deleteAt(index); // remove from Hive, UI updates automatically
                  ScaffoldMessenger.of(context).showSnackBar( // show message of removed item
                    SnackBar(content: Text("${notes[index].title} deleted")),
                  );
                },

                // edit note
                onLongPress: () {
                  // call editing method
                  _showEditDialog(index, notes[index]);
                },
              );
            },
          );
        },
      ),

      // Add note button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog( // Add notes
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: Text("Add Note"),
                content: Column(
                  mainAxisSize: MainAxisSize.min, // minimum content size
                  children: [ // Enter title and content
                    TextField( // add title
                      controller: _titleController,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    TextField( // add title
                      controller: _contentController,
                      decoration: InputDecoration(hintText: "Content"),
                    )
                  ],
                ),
                actions: [
                  TextButton( // cancel alert dialog and clear controller
                    onPressed: () {
                      _titleController.clear();
                      _contentController.clear();
                      Navigator.pop(context);
                    }, 
                    child: Text("Cancel")
                  ),
                  TextButton( // save note and pop alert dialog
                    onPressed: () { 
                      // add note if textcontroller is not empty
                      if(_contentController.text.isNotEmpty && _titleController.text.isNotEmpty) {
                        box.add(Note( 
                          id: _uuid.v4(), // use UUID to automatic generation of IDs
                          title: _titleController.text,
                          content: _contentController.text, 
                          createdAt: DateTime.now()
                        ));
                        _titleController.clear();
                        _contentController.clear();
                        Navigator.pop(context);
                      }
                      // to be added
                    }, 
                    child: Text("Save")
                  )
                ],
              );
            });
        },
        
        child: Icon(Icons.add),
      ),
    );
  }
}