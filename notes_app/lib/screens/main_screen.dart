import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/models/note.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final box = Hive.box<Note>('notes');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    final List<Note> notes = box.values.toList();

    return Scaffold(
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Text(notes[index].title);
        }),

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
                      Navigator.pop(context);
                      _titleController.clear();
                      _contentController.clear();
                    }, 
                    child: Text("Cancel")
                  ),
                  TextButton( // save note and pop alert dialog
                    onPressed: () {
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