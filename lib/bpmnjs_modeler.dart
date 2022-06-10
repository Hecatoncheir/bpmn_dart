// ignore_for_file: prefer-match-file-name
@JS()
library bpmnjs;

import 'dart:math';

import 'package:universal_html/js.dart';
import 'package:universal_html/js_util.dart';

@JS()
@anonymous
class BpmnOptions {
  external String get container;
  external factory BpmnOptions({container});
}

@JS()
@anonymous
class SaveXMLOptions {
  external bool get format;
  external factory SaveXMLOptions({format});
}

@JS()
@anonymous
class SaveSvgOptions {
  external bool get format;
  external factory SaveSvgOptions({format});
}

@JS()
@anonymous
class CanvasViewbox {
  external int get x;
  external int get y;
  external int get width;
  external int get height;

  external factory CanvasViewbox({x, y, width, height});
}

@JS()
@anonymous
class BpmnCanvas {
  external factory BpmnCanvas();
  // ignore: no-object-declaration
  external Object zoom([Object type]);
  external CanvasViewbox viewbox([CanvasViewbox viewbox]);
}

@JS()
@anonymous
class BpmnSavedXmlResponse {
  external String get xml;
  external factory BpmnSavedXmlResponse();
}

@JS()
@anonymous
class BpmnSavedSvgResponse {
  external String get svg;
  external factory BpmnSavedSvgResponse();
}

@JS('BpmnJS')
class BpmnJS {
  external BpmnJS(BpmnOptions options);
  external Future<BpmnJS> importXML(String xml);
  external Future<BpmnSavedXmlResponse> saveXML(SaveXMLOptions options);
  external Future<BpmnSavedSvgResponse> saveSVG(SaveSvgOptions options);
  external BpmnCanvas get(String name);
}

Future<String> getXmlFromModeler(BpmnJS modeler) async =>
    promiseToFuture(modeler.saveXML(SaveXMLOptions(format: true)))
        .then((response) => response.xml);

Future<String> getSvgFromModeler(BpmnJS modeler) async =>
    promiseToFuture(modeler.saveSVG(SaveSvgOptions(format: true)))
        .then((response) => response.svg);

Future<void> setViewboxCenteredAroundPoint(
  Point point,
  BpmnCanvas canvas,
) async {
  // get cached viewbox to preserve zoom
  final cachedViewbox = canvas.viewbox(),
      cachedViewboxWidth = cachedViewbox.width,
      cachedViewboxHeight = cachedViewbox.height;

  canvas.viewbox(CanvasViewbox(
    x: point.x - cachedViewboxWidth / 2, // ignore: no-magic-number
    y: point.y - cachedViewboxHeight / 2, // ignore: no-magic-number
    width: cachedViewboxWidth,
    height: cachedViewboxHeight,
  ));
}
