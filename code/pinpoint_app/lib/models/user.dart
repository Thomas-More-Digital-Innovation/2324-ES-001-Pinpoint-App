class User {
  final String name;
  final String? uniqueCode;
  final double lat;
  final double lon;
  final String timeCreated;
  final String? timeModified;

  const User(
      {required this.name,
      this.uniqueCode,
      required this.lat,
      required this.lon,
      required this.timeCreated,
      this.timeModified});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        uniqueCode: json['uniqueCode'],
        lat: json['lat'],
        lon: json['lon'],
        timeCreated: json['timeCreated'],
        timeModified: json['timeModified']);
  }
}
