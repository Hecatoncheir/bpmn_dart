part of 'bpmn_view_bloc.dart';

@immutable
abstract class BpmnViewState {
  const BpmnViewState();
}

class XmlReadSuccessful extends BpmnViewState {
  final String xml;
  const XmlReadSuccessful({required this.xml});
}

class ViewboxChange extends BpmnViewState {
  final CanvasViewbox viewbox;
  const ViewboxChange({required this.viewbox});
}

class ViewboxUpdate extends BpmnViewState {
  final CanvasViewbox viewbox;
  const ViewboxUpdate({required this.viewbox});
}
