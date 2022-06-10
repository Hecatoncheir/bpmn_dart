import 'dart:ui' as ui;

// ignore: camel_case_types, prefer-match-file-name, camel_case_types, prefer-correct-type-name
class platformViewRegistry {
  static registerViewFactory(String viewId, dynamic cb) {
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, cb);
  }
}
