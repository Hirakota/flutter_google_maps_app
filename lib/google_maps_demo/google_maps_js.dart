import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart' as gMap;

import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:js' as js;

class GoogleMapsJsDemo extends StatefulWidget {
  const GoogleMapsJsDemo({Key? key}) : super(key: key);

  @override
  State<GoogleMapsJsDemo> createState() => _GoogleMapsJsDemoState();
}

class _GoogleMapsJsDemoState extends State<GoogleMapsJsDemo> {
  late html.DivElement _mapContainer;
  late html.DivElement _mapElement;

  @override
  void initState() {
    super.initState();

    _registerMapElement();
  }

  void _registerMapElement() {
    _mapContainer = html.DivElement()
      ..id = 'map-container'
      ..style.height = "100%"
      ..style.width = "100%";
    _mapElement = html.DivElement()..id = "map";

    final mapScript = html.ScriptElement()
      ..text = '''
      (g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.\${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})
        ({key: "AIzaSyBZiqh7kkI7-MQ6PLVGbaWvgq0TkdrA3kQ", v: "weekly"});
      
      let map;

      async function initMap() {
        
        const { Map } = await google.maps.importLibrary("maps");
        
        map = new Map(document.getElementById("map"), {
          center: { lat: -34.397, lng: 150.644 },
          zoom: 8,
        });
        
      }
      
      initMap();
    ''';

    _mapContainer.append(_mapElement);
    _mapContainer.append(mapScript);

/*
    final mapOptions = gMap.MapOptions()
      ..zoom = 15.0
      ..center = gMap.LatLng(35.7560423, 139.7803552);

    final map = gMap.GMap(_mapContainer.getElementsByClassName("map")[0] as html.HtmlElement, mapOptions);*/
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'map-container',
      (int viewId) => _mapContainer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: 'map-container',
      onPlatformViewCreated: (_) {
        // js.context.callMethod('initMap', []);
      },
    );
  }
}
