import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/consultation_repository/get_report_repository.dart';

class ReportService extends ChangeNotifier{
  final ReportRepository repository;

  ReportService({required this.repository}) : assert(repository != null);

  Future uploadReportListService(List reportList) async{
    return await repository.uploadReportListRepo(reportList);
  }

  Future getUploadedReportListListService() async{
    return await repository.getUploadedReportListListRepo();
  }

  Future submitDoctorRequestedReportService(List reportId, List<PlatformFile> multipartFile) async{
    return await repository.submitDoctorRequestedReportRepo(reportId, multipartFile);
  }

  Future submitUserReportUploadService(List<PlatformFile> multipartFile) async{
    return await repository.submitUserReportUploadRepo(multipartFile);
  }

  Future downloadPrescriptionService(String url,String filename,String path) async{
    return await repository.downloadPrescriptionRepo(url, filename, path);
  }

  Future doctorRequestedReportListService() async{
    return await repository.doctorRequestedReportListRepo();
  }

}