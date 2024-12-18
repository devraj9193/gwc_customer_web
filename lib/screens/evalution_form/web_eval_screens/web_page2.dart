import 'package:flutter/material.dart';

import '../../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';

class WebPage2 extends StatefulWidget {
  final ChildGetEvaluationDataModel? model;
  const WebPage2({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<WebPage2> createState() => _WebPage2State();
}

class _WebPage2State extends State<WebPage2> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
