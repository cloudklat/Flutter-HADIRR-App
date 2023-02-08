import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_student_controller.dart';

class AddStudentView extends GetView<AddStudentController> {
  const AddStudentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD STUDENT'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.nikC,
            decoration: InputDecoration(
              labelText: 'NIK',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.jobC,
            decoration: InputDecoration(
              labelText: 'Job Role',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.addStudent();
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? 'Tambahkan' : 'Loading..'),
              )),
        ],
      ),
    );
  }
}
