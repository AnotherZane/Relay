import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:relay/models/relay_state.dart';
import 'package:sembast/sembast.dart';
import '../actions/server_actions.dart';
import '../models/cached/server.dart';

List<Middleware<RelayState>> createServerStorageMiddleware(Database db) {
  final dbStore = StoreRef<String, String>("servers");

  return [
    _loadServers(db, dbStore),
    _saveServers(db, dbStore),
    _addServer(db, dbStore),
    _updateServer(db, dbStore),
    _deleteServer(db, dbStore),
  ];
}

TypedMiddleware<RelayState, LoadServersAction> _loadServers(
    Database db, StoreRef<String, String> dbStore) {
  return TypedMiddleware<RelayState, LoadServersAction>(
      (store, action, next) async {
    final records = await dbStore.find(db);
    final servers = records
        .map((record) => CachedServer.fromJson(jsonDecode(record.value)))
        .toList();

    store.dispatch(ServersLoadedAction(servers));

    next(action);
  });
}

TypedMiddleware<RelayState, ServersLoadedAction> _saveServers(
    Database db, StoreRef<String, String> dbStore) {
  return TypedMiddleware<RelayState, ServersLoadedAction>(
      (store, action, next) async {
    next(action);

    final servers = action.servers.toList();

    await db.transaction((txn) async {
      var existing = await dbStore
          .query(
              finder: Finder(
                  filter:
                      Filter.inList("id", servers.map((e) => e.id).toList())))
          .getSnapshots(txn);

      for (var record in existing) {
        final server = servers.firstWhere((e) => e.id.toString() == record.key);
        servers.remove(server);

        await record.ref.update(txn, jsonEncode(server.toJson()));
      }

      for (var server in servers) {
        await dbStore
            .record(server.id.toString())
            .add(txn, jsonEncode(server.toJson()));
      }
    });
  });
}

TypedMiddleware<RelayState, AddServerAction> _addServer(
    Database db, StoreRef<String, String> dbStore) {
  return TypedMiddleware<RelayState, AddServerAction>(
      (store, action, next) async {
    next(action);

    await dbStore
        .record(action.server.id.toString())
        .add(db, jsonEncode(action.server.toJson()));
  });
}

TypedMiddleware<RelayState, UpdateServerAction> _updateServer(
    Database db, StoreRef<String, String> dbStore) {
  return TypedMiddleware<RelayState, UpdateServerAction>(
      (store, action, next) async {
    next(action);

    await dbStore
        .record(action.server.id.toString())
        .update(db, jsonEncode(action.server.toJson()));
  });
}

TypedMiddleware<RelayState, DeleteServerAction> _deleteServer(
    Database db, StoreRef<String, String> dbStore) {
  return TypedMiddleware<RelayState, DeleteServerAction>(
      (store, action, next) async {
    next(action);

    await dbStore.record(action.server.id.toString()).delete(db);
  });
}
