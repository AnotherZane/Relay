import 'package:redux/redux.dart';
import 'package:relay/actions/server_actions.dart';

final loadingReducer = TypedReducer<bool, ServersLoadedAction>(_setLoaded);

bool _setLoaded(bool state, ServersLoadedAction action) {
  return false;
}
