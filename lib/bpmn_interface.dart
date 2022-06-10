abstract class BpmnInterface {
  Future<String> getXml();
  Future<String?> getId();
  Future<String?> getDefinitionName();
  Future<List<String>?> getRoles();
}
