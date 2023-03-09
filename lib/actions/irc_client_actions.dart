import 'package:irc/client.dart';
import 'package:relay/models/cached/server.dart';

class SetClientConfigurationAction {
  late final Configuration config;

  SetClientConfigurationAction(CachedServer server)
      : config = Configuration(
          host: server.host,
          port: server.port,
          ssl: server.ssl,
          username: server.username,
          nickname: server.nickname ?? server.username,
          realname: server.username,
          password: server.password,
        );
}
