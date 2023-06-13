import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html';

class ShowHtmlElementView extends StatefulWidget {
  const ShowHtmlElementView({Key? key}) : super(key: key);

  @override
  State<ShowHtmlElementView> createState() => _ShowHtmlElementViewState();
}

class _ShowHtmlElementViewState extends State<ShowHtmlElementView> {
  @override
  void initState() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'hello-html',
            (int viewId) => IFrameElement()
          ..width = '640'
          ..height = '360'
          ..src = 'https://www.youtube.com/embed/xg4S67ZvsRs'
          ..style.border = 'none'
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return const HtmlElementView(
      viewType: 'hello-html',
    );
  }
}
