import 'dart:async';

import 'package:bpmn_dart/bpmnjs_modeler.dart';
import 'package:meta/meta.dart';

part 'bpmn_modeler_bloc_interface.dart';
part 'bpmn_modeler_event.dart';
part 'bpmn_modeler_state.dart';

class BpmnModelerBloc implements BpmnModelerBlocInterface {
  late final StreamController<BpmnModelerState> stateController;
  late final Stream<BpmnModelerState> stateStream;

  late final StreamController<BpmnModelerEvent> eventController;
  late final Stream<BpmnModelerEvent> eventStream;

  late final StreamSubscription eventSubscription;

  BpmnJS? modeler;

  String xml;

  static const String defaultXml = """
      <?xml version="1.0" encoding="UTF-8"?>
      <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" id="Definitions_0ydy6jl" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="3.7.1">
        <bpmn:process id="Definition_ID" name="Definition_Name" isExecutable="true">
          <bpmn:startEvent id="StartEvent_1" />
        </bpmn:process>
        <bpmndi:BPMNDiagram id="BPMNDiagram_1">
          <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Definition_ID">
          </bpmndi:BPMNPlane>
        </bpmndi:BPMNDiagram>
      </bpmn:definitions>
  """;

  BpmnModelerBloc({this.xml = defaultXml}) {
    stateController = StreamController<BpmnModelerState>();
    stateStream = stateController.stream.asBroadcastStream();

    eventController = StreamController<BpmnModelerEvent>();
    eventStream = eventController.stream.asBroadcastStream();

    eventSubscription = eventStream.listen((event) {
      if (event is SetUpModeler) setUpModelerEventHandler(event);
      if (event is OriginalXmlRead) originalXmlReadEventHandler(event);
      if (event is XmlRead) xmlReadEventHandler(event);
      if (event is XmlReset) xmlResetEventHandler(event);
    });
  }

  @override
  StreamController<BpmnModelerEvent> getController() => eventController;

  @override
  Stream<BpmnModelerState> getStream() => stateStream;

  @override
  void dispose() {
    eventSubscription.cancel();

    stateController.close();
    eventController.close();
  }

  Future<void> setUpModelerEventHandler(SetUpModeler event) async {
    modeler = event.modeler;
    stateController.add(const SetUpModelerEndSuccessful());
  }

  Future<void> originalXmlReadEventHandler(OriginalXmlRead _) async {
    stateController.add(OriginalXmlReadSuccessful(xml: xml));
  }

  Future<void> xmlReadEventHandler(XmlRead _) async {
    final modelerForGetXmlFrom = modeler;
    if (modelerForGetXmlFrom == null) {
      stateController.add(const XmlReadUnsuccessful(error: "Modeler is null"));
    } else {
      final xml = await getXmlFromModeler(modelerForGetXmlFrom);
      stateController.add(XmlReadSuccessful(xml: xml));
    }
  }

  Future<void> xmlResetEventHandler(XmlReset _) async {
    final originalXml = xml;
    final modelerForGetXmlFrom = modeler;
    if (modelerForGetXmlFrom == null) {
      stateController.add(const XmlResetUnsuccessful(error: "Modeler is null"));
    } else {
      await modelerForGetXmlFrom.importXML(originalXml);
      final xml = await getXmlFromModeler(modelerForGetXmlFrom);
      stateController.add(XmlResetSuccessful(xml: xml));
    }
  }
}
