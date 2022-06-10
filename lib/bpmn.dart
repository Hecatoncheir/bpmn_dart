import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'bpmn_interface.dart';
export 'bpmn_interface.dart';

class Bpmn implements BpmnInterface {
  final String xml;

  final XmlDocument _xmlDocument;

  Bpmn.parse(this.xml) : _xmlDocument = XmlDocument.parse(xml);

  @override
  Future<String> getXml() async => xml;

  @override
  Future<String?> getId() async => _xmlDocument.root
      .findAllElements('bpmn:process')
      .firstWhereOrNull((element) => element.getAttribute("id") != null)
      ?.getAttribute("id");

  @override
  Future<String?> getDefinitionName() async => _xmlDocument.root
      .findAllElements('bpmn:process')
      .firstWhereOrNull((element) => element.getAttribute("name") != null)
      ?.getAttribute("name");

  @override
  Future<List<String>?> getRoles() async => List<String>.from(_xmlDocument
      .findAllElements("bpmn:lane")
      .map<String?>((element) => element.getAttribute("name"))
      .where((element) => element != null)
      .toList());
}
