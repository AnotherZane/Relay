import 'dart:convert';

import 'package:irc/client.dart';
import 'package:redux/redux.dart';
import 'package:relay/actions/cache_actions.dart';
import 'package:relay/models/cached/message.dart';

final cacheReducer = combineReducers<Map<String, List<CachedMessage>>>([
  TypedReducer<Map<String, List<CachedMessage>>, AddMessageAction>(_addMessage),
  TypedReducer<Map<String, List<CachedMessage>>, AddSelfMessageAction>(_addSelfMessage),
  TypedReducer<Map<String, List<CachedMessage>>, ClearMessagesAction>(_clearMessages),
  TypedReducer<Map<String, List<CachedMessage>>, ClearCacheAction>(_clearCache),
]);

Map<String, List<CachedMessage>> _addMessage(
    Map<String, List<CachedMessage>> state, AddMessageAction action) {

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

  print(chan);

  final messages = state[chan] ?? [];

  // remove oldest message if we have more than 250
  if (messages.length > 250) {
    messages.removeAt(0);
  }

  messages.add(CachedMessage(
      sender: action.message.from,
      message: action.message.message,
      timestamp: DateTime.now(),
      intent: action.message.intent,
      target: action.message.target
  ));

  return {...state, chan: messages};
}

Map<String, List<CachedMessage>> _addSelfMessage(
    Map<String, List<CachedMessage>> state, AddSelfMessageAction action) {

  final messages = state[action.channel] ?? [];

  // remove oldest message if we have more than 250
  if (messages.length > 250) {
    messages.removeAt(0);
  }

  messages.add(CachedMessage(
      sender: action.sender,
      message: action.message,
      timestamp: DateTime.now()
  ));

  return {...state, action.channel: messages};
}

Map<String, List<CachedMessage>> _clearMessages(
    Map<String, List<CachedMessage>> state, ClearMessagesAction action) {

  state.remove(action.channel);
  return {...state};
}

Map<String, List<CachedMessage>> _clearCache(
    Map<String, List<CachedMessage>> state, ClearCacheAction action) {
  return {};
}
