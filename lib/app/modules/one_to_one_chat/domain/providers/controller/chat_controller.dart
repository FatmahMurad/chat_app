import 'dart:io';

import 'package:chat/app/modules/one_to_one_chat/domain/providers/state/chat_state.dart';
import 'package:chat/app/modules/one_to_one_chat/domain/repo/message_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ChateMessageStateNotifier extends StateNotifier<ChateMessageState> {
  final MessagingRepository _messagingRepository;
  ChateMessageStateNotifier(super.state, this._messagingRepository);

  final picker = ImagePicker();

  Future<void> sendMessage(
      {required String senderId,
      required String receiverId,
      required String message}) async {
    try {
      state = state.copyWith(isLoading: true);
      await _messagingRepository.sendMessage(
          senderId: senderId, receiverId: receiverId, message: message);
      state = state.copyWith(isLoading: false, message: "");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future uploadMediaFile({
    required File fileData,
    required String senderId,
    required String recieverId,
  }) async {
    final fileName = basename(fileData.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      ref.putFile(fileData).then((snapshot) async {
        final downloadURL = await snapshot.ref.getDownloadURL();

        await sendMessage(
            senderId: senderId, receiverId: recieverId, message: downloadURL);
      });
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future getImageFromGallery(
      {required String senderId, required String receiverId}) async {
    try {
      state = state.copyWith(isLoading: true);
      XFile? pickedFile = await picker.pickMedia();

      if (pickedFile != null) {
        uploadMediaFile(
          senderId: senderId,
          recieverId: receiverId,
          fileData: File(
            pickedFile.path,
          ),
        );
      }
    } catch (e) {
      state =
          state.copyWith(message: "", isLoading: false, error: e.toString());
      debugPrint(e.toString());
    }
  }

  Future getImageFromCamera(
      {required String senderId, required String receiverId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 50);

      if (pickedFile != null) {
        uploadMediaFile(
          senderId: senderId,
          recieverId: receiverId,
          fileData: File(
            pickedFile.path,
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        message: "",
      );
      debugPrint(e.toString());
    }
  }

  void cancel() {
    state = state.copyWith(message: "");
  }
}
