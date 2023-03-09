import 'package:irc/client.dart';
import 'package:meta/meta.dart';
import 'package:relay/models/cached/message.dart';
import 'package:relay/models/cached/server.dart';

@immutable
class RelayState {
  final bool isLoading;
  final List<CachedServer> servers;
  final Client? ircClient;
  final CachedServer? currentServer;
  final String? currentChannel;
  final Map<String, List<CachedMessage>> msgCache;

  // TODO: Find a more efficient way to store messages
  const RelayState({
    this.isLoading = true,
    this.servers = const [],
    this.ircClient,
    this.currentServer,
    this.currentChannel,
    this.msgCache = const {},
  });
}
