import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/screens/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // initialise binding
  WidgetsFlutterBinding.ensureInitialized();
  // initialise plugin
  await Hive.initFlutter();
  // Register adapter
  Hive.registerAdapter(NoteAdapter());
  // open box
  await Hive.openBox<Note>('notes');
  // run app
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}