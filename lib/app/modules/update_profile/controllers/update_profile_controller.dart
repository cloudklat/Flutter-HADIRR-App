import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  //TODO: Implement UpdateProfileController

  RxBool isLoading = false.obs;
  TextEditingController nikC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nikC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          'name': nameC.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split('.').last;
          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({'profile': urlImage});
        }
        await firestore.collection('student').doc(uid).update(data);
        image = null;
        Get.snackbar('Berhasil', 'Berhasil mengupdate Profile.');
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat Mengupdate Profile.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection('student').doc(uid).update({
        'profile': FieldValue.delete(),
      });
      Get.back();
      Get.snackbar('Berhasil', 'Berhasil menghapus Profile.');
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Tidak dapat Delete Profile Picture.');
    } finally {
      update();
    }
  }
}
