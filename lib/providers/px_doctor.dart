import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/doctor_api.dart';
import 'package:allevia_one/models/doctor.dart';

class PxDoctor extends ChangeNotifier {
  final DoctorApi api;

  PxDoctor({required this.api}) {
    _init();
  }

  static Doctor? _doctor;
  Doctor? get doctor => _doctor;

  Future<void> _init() async {
    _doctor = await api.fetchDoctorProfile();
    notifyListeners();
  }
}
