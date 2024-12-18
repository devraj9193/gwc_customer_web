import 'package:flutter/material.dart';

import '../../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';

class WebPage3 extends StatefulWidget {
  final ChildGetEvaluationDataModel? model;
  const WebPage3({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<WebPage3> createState() => _WebPage3State();
}

class _WebPage3State extends State<WebPage3> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
