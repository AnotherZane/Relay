import 'package:meta/meta.dart';

@immutable
class CachedUser {
  final String name;
  final bool pinned;

  const CachedUser(
    this.name,
      {
    this.pinned = false,
  });

  CachedUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        pinned = json['pinned'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'pinned': pinned,
  };

  @override
  String toString() {
    return 'CachedUser{name: $name, pinned: $pinned}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedUser &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          pinned == other.pinned;

  @override
  int get hashCode => name.hashCode ^ pinned.hashCode;

  CachedUser copyWith({
    String? name,
    bool? pinned,
  }) {
    return CachedUser(
      name ?? this.name,
      pinned: pinned ?? this.pinned,
    );
  }
}
