// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:injectable/injectable.dart';

import 'package:cuidapet_shelf/modules/chat/data/i_chat_repository.dart';
import 'package:cuidapet_shelf/modules/chat/service/i_chat_service.dart';

@LazySingleton(as: IChatService)
class IChatServiceImpl implements IChatService {
  IChatRepository repository;
  IChatServiceImpl({required this.repository});
}
