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

  // Retrieve messages between two users
  Stream<List<Message>> messagesStream({
    required String senderId,
    required String receiverId,
  }) {
    try {
      String chatRoomId = _getChatRoomId(senderId, receiverId);

      final Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();

      return snapshot.map((querySnapshot) => querySnapshot.docs.map((doc) {
            final data = doc.data();

            DateTime timestamp = data['timestamp'] is int
                ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int)
                : data['timestamp'] as DateTime;

            return Message(
              messageId: doc.id,
              senderId: data['senderId'],
              receiverId: data['receiverId'],
              message: data['message'],
              timestamp: timestamp,
            );
          }).toList());
    } catch (e) {
      throw ('Error fetching messages: $e');
    }
  }
}
