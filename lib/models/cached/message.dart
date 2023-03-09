import 'package:irc/client.dart';
import 'package:meta/meta.dart';

@immutable
class CachedMessage {
  final Entity? sender;
  final String? message;
  final DateTime timestamp;
  final String? intent;
  final Entity? target;

  const CachedMessage({
    this.sender,
    this.message,
    required this.timestamp,
    this.intent,
    this.target,
  });
}
