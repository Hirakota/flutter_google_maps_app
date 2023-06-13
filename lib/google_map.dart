import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class GoogleMapDemo extends StatefulWidget {
  const GoogleMapDemo({Key? key}) : super(key: key);

  @override
  State<GoogleMapDemo> createState() => _GoogleMapDemoState();
}

const LatLng _kMapCenter = LatLng(52.4478, -3.5402);

class _GoogleMapDemoState extends State<GoogleMapDemo> {
  late BitmapDescriptor customIcon;

  bool _isLoaded = false;

  GlobalKey markerGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
            'https://www.svgrepo.com/show/1276/map-pin.svg')
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onBuildCompleted();
    });
  }

  List<Marker> markers = [
    Marker(
      markerId: MarkerId('marker_1'),
      position: _kMapCenter,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoaded
          ? GoogleMap( // showMap
              initialCameraPosition: CameraPosition(
                target: _kMapCenter,
                zoom: 12,
              ),
              markers: markers.toSet(),
            )
          : Row( // prepare
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: Offset(
                    -MediaQuery.of(context).size.height * 2,
                    -MediaQuery.of(context).size.width * 2,
                  ),
                  child: RepaintBoundary(
                    key: markerGlobalKey,
                    child: CustomMarker(
                      price: 100,
                    ),
                  ),
                ),
                /*RepaintBoundary(
                  key: markerGlobalKey,
                  child: CustomMarker(
                    price: 100,
                  ),
                ),*/
              ],
            ),
    );
  }

  Future<void> _onBuildCompleted() async {
    Future(() async {
      Marker marker = await _generateMarkerFromWidget(markerGlobalKey);

      setState(() {
        markers.add(marker);
        _isLoaded = true;
      });
    });
  }

  Future<Marker> _generateMarkerFromWidget(
    GlobalKey key,
  ) async {
    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return Marker(
      markerId: MarkerId('marker_2'),
      position: _kMapCenter,
      icon: BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List()),
    );
  }
}

class CustomMarker extends StatelessWidget {
  const CustomMarker({Key? key, required this.price}) : super(key: key);

  final int price;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          color: Colors.black,
          child: Text(
            '\$$price',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          height: 10,
          width: 2,
          color: Colors.black,
        )
      ],
    );
  }
}
