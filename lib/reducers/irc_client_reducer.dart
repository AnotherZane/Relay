import 'package:irc/client.dart';
import 'package:redux/redux.dart';
import 'package:relay/actions/irc_client_actions.dart';

final ircClientReducer = combineReducers<Client?>([
  TypedReducer<Client?, SetClientConfigurationAction>(_setClientConfiguration),
]);

Client _setClientConfiguration(Client? state, SetClientConfigurationAction action) => Client(action.config);
