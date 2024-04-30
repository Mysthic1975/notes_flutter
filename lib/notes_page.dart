import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note.dart';
import 'app_localizations.dart';
import 'theme_provider.dart'; // Importieren Sie ThemeProvider

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  List<Note> notes = [];

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.notes ?? ''),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: themeProvider.switchTheme,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Anzahl der Spalten
        ),
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
                                ),
                                TextField(
                                  onChanged: (value) {
                                    content = value;
                                  },
                                  decoration: const InputDecoration(hintText: "Inhalt"),
                                  controller: TextEditingController(text: content),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(localizations.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Aktualisieren'),
                                onPressed: () {
                                  setState(() {
                                    notes[index] = Note(title, content);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        notes.removeAt(index);
                      });
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

              return AlertDialog(
                title: Text(localizations.addNote),
                content: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: const InputDecoration(hintText: "Titel"),
                    ),
                    TextField(
                      onChanged: (value) {
                        content = value;
                      },
                      decoration: const InputDecoration(hintText: "Inhalt"),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(localizations.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Hinzufügen'),
                    onPressed: () {
                      setState(() {
                        notes.add(Note(title, content));
                      });
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