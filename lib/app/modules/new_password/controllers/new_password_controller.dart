import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisfo/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  //TODO: Implement NewPasswordController

  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != 'password') {
        try {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar('Terjadi Kesalahan',
                'Password kurang Aman, Setidaknya 6 Karakter.');
          }
        } catch (e) {
          Get.snackbar('Terjadi Kesalahan',
              'Tidak dapat membuat Password Baru. Mohon Hubungi Contact Support.');
        }
      } else {
        Get.snackbar('Terjadi Kesalahan',
            'Password Tidak Boleh Sama dengan Password Lama');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Pass Baru  Wajib Diisi');
    }
  }
}
