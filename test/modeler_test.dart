@TestOn('browser')
library modeler_test;

import 'package:test/test.dart';
import 'package:universal_html/html.dart';

import 'package:bpmn_dart/bpmnjs_modeler.dart';

void main() {
  test('NavigatedViewer', () {
    final body = document.querySelector('body');
    final viewer = BpmnJS(BpmnOptions(container: body));

    const xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" id="sid-38422fae-e03e-43a3-bef4-bd33b32041b2" targetNamespace="http://bpmn.io/bpmn" exporter="bpmn-js (https://demo.bpmn.io)" exporterVersion="10.2.1">
      <process id="Process_1" isExecutable="false">
        <startEvent id="StartEvent_1y45yut" name="hunger noticed">
          <outgoing>SequenceFlow_0h21x7r</outgoing>
        </startEvent>
        <task id="Task_1hcentk" name="choose recipe">
          <incoming>SequenceFlow_0h21x7r</incoming>
          <outgoing>SequenceFlow_0wnb4ke</outgoing>
        </task>
        <sequenceFlow id="SequenceFlow_0h21x7r" sourceRef="StartEvent_1y45yut" targetRef="Task_1hcentk" />
        <exclusiveGateway id="ExclusiveGateway_15hu1pt" name="desired dish?">
          <incoming>SequenceFlow_0wnb4ke</incoming>
        </exclusiveGateway>
        <sequenceFlow id="SequenceFlow_0wnb4ke" sourceRef="Task_1hcentk" targetRef="ExclusiveGateway_15hu1pt" />
      </process>
      <bpmndi:BPMNDiagram id="BpmnDiagram_1">
        <bpmndi:BPMNPlane id="BpmnPlane_1" bpmnElement="Process_1">
          <bpmndi:BPMNEdge id="SequenceFlow_0wnb4ke_di" bpmnElement="SequenceFlow_0wnb4ke">
            <omgdi:waypoint x="340" y="120" />
            <omgdi:waypoint x="395" y="120" />
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNEdge id="SequenceFlow_0h21x7r_di" bpmnElement="SequenceFlow_0h21x7r">
            <omgdi:waypoint x="188" y="120" />
            <omgdi:waypoint x="240" y="120" />
          </bpmndi:BPMNEdge>
          <bpmndi:BPMNShape id="StartEvent_1y45yut_di" bpmnElement="StartEvent_1y45yut">
            <omgdc:Bounds x="152" y="102" width="36" height="36" />
            <bpmndi:BPMNLabel>
              <omgdc:Bounds x="134" y="145" width="73" height="14" />
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="Task_1hcentk_di" bpmnElement="Task_1hcentk">
            <omgdc:Bounds x="240" y="80" width="100" height="80" />
          </bpmndi:BPMNShape>
          <bpmndi:BPMNShape id="ExclusiveGateway_15hu1pt_di" bpmnElement="ExclusiveGateway_15hu1pt" isMarkerVisible="true">
            <omgdc:Bounds x="395" y="95" width="50" height="50" />
            <bpmndi:BPMNLabel>
              <omgdc:Bounds x="388" y="152" width="65" height="14" />
            </bpmndi:BPMNLabel>
          </bpmndi:BPMNShape>
        </bpmndi:BPMNPlane>
      </bpmndi:BPMNDiagram>
    </definitions>
    """;

    viewer.importXML(xml);
    expect(viewer, isNotNull);
  });
}
