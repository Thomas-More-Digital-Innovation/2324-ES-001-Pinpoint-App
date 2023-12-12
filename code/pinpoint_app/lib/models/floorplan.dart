class Floorplan {
  final String id;
  final String name;
  final Map<String, dynamic> location;
  final String image;
  late final Map<String, double> topLeft;
  late final Map<String, double> bottomRight;

  Floorplan({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
  }) {
    // Extracting coordinates from location map
    topLeft = {
      'lat': location['topLeft']['lat'].toDouble(),
      'lon': location['topLeft']['lon'].toDouble(),
    };

    bottomRight = {
      'lat': location['bottomRight']['lat'].toDouble(),
      'lon': location['bottomRight']['lon'].toDouble(),
    };
  }
}

List<Floorplan> hardcodedFloorplans = [
  Floorplan(
    id: '1',
    name: 'Rock Werchter',
    location: {
      'topLeft': {'lat': 50.970008, 'lon': 4.681241},
      'bottomRight': {'lat': 50.964636, 'lon': 4.689635},
    },
    image: 'assets/rw.png',
  ),
  Floorplan(
    id: '2',
    name: 'Pukkelpop',
    location: {
      'topLeft': {'lat': 50.965732, 'lon': 5.350469},
      'bottomRight': {'lat': 50.952622, 'lon': 5.370038},
    },
    image: 'assets/pkp.png',
  ),
];
