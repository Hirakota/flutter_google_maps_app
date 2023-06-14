import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;

class GoogleMapsFlutter extends StatefulWidget {
  const GoogleMapsFlutter({Key? key}) : super(key: key);

  @override
  State<GoogleMapsFlutter> createState() => _GoogleMapsFlutterState();
}

const LatLng _kMapCenter = LatLng(52.4478, -3.5402);
const LatLng _kMapCenter2 = LatLng(52.44784, -3.54024);

class _GoogleMapsFlutterState extends State<GoogleMapsFlutter> {
  late BitmapDescriptor customIcon;

  bool _isLoaded = false;

  GlobalKey markerGlobalKey = GlobalKey();
  GlobalKey markerGlobalKey2 = GlobalKey();

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
      body: _isLoaded ? _getMap() : _prepareMarkers(),
    );
  }

  Widget _getMap() {
    return GoogleMap(
      // showMap
      initialCameraPosition: CameraPosition(
        target: _kMapCenter,
        zoom: 12,
      ),
      markers: markers.toSet(),
    );
  }

  Widget _prepareMarkers() {
    return Stack(
      children: [
        RepaintBoundary(
          key: markerGlobalKey,
          child: CustomMarker(
            price: 100,
          ),
        ),
        RepaintBoundary(
          key: markerGlobalKey2,
          child: PerformanceTestMarker(
            text: "New Marker",
            backgroundColor: Colors.purple,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Future<void> _onBuildCompleted() async {
    Future(() async {
      Marker marker = await _generateMarkerFromWidget(markerGlobalKey);
      Marker marker2 = await _generateMarkerFromWidget(markerGlobalKey2);
      setState(() {
        markers.add(marker);
        markers.add(marker2);

        // await Future.delayed(Duration(milliseconds: 3000));

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
      markerId: MarkerId(key.toString()),
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

class PerformanceTestMarker extends StatelessWidget {
  const PerformanceTestMarker(
      {Key? key,
      this.backgroundColor = Colors.black,
      this.customContent,
      this.text = ''})
      : super(key: key);

  final Color backgroundColor;

  /// [customContent] or [text} should be not null
  final Widget? customContent;
  final String text;

  @override
  Widget build(BuildContext context) {
    final customWidget = customContent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              Container(
                height: 100,
                width: 100,
                child: Image(image: AssetImage('assets/smile.jpg')),
              ),
              // Content
              customWidget ?? Text(text),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Pin
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
        )
      ],
    );
  }
}
