import 'package:flutter/material.dart';

import 'package:flutter_bpmn_modeler/bpmn_modeler/bloc/bpmn_modeler_bloc.dart';
import 'package:flutter_bpmn_modeler/bpmn_modeler/bpmn_modeler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BpmnModeler(
          bloc: BpmnModelerBloc(),
        ),
      ),
    );
  }
}
