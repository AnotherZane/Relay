import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:relay/actions/irc_client_actions.dart';
import 'package:relay/models/cached/server.dart';
import '../actions/server_actions.dart';
import '../models/relay_state.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onInit;

  const HomeScreen({Key? key, required this.onInit}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> _selectedTiles = <int>[];

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RelayState, List<CachedServer>>(
      converter: (store) => store.state.servers,
      builder: (context, servers) {
        final sorted = servers.toList()..sort((a, b) => a.pinned == b.pinned ? 0 : a.pinned ? -1 : 1);

        return Scaffold(
          appBar: AppBar(
            leading: _selectedTiles.isEmpty
                ? null
                : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _selectedTiles.clear();
                });
              },
            ),
            titleSpacing: _selectedTiles.isNotEmpty ? 0 : 16,
            title: _selectedTiles.isEmpty
                ? const Text("Relay")
                : Text(_selectedTiles.length.toString()),
            actions: createAppBarActions(sorted),
          ),
          body:  ListView.builder(
              itemBuilder: (context, index) {
                final server = sorted[index];

                return ListTile(
                  leading: _selectedTiles.contains(index)
                      ? Stack(
                    children: [
                      const Icon(Icons.computer, size: 28),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(Icons.check_circle,
                              size: 16,
                              color:
                              Theme.of(context).colorScheme.primary)),
                    ],
                  )
                      : const Icon(Icons.computer, size: 28),
                  title: Text(server.name, style: TextStyle(color: Colors.white.withOpacity(_selectedTiles.contains(index) ? 1 : 0.8))),
                  subtitle: server.ssl
                      ? Row(
                    children: [
                      Icon(Icons.lock, size: 14, color: Theme.of(context).colorScheme.onSecondary),
                      const SizedBox(width: 4),
                      Text(server.host, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                    ],
                  )
                      : Text(server.host, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                  trailing: server.pinned
                      ? Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: const Icon(Icons.push_pin, size: 20))
                      : null,
                  shape: BeveledRectangleBorder(
                    side: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), width: 0.1),
                  ),
                  onTap: () {
                    if (_selectedTiles.contains(index)) {
                      setState(() {
                        _selectedTiles.remove(index);
                      });
                    } else if (_selectedTiles.isNotEmpty) {
                      setState(() {
                        _selectedTiles.add(index);
                      });
                    }
                    else {
                      StoreProvider.of<RelayState>(context).dispatch(SelectCurrentServerAction(server));
                      StoreProvider.of<RelayState>(context).dispatch(SetClientConfigurationAction(server));
                      Navigator.pushNamed(context, "/server");
                    }
                  },
                  onLongPress: () {
                    if (!_selectedTiles.contains(index)) {
                      setState(() {
                        _selectedTiles.add(index);
                      });
                    }
                  },
                  selected: _selectedTiles.contains(index),
                  selectedColor: Theme.of(context).colorScheme.onSecondary,
                  selectedTileColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                );
              },
              itemCount: sorted.length),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/add_server");
            },
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
          ),
        );
      });
  }

  List<Widget> createAppBarActions(List<CachedServer> servers) {
    if (_selectedTiles.isEmpty) {
      return [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}, tooltip: "Search"),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}, tooltip: "Options"),
      ];
    }

    if (_selectedTiles.length == 1) {
      final server = servers[_selectedTiles.first];

      return [
        IconButton(icon: Transform.rotate(
            angle: 45 * math.pi / 180,
            child: const Icon(Icons.push_pin, size: 20)), onPressed: () {
          StoreProvider.of<RelayState>(context).dispatch(UpdateServerAction(server.copyWith(pinned: !server.pinned)));
          _selectedTiles.clear();
          setState(() {});
        },
          tooltip: server.pinned ? "Unpin" : "Pin",
        ),
        IconButton(icon: const Icon(Icons.edit), onPressed: () {
          Navigator.pushNamed(context, "/edit_server", arguments: server);
          _selectedTiles.clear();
          setState(() {});
        }, tooltip: "Edit"),
        IconButton(icon: const Icon(Icons.delete), onPressed: () {
          StoreProvider.of<RelayState>(context).dispatch(DeleteServerAction(server));
          _selectedTiles.clear();
          setState(() {});
        },
          tooltip: "Delete",
        ),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}, tooltip: "Options"),
      ];
    }

    return [
      IconButton(icon: const Icon(Icons.delete), onPressed: () {}, tooltip: "Delete"),
      IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}, tooltip: "Options"),
    ];
  }
}
