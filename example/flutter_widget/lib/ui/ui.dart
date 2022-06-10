library ui;

import 'package:flutter/foundation.dart';

import 'fake.dart' if (dart.library.html) 'real.dart';

class PlatformViewRegistryFix {
  registerViewFactory(dynamic x, dynamic y) {
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      platformViewRegistry.registerViewFactory(
        x,
        y,
      );
    } else {}
  }
}

class UniversalUI {
  PlatformViewRegistryFix platformViewRegistry = PlatformViewRegistryFix();
}

var ui = UniversalUI();
