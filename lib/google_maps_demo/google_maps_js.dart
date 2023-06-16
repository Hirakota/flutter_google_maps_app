import 'package:flutter/material.dart';

import 'dart:html' as html;
import 'dart:ui' as ui;

class GoogleMapsJsDemo extends StatefulWidget {
  const GoogleMapsJsDemo({Key? key}) : super(key: key);

  @override
  State<GoogleMapsJsDemo> createState() => _GoogleMapsJsDemoState();
}

class _GoogleMapsJsDemoState extends State<GoogleMapsJsDemo> {
  late html.DivElement _mapContainer;
  late html.DivElement _mapElement;

  late html.IFrameElement _mapIFrameElement;

  @override
  void initState() {
    super.initState();

    _registerMapElement();
    _registerIFrameMapElement();
  }

  void _registerMapElement() {
    _mapContainer = html.DivElement()
      ..id = 'map-container'
      ..style.height = "100%"
      ..style.width = "100%";

    _mapElement = html.DivElement()
      ..id = "map"
      ..style.height = "100%"
      ..style.width = "100%";

    final mapScript = html.ScriptElement()
      ..type = "text/javascript"
      ..text = '''
      let map;

      async function initMap() {
        // const { Map } = await google.maps.importLibrary("maps");
        // const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
        
        
        map = new google.maps.Map(document.getElementById("map"), {
          center: { lat: -25.363, lng: 131.044 },
          zoom: 8,
          mapId: "7d7a142fba8d398",
        });
        
        console.log(map);
        
        
        
        /*new google.maps.Marker({
          position: { lat: -25.363, lng: 131.044 },
          map,
          title: "Hello World!",
        });*/
        
        const priceTag = document.createElement('div');
        
        priceTag.className = 'price-tag';
        priceTag.textContent = '\$2.5M';
      
        const marker = new google.maps.marker.AdvancedMarkerElement({
            map,
            position: { lat: -25.363, lng: 131.044 },
            content: priceTag,
          });
      }
      
      window.addEventListener('message', (event) => {
        if(event.data == "initMap") {
          initMap();
        }
      });
            
    ''';

    final mapStyle = html.StyleElement()
      ..text = '''
      /* HTML marker styles */
      .price-tag {
        background-color: #4285F4;
        border-radius: 8px;
        color: #FFFFFF;
        font-size: 14px;
        padding: 10px 15px;
        position: relative;
      }
      
      .price-tag::after {
        content: "";
        position: absolute;
        left: 50%;
        top: 100%;
        transform: translate(-50%, 0);
        width: 0;
        height: 0;
        border-left: 8px solid transparent;
        border-right: 8px solid transparent;
        border-top: 8px solid #4285F4;
      }
    ''';

    _mapContainer.append(_mapElement);
    _mapContainer.append(mapStyle);
    _mapContainer.append(html.ScriptElement()
      ..type = "text/javascript"
      ..src =
          "https://maps.googleapis.com/maps/api/js?key=[API_KEY]&callback=initMap&libraries=marker&v=beta");
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

  void _registerIFrameMapElement() {
    _mapIFrameElement = html.IFrameElement()
      ..src = "/assets/templates/google_map.html"
      ..style.width = "100%"
      ..style.height = "100%";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'map-iframe',
      (int viewId) => _mapIFrameElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*return HtmlElementView(
      viewType: 'map-container',
      onPlatformViewCreated: (_) {
        // html.window.postMessage('initMap', '*');
      },
    );*/

    return Column(
      children: [
        Expanded(child: HtmlElementView(viewType: 'map-iframe')),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: OutlinedButton(
            onPressed: () {
              _mapIFrameElement.contentWindow?.postMessage({
                "action": "addMarker",
                "text":
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in"
              }, "*");
            },
            child: Text('Add marker'),
          ),
        ),
      ],
    );
  }
}
