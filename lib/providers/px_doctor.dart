import 'package:allevia_one/providers/px_auth.dart';
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

  static List<Doctor>? _allDoctors;
  List<Doctor>? get allDoctors => _allDoctors;

  Future<void> _init() async {
    if (PxAuth.isUserNotDoctor) {
      _allDoctors = await api.fetchAllDoctors();
      notifyListeners();
    } else {
      _allDoctors = await api.fetchAllDoctors();
      _doctor = await api.fetchDoctorProfile();
      notifyListeners();
    }
  }

  Future<void> retry() async => await _init();
}
