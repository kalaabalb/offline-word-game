class PlayerProfile {
  const PlayerProfile({required this.name, required this.avatarId});

  final String name;
  final int avatarId;

  Map<String, Object> toJson() => {'name': name, 'avatarId': avatarId};

  factory PlayerProfile.fromJson(Map<String, dynamic> json) => PlayerProfile(
        name: json['name'] as String,
        avatarId: json['avatarId'] as int,
      );
}
