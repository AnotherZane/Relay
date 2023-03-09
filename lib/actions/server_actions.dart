import 'package:relay/models/cached/server.dart';

class LoadServersAction {}

class ServersLoadedAction {
  final List<CachedServer> servers;

  const ServersLoadedAction(this.servers);
}

class SelectCurrentServerAction {
  final CachedServer server;

  const SelectCurrentServerAction(this.server);
}

class UpdateCurrentServerAction {
  final CachedServer server;

  const UpdateCurrentServerAction(this.server);
}

class AddServerAction {
  final CachedServer server;

  const AddServerAction(this.server);
}

class UpdateServerAction {
  final CachedServer server;

  const UpdateServerAction(this.server);
}

class DeleteServerAction {
  final CachedServer server;

  const DeleteServerAction(this.server);
}

class AddChannelAction {
  final String channel;

  AddChannelAction(this.channel);
}
