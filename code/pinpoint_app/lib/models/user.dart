class User {
  final String id;
  final String name;
  final String? uniqueCode;
  final String? codeValid;
  final double lat;
  final double lon;
  final String timeCreated;
  final String? timeModified;

  const User(
      {required this.id,
      required this.name,
      this.uniqueCode,
      this.codeValid,
      required this.lat,
      required this.lon,
      required this.timeCreated,
      this.timeModified});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        uniqueCode: json['code']['value'],
        codeValid: json['code']['timeValid'],
        lat: json['lat'],
        lon: json['lon'],
        timeCreated: json['timeCreated'],
        timeModified: json['timeModified']);
  }
}
