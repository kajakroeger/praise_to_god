// Datenmodell in Dart

class Member {
  final String name;
  final String profileImageUrl;

  Member({required this.name, required this.profileImageUrl});

  factory Member.fromMap(Map<String, dynamic> data) {
    return Member(
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }
}

class Service {
  final String serviceName;
  final String startTime;
  final List<Member> members;

  Service({
    required this.serviceName,
    required this.startTime,
    required this.members,
  });

  factory Service.fromFirestore(Map<String, dynamic> data) {
    return Service(
      serviceName: data['serviceName'] ?? '',
      startTime: data['startTime'] ?? '',
      members: (data['members'] as List<dynamic>)
          .map((e) => Member.fromMap(e))
          .toList(),
    );
  }
}
