import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_ce_flutter/adapters.dart';
import 'package:allevia_one/core/api/_api_result.dart';
// import 'package:allevia_one/core/api/cache/api_caching_service.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/functions/dprint.dart';
import 'package:allevia_one/models/clinic/clinic.dart';
import 'package:http/http.dart' as http;
import 'package:allevia_one/models/clinic/clinic_schedule.dart';
import 'package:allevia_one/models/clinic/prescription_details.dart';
import 'package:allevia_one/models/clinic/schedule_shift.dart';

class ClinicsApi {
  ClinicsApi({required this.doc_id});

  final String doc_id;

  late final String _collection = '${doc_id}__clinics';

  late final _box = Hive.box<String>(_collection);

  Future<ApiResult<List<Clinic>>> fetchDoctorClinics() async {
    await Hive.openBox<String>(_collection);

    late List<Clinic> _clinics;

    if (_box.get(_collection) != null && _box.isNotEmpty) {
      _clinics = (json.decode(_box.get(_collection)!) as List<dynamic>)
          .map((e) => Clinic.fromJson(e))
          .toList();
      return ApiDataResult<List<Clinic>>(data: _clinics);
    }
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getList();

      _clinics =
          _response.items.map((e) => Clinic.fromJson(e.toJson())).toList();
      try {
        await _box.put(
            _collection, json.encode(_clinics.map((x) => x.toJson()).toList()));
      } catch (e) {
        dprint('caching Error => ${e.toString()}');
      }

      return ApiDataResult<List<Clinic>>(data: _clinics);
    } catch (e) {
      return ApiErrorResult<List<Clinic>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> createNewClinic(Clinic clinic) async {
    await PocketbaseHelper.pb
        .collection(_collection)
        .create(body: clinic.toJson());
    await _box.clear();
  }

  Future<void> updateClinicInfo(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
          clinic.id,
          body: clinic.toJson(),
        );
    await _box.clear();
  }

  Future<void> addPrescriptionImageFileToClinic(
    Clinic clinic, {
    required Uint8List file_bytes,
    required String filename,
  }) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      files: [
        http.MultipartFile.fromBytes(
          'prescription_file',
          file_bytes,
          filename: filename,
        ),
      ],
    );
    await _box.clear();
  }

  Future<void> deletePrescriptionFile(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'prescription_file': '',
      },
    );
    await _box.clear();
  }

  Future<void> deleteClinic(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).delete(
          clinic.id,
        );
    await _box.clear();
  }

  Future<void> toggleClinicActivation(Clinic clinic) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'is_active': !clinic.is_active,
      },
    );
    await _box.clear();
  }

  Future<void> updatePrescriptionDetails(
    Clinic clinic,
    PrescriptionDetails details,
  ) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      clinic.id,
      body: {
        'prescription_details': details.toJson(),
      },
    );
    await _box.clear();
  }

  Future<void> addClinicSchedule(Clinic clinic, ClinicSchedule schedule) async {
    final _newSchedule = [...clinic.clinic_schedule, schedule];
    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
    await _box.clear();
  }

  Future<void> removeClinicSchedule(
    Clinic clinic,
    ClinicSchedule schedule,
  ) async {
    final _newSchedule = clinic.clinic_schedule
      ..removeWhere((e) => e.id == schedule.id);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
    await _box.clear();
  }

  Future<void> updateClinicSchedule(
    Clinic clinic,
    ClinicSchedule schedule,
  ) async {
    final _elementIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_elementIndex] = schedule;

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
    await _box.clear();
  }

  Future<void> addScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _newShifts = [...schedule.shifts, shift];

    final _scheduleIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_scheduleIndex] = schedule.copyWith(shifts: _newShifts);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
    await _box.clear();
  }

  Future<void> removeScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _newShifts = schedule.shifts..removeWhere((e) => e.id == shift.id);

    final _scheduleIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_scheduleIndex] = schedule.copyWith(shifts: _newShifts);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
    await _box.clear();
  }

  Future<void> updateScheduleShift(
    Clinic clinic,
    ClinicSchedule schedule,
    ScheduleShift shift,
  ) async {
    final _shiftIndex = schedule.shifts.indexWhere((e) => e.id == shift.id);

    final _scheduleIndex =
        clinic.clinic_schedule.indexWhere((e) => e.id == schedule.id);

    final _newShifts = schedule.shifts;

    _newShifts[_shiftIndex] = shift;

    final _newSchedule = clinic.clinic_schedule;

    _newSchedule[_scheduleIndex] = schedule.copyWith(shifts: _newShifts);

    await PocketbaseHelper.pb.collection(_collection).update(
      schedule.clinic_id,
      body: {
        'clinic_schedule': _newSchedule.map((e) => e.toJson()).toList(),
      },
    );
    await _box.clear();
  }
}
