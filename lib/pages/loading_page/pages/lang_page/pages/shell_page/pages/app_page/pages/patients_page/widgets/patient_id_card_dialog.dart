import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/assets/assets.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/models/patient.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/paient_id_card_printer_dialog.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_doctor.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class PatientIdCardDialog extends StatefulWidget {
  const PatientIdCardDialog({
    super.key,
    required this.patient,
  });
  final Patient patient;

  @override
  State<PatientIdCardDialog> createState() => _PatientIdCardDialogState();
}

class _PatientIdCardDialogState extends State<PatientIdCardDialog> {
  late final ScreenshotController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScreenshotController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(context.loc.patientCard),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: Screenshot(
        controller: _controller,
        child: SizedBox(
          width: 360,
          height: 220,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card.outlined(
                elevation: 6,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('كارت متابعة'),
                          Text('دكتور'),
                          Consumer<PxDoctor>(
                            builder: (context, d, _) {
                              while (d.doctor == null) {
                                return SizedBox(
                                  width: 80,
                                  height: 10,
                                  child: LinearProgressIndicator(),
                                );
                              }
                              return Text(
                                '${d.doctor?.name_ar}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: QrImageView.withQr(
                              qr: QrCode.fromData(
                                data:
                                    '{doc_id : ${context.read<PxAuth>().doc_id}, pt_id: ${widget.patient.id}}',
                                errorCorrectLevel: QrErrorCorrectLevel.Q,
                              ),
                              embeddedImage: AssetImage(AppAssets.icon),
                              dataModuleStyle: QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.circle,
                                color: Colors.black,
                              ),
                              eyeStyle: QrEyeStyle(
                                eyeShape: QrEyeShape.circle,
                                color: Colors.blue,
                              ),
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size(50, 50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text('الاسم'),
                            subtitle: Text(widget.patient.name),
                            minVerticalPadding: 4,
                            contentPadding: EdgeInsets.all(0),
                          ),
                          ListTile(
                            title: Text('تاريخ الميلاد'),
                            subtitle: Text(DateFormat('dd - MM - yyyy', 'ar')
                                .format(DateTime.parse(widget.patient.dob))),
                            minVerticalPadding: 4,
                            contentPadding: EdgeInsets.all(0),
                          ),
                          ListTile(
                            title: Text('الموبايل'),
                            subtitle: Text(widget.patient.phone),
                            minVerticalPadding: 4,
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            final _data = await _controller.capture();
            if (_data != null && context.mounted) {
              await showDialog(
                context: context,
                builder: (context) {
                  return PatientIdCardPrinterDialog(
                    dataBytes: _data,
                  );
                },
              );
            }
          },
          label: Text(context.loc.print),
          icon: Icon(
            Icons.print,
            color: Colors.green.shade100,
          ),
        ),
      ],
    );
  }
}
