import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sisfo/app/routes/app_pages.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            isLoading.value = false;

            if (passC.text == 'password') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: 'Belum Verifikasi',
              middleText: 'Kamu Belum Verif. Mohon verif telebih dahulu.',
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await credential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar('Terkirim',
                          'Kami Sudah Mengirim ulang Email Verifikasi ke akun kamu.');
                      isLoading.value = false;
                    } catch (e) {
                      Get.snackbar('Terjadi Kesalahan',
                          'Tidak dapat mengirim Email Verifikasi. Hubungi Contact Support');
                      isLoading.value = false;
                    }
                  },
                  child: Text('Kirim Ulang'),
                ),
              ],
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'Email Tidak Terdaftar');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Pass Salah');
        }
      } catch (e) {
        isLoading.value = false;

        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat login.');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Email Pass Wajib Diisi');
    }
  }
}
