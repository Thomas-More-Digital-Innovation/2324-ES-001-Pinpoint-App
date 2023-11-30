import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapTryout extends StatelessWidget {
  const MapTryout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
      mapController: MapController(),
      options: const MapOptions(
          initialCenter: LatLng(50.96813, 4.68479), initialZoom: 14),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        OverlayImageLayer(
          overlayImages: [
            OverlayImage(
              bounds: LatLngBounds(
                const LatLng(50.970008, 4.681241),
                const LatLng(50.964636, 4.689635),
              ),
              imageProvider: const AssetImage(
                "assets/rw.png",
              ),
            ),
            OverlayImage(
              bounds: LatLngBounds(
                const LatLng(50.965732, 5.350469),
                const LatLng(50.952622, 5.370038),
              ),
              imageProvider: const AssetImage(
                "assets/pkp.png",
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
