import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../generated/l10n.dart';
import '../utilities/constants.dart';

class BasicDateTimeField extends StatefulWidget {
  final Function(DateTime) onChanged;

  final DateTime initialValue;

  const BasicDateTimeField({Key key, this.onChanged, this.initialValue})
      : super(key: key);

  @override
  _BasicDateTimeFieldState createState() => _BasicDateTimeFieldState();
}

class _BasicDateTimeFieldState extends State<BasicDateTimeField> {
  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          S.of(context).date_and_time,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle.copyWith(
            color: Colors.white,
          ),
          height: 56.0,
          child: DateTimeField(
            format: format,
            initialValue: widget.initialValue,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsetsDirectional.only(
                start: 14.0,
              ),
              hintText: S.of(context).date_and_time_hint,
              hintStyle: kHintTextStyle.copyWith(color: Colors.black45),
            ),
            onChanged: widget.onChanged,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
          ),
        ),
      ],
    );
  }
}
