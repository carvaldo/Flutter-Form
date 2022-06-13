library carvaldo_form;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    Key? key,
    required this.label,
    this.format = "MM/dd/yyyy",
    this.onPicked,
    this.firstDate,
    this.lastDate,
    this.textAlign = TextAlign.start,
    this.border,
    this.controller,
    FormFieldValidator<DateTime?>? validator
  }) : super(
      key: key,
      onSaved: onPicked,
      validator: validator,
      // autovalidateMode: AutovalidateMode.disabled,
      builder: (state) {
        var value = controller?.value == null ? "" : DateFormat(format).format(controller!.value!);
        return TextFormField(
            textAlign: textAlign,
            readOnly: true,
            decoration: InputDecoration(
                label: Text(label),
                border: border
            ),
            controller: TextEditingController(text: value),
            onTap: () async {
              var date = await showDatePicker(
                context: state.context,
                initialDate: controller?.value ?? DateTime.now(),
                firstDate: firstDate ?? DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: lastDate ?? DateTime.now(),
              );
              controller?.value = date;
              // state.didChange(date);
              if(onPicked != null) {
                onPicked(date);
              }
            }
        );
      }
  );

  final String format;
  final String label;
  final FormFieldSetter<DateTime?>? onPicked;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final TextAlign textAlign;
  final InputBorder? border;
  final DatePickingController? controller;
}

class DatePickingController extends ValueNotifier<DateTime?> {
  DatePickingController({DateTime? date}) : super(date);
}