import 'package:redux/redux.dart';
import 'package:relay/middleware/cache_middleware.dart';
import 'package:relay/middleware/storage_middleware.dart';
import 'package:relay/models/relay_state.dart';
import 'package:sembast/sembast.dart';

List<Middleware<RelayState>> createMiddleware(Database db) {
  return [
    ...createServerStorageMiddleware(db),
    ...createCacheMiddleware(),
  ];
}
