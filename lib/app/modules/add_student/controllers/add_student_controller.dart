import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudentController extends GetxController {
  //TODO: Implement AddStudentController

  RxBool isLoading = false.obs;
  RxBool isLoadingAddStudent = false.obs;

  TextEditingController nikC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddStudent() async {
    isLoadingAddStudent.value = true;
    if (passAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        final credentialAdmin = await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        final credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: 'password',
        );

        if (credential.user != null) {
          String uid = credential.user!.uid;

          await firestore.collection('student').doc(uid).set({
            'nik': nikC.text,
            'name': nameC.text,
            'job': jobC.text,
            'email': emailC.text,
            'uid': uid,
            'createdAt': DateTime.now().toIso8601String(),
          });

          await credential.user!.sendEmailVerification();

          await auth.signOut();

          final credentialAdmin = await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back();
          Get.back();
          Get.snackbar('Berhasil', 'Berhasil Menambahkan Data');
          isLoadingAddStudent.value = false;
        }

        print(credential);
      } on FirebaseAuthException catch (e) {
        isLoadingAddStudent.value = false;

        if (e.code == 'weak-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password terlalu singkat');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan', 'Email Sudah Digunakan');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password Administrator Salah !');
        } else {
          Get.snackbar('Terjadi Kesalahan', '${e.code}');
        }
      } catch (e) {
        isLoadingAddStudent.value = false;

        Get.snackbar('Terjadi Kesalahan', 'tidak dapat menambahkan');
      }
    } else {
      isLoading.value = false;

      Get.snackbar(
          'Terjadi Kesalahan', 'Konfirmasikan bahwa Anda adalah Admin');
    }
  }

  Future<void> addStudent() async {
    if (nikC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: 'Validasi Admin',
        content: Column(
          children: [
            Text('Masukan Password untuk Validasi Admin !'),
            SizedBox(height: 10),
            TextField(
              controller: passAdminC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddStudent.isFalse) {
                    await prosesAddStudent();
                  }
                  isLoading.value = false;
                },
                child: Text(
                    isLoadingAddStudent.isFalse ? 'Add Student' : 'Loading..'),
              )),
        ],
      );
    } else {
      Get.snackbar(
          'Terjadi Kesalahan', 'NIK, Nama, Job, dan Email Harus diisi');
    }
  }
}
