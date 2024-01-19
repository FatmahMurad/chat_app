import 'package:chat/app/modules/one_to_one_chat/domain/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MessagingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sending a message from sender to receiver
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      String chatRoomId = _getChatRoomId(senderId, receiverId);

      DocumentReference documentReference = _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      Message messageChat = Message(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now(),
        messageId: const Uuid().v4(),
      );

      await documentReference.set(messageChat.toMap());
    } catch (e) {
      throw ('Error sending message: $e');
    }
  }

  // Get chat room ID between two users
  String _getChatRoomId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';
  }
}
