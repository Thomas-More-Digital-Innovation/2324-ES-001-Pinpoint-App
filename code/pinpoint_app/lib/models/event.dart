import 'package:pinpoint_app/models/floorplan.dart';

class Event {
  final String? id;
  final String title;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String? image;
  final String? imageBanner;
  final Floorplan? floorplan;

  const Event({
    this.id,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.image,
    this.imageBanner,
    this.floorplan,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      image: json['image'],
      imageBanner: json['imageBanner'],
      floorplan: json['floorplan'] != null
          ? Floorplan.fromJson(json['floorplan'])
          : null,
    );
  }
}
