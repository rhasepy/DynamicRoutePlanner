import 'package:flutter/material.dart';
import 'package:dynamicrouteplanner/components/text_field_container.dart';
import 'package:dynamicrouteplanner/StaticConstants/constants.dart';

class RoundedPhoneField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPhoneField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: TextField(
        keyboardType: TextInputType.phone,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Phone Number",
          icon: Icon(
            Icons.phone,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
