import 'package:flutter/material.dart';
import 'note.dart';
import 'app_localizations.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  List<Note> notes = []; // Hier wird die Liste mit einer leeren Liste initialisiert

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.notes ?? ''),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Fügen Sie einen Null-Check hinzu
              final localizations = AppLocalizations.of(context);
              if (localizations == null) {
                return const Text('Localization not found');
              }

              return AlertDialog(
                title: Text(localizations.addNote), // Verwenden Sie die lokalisierten Strings
                content: Text(localizations.inputNoteData),
                actions: <Widget>[
                  TextButton(
                    child: Text(localizations.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}