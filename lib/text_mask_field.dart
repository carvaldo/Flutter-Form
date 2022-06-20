import 'package:flutter/material.dart';

class TextMaskFormField extends FormField<String?> {
  final String mask;
  final TextEditingController? controller;
  final String label;
  final bool readOnly;
  final TextAlign? textAlign;
  final void Function(String? text)? onFinish;

  TextMaskFormField({
    Key? key,
    required this.label,
    required this.mask,
    this.controller,
    this.onFinish,
    this.readOnly = false,
    this.textAlign
  }) : super(
      key: key,
      builder: (state) {
        var charactersCount = RegExp(r'[\#]').allMatches(mask).length;
        var aux = 0;
        String apply(String text) {
          var result = "";
          for(var i = 0; i < text.length; i++) {
            var c = mask[i+aux];
            if (c == "#") {
              result += text[i];
            } else {
              aux++;
              result += c;
              result += text[i];
            }
          }
          return result;
        }

        String revert(String text) {
          var result = text;
          var punctuations = mask.replaceAll("#", "");
          for (var element in punctuations.characters) {
            result = result.replaceAll(element, "");
          }
          return result;
        }

        return TextFormField(
          maxLength: mask.length,
          onChanged: (text) {
            var content = revert(text);
            if (content.length == charactersCount) {
              var newText = apply(content);
              controller?.text = newText;
              state.didChange(newText);
              if (onFinish != null) {
                onFinish(newText);
              }
            }
          },
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
              labelText: label
          ),
        );
      }
  );
}