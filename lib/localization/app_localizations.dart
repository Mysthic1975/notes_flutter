import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String get notes {
    return Intl.message(
      'Notizen',
      name: 'notes',
      desc: 'Title for the Notes page',
    );
  }

  // Fügen Sie die fehlenden Getter hinzu
  String get addNote {
    return Intl.message(
      'Eine neue Notiz hinzufügen',
      name: 'addNote',
      desc: 'Title for the add note dialog',
    );
  }

  String get inputNoteData {
    return Intl.message(
      'Hier könnten Sie ein Formular hinzufügen, um die Notizdaten einzugeben.',
      name: 'inputNoteData',
      desc: 'Content for the add note dialog',
    );
  }

  String get close {
    return Intl.message(
      'Schließen',
      name: 'close',
      desc: 'Close button text',
    );
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['de', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations());
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}