import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_google_maps_app/google_maps_demo/google_map_flutter.dart';
import 'package:flutter_google_maps_app/google_maps_demo/google_maps_demo.dart';
import 'package:flutter_google_maps_app/google_maps_demo/google_maps_js.dart';
import 'package:flutter_google_maps_app/js_handle/iframe_js_callback_demo.dart';
import 'package:flutter_google_maps_app/js_handle/iframe_js_handle_demo2.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'ShowHtmlElementView.dart';


void main() {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // AS - TODO: navigator

            /*if(kIsWeb)
              Flexible(child: ShowHtmlElementView()),*/


            /*if(kIsWeb)
              Flexible(child: GoogleMapsFlutter()),*/
            // Flexible(child: GoogleMapsDemo()),
            // Flexible(child: GoogleMapsJsDemo()),

            /*if(kIsWeb)
              Flexible(child: IFrameJsCallBackDemo()),*/
            if(kIsWeb)
              Flexible(child: IframeJsHandleDemo2()),
          ],
        ),
      ),
    );
  }
}
