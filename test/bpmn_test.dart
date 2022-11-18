@TestOn('browser')
library bpmn_test;

import 'package:test/test.dart';
import 'package:universal_html/html.dart';

import 'package:bpmn_dart/bpmn.dart';

void main() {
  group("Bpmn", () {
    test("can return definition id", () async {
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

      final bpmnSource = Bpmn.parse(xml);
      final definitionName = await bpmnSource.getId();
      expect(definitionName, equals("Definition_ID"));
    });

    test("can return definition name", () async {
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

      final bpmnSource = Bpmn.parse(xml);
      final definitionName = await bpmnSource.getDefinitionName();
      expect(definitionName, equals("Definition_Name"));
    });

    test("can return roles", () async {
      const xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_0fufvfz" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="3.7.1">
          <bpmn:process id="Process_10abycs" isExecutable="true">
            <bpmn:laneSet id="LaneSet_0pzq1yi">
              <bpmn:lane id="Lane_1ignpfr" name="МКО">
              </bpmn:lane>
              <bpmn:lane id="Lane_118ganq" name="Договорный сектор">
              </bpmn:lane>
              <bpmn:lane id="Lane_1e5q9x4" name="ПМ">
              </bpmn:lane>
            </bpmn:laneSet>
          </bpmn:process>
        </bpmn:definitions>
        """;

      final bpmnSource = Bpmn.parse(xml);
      final roles = await bpmnSource.getRoles();

      expect(roles, isNotEmpty);
      expect(roles, equals(["МКО", "Договорный сектор", "ПМ"]));
    });
  });
}
