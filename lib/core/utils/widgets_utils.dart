import 'package:flutter/material.dart';
import 'package:notas_equipo_app/core/theme/styles_utils.dart';

class WidgetsUtils {
  static Widget loader(Color color) =>
      Center(child: CircularProgressIndicator(color: color));

  static appSnackbar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text, style: TextStyle(color: AppStyles.primaryDark)),
          backgroundColor: AppStyles.alertColor,
        ),
      );
}
