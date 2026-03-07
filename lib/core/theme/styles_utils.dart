import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  // #PRIMARY
  static Color primaryColor = const Color.fromARGB(255, 78, 98, 186);
  static Color primaryColorLight = const Color.fromARGB(255, 218, 225, 255);
  static Color primaryColorLightDarker = const Color.fromARGB(
    255,
    169,
    184,
    245,
  );
  static Color primaryColorDark = const Color.fromARGB(255, 52, 71, 158);

  // #SECONDARY
  // static Color secondaryColor = const Color.fromARGB(255, 255, 147, 255);
  static Color secondaryColor = const Color.fromARGB(255, 255, 147, 255);
  static Color secondaryColorLight = const Color.fromARGB(255, 255, 228, 255);
  static Color secondaryColorLightDarker = const Color.fromARGB(
    255,
    242,
    193,
    242,
  );
  static Color secondaryColorDark = const Color.fromARGB(255, 203, 85, 203);

  static Color disabledColor = const Color.fromARGB(29, 97, 97, 97);
  static LinearGradient footerHomeGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: <Color>[
      primaryWhite,
      Colors.transparent,
    ], // Gradient from https://learnui.design/tools/gradient-generator.html
    tileMode: TileMode.mirror,
  );
  static LinearGradient basicColorGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
  );
  static Color primaryDark = const Color.fromARGB(255, 31, 31, 31);
  static Color secondaryDark = const Color.fromARGB(255, 53, 53, 53);
  static Color tertiaryDark = const Color.fromARGB(255, 68, 68, 68);
  static Color primaryGrey = const Color.fromARGB(255, 138, 138, 138);
  static Color creamWhite = const Color.fromARGB(255, 242, 240, 237);
  static Color primaryWhite = Colors.white;
  static Color secondaryWhite = const Color.fromARGB(255, 221, 221, 221);
  static Color alertColor = Colors.redAccent;

  // TextStyles
  static TextStyle mainTextStyle = TextStyle(fontSize: 16, color: primaryDark);
  static TextStyle mainTextStyleWhite = TextStyle(
    fontSize: 16,
    color: primaryWhite,
  );
  static TextStyle mainTextStylePrimary = TextStyle(
    fontSize: 16,
    color: primaryColor,
  );
  static TextStyle tileTextStyle = TextStyle(
    fontSize: 16,
    color: primaryDark,
    fontWeight: FontWeight.w600,
  );
  static TextStyle cardTextStyle = TextStyle(fontSize: 19, color: primaryDark);
  static TextStyle secondaryTextStyle = TextStyle(
    fontSize: 13,
    color: primaryDark,
  );
  static TextStyle secondaryColoredTextStyle = TextStyle(
    fontSize: 13,
    color: primaryColor,
  );
  static TextStyle secondaryWhiteTextStyle = TextStyle(
    fontSize: 13,
    color: primaryWhite,
  );
  static TextStyle hintTextStyle = TextStyle(fontSize: 15, color: primaryGrey);
  static TextStyle tertiaryTextStyle = TextStyle(
    fontSize: 12,
    color: primaryDark,
  );

  static TextStyle h1TextStyle = TextStyle(fontSize: 23, color: primaryDark);
  static TextStyle h2TextStyle = TextStyle(fontSize: 20, color: primaryDark);
  static TextStyle h2TextStyleWhite = TextStyle(
    fontSize: 20,
    color: primaryWhite,
  );
  static TextStyle formTextStyle = TextStyle(fontSize: 18, color: primaryWhite);
  static TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    color: primaryDark,
  );
  static TextStyle bigTextFieldStyle = TextStyle(
    fontSize: 21,
    color: primaryDark,
  );

  static TextStyle alertTextStyle = TextStyle(fontSize: 16, color: alertColor);

  // Texts
  static String appName = 'App de notas';
  static String listText = 'Lista';
  static String noteText = 'Nota';
  static String cancelText = 'Cancelar';
  static String deleteText = 'Eliminar';
  static String doYoWantDeleteText = '¿Quieres eliminar la entrada';
  static String createText = 'Crear';
  static String updateText = 'Guardar cambios';
  static String entriesText = 'Entradas';
  static String chooseEntryText = 'Elige un tipo de entrada';
  static String listTextfield = 'Título de la lista';
  static String noteTextfield = 'Título de la nota';
  static String writeYourNoteText = 'Escribe tu nota.';
  static String emptyListText = 'Tu lista está vacia. \n ¡Crea una nota!';
  static String errorTextfield = 'El campo no puede estar vacío';
  static String addItemToListText = 'Añade items a tu lista';
  static String chooseReminderDate = 'Establece un recordatorio';
  static String loginText = 'Iniciar sesión';
  static String registerText = 'Registrarme';
  static String loginText2 = '!Estás de vuelta!';
  static String forgotPasswordText = '¿Olvidaste tu contraseña?';
  static String rememberMeText = 'Recuérdame';
  static String emailText = 'Email';
  static String passwordText = 'Contraseña';
  static String logoutText = 'Cerrar sesión';
  static String backToLogin = 'Volver a Login';

  // Sizes
  static BorderRadius tileBorderRadius(Size size) =>
      BorderRadius.circular(size.width * 0.01);

  static BorderRadius cardBorderRadius(Size size) =>
      BorderRadius.circular(size.width * 0.05);

  // Mask Gradients
  static ShaderMask gradientIconsColor(IconData icon, double size) =>
      ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [primaryColor, secondaryColor],
        ).createShader(bounds),
        child: Icon(icon, size: size, color: AppStyles.primaryWhite),
      );
}
