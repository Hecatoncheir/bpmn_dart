import 'package:flutter/material.dart';
import 'package:flutter_bpmn_modeler/bpmn_modeler/bloc/bpmn_modeler_bloc.dart';
import 'package:flutter_bpmn_modeler/bpmn_modeler/bpmn_modeler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const xml = """
<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_0ydy6jl" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="2.2.3">
  <bpmn:process id="Definition_ID" name="Definition_Name" isExecutable="true">
    <bpmn:startEvent id="StartEvent_1" />
    <bpmn:startEvent id="Event_1w1ulgz">
      <bpmn:outgoing>Flow_1na6x1a</bpmn:outgoing>
    </bpmn:startEvent>
    <bpmn:task id="Activity_0on9ogp" name="1">
      <bpmn:incoming>Flow_1na6x1a</bpmn:incoming>
    </bpmn:task>
    <bpmn:sequenceFlow id="Flow_1na6x1a" sourceRef="Event_1w1ulgz" targetRef="Activity_0on9ogp" />
    <bpmn:task id="Activity_1h76npz" name="2" />
  </bpmn:process>
  <bpmndi:BPMNDiagram id="BPMNDiagram_1">
    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Definition_ID">
      <bpmndi:BPMNShape id="Event_1w1ulgz_di" bpmnElement="Event_1w1ulgz">
        <dc:Bounds x="312" y="182" width="36" height="36" />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Activity_0on9ogp_di" bpmnElement="Activity_0on9ogp">
        <dc:Bounds x="400" y="160" width="100" height="80" />
        <bpmndi:BPMNLabel />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape id="Activity_1h76npz_di" bpmnElement="Activity_1h76npz">
        <dc:Bounds x="400" y="300" width="100" height="80" />
        <bpmndi:BPMNLabel />
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge id="Flow_1na6x1a_di" bpmnElement="Flow_1na6x1a">
        <di:waypoint x="348" y="200" />
        <di:waypoint x="400" y="200" />
      </bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</bpmn:definitions>
""";

    return MaterialApp(
      home: Scaffold(
        body: BpmnModeler(
          bloc: BpmnModelerBloc(xml: xml),
        ),
      ),
    );
  }
}
