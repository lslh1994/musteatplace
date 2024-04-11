import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
//FUNCTIONS
  late MapController mapController;
  late double latData;
  late double lngData;
  late double initialCenter;

  var value = Get.arguments ?? '__';

//INIT
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    latData = value[0];
    lngData = value[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 위치'),
      ),
      body: flutterMap(),
    );
  }

  Widget flutterMap() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FlutterMap(
          mapController: mapController,
          options: const MapOptions(
              initialCenter: latlng.LatLng(37.4732933, 127.0312101),
              initialZoom: 14),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(markers: [
              Marker(
                  point: latlng.LatLng(latData, lngData),
                  child: Column(
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        size: 30,
                        color: Theme.of(context).colorScheme.error,
                      )
                    ],
                  ))
            ])
          ]),
    );
  }
}
