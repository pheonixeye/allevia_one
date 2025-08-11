import 'package:flutter/material.dart';
import 'package:allevia_one/extensions/loc_ext.dart';

// ignore: unused_element
Widget _unused(BuildContext context) => ListView(
      children: [
        Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: FloatingActionButton.small(
                heroTag: 'profile_drugs',
                onPressed: null,
              ),
              title: Text(
                context.loc.doctorDrugs,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              trailing: FloatingActionButton.small(
                heroTag: 'manage_profile_drugs',
                tooltip: context.loc.manage,
                onPressed: () async {},
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
        Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: FloatingActionButton.small(
                heroTag: 'profile_labs',
                onPressed: null,
              ),
              title: Text(
                context.loc.laboratoryRequests,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              trailing: FloatingActionButton.small(
                heroTag: 'manage_profile_labs',
                tooltip: context.loc.manage,
                onPressed: () async {},
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
        Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: FloatingActionButton.small(
                heroTag: 'profile_rads',
                onPressed: null,
              ),
              title: Text(
                context.loc.radiology,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              trailing: FloatingActionButton.small(
                heroTag: 'manage_profile_rads',
                tooltip: context.loc.manage,
                onPressed: () async {},
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
        Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: FloatingActionButton.small(
                heroTag: 'profile_procedures',
                onPressed: null,
              ),
              title: Text(
                context.loc.procedures,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              trailing: FloatingActionButton.small(
                heroTag: 'manage_profile_procedures',
                tooltip: context.loc.manage,
                onPressed: () async {},
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
        Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: FloatingActionButton.small(
                heroTag: 'profile_supplies',
                onPressed: null,
              ),
              title: Text(
                context.loc.supplies,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              trailing: FloatingActionButton.small(
                heroTag: 'manage_profile_supplies',
                tooltip: context.loc.manage,
                onPressed: () async {},
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
      ],
    );
