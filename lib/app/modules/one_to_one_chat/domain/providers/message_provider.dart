import 'package:chat/app/modules/one_to_one_chat/domain/providers/controller/chat_controller.dart';
import 'package:chat/app/modules/one_to_one_chat/domain/providers/state/chat_state.dart';
import 'package:chat/app/modules/one_to_one_chat/domain/repo/message_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository();
});
final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository();
});

final chatMessageStateNotifierProvider =
    StateNotifierProvider<ChateMessageStateNotifier, ChateMessageState>(
  (ref) => ChateMessageStateNotifier(
    ChateMessageState(),
    ref.read(
      messagingRepositoryProvider,
    ),
  ),
);
