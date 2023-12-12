class Floorplan {
  final String? id;
  final String name;
  final double topLeftLat;
  final double topLeftLon;
  final double bottomRightLat;
  final double bottomRightLon;
  final String image;

  const Floorplan({
    this.id,
    required this.name,
    required this.topLeftLat,
    required this.topLeftLon,
    required this.bottomRightLat,
    required this.bottomRightLon,
    required this.image,
  });

  factory Floorplan.fromJson(Map<String, dynamic> json) {
    return Floorplan(
      id: json['id'],
      name: json['name'],
      topLeftLat: json['location']['topLeft']['lat'],
      topLeftLon: json['location']['topLeft']['lon'],
      bottomRightLat: json['location']['bottomRight']['lat'],
      bottomRightLon: json['location']['bottomRight']['lon'],
      image: json['image'],
    );
  }
}
