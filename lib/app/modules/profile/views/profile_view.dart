import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sisfo/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';
import '../../../controllers/index_page_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<IndexPageController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text('ACCOUNT'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;
            String defaultImage =
                'https://ui-avatars.com/api/?name=${user['name']}';
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          user['profile'] != null
                              ? user['profile'] != ''
                                  ? user['profile']
                                  : defaultImage
                              : defaultImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '${user['name'].toString().toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${user['email']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  onTap: () => Get.toNamed(
                    Routes.UPDATE_PROFILE,
                    arguments: user,
                  ),
                  leading: Icon(Icons.person_rounded),
                  title: Text('Update Profile'),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
                  leading: Icon(Icons.vpn_key_rounded),
                  title: Text('Change Password'),
                ),
                if (user['role'] == 'admin')
                  ListTile(
                    onTap: () => Get.toNamed(Routes.ADD_STUDENT),
                    leading: Icon(Icons.person_rounded),
                    title: Text('Add Student'),
                  ),
                ListTile(
                  onTap: () => controller.logout(),
                  leading: Icon(Icons.logout_rounded),
                  title: Text('Logout'),
                ),
              ],
            );
          } else {
            return Center(
              child: Text('Memuat Data Profil User..'),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.cyan,
        style: TabStyle.fixedCircle,
        top: -30,
        curveSize: 80,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.person_pin_circle_rounded, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
