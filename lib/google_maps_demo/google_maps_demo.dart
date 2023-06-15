import 'package:flutter/material.dart';

import 'package:google_maps/google_maps.dart' as gMap;
import 'package:google_maps/google_maps_drawing.dart' as gDrawing;
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:js' as js;

class GoogleMapsDemo extends StatefulWidget {
  const GoogleMapsDemo({Key? key}) : super(key: key);

  @override
  State<GoogleMapsDemo> createState() => _GoogleMapsDemoState();
}

class _GoogleMapsDemoState extends State<GoogleMapsDemo> {
  late html.IFrameElement _element;
  late js.JsObject _connector;
  late final _iFrameDocument;

  @override
  void initState() {
    super.initState();

    // Fucntions
    js.context["flutter_connector"] = (content) {
      _connector = content;
    };
    js.context["flutter_document"] = (html.DivElement mapEl) {
      initMap(mapEl);

    };

    // Element
    _element = html.IFrameElement()
      ..style.border = 'none'
      ..src = "assets/templates/google_map.html"
      ..onLoad.listen((event) {print("onload");});

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'gMap-html',
      (viewId) => _element,
    );
  }

  void initMap(html.DivElement el) {
    print(el);

    // Map
    final mapOptions = gMap.MapOptions()
      ..zoom = 15.0
      ..center = gMap.LatLng(35.7560423, 139.7803552);

    final map = gMap.GMap(el as html.HtmlElement, mapOptions);
  }

  Widget _map() {
    final String htmlId = "map";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final mapOptions = gMap.MapOptions()
        ..zoom = 15.0
        ..center = gMap.LatLng(35.7560423, 139.7803552);

      final elem = html.DivElement()..id = htmlId;



      final map = gMap.GMap(elem, mapOptions);

      gMap.Marker(gMap.MarkerOptions());

      return elem;
    });
    return HtmlElementView(viewType: htmlId);
  }

  @override
  Widget build(BuildContext context) {
    return _map();
  }
}
