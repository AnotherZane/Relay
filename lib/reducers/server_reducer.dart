import 'package:redux/redux.dart';
import 'package:relay/actions/server_actions.dart';
import 'package:relay/models/cached/channel.dart';
import 'package:relay/models/cached/server.dart';

final serversReducer = combineReducers<List<CachedServer>>([
  TypedReducer<List<CachedServer>, ServersLoadedAction>(_setLoadedServers),
  TypedReducer<List<CachedServer>, AddServerAction>(_addServer),
  TypedReducer<List<CachedServer>, UpdateServerAction>(_updateServer),
  TypedReducer<List<CachedServer>, DeleteServerAction>(_deleteServer),
]);

final currentServerReducer = combineReducers<CachedServer?>([
  TypedReducer<CachedServer?, SelectCurrentServerAction>(_selectCurrentServer),
  TypedReducer<CachedServer?, UpdateCurrentServerAction>(_updateCurrentServer),
  TypedReducer<CachedServer?, AddChannelAction>(_addChannel),
]);

CachedServer? _selectCurrentServer(
        CachedServer? state, SelectCurrentServerAction action) =>
    action.server;

CachedServer? _updateCurrentServer(
        CachedServer? state, UpdateCurrentServerAction action) =>
    action.server;

List<CachedServer> _setLoadedServers(
        List<CachedServer> servers, ServersLoadedAction action) =>
    action.servers;

List<CachedServer> _addServer(
        List<CachedServer> servers, AddServerAction action) =>
    List.from(servers)..add(action.server);

List<CachedServer> _updateServer(
        List<CachedServer> servers, UpdateServerAction action) =>
    servers
        .map((server) => server.id == action.server.id ? action.server : server)
        .toList();

List<CachedServer> _deleteServer(
        List<CachedServer> servers, DeleteServerAction action) =>
    servers.where((server) => server.id != action.server.id).toList();

CachedServer? _addChannel(CachedServer? state, AddChannelAction action) => state;
