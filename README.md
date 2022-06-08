# BPMN
Use with `bpmn-js` library.

### How to

Check version of `bpmn-js` repository: `https://github.com/bpmn-io/bpmn-js.git`
Add `.css` and `.js` to `index.html`:

```html
<head>

<!-- Bpmn -->
<link rel="stylesheet" href="https://unpkg.com/bpmn-js@9.2.0/dist/assets/diagram-js.css">
<link rel="stylesheet" href="https://unpkg.com/bpmn-js@9.2.0/dist/assets/bpmn-font/css/bpmn.css">

<script src="https://unpkg.com/bpmn-js@9.2.0/dist/bpmn-modeler.development.js"></script>

</head>

```
In dart:
```dart

import 'package:bpmn_dart/bpmn.dart';

void main(){
    final xml = "";
    final bpmn = Bpmn.parse(xml);
    final id = await bpmn.getId();
    final definitionName = await bpmnSource.getDefinitionName();
    final svg = await bpmnSource.getSvg();
}
```

---

### Run tests:
`dart test -p chrome`