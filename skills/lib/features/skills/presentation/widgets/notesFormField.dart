import 'package:flutter/material.dart';

class NotesFormField extends TextFormField {
  NotesFormField(TextEditingController controller, String placeHolder)
      : super(
            maxLength: 400,
            maxLines: null,
            decoration: InputDecoration(labelText: placeHolder),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            controller: controller);
}
