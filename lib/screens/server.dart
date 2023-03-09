import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irc/client.dart';
import 'package:relay/actions/channel_actions.dart';
import 'package:relay/models/relay_state.dart';
import 'package:relay/screens/server/channel.dart';
import 'package:relay/screens/server/server_list.dart';
import 'package:relay/screens/server/user_list.dart';
import 'package:relay/widgets/overlapping_panel.dart';

import '../actions/cache_actions.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({Key? key}) : super(key: key);

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  late final StreamSubscription _subReceive;
  late final StreamSubscription _subSent;
  late final StreamSubscription _subMessage;
  late final void Function(RevealSide) reveal;

  void _handleLine(String line) {
    print(line);
  }

  void _handleMessage(MessageEvent e) {
    StoreProvider.of<RelayState>(context).dispatch(AddMessageAction(e));
  }

  @override
  Widget build(BuildContext context) {
    final str = StoreProvider.of<RelayState>(context);
    return WillPopScope(
        child: StoreConnector<RelayState, RelayState>(
          onInit: (store) async {
            _subReceive = store.state.ircClient!.onLineReceive.listen((line) => _handleLine(line.line));
            _subSent = store.state.ircClient!.onLineSent.listen((line) => _handleLine(">> ${line.line}"));
            _subMessage = store.state.ircClient!.onMessage.listen((msg) => _handleMessage(msg));

            await store.state.ircClient!.connect();
          },
          onDispose: (store) async {
            _subReceive.cancel();
            _subSent.cancel();
            _subMessage.cancel();

            str.dispatch(ClearCacheAction());
            str.dispatch(SelectCurrentChannelAction(null));

            await store.state.ircClient!.disconnect();
          },
          converter: (store) => store.state,
          builder: (context, state) => OverlappingPanels(
            left: ServerListWidget(),
            right: UserListWidget(),
            main: ChannelWidget(),
          ),
        ),
        onWillPop: () => Future.value(false));
  }
}
