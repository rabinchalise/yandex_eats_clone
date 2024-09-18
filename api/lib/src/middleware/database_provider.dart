import 'package:api/src/common/common.dart';
import 'package:dart_frog/dart_frog.dart';

import 'package:stormberry/stormberry.dart' hide Pool;

/// Define a global connection pool.

final Future<Connection> _connection = _initializeConnection();

/// Initializes the database connection.
Future<Connection> _initializeConnection() async {
  final env = Env();
  final endpoint = Endpoint(
    host: env.pgHost,
    port: env.pgPort.intParse(),
    database: env.pgDatabase,
    username: env.pgUser,
    password: env.pgPassword,
  );

  return Connection.open(endpoint);
}

/// Middleware to provide a [Connection] instance to the request context.
Middleware databaseProvider() {
  return (handler) {
    return handler.use(
      provider<Future<Connection>>((_) async {
        try {
          // Use the connection pool to get a connection

          final conn = await _connection;

          // Check if the connection is open; if not, reinitialize it
          if (!conn.isOpen) {
            await conn.close();
            return await _initializeConnection();
          }

          return conn;
        } catch (e) {
          // Log the error
          print('Error establishing a database connection: $e');
          // Optionally rethrow or handle the error
          throw Exception('Database connection error');
        }
      }),
    );
  };
}
