import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:pointer_interceptor/pointer_interceptor.dart';

class IFrameJsCallBackDemo extends StatefulWidget {
  const IFrameJsCallBackDemo({Key? key}) : super(key: key);

  @override
  State<IFrameJsCallBackDemo> createState() => _IFrameJsCallBackDemoState();
}

class _IFrameJsCallBackDemoState extends State<IFrameJsCallBackDemo> {
  late final html.IFrameElement iFrame;

  @override
  void initState() {
    super.initState();

    // Register a message handler for the window.onMessage event
    html.window.addEventListener('message', listen, true);

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'myHtmlElementView',
      (int viewId) {
        final iFrameElement = html.IFrameElement()
          ..width = '100%'
          ..height = '100%'
          ..srcdoc = '''
<!DOCTYPE html>
<html>
<head>
  <script defer>
    function customAlertMessage(message) { alert(message); }
  </script>
</head>
<body>
<form id="form">
    <Button id="submitBtn" type="submit">Submit</Button>
</form>
<Button id="testBtn" type="button">Click me!</button>

<script>
    let btn = document.getElementById('testBtn');
    btn.addEventListener('click', (event) => {
       window.parent.postMessage({'message': 'hello from js', 'source': 'js'}, '*');
    });
   
   window.parent.addEventListener('message', (event) => {
        console.loge
        let data = event.data;
   
        if(data['source'] != 'flutter') return;
 
        alert('catched ' + data['message']);
    });
</script>
</body>
</html>
        '''
          ..style.border = 'none';

        iFrame = iFrameElement;

        return iFrameElement;
      },
    );
  }

  void listen(html.Event event) {
    if (event is html.MessageEvent) {
      var data = event.data;

      if (data["source"] != "js") {
        return;
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PointerInterceptor(
              child: AlertDialog(
                title: Text('Resived message'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'))
                ],
              ),
            );
          });
    }
  }

  void sender() {
    final contentWindow = iFrame.contentWindow;

    if (contentWindow != null) {
      contentWindow.parent?.postMessage(
          {"message": "hello from flutter", "source": "flutter"}, "*");
    }
  }

  void sender2() {
    // Dont' work fn should be in global intex.html as defer
    js.context.callMethod("customAlertMessage", ['Hey there is other way to call js']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: sender, child: Text('Send Message')),
        ElevatedButton(onPressed: sender2, child: Text('Send Message Other way')),
        Flexible(
          child: HtmlElementView(
            viewType: 'myHtmlElementView',
          ),
        ),
      ],
    );
  }
}
