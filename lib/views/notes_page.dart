import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../localization/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../database/database_helper.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    var newNotes = await DatabaseHelper.instance.getNotes();
    setState(() {
      notes = newNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.notes ?? ''),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: themeProvider.switchTheme,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(notes[index].title),
              subtitle: Text(notes[index].content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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

                          String title = notes[index].title;
                          String content = notes[index].content;

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
                                      Note note =
                                      Note(title, content, id: notes[index].id);
                                      DatabaseHelper.instance.update(note).then((_) => loadNotes());
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
                    onPressed: () async {
                      int id = notes[index].id ?? 0;
                      if (id > 0) {
                        await DatabaseHelper.instance.delete(id);
                        await loadNotes();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final localizations = AppLocalizations.of(context);
              if (localizations == null) {
                return const Text('Localization not found');
              }

              String title = '';
              String content = '';

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
                          decoration: const InputDecoration(hintText: "Titel"),
                          controller: TextEditingController(text: title),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                        TextField(
                          onChanged: (value) {
                            content = value;
                          },
                          decoration: const InputDecoration(hintText: "Inhalt"),
                          controller: TextEditingController(text: content),
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
                        child: const Text('Hinzufügen'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Pop the dialog first
                          Note note = Note(title, content);
                          DatabaseHelper.instance.insert(note).then((_) => loadNotes());
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
    );
  }
}