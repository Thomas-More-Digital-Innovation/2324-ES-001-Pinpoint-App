class Floorplan {
  final double topLeftLat;
  final double topLeftLon;
  final double bottomRightLat;
  final double bottomRightLon;
  final double? centerLat;
  final double? centerLon;
  final String? image;

  const Floorplan({
    required this.topLeftLat,
    required this.topLeftLon,
    required this.bottomRightLat,
    required this.bottomRightLon,
    this.centerLat,
    this.centerLon,
    this.image,
  });

  factory Floorplan.fromJson(Map<String, dynamic> json) {
    return Floorplan(
      topLeftLat: json['location']['topLeft']['lat'] + 0.0,
      topLeftLon: json['location']['topLeft']['lon'] + 0.0,
      bottomRightLat: json['location']['bottomRight']['lat'] + 0.0,
      bottomRightLon: json['location']['bottomRight']['lon'] + 0.0,
      centerLat: json['center']['lat'] + 0.0,
      centerLon: json['center']['lon'] + 0.0,
      image: json['image'],
    );
  }
}
