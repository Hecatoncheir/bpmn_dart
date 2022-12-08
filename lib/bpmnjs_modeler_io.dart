// ignore_for_file: prefer-match-file-name

library bpmnjs;

import 'dart:math';

class BpmnOptions {
  external String get container;
  external factory BpmnOptions({container});
}

class SaveXMLOptions {
  external bool get format;
  external factory SaveXMLOptions({format});
}

class SaveSvgOptions {
  external bool get format;
  external factory SaveSvgOptions({format});
}

class CanvasViewbox {
  external int get x;
  external int get y;
  external int get width;
  external int get height;

  external factory CanvasViewbox({x, y, width, height});
}

extension Compare on CanvasViewbox {
  bool compareTo(CanvasViewbox other) {
    if (x == other.x &&
        y == other.y &&
        width == other.width &&
        height == other.height) {
      return true;
    }
    return false;
  }
}

class BpmnCanvas {
  external factory BpmnCanvas();
  // ignore: no-object-declaration
  external Object zoom([Object type]);
  external CanvasViewbox viewbox([CanvasViewbox viewbox]);
}

extension BpmnCanvasUtils on BpmnCanvas {
  void fitViewport() {} // ignore: no-empty-block
  void centerViewport() {} // ignore: no-empty-block
  void autoViewport() {} // ignore: no-empty-block
}

class BpmnSavedXmlResponse {
  external String get xml;
  external factory BpmnSavedXmlResponse();
}

class BpmnSavedSvgResponse {
  external String get svg;
  external factory BpmnSavedSvgResponse();
}

class BpmnJS {
  external BpmnJS(BpmnOptions options);
  external Future<BpmnJS> importXML(String xml);
  external Future<BpmnSavedXmlResponse> saveXML(SaveXMLOptions options);
  external Future<BpmnSavedSvgResponse> saveSVG(SaveSvgOptions options);
}

extension BpmnJSUtils on BpmnJS {
  BpmnCanvas canvas() => BpmnCanvas();
}

typedef OnCallbackCallback = Function(BpmnJS);

extension OnCallback on BpmnJS {
  void onViewboxChange(OnCallbackCallback _) {} // ignore: no-empty-block
  void onImportRenderComplete(OnCallbackCallback _) {} // ignore: no-empty-block
}

Future<String> getXmlFromModeler(BpmnJS _) async => "";

Future<String> getSvgFromModeler(BpmnJS _) async => "";

Future<void> setViewboxCenteredAroundPoint(
  Point point, // ignore: avoid-unused-parameters
  BpmnCanvas canvas, // ignore: avoid-unused-parameters
) async {} // ignore: no-empty-block
