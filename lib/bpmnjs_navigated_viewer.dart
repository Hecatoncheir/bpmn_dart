export 'bpmnjs_navigated_viewer_web.dart'
    if (dart.library.js) 'bpmnjs_navigated_viewer_web.dart' // Browser, Node.JS
    if (dart.library.io) 'bpmnjs_navigated_viewer_io.dart'; // VM