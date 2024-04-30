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
              final localizations = AppLocalizations.of(context);
              if (localizations == null) {
                return const Text('Localization not found');
              }

              return AlertDialog(
                title: Text(localizations.addNote),
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