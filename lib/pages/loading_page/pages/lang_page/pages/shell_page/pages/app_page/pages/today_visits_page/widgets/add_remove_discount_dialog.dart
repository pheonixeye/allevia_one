import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_name.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visit_view_card.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddRemoveDiscountDialog extends StatefulWidget {
  const AddRemoveDiscountDialog({
    super.key,
    required this.visit,
    required this.direction,
  });
  final Visit visit;
  final BookkeepingDirection direction;

  @override
  State<AddRemoveDiscountDialog> createState() =>
      _AddRemoveDiscountDialogState();
}

class _AddRemoveDiscountDialogState extends State<AddRemoveDiscountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(switch (widget.direction) {
              BookkeepingDirection.IN => context.loc.removeDiscount,
              BookkeepingDirection.OUT => context.loc.addDiscount,
              BookkeepingDirection.NONE => throw UnimplementedError(),
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton.outlined(
              onPressed: () {
                Navigator.pop(context, null);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
      scrollable: false,
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        // height: MediaQuery.sizeOf(context).height,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PreviousVisitViewCard(
                item: widget.visit,
                index: 0,
                showIndexNumber: false,
                showPatientName: true,
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.discount),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: context.loc.discountInPounds,
                          ),
                          controller: _amountController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${context.loc.enter} ${context.loc.amountInPounds}';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final _dto = BookkeepingItemDto(
                id: '',
                item_name: switch (widget.direction) {
                  BookkeepingDirection.IN =>
                    BookkeepingName.visit_remove_discount.name,
                  BookkeepingDirection.OUT =>
                    BookkeepingName.visit_add_discount.name,
                  BookkeepingDirection.NONE => throw UnimplementedError(),
                },
                item_id: widget.visit.id,
                collection_id: 'visits',
                added_by_id: PxAuth.doc_id_static_getter,
                updated_by_id: '',
                amount: switch (widget.direction) {
                  BookkeepingDirection.IN =>
                    double.parse(_amountController.text),
                  BookkeepingDirection.OUT =>
                    -double.parse(_amountController.text),
                  BookkeepingDirection.NONE => throw UnimplementedError(),
                },
                type: widget.direction.value,
                update_reason: '',
                auto_add: false,
              );
              //pop with null to avoid an extra useless request

              Navigator.pop(context, _dto);
            }
          },
          label: Text(context.loc.confirm),
          icon: Icon(
            Icons.check,
            color: Colors.green.shade100,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: Text(context.loc.cancel),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
