import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/note.dart';
import 'dart:async';

class DatabaseHelper {
  static const serverUrl = 'http://192.168.178.20:8080/data';
  static const webSocketUrl = 'ws://192.168.178.20:8080/ws';

  static final StreamController<List<Note>> _notesStreamController = StreamController.broadcast();
  static WebSocket? _webSocket;
  static List<Note> _currentNotes = []; // Neue Variable, um die aktuellen Notizen zu speichern

  static Stream<List<Note>> get notesStream => _notesStreamController.stream;

  static Future<void> loadNotes() async {
    var newNotes = await getNotes();
    _currentNotes = newNotes; // Aktualisieren Sie die aktuellen Notizen, wenn neue Notizen geladen werden
    _notesStreamController.add(newNotes);
  }

  static Future<List<Note>> getNotes() async {
    var response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      return data.map<Note>((item) => Note(item['title'], item['content'], id: item['id'])).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<void> insert(Note note) async {
    var response = await http.post(
      Uri.parse(serverUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(note.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to insert note');
    }
    await loadNotes();
  }

  static Future<void> update(Note note) async {
    var response = await http.put(
      Uri.parse('$serverUrl/${note.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(note.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
    await loadNotes();
  }

  static Future<void> delete(int id) async {
    var response = await http.delete(Uri.parse('$serverUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
    await loadNotes();
  }

  static Future<void> openWebSocket() async {
    _webSocket = await WebSocket.connect(webSocketUrl);
    _webSocket!.listen((event) {
      var message = jsonDecode(event);
      var action = message['action'];
      var noteId = message['noteId'];

      switch (action) {
        case 'create':
        case 'update':
        // Wenn eine Notiz erstellt oder aktualisiert wurde, laden Sie die Notizen erneut
          loadNotes();
          break;
        case 'delete':
        // Wenn eine Notiz gelöscht wurde, entfernen Sie sie aus der Liste der Notizen
          _currentNotes = _currentNotes.where((note) => note.id != noteId).toList();
          _notesStreamController.add(_currentNotes);
          break;
      }
    });
  }

  static void closeWebSocket() {
    _webSocket?.close();
    _webSocket = null;
  }
}