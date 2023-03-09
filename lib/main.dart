import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:relay/models/relay_state.dart';
import 'package:relay/reducers/relay_reducer.dart';
import 'package:relay/relay_app.dart';
import 'package:sembast/sembast_io.dart';
import 'package:relay/middleware/relay_middleware.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  var dbPath = "${dir.path}/relay.db";
  print(dbPath);
  var db = await databaseFactoryIo.openDatabase(dbPath);

  runApp(RelayApp(Store<RelayState>(relayReducer,
      initialState: const RelayState(),
      middleware: createMiddleware(db))));
}
