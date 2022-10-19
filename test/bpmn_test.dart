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
          <bpmn:collaboration id="Collaboration_1asxi0x">
            <bpmn:participant id="Participant_109eocm" name="Клиентские стройки" processRef="Process_10abycs" />
          </bpmn:collaboration>
          <bpmn:process id="Process_10abycs" isExecutable="true">
            <bpmn:laneSet id="LaneSet_0pzq1yi">
              <bpmn:lane id="Lane_1ignpfr" name="МКО">
                <bpmn:flowNodeRef>StartEvent_1</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>ExclusiveGateway_1scjwbv</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>ExclusiveGateway_04pv3c6</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>Task_0hlrlcj</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>ExclusiveGateway_08jezor</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>Task_0bhqwoh</bpmn:flowNodeRef>
              </bpmn:lane>
              <bpmn:lane id="Lane_118ganq" name="Договорный сектор">
                <bpmn:flowNodeRef>Task_0aa9mh6</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>Gateway_0bmvthf</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>ExclusiveGateway_03ax4cf</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>ExclusiveGateway_1pi6klp</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>CallActivity_0hjfv44</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>Task_1houvma</bpmn:flowNodeRef>
              </bpmn:lane>
              <bpmn:lane id="Lane_1e5q9x4" name="ПМ">
                <bpmn:flowNodeRef>ExclusiveGateway_100op7m</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>CallActivity_0wucsuz</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>CallActivity_07o1xvu</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>EndEvent_0j9b1h2</bpmn:flowNodeRef>
                <bpmn:flowNodeRef>ExclusiveGateway_0cxp6ct</bpmn:flowNodeRef>
              </bpmn:lane>
            </bpmn:laneSet>
            <bpmn:startEvent id="StartEvent_1">
              <bpmn:outgoing>SequenceFlow_0h9pnwe</bpmn:outgoing>
            </bpmn:startEvent>
            <bpmn:exclusiveGateway id="ExclusiveGateway_1scjwbv" name="Требуется проработка?">
              <bpmn:incoming>SequenceFlow_0undqrg</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_1vabi2j</bpmn:outgoing>
              <bpmn:outgoing>SequenceFlow_03hx8bo</bpmn:outgoing>
            </bpmn:exclusiveGateway>
            <bpmn:exclusiveGateway id="ExclusiveGateway_04pv3c6">
              <bpmn:incoming>SequenceFlow_1vabi2j</bpmn:incoming>
              <bpmn:incoming>SequenceFlow_0ngln1x</bpmn:incoming>
              <bpmn:outgoing>Flow_17k3gge</bpmn:outgoing>
            </bpmn:exclusiveGateway>
            <bpmn:callActivity id="Task_0hlrlcj" name="Проработка объекта">
              <bpmn:incoming>SequenceFlow_03hx8bo</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_0ngln1x</bpmn:outgoing>
            </bpmn:callActivity>
            <bpmn:parallelGateway id="ExclusiveGateway_08jezor">
              <bpmn:incoming>SequenceFlow_0y6y003</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_141ry8e</bpmn:outgoing>
              <bpmn:outgoing>SequenceFlow_0undqrg</bpmn:outgoing>
            </bpmn:parallelGateway>
            <bpmn:callActivity id="Task_0bhqwoh" name="Осмечивание стройки">
              <bpmn:incoming>SequenceFlow_0h9pnwe</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_0y6y003</bpmn:outgoing>
            </bpmn:callActivity>
            <bpmn:task id="Task_0aa9mh6" name="Подготовить договор о сотрудничестве">
              <bpmn:incoming>SequenceFlow_141ry8e</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_03uk4pk</bpmn:outgoing>
            </bpmn:task>
            <bpmn:parallelGateway id="Gateway_0bmvthf">
              <bpmn:incoming>SequenceFlow_03uk4pk</bpmn:incoming>
              <bpmn:incoming>Flow_17k3gge</bpmn:incoming>
              <bpmn:outgoing>Flow_0gtckai</bpmn:outgoing>
            </bpmn:parallelGateway>
            <bpmn:exclusiveGateway id="ExclusiveGateway_03ax4cf" name="Обговорено?">
              <bpmn:incoming>Flow_0gtckai</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_1iviu6k</bpmn:outgoing>
              <bpmn:outgoing>SequenceFlow_02xs5zd</bpmn:outgoing>
            </bpmn:exclusiveGateway>
            <bpmn:exclusiveGateway id="ExclusiveGateway_1pi6klp">
              <bpmn:incoming>SequenceFlow_0duehum</bpmn:incoming>
              <bpmn:incoming>SequenceFlow_1630cnh</bpmn:incoming>
              <bpmn:outgoing>Flow_0jh9yho</bpmn:outgoing>
            </bpmn:exclusiveGateway>
            <bpmn:callActivity id="CallActivity_0hjfv44" name="Согласование договора о сотрудничестве.">
              <bpmn:incoming>SequenceFlow_1iviu6k</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_1630cnh</bpmn:outgoing>
            </bpmn:callActivity>
            <bpmn:callActivity id="Task_1houvma" name="Согласование договора о сотрудничестве">
              <bpmn:incoming>SequenceFlow_02xs5zd</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_0duehum</bpmn:outgoing>
            </bpmn:callActivity>
            <bpmn:inclusiveGateway id="ExclusiveGateway_100op7m" default="SequenceFlow_1mt4bym">
              <bpmn:incoming>Flow_0jh9yho</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_1mt4bym</bpmn:outgoing>
              <bpmn:outgoing>SequenceFlow_084vqr7</bpmn:outgoing>
            </bpmn:inclusiveGateway>
            <bpmn:callActivity id="CallActivity_0wucsuz" name="Аренда канала">
              <bpmn:incoming>SequenceFlow_084vqr7</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_1ihupsd</bpmn:outgoing>
            </bpmn:callActivity>
            <bpmn:callActivity id="CallActivity_07o1xvu" name="Стройка на объекте.">
              <bpmn:incoming>SequenceFlow_1mt4bym</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_00rsr4d</bpmn:outgoing>
            </bpmn:callActivity>
            <bpmn:endEvent id="EndEvent_0j9b1h2">
              <bpmn:incoming>SequenceFlow_04xjjk8</bpmn:incoming>
            </bpmn:endEvent>
            <bpmn:inclusiveGateway id="ExclusiveGateway_0cxp6ct">
              <bpmn:incoming>SequenceFlow_00rsr4d</bpmn:incoming>
              <bpmn:incoming>SequenceFlow_1ihupsd</bpmn:incoming>
              <bpmn:outgoing>SequenceFlow_04xjjk8</bpmn:outgoing>
            </bpmn:inclusiveGateway>
            <bpmn:sequenceFlow id="SequenceFlow_04xjjk8" sourceRef="ExclusiveGateway_0cxp6ct" targetRef="EndEvent_0j9b1h2" />
            <bpmn:sequenceFlow id="SequenceFlow_1ihupsd" sourceRef="CallActivity_0wucsuz" targetRef="ExclusiveGateway_0cxp6ct" />
            <bpmn:sequenceFlow id="SequenceFlow_00rsr4d" sourceRef="CallActivity_07o1xvu" targetRef="ExclusiveGateway_0cxp6ct" />
            <bpmn:sequenceFlow id="SequenceFlow_084vqr7" name="Аренда канала / Радиоканал" sourceRef="ExclusiveGateway_100op7m" targetRef="CallActivity_0wucsuz" />
            <bpmn:sequenceFlow id="SequenceFlow_0h9pnwe" sourceRef="StartEvent_1" targetRef="Task_0bhqwoh" />
            <bpmn:sequenceFlow id="SequenceFlow_0y6y003" sourceRef="Task_0bhqwoh" targetRef="ExclusiveGateway_08jezor" />
            <bpmn:sequenceFlow id="SequenceFlow_141ry8e" sourceRef="ExclusiveGateway_08jezor" targetRef="Task_0aa9mh6" />
            <bpmn:sequenceFlow id="SequenceFlow_0undqrg" sourceRef="ExclusiveGateway_08jezor" targetRef="ExclusiveGateway_1scjwbv" />
            <bpmn:sequenceFlow id="SequenceFlow_03uk4pk" sourceRef="Task_0aa9mh6" targetRef="Gateway_0bmvthf" />
            <bpmn:sequenceFlow id="SequenceFlow_03hx8bo" name="Да" sourceRef="ExclusiveGateway_1scjwbv" targetRef="Task_0hlrlcj" />
            <bpmn:sequenceFlow id="SequenceFlow_1vabi2j" name="Нет" sourceRef="ExclusiveGateway_1scjwbv" targetRef="ExclusiveGateway_04pv3c6" />
            <bpmn:sequenceFlow id="SequenceFlow_0ngln1x" sourceRef="Task_0hlrlcj" targetRef="ExclusiveGateway_04pv3c6" />
            <bpmn:sequenceFlow id="Flow_0gtckai" sourceRef="Gateway_0bmvthf" targetRef="ExclusiveGateway_03ax4cf" />
            <bpmn:sequenceFlow id="Flow_17k3gge" sourceRef="ExclusiveGateway_04pv3c6" targetRef="Gateway_0bmvthf" />
            <bpmn:sequenceFlow id="SequenceFlow_02xs5zd" name="да" sourceRef="ExclusiveGateway_03ax4cf" targetRef="Task_1houvma" />
            <bpmn:sequenceFlow id="SequenceFlow_1iviu6k" name="нет" sourceRef="ExclusiveGateway_03ax4cf" targetRef="CallActivity_0hjfv44" />
            <bpmn:sequenceFlow id="SequenceFlow_1630cnh" sourceRef="CallActivity_0hjfv44" targetRef="ExclusiveGateway_1pi6klp" />
            <bpmn:sequenceFlow id="SequenceFlow_0duehum" sourceRef="Task_1houvma" targetRef="ExclusiveGateway_1pi6klp" />
            <bpmn:sequenceFlow id="Flow_0jh9yho" sourceRef="ExclusiveGateway_1pi6klp" targetRef="ExclusiveGateway_100op7m" />
          </bpmn:process>
          <bpmndi:BPMNDiagram id="BPMNDiagram_1">
            <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Collaboration_1asxi0x">
              <bpmndi:BPMNShape id="Participant_109eocm_di" bpmnElement="Participant_109eocm" isHorizontal="true">
                <dc:Bounds x="160" y="85" width="1330" height="730" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="Lane_1ignpfr_di" bpmnElement="Lane_1ignpfr" isHorizontal="true">
                <dc:Bounds x="190" y="85" width="1300" height="250" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="Lane_118ganq_di" bpmnElement="Lane_118ganq" isHorizontal="true">
                <dc:Bounds x="190" y="335" width="1300" height="260" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="Lane_1e5q9x4_di" bpmnElement="Lane_1e5q9x4" isHorizontal="true">
                <dc:Bounds x="190" y="595" width="1300" height="220" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNEdge id="SequenceFlow_04xjjk8_di" bpmnElement="SequenceFlow_04xjjk8">
                <di:waypoint x="1395" y="755" />
                <di:waypoint x="1422" y="755" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_1ihupsd_di" bpmnElement="SequenceFlow_1ihupsd">
                <di:waypoint x="1290" y="655" />
                <di:waypoint x="1370" y="655" />
                <di:waypoint x="1370" y="730" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_00rsr4d_di" bpmnElement="SequenceFlow_00rsr4d">
                <di:waypoint x="1290" y="755" />
                <di:waypoint x="1345" y="755" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_084vqr7_di" bpmnElement="SequenceFlow_084vqr7">
                <di:waypoint x="1100" y="730" />
                <di:waypoint x="1100" y="655" />
                <di:waypoint x="1190" y="655" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="1098" y="621" width="84" height="27" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_1mt4bym_di" bpmnElement="SequenceFlow_1mt4bym">
                <di:waypoint x="1125" y="755" />
                <di:waypoint x="1190" y="755" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="1142" y="738" width="31" height="14" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_0h9pnwe_di" bpmnElement="SequenceFlow_0h9pnwe">
                <di:waypoint x="278" y="250" />
                <di:waypoint x="310" y="250" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_0y6y003_di" bpmnElement="SequenceFlow_0y6y003">
                <di:waypoint x="410" y="250" />
                <di:waypoint x="445" y="250" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_141ry8e_di" bpmnElement="SequenceFlow_141ry8e">
                <di:waypoint x="470" y="275" />
                <di:waypoint x="470" y="430" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_0undqrg_di" bpmnElement="SequenceFlow_0undqrg">
                <di:waypoint x="495" y="250" />
                <di:waypoint x="535" y="250" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_03uk4pk_di" bpmnElement="SequenceFlow_03uk4pk">
                <di:waypoint x="520" y="470" />
                <di:waypoint x="645" y="470" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_03hx8bo_di" bpmnElement="SequenceFlow_03hx8bo">
                <di:waypoint x="560" y="225" />
                <di:waypoint x="560" y="180" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="568" y="203" width="13" height="14" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_1vabi2j_di" bpmnElement="SequenceFlow_1vabi2j">
                <di:waypoint x="585" y="250" />
                <di:waypoint x="645" y="250" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="600" y="228" width="20" height="14" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_0ngln1x_di" bpmnElement="SequenceFlow_0ngln1x">
                <di:waypoint x="610" y="140" />
                <di:waypoint x="670" y="140" />
                <di:waypoint x="670" y="225" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="Flow_0gtckai_di" bpmnElement="Flow_0gtckai">
                <di:waypoint x="695" y="470" />
                <di:waypoint x="725" y="470" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="Flow_17k3gge_di" bpmnElement="Flow_17k3gge">
                <di:waypoint x="670" y="275" />
                <di:waypoint x="670" y="445" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_02xs5zd_di" bpmnElement="SequenceFlow_02xs5zd">
                <di:waypoint x="750" y="445" />
                <di:waypoint x="750" y="390" />
                <di:waypoint x="820" y="390" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="759" y="425" width="12" height="14" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_1iviu6k_di" bpmnElement="SequenceFlow_1iviu6k">
                <di:waypoint x="750" y="495" />
                <di:waypoint x="750" y="540" />
                <di:waypoint x="820" y="540" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="756" y="507" width="18" height="14" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_1630cnh_di" bpmnElement="SequenceFlow_1630cnh">
                <di:waypoint x="920" y="540" />
                <di:waypoint x="990" y="540" />
                <di:waypoint x="990" y="495" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="SequenceFlow_0duehum_di" bpmnElement="SequenceFlow_0duehum">
                <di:waypoint x="920" y="390" />
                <di:waypoint x="990" y="390" />
                <di:waypoint x="990" y="445" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNEdge id="Flow_0jh9yho_di" bpmnElement="Flow_0jh9yho">
                <di:waypoint x="1015" y="470" />
                <di:waypoint x="1040" y="470" />
                <di:waypoint x="1040" y="755" />
                <di:waypoint x="1075" y="755" />
              </bpmndi:BPMNEdge>
              <bpmndi:BPMNShape id="_BPMNShape_StartEvent_2" bpmnElement="StartEvent_1">
                <dc:Bounds x="242" y="232" width="36" height="36" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="ExclusiveGateway_1scjwbv_di" bpmnElement="ExclusiveGateway_1scjwbv" isMarkerVisible="true">
                <dc:Bounds x="535" y="225" width="50" height="50" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="527" y="285" width="65" height="40" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="ExclusiveGateway_04pv3c6_di" bpmnElement="ExclusiveGateway_04pv3c6" isMarkerVisible="true">
                <dc:Bounds x="645" y="225" width="50" height="50" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="CallActivity_1wwetzu_di" bpmnElement="Task_0hlrlcj">
                <dc:Bounds x="510" y="100" width="100" height="80" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="ParallelGateway_0bjpylr_di" bpmnElement="ExclusiveGateway_08jezor">
                <dc:Bounds x="445" y="225" width="50" height="50" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="CallActivity_1trr5dk_di" bpmnElement="Task_0bhqwoh">
                <dc:Bounds x="310" y="210" width="100" height="80" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="Task_0aa9mh6_di" bpmnElement="Task_0aa9mh6">
                <dc:Bounds x="420" y="430" width="100" height="80" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="Gateway_1teylg7_di" bpmnElement="Gateway_0bmvthf">
                <dc:Bounds x="645" y="445" width="50" height="50" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="ExclusiveGateway_03ax4cf_di" bpmnElement="ExclusiveGateway_03ax4cf" isMarkerVisible="true">
                <dc:Bounds x="725" y="445" width="50" height="50" />
                <bpmndi:BPMNLabel>
                  <dc:Bounds x="777" y="456" width="86" height="27" />
                </bpmndi:BPMNLabel>
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="ExclusiveGateway_1pi6klp_di" bpmnElement="ExclusiveGateway_1pi6klp" isMarkerVisible="true">
                <dc:Bounds x="965" y="445" width="50" height="50" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="CallActivity_0hjfv44_di" bpmnElement="CallActivity_0hjfv44">
                <dc:Bounds x="820" y="500" width="100" height="80" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="CallActivity_1fw02hz_di" bpmnElement="Task_1houvma">
                <dc:Bounds x="820" y="350" width="100" height="80" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="Gateway_0m00yn2_di" bpmnElement="ExclusiveGateway_100op7m">
                <dc:Bounds x="1075" y="730" width="50" height="50" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="CallActivity_0wucsuz_di" bpmnElement="CallActivity_0wucsuz">
                <dc:Bounds x="1190" y="615" width="100" height="80" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="CallActivity_07o1xvu_di" bpmnElement="CallActivity_07o1xvu">
                <dc:Bounds x="1190" y="715" width="100" height="80" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="EndEvent_0j9b1h2_di" bpmnElement="EndEvent_0j9b1h2">
                <dc:Bounds x="1422" y="737" width="36" height="36" />
              </bpmndi:BPMNShape>
              <bpmndi:BPMNShape id="Gateway_0qytbmn_di" bpmnElement="ExclusiveGateway_0cxp6ct">
                <dc:Bounds x="1345" y="730" width="50" height="50" />
              </bpmndi:BPMNShape>
            </bpmndi:BPMNPlane>
          </bpmndi:BPMNDiagram>
        </bpmn:definitions>
        """;

      final bpmnSource = Bpmn.parse(xml);
      final roles = await bpmnSource.getRoles();

      expect(roles, isNotEmpty);
      expect(roles, equals(["МКО", "Договорный сектор", "ПМ"]));
    });
  });
}
