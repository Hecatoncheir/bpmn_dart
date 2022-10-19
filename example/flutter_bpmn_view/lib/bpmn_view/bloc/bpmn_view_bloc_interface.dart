part of 'bpmn_view_bloc.dart';

abstract class BpmnViewBlocInterface {
  StreamController<BpmnViewEvent> getController();
  Stream<BpmnViewState> getStream();
  void dispose();
}
