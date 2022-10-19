import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:universal_html/html.dart';
import 'package:bpmn_dart/bpmnjs_navigated_viewer.dart';

import 'ui/ui.dart';
import 'bloc/bpmn_view_bloc.dart';
import 'bpmn_view_footer.dart';

class BpmnView extends StatefulWidget {
  final BpmnViewBlocInterface bloc;
  final String? saveFileName;

  const BpmnView({
    super.key,
    required this.bloc,
    this.saveFileName,
  });

  @override
  State<BpmnView> createState() => _BpmnViewState();
}

class _BpmnViewState extends State<BpmnView> {
  late BpmnViewBlocInterface bpmnViewBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bpmnViewBloc = widget.bloc;

    const event = ReadXml();
    bpmnViewBloc.getController().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BpmnViewState>(
      stream:
          bpmnViewBloc.getStream().where((state) => state is XmlReadSuccessful),
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return Container();

        if (state is XmlReadSuccessful) {
          final xml = state.xml;
          final area = DivElement()
            ..style.position = "relative"
            ..style.left = "0"
            ..style.top = "0"
            ..style.right = "0"
            ..style.bottom = "0";

          final viewer = NavigatedViewer(BpmnOptions(container: area));
          final id = const Uuid().v4();

          // ignore: undefined_prefixed_name
          ui.platformViewRegistry.registerViewFactory(id, (int viewId) => area);

          SchedulerBinding.instance.addPostFrameCallback((_) async {
            await viewer.importXML(xml);
            viewer.get('canvas').zoom('fit-viewport');

            viewer.onViewboxChange((updatedViewer) {
              final viewbox = updatedViewer.get('canvas').viewbox();
              final event = ViewboxChanged(viewbox: viewbox);
              bpmnViewBloc.getController().add(event);
            });
          });

          return Stack(
            children: [
              Positioned.fill(
                child: Column(
                  key: const Key("bpmn_view"),
                  children: [
                    Expanded(
                      child: HtmlElementView(
                        key: const Key("bpmn_view_area"),
                        viewType: id,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: BpmnViewFooter(
                  navigatedViewer: viewer,
                  saveFileName: widget.saveFileName,
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
