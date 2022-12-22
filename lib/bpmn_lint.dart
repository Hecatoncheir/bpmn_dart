export 'bpmn_lint_web.dart'
    if (dart.library.js) 'bpmn_lint_web.dart' // Browser, Node.JS
    if (dart.library.io) 'bpmn_lint_io.dart'; // VM