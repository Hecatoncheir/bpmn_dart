part of 'bpmn_modeler_bloc.dart';

abstract class BpmnModelerBlocInterface {
  StreamController<BpmnModelerEvent> getController();
  Stream<BpmnModelerState> getStream();
  void dispose();
}
