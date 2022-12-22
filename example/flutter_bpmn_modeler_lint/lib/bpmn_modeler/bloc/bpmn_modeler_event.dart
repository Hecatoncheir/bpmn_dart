part of 'bpmn_modeler_bloc.dart';

@immutable
abstract class BpmnModelerEvent {
  const BpmnModelerEvent();
}

class SetUpModeler extends BpmnModelerEvent {
  final BpmnJS modeler;
  const SetUpModeler({required this.modeler});
}

class XmlReset extends BpmnModelerEvent {
  const XmlReset();
}

class OriginalXmlRead extends BpmnModelerEvent {
  const OriginalXmlRead();
}

class XmlRead extends BpmnModelerEvent {
  const XmlRead();
}
