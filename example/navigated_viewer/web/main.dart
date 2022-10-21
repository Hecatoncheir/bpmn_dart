import 'dart:html';

import 'package:bpmn_dart/bpmn.dart';
import 'package:bpmn_dart/bpmnjs_navigated_viewer.dart';

Future<void> main() async {
  const xml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" id="Definitions_0ydy6jl" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="3.7.1">
        <bpmn:process id="Definition_ID" name="Definition_Name" isExecutable="true">
          <bpmn:startEvent id="StartEvent_1" />
        </bpmn:process>
        <bpmndi:BPMNDiagram id="BPMNDiagram_1">
          <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Definition_ID">
            <bpmndi:BPMNShape id="_BPMNShape_StartEvent_2" bpmnElement="StartEvent_1">
              <dc:Bounds x="179" y="79" width="36" height="36" />
            </bpmndi:BPMNShape>
          </bpmndi:BPMNPlane>
        </bpmndi:BPMNDiagram>
      </bpmn:definitions>
      """;

  final _ = Bpmn.parse(xml);

  final element = querySelector('#output');
  final view = NavigatedViewer(BpmnOptions(container: element));
  view.importXML(xml);

  view.onViewboxChange((view) {
    final viewbox = view.get("canvas").viewbox();
    print(viewbox.x);
    print(viewbox.y);
  });

  view.onImportRenderComplete((view) {
    final canvas = view.get("canvas");
    canvas.fitViewport();
  });

  Future(() async {
    final canvas = view.get('canvas');
    canvas.centerViewport();

    final viewbox = canvas.viewbox();
    final x = viewbox.width / 3;
    final y = viewbox.height / 3;
    final point = Point(x, y);

    setViewboxCenteredAroundPoint(point, canvas);
  });
}
