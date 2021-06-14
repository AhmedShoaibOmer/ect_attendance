import 'package:flutter/material.dart';

Future<T> showPrimaryDialog<T>(
    {BuildContext context,
    Widget dialog,
    Widget Function(BuildContext) dialogBuilder}) {
  return showGeneralDialog<T>(
    context: context,
    barrierColor: Theme.of(context).primaryColor.withOpacity(0.6),
    // background color
    barrierDismissible: false,
    // should dialog be dismissed when tapped outside
    transitionDuration: Duration(milliseconds: 400),
    // how long it takes to popup dialog after button click
    pageBuilder: (context, __, ___) {
      // your widget implementation
      return dialog != null ? dialog : dialogBuilder(context);
    },
  );
}
