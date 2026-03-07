import 'package:flutter/material.dart';
import 'package:notas_equipo_app/core/theme/styles_utils.dart';

class SimpleWidgets {
  // static Widget loader() => Center(
  //   child: CircularProgressIndicator(
  //     strokeWidth: 5,
  //     color: AppStyles.primaryDark,
  //     backgroundColor: AppStyles.secondaryWhite,
  //   ),
  // );

  static emptyList(Size size) => baseContainer(
    Icons.remove_shopping_cart_outlined,
    AppStyles.emptyListText,
    size,
    AppStyles.secondaryColor,
  );

  static errorContainer(Size size, String message) => baseContainer(
    Icons.error,
    'Ha ocurrido un error. \n $message',
    size,
    AppStyles.alertColor,
  );

  static baseContainer(IconData icon, String text, Size size, Color color) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: size.width * 0.2, color: color),
            SizedBox(height: size.height * 0.025),
            Text(
              text,
              style: AppStyles.h1TextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
