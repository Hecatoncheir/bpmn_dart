// ignore_for_file: prefer-match-file-name

@JS('BpmnJS')
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
class SaveSVGOptions {
  external bool get format;
  external factory SaveSVGOptions({format});
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
  external double get x;
  external double get y;
  external double get width;
  external double get height;

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

@JS()
class NavigatedViewer {
  external NavigatedViewer(BpmnOptions options);

  /// importXml - нужен для отображения bpmn в html элементе.
  /// Если нужно сделать что-то с NavigatedViewer после импортирования xml,
  /// нужно использоваться Future и
  /// тот же NavigatedViewer(не тот что возвращается из importXML).
  /// Пример:
  ///   void importXML(String xml) {
  //     _navigator.importXML(xml);
  //     Future(() {
  //       final canvas = _navigator.get('canvas');
  //       canvas.zoom('fit-viewport');
  //     });
  //   }
  external Future<NavigatedViewer> importXML(String xml);

  external Future<BpmnSavedXmlResponse> saveXML(SaveXMLOptions options);
  external Future<BpmnSavedSvgResponse> saveSVG(SaveSvgOptions options);
  external BpmnCanvas get(String name);
}

typedef OnViewboxChangeCallback = Function(NavigatedViewer);

extension OnCallback on NavigatedViewer {
  void onViewboxChange(OnViewboxChangeCallback callback) {
    callMethod(this, "on", [
      "canvas.viewbox.changed",
      allowInterop((_, __) {
        callback(this);
      }),
    ]);
  }
}

/// It takes a NavigatedViewer and returns a Future that resolves to the XML of the modeler
///
/// Args:
///   modeler (NavigatedViewer): The modeler instance
Future<String> getXmlFromModeler(NavigatedViewer modeler) async =>
    promiseToFuture(modeler.saveXML(SaveXMLOptions(format: true)))
        .then((response) => response.xml);

/// It takes a NavigatedViewer, and returns a Future that resolves to a String containing the SVG
///
/// Args:
///   viewer (NavigatedViewer): The NavigatedViewer object that you want to get the SVG from.
Future<String> getSvgFromViewer(NavigatedViewer viewer) async =>
    promiseToFuture(viewer.saveSVG(SaveSvgOptions(format: true)))
        .then((response) => response.svg);

/// It sets the viewbox of the canvas to be centered around the given point
///
/// Args:
///   point (Point): The point around which the viewbox should be centered.
///   canvas (BpmnCanvas): The canvas that you want to set the viewbox for.
Future<void> setViewboxCenteredAroundPoint(
  Point point,
  BpmnCanvas canvas,
) async {
  // get cached viewbox to preserve zoom
  final cachedViewbox = canvas.viewbox(),
      cachedViewboxWidth = cachedViewbox.width,
      cachedViewboxHeight = cachedViewbox.height;

  canvas.viewbox(CanvasViewbox(
    x: point.x - cachedViewboxWidth / 2, //ignore: no-magic-number
    y: point.y - cachedViewboxHeight / 2, // ignore: no-magic-number
    width: cachedViewboxWidth,
    height: cachedViewboxHeight,
  ));
}
