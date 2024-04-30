import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'notes_page.dart';
import 'app_localizations.dart'; // Importieren Sie AppLocalizations

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate, // Fügen Sie diesen Delegate hinzu
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('de', ''), // Deutsch
        Locale('en', ''), // Englisch
        // Sie können hier weitere Sprachen hinzufügen
      ],
      home: NotesPage(),
    );
  }
}
