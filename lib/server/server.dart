import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgresql2/pool.dart';
import 'package:shelf/shelf_io.dart' as io;

class Server {
  final Router _router;
  final Pool _pool;
  final Middleware _corsMiddleware;

  Server(this._pool)
      : _router = Router(),
        _corsMiddleware = createMiddleware(
          requestHandler: (Request request) {
            if (request.method == 'OPTIONS') {
              return Response.ok(null, headers: _createCorsHeaders());
            }
            return null;
          },
          responseHandler: (Response response) {
            return response.change(headers: _createCorsHeaders());
          },
        ) {
    _router.get('/data', _handleGetData);
    _router.post('/data', _handlePostData);
    _router.put('/data/<id>', _handlePutData);
    _router.delete('/data/<id>', _handleDeleteData);
  }

  Handler get handler {
    final handler = const Pipeline().addMiddleware(_corsMiddleware).addHandler(_router.call);
    return handler;
  }

  static Map<String, String> _createCorsHeaders() {
    final headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Origin, Content-Type',
    };
    return headers;
  }

  Future<Response> _handleGetData(Request request) async {
    var client = await _pool.connect();
    var resultStream = client.query('SELECT * FROM notes');

    var result = await resultStream.toList();

    client.close();

    var data = result.map((row) => {'id': row[0], 'title': row[1], 'content': row[2]}).toList();

    return Response.ok(jsonEncode({'data': data}));
  }

  Future<Response> _handlePostData(Request request) async {
    var client = await _pool.connect();
    var body = jsonDecode(await request.readAsString());
    var title = body['title'];
    var content = body['content'];

    await client.query('INSERT INTO notes (title, content) VALUES (@a, @b)', {'a': title, 'b': content}).toList();

    client.close();

    return Response.ok(jsonEncode({'result': 'success'}));
  }

  Future<Response> _handlePutData(Request request, String id) async {
    var client = await _pool.connect();
    var body = jsonDecode(await request.readAsString());
    var title = body['title'];
    var content = body['content'];

    await client.query('UPDATE notes SET title = @a, content = @b WHERE id = @c', {'a': title, 'b': content, 'c': int.parse(id)}).toList();

    client.close();

    return Response.ok(jsonEncode({'result': 'success'}));
  }

  Future<Response> _handleDeleteData(Request request, String id) async {
    var client = await _pool.connect();

    await client.query('DELETE FROM notes WHERE id = @a', {'a': int.parse(id)}).toList();

    client.close();

    return Response.ok(jsonEncode({'result': 'success'}));
  }
}

Future<void> ensureTableExists(Pool pool) async {
  var client = await pool.connect();
  client.query('''
    CREATE TABLE IF NOT EXISTS notes (
      id SERIAL PRIMARY KEY,
      title TEXT NOT NULL,
      content TEXT NOT NULL
    )
  ''');
  client.close();
}

void main() {
  var uri = 'postgres://postgres:admin@localhost:5433/postgres';
  var pool = Pool(uri, minConnections: 2, maxConnections: 5);
  pool.start().then((_) async {
    await ensureTableExists(pool);
    final server = Server(pool);
    try {
      io.serve(server.handler, '192.168.178.20', 8080);
      print('Server is running on http://192.168.178.20:8080');
    } catch (e) {
      print('An error occurred while starting the server: $e');
    }
  });
}