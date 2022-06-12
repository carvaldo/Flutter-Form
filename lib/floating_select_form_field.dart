library carvaldo_form;

import 'package:flutter/material.dart';

class FloatingSelectFormField extends StatefulWidget {
  final List<FloatingSelectOption> children;
  final String? label;
  final List<Widget>? actions;
  final EdgeInsetsGeometry buttonPadding;
  final EdgeInsetsGeometry contentPadding;
  final InputBorder? border; /// TODO: Criar atributo "decoration".
  final void Function(int index, FloatingSelectOption widget)? onSelected;
  final int? selectedPosition;

  const FloatingSelectFormField({
    Key? key,
    this.label,
    this.actions,
    this.contentPadding = const EdgeInsets.all(16),
    this.buttonPadding = const EdgeInsets.all(0),
    this.onSelected,
    this.border,
    this.selectedPosition,
    required this.children
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FloatingSelectState();
}

class FloatingSelectState extends State<FloatingSelectFormField> {
  FloatingSelectOption? _selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: TextFormField(
              onTap: _showOptions,
              controller: TextEditingController(
                  text: _selected?.text
              ),
              readOnly: true,
              decoration: InputDecoration(
                border: widget.border,
                labelText: widget.label,
              ),
            )
        ),
        Container(
          margin: const EdgeInsets.only(
              left: 8, top: 0, right: 0, bottom: 0
          ),
          child: const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.selectedPosition != null) {
      _selected = widget.children[widget.selectedPosition!];
    }
  }

  _showOptions() {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.children.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => _onSelected(index),
                    child: widget.children[index]
                );
              },
            ),
          ),
          actions: widget.actions,
          contentPadding: widget.contentPadding,
          buttonPadding: widget.buttonPadding,
        );
      },
    );
  }

  _onSelected(int index) {
    setState((){
      if(widget.onSelected != null) {
        widget.onSelected!(index, widget.children[index]);
      }
      _selected = widget.children[index];
    });
    Navigator.of(context).pop();
  }
}

class FloatingSelectOption extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String text; // TODO: Renomear para value

  const FloatingSelectOption({
    Key? key,
    this.padding = const EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8),
    required this.text,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    child: child,
  );
}