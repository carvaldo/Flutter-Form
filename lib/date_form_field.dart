library carvaldo_form;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends StatefulWidget {
  const DateFormField({
    Key? key,
    required this.label,
    this.format = "MM/dd/yyyy",
    this.onPicked,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.locale,
    this.textAlign = TextAlign.start,
    this.inputBorder,
    this.validator
  }) : super(key: key);

  final String format;
  final String label;
  final void Function(DateTime? date)? onPicked;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Locale? locale;
  final TextAlign textAlign;
  final InputBorder? inputBorder;
  final String? Function(DateTime? value)? validator;

  @override
  State<StatefulWidget> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  late DateFormat _formatter;
  String? _text;
  DateTime? _date;

  @override
  Widget build(BuildContext context) => TextFormField(
    textAlign: widget.textAlign,
    readOnly: true,
    decoration: InputDecoration(
        label: Text(widget.label),
        border: widget.inputBorder
    ),
    controller: TextEditingController(
        text: _text
    ),
    onTap: _selectDate,
    validator: (text) {
      if(widget.validator != null) {
        return widget.validator!(_date);
      }
      return null;
    },
  );


  @override
  void initState() {
    super.initState();
    _formatter = DateFormat(widget.format);
  }

  _selectDate() async {
    var date = await showDatePicker(
        context: context,
        initialDate: widget.initialDate ?? DateTime.now(),
        firstDate: widget.firstDate ?? DateTime.fromMillisecondsSinceEpoch(0),
        lastDate: widget.lastDate ?? DateTime.now(),
        locale: widget.locale ?? const Locale("en", "US")
    );
    setState(() {
      _text = (date != null) ? _formatter.format(date) : null;
      _date = date;
      if(widget.onPicked != null) {
        widget.onPicked!(date);
      }
    });
  }
}