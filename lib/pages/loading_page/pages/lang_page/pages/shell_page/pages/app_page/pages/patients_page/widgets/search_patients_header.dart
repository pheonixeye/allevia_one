import 'package:flutter/material.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/has_numbers.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/providers/px_patients.dart';
import 'package:provider/provider.dart';

class SearchPatientsHeader extends StatefulWidget {
  const SearchPatientsHeader({super.key});

  @override
  State<SearchPatientsHeader> createState() => _SearchPatientsHeaderState();
}

class _SearchPatientsHeaderState extends State<SearchPatientsHeader> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<PxPatients>(
        builder: (context, p, _) {
          return ListTile(
            title: Form(
              key: formKey,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.myPatients),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: context.loc.searchByPatientNameorMobileNumber,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.loc.enterPatientName;
                        }
                        if (hasNumbers(value) && value.length != 11) {
                          return context.loc.enterValidPatientPhone;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.small(
                      heroTag: 'patient-search-button',
                      tooltip: context.loc.findPatient,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              if (hasNumbers(_controller.text)) {
                                await p.searchPatientsByPhone(_controller.text);
                              } else {
                                await p.searchPatientsByName(_controller.text);
                              }
                            },
                          );
                        }
                      },
                      child: const Icon(Icons.search),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.small(
                      tooltip: context.loc.clearSearch,
                      heroTag: 'patient-clear-search-button',
                      backgroundColor: Colors.red.shade300,
                      onPressed: () async {
                        _controller.clear();
                        await shellFunction(
                          context,
                          toExecute: () async {
                            await p.clearSearch();
                          },
                        );
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: const Divider(),
          );
        },
      ),
    );
  }
}
