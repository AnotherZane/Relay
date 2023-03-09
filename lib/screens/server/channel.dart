import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:relay/actions/cache_actions.dart';
import 'package:relay/models/relay_state.dart';
import 'package:relay/widgets/overlapping_panel.dart';

class ChannelWidget extends StatefulWidget {

  const ChannelWidget({Key? key}) : super(key: key);

  @override
  State<ChannelWidget> createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final str = StoreProvider.of<RelayState>(context);
    final dateFormatter = DateFormat("HH:mm:ss");
    return StoreConnector<RelayState, RelayState>(converter: (store) => store.state,
      builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              tooltip: "Server List",
              onPressed: () {
                OverlappingPanels.of(context)!.reveal(RevealSide.left);
              },
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.currentChannel ?? state.currentServer!.name),
                const SizedBox(height: 2),
                state.currentServer!.ssl
                    ? Row(
                  children: [
                    const Icon(Icons.lock, size: 12),
                    const SizedBox(width: 4),
                    Text(state.currentServer!.host,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal)),
                  ],
                )
                    : Text(state.currentServer!.host,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal))
              ],
            ),
            titleSpacing: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  var choice = showDialog<String>(context: context, builder: (builder) {
                    return AlertDialog(
                      title: const Text("Disconnect"),
                      content: const Text("Are you sure you want to disconnect?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                          onPressed: () {
                            Navigator.pop(context, "Cancel");
                          },
                        ),
                        TextButton(
                            child: const Text("Disconnect", style: TextStyle(color: Colors.red)),
                            onPressed: () => Navigator.pop(context, "Disconnect")
                        )
                      ],
                    );
                  });

                  choice.then((value) {
                    if (value == "Disconnect") {
                      Navigator.pop(context);
                    }
                  });
                },
                tooltip: "Disconnect",
              ),
              IconButton(
                  icon: const Icon(Icons.people_alt_rounded),
                  onPressed: () {
                    OverlappingPanels.of(context)!.reveal(RevealSide.right);
                  },
                  tooltip: "User List"),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Expanded(
                    child: state.ircClient!.connected
                        ? ListView.builder(
                      itemCount: state.msgCache[state.currentChannel ?? "SERVER"]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final message = state.msgCache[state.currentChannel ?? "SERVER"]![index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("<${message.sender!.name}> ${message.message}")),
                              Text(dateFormatter.format(message.timestamp), style: const TextStyle(fontSize: 10))
                            ],
                          ),
                        );
                      },
                    ) : const Center(child: CircularProgressIndicator())),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Message",
                          ),
                          autofocus: true,
                        )),
                    IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final channel = state.currentChannel ?? "SERVER";

                          if (channel != "SERVER") {
                            state.ircClient!.sendMessage(channel, _controller.text);
                            final nick = state.ircClient!.config!.nickname;
                            final username = state.ircClient!.config!.username;
                            str.dispatch(AddSelfMessageAction(channel, _controller.text, state.ircClient?.getEntity(username)));
                          }
                          else {
                            state.ircClient!.send(_controller.text);
                          }
                          _controller.clear();
                        },
                        tooltip: "Send"),
                  ],
                )
              ],
            ),
          )
      );
      }
    );
  }
}
