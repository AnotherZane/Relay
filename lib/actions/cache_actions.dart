import 'package:irc/client.dart';

class AddMessageAction {
  final MessageEvent message;

  const AddMessageAction(this.message);
}

class AddSelfMessageAction {
  final String channel;
  final String message;
  final Entity? sender;

  const AddSelfMessageAction(this.channel, this.message, this.sender);
}

class ClearMessagesAction {
  final String channel;

  const ClearMessagesAction(this.channel);
}

class ClearCacheAction {}
