library carvaldo_form;

import 'package:flutter/material.dart';

// TODO: Fazer assertion para validar se children é do tipo SelectOption.
class SelectFormField extends FormField<int> {
  final List<SelectOption> children;
  final String? label;
  final List<Widget>? actions;
  final EdgeInsetsGeometry buttonPadding;
  final EdgeInsetsGeometry contentPadding;
  final InputBorder? border; /// TODO: Criar atributo "decoration".
  final void Function(int index, SelectOption widget)? onSelected;
  final SelectController? controller;

  SelectFormField({
    Key? key,
    required this.children,
    this.controller,
    this.label,
    this.actions,
    this.contentPadding = const EdgeInsets.all(16),
    this.buttonPadding = const EdgeInsets.all(0),
    this.onSelected,
    this.border,
  }) : super(key: key,
      builder: (state) {
        return Row(
          children: [
            Flexible(
                child: TextFormField(
                  onTap: () async {
                    showDialog(
                      context: state.context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            width: double.minPositive,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: children.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      if(onSelected != null) {
                                        onSelected(index, children[index]);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: children[index]
                                );
                              },
                            ),
                          ),
                          actions: actions,
                          contentPadding: contentPadding,
                          buttonPadding: buttonPadding,
                        );
                      },
                    );
                  },
                  controller: TextEditingController(
                      text: (controller?.value != null) ? children[controller!.value!].label : null
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    border: border,
                    labelText: label,
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
  );
}

class SelectOption extends StatelessWidget {
  final Widget child;
  final String label;
  final EdgeInsetsGeometry padding;

  const SelectOption({
    Key? key,
    required this.label,
    required this.child,
    this.padding = const EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    child: child,
  );
}

class SelectController extends ValueNotifier<int?> {
  SelectController(int? value) : super(value);
}