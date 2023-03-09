import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:relay/actions/channel_actions.dart';
import 'package:relay/actions/server_actions.dart';
import 'package:relay/models/relay_state.dart';
import 'package:relay/widgets/overlapping_panel.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final str = StoreProvider.of<RelayState>(context);
    return StoreConnector<RelayState, RelayState>(
      converter: (store) => store.state,
      builder: (context, store) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Container(
              child: Row(
            children: [
              Expanded(
                child: Container(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 28, bottom: 12, left: 12, right: 12),
                          child: Text(
                            "USERS - ${store.ircClient?.getChannel(store.currentChannel)?.allUsers.length ?? 0}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                        ),
                        ...(store.ircClient
                                    ?.getChannel(store.currentChannel)
                                    ?.allUsers
                                    .toList() ??
                                [])
                            .map((user) => ListTile(
                                  leading: const Icon(Icons.person_rounded),
                                  horizontalTitleGap: 0,
                                  title: Text(user!.nickname ?? user.username!, style: const TextStyle(fontSize: 14)),
                                  onTap: () {
                                    str.dispatch(AddChannelAction(
                                        user.nickname ?? user.username!
                                    ));
                                    str.dispatch(SelectCurrentChannelAction(
                                        user.nickname ?? user.username!
                                    ));
                                    OverlappingPanels.of(context)!
                                        .reveal(RevealSide.right);
                                  },
                                )),
                      ],
                    ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
