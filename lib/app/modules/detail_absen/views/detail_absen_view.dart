import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_absen_controller.dart';

class DetailAbsenView extends GetView<DetailAbsenController> {
  const DetailAbsenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    '${DateFormat.yMMMMEEEEd().format(DateTime.now())}',
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
                  'Jam : ${DateFormat.jms().format(DateTime.now())}',
                ),
                Text(
                  'Posisi : -7.8218, 219.12919',
                ),
                Text(
                  'Status : Di dalam area',
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
                  'Jam : ${DateFormat.jms().format(DateTime.now())}',
                ),
                Text(
                  'Posisi : -7.8218, 219.12919',
                ),
                Text(
                  'Status : Di dalam area',
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
