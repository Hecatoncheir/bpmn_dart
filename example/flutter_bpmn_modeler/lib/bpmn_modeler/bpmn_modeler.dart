import 'dart:async';

import 'package:bpmn_dart/bpmnjs_modeler.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'package:uuid/uuid.dart';

import 'bloc/bpmn_modeler_bloc.dart';
import 'bpmn_modeler_footer.dart';
import 'ui/ui.dart';

class BpmnModeler extends StatefulWidget {
  final TextEditingController? name;
  final BpmnModelerBlocInterface bloc;

  const BpmnModeler({
    super.key,
    this.name,
    required this.bloc,
  });

  @override
  State<BpmnModeler> createState() => _BpmnModelerState();
}

class _BpmnModelerState extends State<BpmnModeler> {
  late final String areaId;
  late final BpmnJS modeler;

  late final StreamSubscription<BpmnModelerState> bpmnModelerStreamSubscription;

  late final StreamController<bool> isReadyStreamController;
  late final Stream<bool> isReadyStream;

  @override
  void initState() {
    super.initState();

    isReadyStreamController = StreamController<bool>();
    isReadyStream = isReadyStreamController.stream;

    setUpModeler();

    bpmnModelerStreamSubscription =
        widget.bloc.getStream().listen((state) async {
      if (state is SetUpModelerEndSuccessful) {
        isReadyStreamController.add(true);

        // ignore: prefer-extracting-callbacks
        Future(() async {
          widget.bloc.getController().add(const OriginalXmlRead());
          final xml = await widget.bloc
              .getStream()
              .firstWhere((state) => state is OriginalXmlReadSuccessful)
              .then((state) => (state as OriginalXmlReadSuccessful).xml);
          modeler.importXML(xml);
        });
      }
    });
  }

  Future<void> setUpModeler() async {
    areaId = const Uuid().v4();
    final area = DivElement()..id = areaId;
    ui.platformViewRegistry.registerViewFactory(areaId, (int id) => area);

    modeler = BpmnJS(BpmnOptions(container: area));

    widget.bloc.getController().add(SetUpModeler(modeler: modeler));
  }

  @override
  void dispose() {
    isReadyStreamController.close();
    bpmnModelerStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: isReadyStream,
      builder: (context, snapshot) {
        final isReady = snapshot.data;
        if (isReady == null || !isReady) return Container();

        return Stack(
          children: [
            Positioned.fill(
              child: Column(
                key: const Key("bpmn_modeler"),
                children: [
                  Expanded(
                    child: HtmlElementView(
                      key: const Key("bpmn_modeler_area"),
                      viewType: areaId,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: BpmnModelerFooter(
                modeler: modeler,
                name: widget.name,
              ),
            ),
          ],
        );
      },
    );
  }
}
