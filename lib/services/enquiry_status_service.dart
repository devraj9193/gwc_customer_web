import 'package:flutter/material.dart';

import '../repository/enquiry_status_repository.dart';

class EnquiryStatusService extends ChangeNotifier{
  late final EnquiryStatusRepository repository;

  EnquiryStatusService({required this.repository}) : assert(repository != null);

  Future enquiryStatusService(String deviceId) async{
    return await repository.enquiryStatusRepo(deviceId);
  }
}