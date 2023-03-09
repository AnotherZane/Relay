import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irc/client.dart';
import 'package:redux/redux.dart';
import 'package:relay/actions/server_actions.dart';
import 'package:relay/models/relay_state.dart';
import 'package:relay/models/cached/server.dart';
import 'package:relay/screens/add_server.dart';
import 'package:relay/screens/edit_server.dart';
import 'package:relay/screens/home.dart';
import 'package:relay/screens/server.dart';
import 'package:relay/util/theme.dart';

class RelayApp extends StatelessWidget {
  final Store<RelayState> store;

  const RelayApp(this.store, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            title: 'Relay',
            // hide the debug banner
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.dark,
            routes: {
              "/": (context) => HomeScreen(onInit: () {
                    StoreProvider.of<RelayState>(context)
                        .dispatch(LoadServersAction());
                  }),
              "/add_server": (context) => const AddServerScreen(),
              "/edit_server": (context) {
                final CachedServer server = ModalRoute.of(context)!.settings.arguments as CachedServer;
                return EditServerScreen(server);
              },
              "/server": (context) {
                return const ServerScreen();
              },
            }));
  }
}
