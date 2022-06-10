@TestOn("browser")
library bpmn_view_test;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_widget/bpmn_view.dart';

void main() {
  testWidgets("Test", (tester) async {
    const testWidget = BpmnView();

    const widget = MaterialApp(
      home: Scaffold(
        body: testWidget,
      ),
    );

    await tester.pumpWidget(widget);
  });
}
