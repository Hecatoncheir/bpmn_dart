# BPMN
Use with `bpmn-js` library.
<br> For web only. Forger about tests if use flutter.

### How to

Check version of `bpmn-js` repository: `https://github.com/bpmn-io/bpmn-js.git`

#### HTML
<br>Add `.css` and `.js` to `index.html`:

```html
<head>
<!-- Bpmn -->
<link rel="stylesheet" href="https://unpkg.com/bpmn-js@10.2.1/dist/assets/diagram-js.css">
<link rel="stylesheet" href="https://unpkg.com/bpmn-js@10.2.1/dist/assets/bpmn-font/css/bpmn.css">

<script src="https://unpkg.com/bpmn-js@10.2.1/dist/bpmn-modeler.development.js"></script>

<!-- Dart -->
<script defer src="main.dart.js"></script>
</head>

```

#### DART
```dart

import 'package:bpmn_dart/bpmn.dart';

Future<void> main() async {
  const xml = "";
  final bpmn = Bpmn.parse(xml);
  final id = await bpmn.getId();
  final name = await bpmn.getDefinitionName();
  final svg = await bpmn.getSvg();
}

```

#### Examples:
 - [navigated_viewer](/example/navigated_viewer/)
 - [modeler](/example/modeler/)
 - [flutter_widget](/example/flutter_widget/) <br>![flutter_widget_screenshot](/example/flutter_widget.png "Flutter widget example preview")

##### Run examples:
```bash
dart pub global activate webdev
cd /example/navigated_viewer/
webdev serve
open http://127.0.0.1:8080
```

---

### Run tests:
`dart test --platform chrome`