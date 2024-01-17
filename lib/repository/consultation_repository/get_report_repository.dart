import 'package:file_picker/file_picker.dart';

import '../api_service.dart';

class ReportRepository{
  ApiClient apiClient;

  ReportRepository({required this.apiClient}) : assert(apiClient != null);

  Future uploadReportListRepo(List reportList) async{
    return await apiClient.uploadReportApi(reportList);
  }

  Future getUploadedReportListListRepo() async{
    return await apiClient.getUploadedReportListListApi();
  }

  Future doctorRequestedReportListRepo() async{
    return await apiClient.doctorRequestedReportListApi();
  }

  Future downloadPrescriptionRepo(String url, String filename, String path) async{
    return await apiClient.downloadFile(url, filename, path);
  }

  Future submitDoctorRequestedReportRepo(List reportId, List<PlatformFile> multipartFile) async{
    return await apiClient.submitDoctorRequestedReportApi(reportId, multipartFile);
  }

  Future submitUserReportUploadRepo(List<PlatformFile> multipartFile) async{
    return await apiClient.submitUserReportUploadApi(multipartFile);
  }

}