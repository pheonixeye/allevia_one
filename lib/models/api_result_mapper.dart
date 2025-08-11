import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/models/patient.dart';
import 'package:allevia_one/models/patient_form_item.dart';
import 'package:allevia_one/models/pc_form.dart';

typedef PatientDataResult = ApiDataResult<List<Patient>>;

typedef FormDataResult = ApiDataResult<List<PcForm>>;

typedef PatientFormItemResult = ApiDataResult<List<PatientFormItem>>;
