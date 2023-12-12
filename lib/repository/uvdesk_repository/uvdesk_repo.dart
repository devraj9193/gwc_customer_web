import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../api_service.dart';
import 'package:http/http.dart';
class UvDeskRepo {
  ApiClient apiClient;

  UvDeskRepo({required this.apiClient}) : assert(apiClient != null);

  Future getTicketListRepo(String email, int index) async{
    return await apiClient.getTicketListApi(email, index);
  }

  Future getTicketDetailsByIdRepo(String id) async{
    return await apiClient.getTicketDetailsApi(id);
  }

  Future createTicketRepo(Map data, {List<File>? attachments}) async{
    return await apiClient.createTicketApi(data, attachments: attachments);
  }

  Future getTicketsByCustomerIdRepo(String customerId, String statusId) async{
    return await apiClient.getTicketListByCustomerIdApi(customerId, statusId);
  }



  Future sendReplyRepo(String ticketId, Map data, {List<PlatformFile>? attachments}) async{
    return await apiClient.sendReplyApi(ticketId, data, attachments: attachments);
  }

  Future reOpenTicketRepo(String id) async{
    return await apiClient.reOpenTicketApi(id);
  }

}