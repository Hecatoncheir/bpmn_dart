part of 'bpmn_view_bloc.dart';

@immutable
abstract class BpmnViewEvent {
  const BpmnViewEvent();
}

class ReadXml extends BpmnViewEvent {
  const ReadXml();
}

class ViewboxChanged extends BpmnViewEvent {
  final CanvasViewbox viewbox;
  const ViewboxChanged({required this.viewbox});
}
