import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_absen_controller.dart';

class DetailAbsenView extends GetView<DetailAbsenController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text('DETAIL ABSENSI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            // ignore: sort_child_properties_last
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Check-In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}',
                ),
                Text(
                  'Posisi : ${data['masuk']!['lat']}, ${data['masuk']!['long']}',
                ),
                Text(
                  'Status : ${data['masuk']!['status']}',
                ),
                Text(
                  'Distance : ${data['masuk']!['distance'].toString().split('.').first} Meter',
                ),
                Text(
                  'Address : ${data['masuk']!['address']}',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Check-Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['keluar']?['date'] == null
                      ? 'Jam : -'
                      : 'Jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}',
                ),
                Text(
                  data['keluar']?['lat'] == null &&
                          data['keluar']?['long'] == null
                      ? 'Posisi : -'
                      : 'Posisi : ${data['keluar']!['lat']}, ${data['keluar']!['long']}',
                ),
                Text(
                  data['keluar']?['status'] == null
                      ? 'Status : -'
                      : 'Status : ${data['keluar']!['status']}',
                ),
                Text(
                  data['keluar']?['distance'] == null
                      ? 'Distance : -'
                      : 'Distance : ${data['keluar']!['distance'].toString().split('.').first} Meter',
                ),
                Text(
                  data['keluar']?['address'] == null
                      ? 'Address : -'
                      : 'Address : ${data['keluar']!['address']}',
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
