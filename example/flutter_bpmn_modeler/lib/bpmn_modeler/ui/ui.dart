import 'package:flutter/foundation.dart';
import 'ui_io.dart' if (dart.library.html) 'ui_web.dart' as ui_instance;

// ignore: prefer-match-file-name
class PlatformViewRegistryFix {
  registerViewFactory(dynamic x, dynamic y) {
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui_instance.platformViewRegistry.registerViewFactory(
        x,
        y,
      );
      // ignore: no-empty-block
    } else {}
  }
}

class UniversalUI {
  PlatformViewRegistryFix platformViewRegistry = PlatformViewRegistryFix();
}

// ignore: avoid-global-state
var ui = UniversalUI();
