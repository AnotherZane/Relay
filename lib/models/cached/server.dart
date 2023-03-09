import 'package:meta/meta.dart';
import 'package:relay/models/cached/channel.dart';
import 'package:relay/models/cached/user.dart';

@immutable
class CachedServer {
  late final int id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String? nickname;
  final String? password;
  final bool ssl;
  final bool pinned;
  final List<CachedChannel> channels;
  final List<CachedUser> users;

  CachedServer(
    this.name,
    this.host,
    this.port,
    this.username, {
    int? id,
        this.nickname,
        this.password,
    this.ssl = false,
    this.pinned = false,
    this.channels = const [],
    this.users = const [],
  }) {
    // TODO: Replace this with a UUID
    this.id = id ?? DateTime.now().millisecondsSinceEpoch;
  }

  CachedServer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        host = json['host'],
        port = json['port'],
        username = json['username'],
        nickname = json['nickname'],
        password = json['password'],
        ssl = json['ssl'],
        pinned = json['pinned'],
        channels = (json['channels'] as List<dynamic>)
            .map((e) => CachedChannel.fromJson(e))
            .toList(),
        users = (json['users'] as List<dynamic>)
            .map((e) => CachedUser.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'host': host,
    'port': port,
    'username': username,
    'nickname': nickname,
    'password': password,
    'ssl': ssl,
    'pinned': pinned,
    'channels': channels.map((e) => e.toJson()).toList(),
    'users': users.map((e) => e.toJson()).toList(),
  };

  CachedServer copyWith({
    int? id,
    String? name,
    String? host,
    int? port,
    String? username,
    String? nickname,
    String? password,
    bool? ssl,
    bool? pinned,
    List<CachedChannel>? channels,
    List<CachedUser>? users,
  }) {
    return CachedServer(
      name ?? this.name,
      host ?? this.host,
      port ?? this.port,
      username ?? this.username,
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      password: password ?? this.password,
      ssl: ssl ?? this.ssl,
      pinned: pinned ?? this.pinned,
      channels: channels ?? this.channels,
      users: users ?? this.users,
    );
  }

  @override
  String toString() {
    return 'CachedServer{id: $id, name: $name, host: $host, port: $port, username: $username, nickname: $nickname, password: $password, ssl: $ssl, pinned: $pinned, channels: $channels, users: $users}';
  }

  @override
bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedServer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          host == other.host &&
          port == other.port &&
          username == other.username &&
          nickname == other.nickname &&
          password == other.password &&
          ssl == other.ssl &&
          pinned == other.pinned &&
          channels == other.channels &&
          users == other.users;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      host.hashCode ^
      port.hashCode ^
      username.hashCode ^
      nickname.hashCode ^
      password.hashCode ^
      ssl.hashCode ^
      pinned.hashCode ^
      channels.hashCode ^
      users.hashCode;
}
