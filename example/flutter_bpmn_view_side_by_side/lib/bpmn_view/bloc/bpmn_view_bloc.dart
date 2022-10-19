import 'dart:async';

import 'package:meta/meta.dart';

import 'package:bpmn_dart/bpmnjs_navigated_viewer.dart';

part 'bpmn_view_bloc_interface.dart';
part 'bpmn_view_event.dart';
part 'bpmn_view_state.dart';

class BpmnViewBloc implements BpmnViewBlocInterface {
  final String xml;

  late final StreamController<BpmnViewState> stateController;
  late final Stream<BpmnViewState> stateStream;

  late final StreamController<BpmnViewEvent> eventController;
  late final Stream<BpmnViewEvent> eventStream;

  late final StreamSubscription eventSubscription;

  BpmnViewBloc({
    required this.xml,
  }) {
    stateController = StreamController<BpmnViewState>();
    stateStream = stateController.stream.asBroadcastStream();

    eventController = StreamController<BpmnViewEvent>();
    eventStream = eventController.stream;

    eventSubscription = eventStream.listen((event) {
      if (event is ReadXml) readXmlEventHandler(event);
      if (event is ViewboxChanged) viewboxChangedEventHandler(event);
      if (event is ViewboxUpdated) viewboxUpdatedEventHandler(event);
    });
  }

  @override
  StreamController<BpmnViewEvent> getController() => eventController;

  @override
  Stream<BpmnViewState> getStream() => stateStream;

  @override
  void dispose() {
    eventSubscription.cancel();

    stateController.close();
    eventController.close();
  }

  Future<void> readXmlEventHandler(ReadXml _) async {
    final state = XmlReadSuccessful(xml: xml);
    stateController.add(state);
  }

  Future<void> viewboxChangedEventHandler(ViewboxChanged event) async {
    final state = ViewboxChange(viewbox: event.viewbox);
    stateController.add(state);
  }

  Future<void> viewboxUpdatedEventHandler(ViewboxUpdated event) async {
    final state = ViewboxUpdate(viewbox: event.viewbox);
    stateController.add(state);
  }
}
