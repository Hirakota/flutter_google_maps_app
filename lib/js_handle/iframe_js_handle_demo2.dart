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
  late html.DivElement _divElement;
  late js.JsObject _connector;

  @override
  void initState() {
    super.initState();

    // Register elements
    _registerIFrame();
    _registerDivElement();
    _registerFormElement();
  }

  void _registerIFrame() {
    js.context["connect_content_to_flutter"] = (content) {
      _connector = content as js.JsObject;
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
            <Button id="messageBtn" type="button">Post message</Button>
          </body>
          <script>
            let btn = document.getElementById('testBtn');
            btn.addEventListener('click', (event) => {
              parent.callSumDartFn(2, 2);
            });
            
            let messageBtn = document.getElementById('messageBtn');
            messageBtn.addEventListener('click', (event) => {
              window.postMessage("world", "*");
            });
          </script>
        </html>
        """
      ..on["message"].listen((event) {
        print('from on');
      });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'example',
      (int viewId) => _element,
    );
  }

  void _registerDivElement() {
    js.context["sendMessage"] = (text) {
      print("message from divScript: $text");
    };

    _divElement = html.DivElement()
      ..id = 'firstDiv'
      ..style.height = "200px"
      ..style.width = "200px"
      ..style.backgroundColor = "#456789"
      ..append(html.DivElement()
        ..id = "div1"
        ..style.height = "150px"
        ..style.height = "150px"
        ..style.backgroundColor = "yellow")
      ..append(html.ButtonElement()
        ..id = "divBtn"
        ..text = "Post message")
      ..append(html.ScriptElement()
        ..text = """
          let div1 = document.getElementById("div1");
          div1.addEventListener('click', (event) => {
            window.postMessage('hello from div1', '*');
          });
          
          let divBtn = document.getElementById("divBtn");
          divBtn.addEventListener('click', (event) => {
          
            //can't be catched
         
            parent.postMessage('hello from divBtn', '*');
            postMessage('hello from divBtn', '*');
            window.postMessage('hello from divBtn', '*');
            window.parent.postMessage('hello from divBtn', '*');
            
            parent.sendMessage("text");
            
            alert("btn");
          });
        """)
      ..on["message"].listen((event) {
        print('message from firstDiv: $event');
      })
      ..on["mouseover"].listen((event) {
        print('hovered');
      })
      ..on['click'].listen((event) {
        print('clicked');
      });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'divElement',
      (int viewId) => _divElement,
    );
  }

  void _registerFormElement() {
    final formElement = html.FormElement();

    final formInput = html.InputElement()
      ..id = "fInput"
      ..type = "text"
      ..name = "name";
    final fromSubmitBtn = html.ButtonElement()
      ..id = "fSubmit"
      ..type = "submit"
      ..innerText = "Submit";

    formElement.append(formInput);
    formElement.append(fromSubmitBtn);

    formElement.onSubmit.listen((event) {
      event.preventDefault();

      final data = html.FormData(event.target as html.FormElement);
      final name = data.get("name") as String?;

      print('formSubmit $event - name: $name');
    });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory('formElement', (viewId) => formElement);
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
        child: Column(
          children: [
            Flexible(child: HtmlElementView(viewType: 'example')),
            Flexible(child: HtmlElementView(viewType: 'divElement')),
            Flexible(child: HtmlElementView(viewType: 'formElement')),
          ],
        ),
      ),
    );
  }
}
