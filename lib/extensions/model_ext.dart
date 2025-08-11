import 'dart:typed_data';

import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/models/clinic/clinic.dart';
import 'package:allevia_one/models/speciality.dart';
import 'package:http/http.dart' as http;

extension Imageurl on Speciality {
  String get imageUrl =>
      '${PocketbaseHelper.pb.baseURL}/api/files/specialities/$id/$image';
}

extension PrescriptionFileUrl on Clinic {
  String prescriptionFileUrl() =>
      '${PocketbaseHelper.pb.baseURL}/api/files/clinics/$id/$prescription_file';

  Future<Uint8List> prescImageBytes() async {
    final _response = await http.get(Uri.parse(prescriptionFileUrl()));
    return _response.bodyBytes;
  }
}
