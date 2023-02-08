import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sisfo/app/routes/app_pages.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class IndexPageController extends GetxController {
  //TODO: Implement IndexPageController
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        print('ABSENSI');
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              '${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}';
          await updatePosition(position, address);

          // ? Absensi
          await absensi(position, address);
          Get.snackbar('Berhasil', 'Kamu telah terdaftar Hadir..');
        } else {
          Get.snackbar('Terjadi Kesalahan', dataResponse['message']);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> absensi(Position position, String address) async {}

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection('student').doc(uid).update(
      {
        'position': {
          'lat': position.latitude,
          'long': position.longitude,
        },
        'address': address,
      },
    );
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        'message': 'Lokasi Dimatikan. Mohon Aktifkan Lokasi',
        'error': true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          'message': 'Akses Izin Lokasi Ditolak. Mohon Izinkan Akses Lokasi',
          'error': true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        'message':
            'Pengaturan HPmu Tidak Mengizinkan Akses Lokasi, Mohon Izinkan Akses Lokasi pada Setting HP Kamu..',
        'error': true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      'position': position,
      'message': 'Berhasil mendapatkan Lokasi Device..',
      'error': false,
    };
  }
}
