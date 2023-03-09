import 'package:relay/models/relay_state.dart';
import 'package:relay/reducers/cache_reducer.dart';
import 'package:relay/reducers/channel_reducer.dart';
import 'package:relay/reducers/loading_reducer.dart';
import 'package:relay/reducers/server_reducer.dart';
import 'package:relay/reducers/irc_client_reducer.dart';

RelayState relayReducer(RelayState state, action) {
  return RelayState(
    isLoading: loadingReducer(state.isLoading, action),
    servers: serversReducer(state.servers, action),
    ircClient: ircClientReducer(state.ircClient, action),
    currentServer: currentServerReducer(state.currentServer, action),
    currentChannel: channelReducer(state.currentChannel, action),
    msgCache: cacheReducer(state.msgCache, action),
  );
}
