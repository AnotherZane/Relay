import 'package:meta/meta.dart';

@immutable
class CachedChannel {
  final String name;
  final bool pinned;

  const CachedChannel(
    this.name, {
    this.pinned = false,
  });

  CachedChannel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        pinned = json['pinned'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'pinned': pinned,
  };

  @override
  String toString() {
    return 'CachedChannel{name: $name, pinned: $pinned}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedChannel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          pinned == other.pinned;

  @override
  int get hashCode => name.hashCode ^ pinned.hashCode;

CachedChannel copyWith({
    String? name,
    bool? pinned,
  }) {
    return CachedChannel(
      name ?? this.name,
      pinned: pinned ?? this.pinned,
    );
  }
}
