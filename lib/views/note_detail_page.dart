import 'package:flutter/material.dart';
import '../models/note.dart';
import '../database/database_helper.dart';
import '../localization/app_localizations.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        backgroundColor: Colors.red, // Set the AppBar color
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final localizations = AppLocalizations.of(context);
                  if (localizations == null) {
                    return const Text('Localization not found');
                  }

                  String title = note.title;
                  String content = note.content;

                  return StatefulBuilder(
                    builder: (BuildContext dialogContext, StateSetter setState) {
                      return AlertDialog(
                        title: Text(localizations.addNote),
                        content: Column(
                          children: <Widget>[
                            TextField(
                              onChanged: (value) {
                                title = value;
                              },
                              decoration:
                              const InputDecoration(hintText: "Titel"),
                              controller:
                              TextEditingController(text: title),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                            TextField(
                              onChanged: (value) {
                                content = value;
                              },
                              decoration:
                              const InputDecoration(hintText: "Inhalt"),
                              controller:
                              TextEditingController(text: content),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(localizations.close),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Aktualisieren'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Pop the dialog first
                              Note updatedNote =
                              Note(title, content, id: note.id);
                              DatabaseHelper.instance.update(updatedNote);
                              Navigator.pop(context, 'update'); // Pass 'update' back to the previous page
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              int id = note.id ?? 0;
              if (id > 0) {
                DatabaseHelper.instance.delete(id);
                Navigator.pop(context, 'delete'); // Pass 'delete' back to the previous page
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.grey[850], // Set the Container color
          child: Text(note.content),
        ),
      ),
    );
  }
}