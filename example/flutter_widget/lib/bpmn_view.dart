import 'package:uuid/uuid.dart';

import 'ui/ui.dart';
import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// import 'package:bpmn_dart/bpmnjs_navigated_viewer.dart';
import 'package:bpmn_dart/bpmnjs_modeler.dart';

class BpmnView extends StatefulWidget {
  const BpmnView({super.key});

  @override
  State<BpmnView> createState() => _BpmnViewState();
}

class _BpmnViewState extends State<BpmnView> {
  late final String id;

  @override
  void initState() {
    super.initState();

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

    final area = DivElement()
      ..style.position = "relative"
      ..style.left = "0"
      ..style.top = "0"
      ..style.right = "0"
      ..style.bottom = "0";

    // final viewer = NavigatedViewer(BpmnOptions(container: area));
    final viewer = BpmnJS(BpmnOptions(container: area));

    id = const Uuid().v4();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      id,
      (int viewId) => area,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      viewer
        ..importXML(xml)
        ..get('canvas').zoom('fit-viewport');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key("bpmn_view"),
      children: [
        Expanded(
          child: HtmlElementView(
            key: const Key("bpmn_view_area"),
            viewType: id,
          ),
        ),
      ],
    );
  }
}
