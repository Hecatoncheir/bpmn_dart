part of 'bpmn_modeler_bloc.dart';

@immutable
abstract class BpmnModelerState {
  const BpmnModelerState();
}

class SetUpModelerEndSuccessful extends BpmnModelerState {
  const SetUpModelerEndSuccessful();
}

class OriginalXmlReadSuccessful extends BpmnModelerState {
  final String xml;
  const OriginalXmlReadSuccessful({required this.xml});
}

class XmlReadSuccessful extends BpmnModelerState {
  final String xml;
  const XmlReadSuccessful({required this.xml});
}

class XmlReadUnsuccessful extends BpmnModelerState {
  final String error;
  const XmlReadUnsuccessful({required this.error});
}

class XmlResetSuccessful extends BpmnModelerState {
  final String xml;
  const XmlResetSuccessful({required this.xml});
}

class XmlResetUnsuccessful extends BpmnModelerState {
  final String error;
  const XmlResetUnsuccessful({required this.error});
}
