import 'package:irc/client.dart';
import 'package:redux/redux.dart';
import 'package:relay/actions/cache_actions.dart';
import 'package:relay/actions/server_actions.dart';
import 'package:relay/models/cached/channel.dart';
import 'package:relay/models/relay_state.dart';

List<Middleware<RelayState>> createCacheMiddleware() {
  return [
    TypedMiddleware<RelayState, AddMessageAction>(_addMessage),
    TypedMiddleware<RelayState, AddChannelAction>(_addChannel)
  ];
}

void _addMessage(Store<RelayState> store, AddMessageAction action, NextDispatcher next) {
  next(action);

  var server = store.state.currentServer;

  // get channel or user name, default to server
  final target = action.message.target?.name;
  final currentUser = action.message.client.config!.username;
  var chan = (target == currentUser ? action.message.from?.name : target) ?? "SERVER";

  if (action.message is NoticeEvent)
  {
    final notice = action.message as NoticeEvent;

    if (notice.isServer)
    {
      chan = "SERVER";
    }
    else {
      chan = notice.target!.name!;
    }
  }

    if (!server!.channels.any((x) => x.name == chan)) {

      var channels = server.channels.toList();
      channels.add(CachedChannel(chan));
      final srvr = server.copyWith(channels: channels);
      store.dispatch(UpdateServerAction(srvr));
      store.dispatch(UpdateCurrentServerAction(srvr));
    }
}

void _addChannel(Store<RelayState> store, AddChannelAction action, NextDispatcher next) {
  var server = store.state.currentServer;

  if (server != null){
    if (!server.channels.any((x) => x.name == action.channel)) {

      var channels = server.channels.toList();
      channels.add(CachedChannel(action.channel));
      final srvr = server.copyWith(channels: channels);
      store.dispatch(UpdateServerAction(srvr));
      store.dispatch(UpdateCurrentServerAction(srvr));
    }
  }

  next(action);
}
