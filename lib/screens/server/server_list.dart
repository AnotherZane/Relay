import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:relay/actions/channel_actions.dart';
import 'package:relay/actions/server_actions.dart';
import 'package:relay/models/relay_state.dart';
import 'package:relay/widgets/overlapping_panel.dart';

class ServerListWidget extends StatelessWidget {
  const ServerListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RelayState, RelayState>(
        converter: (store) => store.state,
        builder: (context, store) => Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "CHANNELS - ${store.currentServer?.channels.length ?? 0}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Join Channel"),
                                    content: TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Channel Name"),
                                      onSubmitted: (value) {
                                        if (value.startsWith("#") ||
                                            value.startsWith("&")) {
                                          if (store.ircClient?.getChannel(value) == null) {
                                            store.ircClient?.join(value);
                                          }
                                        }
                                        StoreProvider.of<RelayState>(context)
                                            .dispatch(AddChannelAction(value));
                                        StoreProvider.of<RelayState>(context)
                                            .dispatch(SelectCurrentChannelAction(value));
                                        // OverlappingPanels.of(context)!
                                        //     .reveal(RevealSide.right);
                                        Navigator.pop(context);
                                      },

                                    ),
                                  ));
                        },
                      )
                    ],
                  ),
                ),
                ...store.currentServer!.channels.map(
                  (e) => ListTile(
                    leading: const Icon(Icons.chat_rounded),
                      title: Text(e.name),
                      onTap: () {
                        if (e.name.startsWith("#") || e.name.startsWith("&")) {
                          if (store.ircClient?.getChannel(e.name) == null) {
                            store.ircClient?.join(e.name);
                          }
                        }
                        StoreProvider.of<RelayState>(context)
                            .dispatch(SelectCurrentChannelAction(e.name));
                        OverlappingPanels.of(context)!.reveal(RevealSide.right);
                      },
                      onLongPress: () {

                      },
                      ),
                )
              ],
            )));
  }
}
