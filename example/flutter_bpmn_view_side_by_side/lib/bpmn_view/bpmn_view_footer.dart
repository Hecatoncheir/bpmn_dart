import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:universal_html/html.dart' as html;

import 'package:bpmn_dart/bpmn.dart';
import 'package:bpmn_dart/bpmnjs_navigated_viewer.dart';

class BpmnViewFooter extends StatelessWidget {
  final NavigatedViewer navigatedViewer;
  final String? saveFileName;

  const BpmnViewFooter({
    required this.navigatedViewer,
    this.saveFileName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _downloadSvg(
                viewer: navigatedViewer,
                saveFileName: saveFileName,
              ),
              child: HoverWidget(
                // ignore: avoid_returning_null_for_void
                onHover: (_) => null,
                hoverChild: Text(
                  "SVG",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.3),
                    decoration: TextDecoration.underline,
                    decorationThickness: 4,
                  ),
                ),
                child: const Text(
                  "SVG",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    decorationThickness: 4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _downloadPng(
                viewer: navigatedViewer,
                saveFileName: saveFileName,
              ),
              child: HoverWidget(
                // ignore: avoid_returning_null_for_void
                onHover: (_) => null,
                hoverChild: Text(
                  "PNG",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.3),
                    decoration: TextDecoration.underline,
                    decorationThickness: 4,
                  ),
                ),
                child: const Text(
                  "PNG",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    decorationThickness: 4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _downloadBpmn(
                viewer: navigatedViewer,
                saveFileName: saveFileName,
              ),
              child: HoverWidget(
                // ignore: avoid_returning_null_for_void
                onHover: (_) => null,
                hoverChild: Text(
                  "BPMN",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.3),
                    decoration: TextDecoration.underline,
                    decorationThickness: 4,
                  ),
                ),
                child: const Text(
                  "BPMN",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    decorationThickness: 4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadSvg({
    required NavigatedViewer viewer,
    String? saveFileName,
  }) async {
    final svg = await getSvgFromViewer(viewer);
    final encodedSvg = base64.encode(utf8.encode(svg));
    final uriData = "data:image/svg+xml;base64, $encodedSvg";

    final originXml = await getXmlFromModeler(viewer);

    final bpmn = Bpmn.parse(originXml);
    final name =
        saveFileName ?? await bpmn.getDefinitionName() ?? await bpmn.getId();
    final fileNameWithExtension = "${name ?? "_"}.svg";

    final a = html.AnchorElement()
      ..download = fileNameWithExtension
      ..href = uriData
      ..style.display = "none";

    html.window.document.querySelector('body')?.append(a);
    a
      ..click()
      ..remove();
  }

  Future<void> _downloadPng({
    required NavigatedViewer viewer,
    String? saveFileName,
  }) async {
    final originSvg = await getSvgFromViewer(viewer);
    final svgRoot = await svg.fromSvgString(originSvg, originSvg);
    final width = svgRoot.viewport.width.toInt();
    final height = svgRoot.viewport.height.toInt();
    final svgImage = await svgRoot.toPicture().toImage(width, height);
    final imageByteData =
        await svgImage.toByteData(format: ImageByteFormat.png);
    if (imageByteData == null) return;

    final encodedSvg = base64.encode(imageByteData.buffer.asUint8List());
    final uriData = "data:image/png;base64, $encodedSvg";

    final originXml = await getXmlFromModeler(viewer);

    final bpmn = Bpmn.parse(originXml);
    final name =
        saveFileName ?? await bpmn.getDefinitionName() ?? await bpmn.getId();
    final fileNameWithExtension = "${name ?? "_"}.png";

    final a = html.AnchorElement()
      ..download = fileNameWithExtension
      ..href = uriData
      ..style.display = "none";

    html.window.document.querySelector('body')?.append(a);
    a
      ..click()
      ..remove();
  }

  Future<void> _downloadBpmn({
    required NavigatedViewer viewer,
    String? saveFileName,
  }) async {
    final originXml = await getXmlFromModeler(viewer);

    final bpmn = Bpmn.parse(originXml);
    final name =
        saveFileName ?? await bpmn.getDefinitionName() ?? await bpmn.getId();
    final fileNameWithExtension = "${name ?? "_"}.bpmn";

    final xmlBytes = utf8.encode(originXml);
    final blob = html.Blob([xmlBytes], ".xml");

    final a = html.AnchorElement()
      ..download = fileNameWithExtension
      ..href = html.Url.createObjectUrl(blob)
      ..style.display = "none";

    html.window.document.querySelector('body')?.append(a);
    a
      ..click()
      ..remove();
  }
}
