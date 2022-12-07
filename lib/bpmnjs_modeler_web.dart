// ignore_for_file: prefer-match-file-name
@JS()
library bpmnjs;

import 'dart:math';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

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

@JS()
@anonymous
class BpmnCanvas {
  external factory BpmnCanvas();

  // ignore: no-object-declaration
  external Object zoom([
    Object type,
    Point point,
  ]);

  external CanvasViewbox viewbox([CanvasViewbox viewbox]);
}

extension BpmnCanvasUtils on BpmnCanvas {
  void fitViewport() {
    callMethod(this, "zoom", [
      "fit-viewport",
    ]);
  }

  void centerViewport() {
    callMethod(this, "zoom", [
      "center",
    ]);
  }

  void autoViewport() {
    callMethod(this, "zoom", [
      "auto",
    ]);
  }
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

  /// importXml - нужен для отображения bpmn в html элементе.
  /// Если нужно сделать что-то с Modeler после импортирования xml,
  /// нужно использоваться Future и
  /// тот же Modeler(не тот что возвращается из importXML).
  /// Пример:
  ///   void importXML(String xml) {
  //     _modeler.importXML(xml);
  //     Future(() {
  //       final canvas = _modeler.get('canvas');
  //       canvas.zoom('fit-viewport');
  //     });
  //   }
  external Future<BpmnJS> importXML(String xml);

  external Future<BpmnSavedXmlResponse> saveXML(SaveXMLOptions options);
  external Future<BpmnSavedSvgResponse> saveSVG(SaveSvgOptions options);
}

extension BpmnJSUtils on BpmnJS {
  BpmnCanvas canvas() => callMethod(this, "get", ["canvas"]);
}

typedef OnCallbackCallback = Function(BpmnJS);

extension OnCallback on BpmnJS {
  void onViewboxChange(OnCallbackCallback callback) {
    callMethod(this, "on", [
      "canvas.viewbox.changed",
      allowInterop((_, __) {
        callback(this);
      }),
    ]);
  }

  void onImportRenderComplete(OnCallbackCallback callback) {
    callMethod(this, "on", [
      "import.render.complete",
      allowInterop((_, __) {
        callback(this);
      }),
    ]);
  }
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
