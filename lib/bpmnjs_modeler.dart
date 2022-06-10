export 'bpmnjs_modeler_web.dart'
    if (dart.library.js) 'bpmnjs_modeler_web.dart' // Browser, Node.JS
    if (dart.library.io) 'bpmnjs_modeler_io.dart'; // VM

