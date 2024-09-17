import 'package:flutter/cupertino.dart';

import '../../repository/shift_slots_repo/shift_slots_repo.dart';

class ShiftSlotsService extends ChangeNotifier{
  final ShiftSlotsRepository repository;

  ShiftSlotsService({required this.repository}) : assert(repository != null);

  Future getConsultationSlotsService(String selectedDate) async{
    return await repository.getConsultationSlotsRepo(selectedDate);
  }

  Future getShiftSlotsService(String selectedDate,String shiftType,String doctorId) async{
    return await repository.getShiftSlotsRepo(selectedDate,shiftType,doctorId);
  }

}