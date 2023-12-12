import 'package:flutter/material.dart';

import '../../repository/chat_repository/message_repo.dart';

class ChatService extends ChangeNotifier{
  late final MessageRepository repository;

  ChatService({required this.repository}) : assert(repository != null);

  Future getChatGroupIdService() async{
    return await repository.getChatGroupIdRepo();
  }
}