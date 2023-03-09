import 'package:redux/redux.dart';

import '../actions/channel_actions.dart';

final channelReducer = combineReducers<String?>([
  TypedReducer<String?, SelectCurrentChannelAction>(_setCurrentChannel),
]);

String? _setCurrentChannel(String? state, SelectCurrentChannelAction action) => action.channel;
