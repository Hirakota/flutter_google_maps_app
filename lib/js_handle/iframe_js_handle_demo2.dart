import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:js' as js;

class IframeJsHandleDemo2 extends StatefulWidget {
  const IframeJsHandleDemo2({Key? key}) : super(key: key);

  @override
  State<IframeJsHandleDemo2> createState() => _IframeJsHandleDemo2State();
}

class _IframeJsHandleDemo2State extends State<IframeJsHandleDemo2> {
  late html.IFrameElement _element;
  late js.JsObject _connector;

  @override
  void initState() {
    super.initState();

    js.context["connect_content_to_flutter"] = (content) {
      _connector = content;
    };

    js.context["callSumDartFn"] = (a, b) {
      print(a + b);
    };

    _element = html.IFrameElement()
      ..style.border = 'none'
      ..srcdoc = """
        <!DOCTYPE html>
          <head>
            <script>
            
              // variant 1
              parent.connect_content_to_flutter && parent.connect_content_to_flutter(window);
              function hello(msg) {
                alert(msg)
              }
              
              function callDartSum (a, b) {
                parent.callSumDartFn && parent.callSumDartFn(a, b);
              }

              // variant 2
              window.addEventListener("message", (message) => {
                if (message.data.id === "test") {
                  alert(message.data.msg)
                }
              })
              
              // vall from js
            </script>
          </head>
          <body>
            <h2>I'm IFrame</h2>
            <Button id="testBtn" type="button">Call sum 2 + 2</Button>
          </body>
          <script>
            let btn = document.getElementById('testBtn');
            btn.addEventListener('click', (event) => {
              parent.callSumDartFn(2, 2);
            });
            
          </script>
        </html>
        """
    ;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'example',
          (int viewId) => _element,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.filter_1),
            tooltip: 'Test with connector',
            onPressed: () {
              _connector.callMethod('hello', ['Hello from first variant']);
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_2),
            tooltip: 'Test with postMessage',
            onPressed: () {
              _element.contentWindow?.postMessage({
                'id': 'test',
                'msg': 'Hello from second variant',
              }, "*");
            },
          )
        ],
      ),
      body: Container(
        child: HtmlElementView(viewType: 'example'),
      ),
    );
  }
}
