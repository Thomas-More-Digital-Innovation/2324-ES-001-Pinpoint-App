class User {
  final String name;
  final double lat;
  final double lon;
  final String timeCreated;
  final String? timeModified;

  const User(
      {required this.name,
      required this.lat,
      required this.lon,
      required this.timeCreated,
      this.timeModified});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        lat: json['lat'],
        lon: json['lon'],
        timeCreated: json['timeCreated'],
        timeModified: json['timeModified']);
  }
}