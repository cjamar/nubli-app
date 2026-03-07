import 'package:flutter/material.dart';
import 'package:notas_equipo_app/core/theme/styles_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(body: _registerBody(size));
  }

  _registerBody(Size size) => Container(
    width: size.width,
    height: size.height,
    color: AppStyles.primaryColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildingPageContainer(size), _backButton(size)],
    ),
  );

  _buildingPageContainer(Size size) => SizedBox(
    width: size.width,
    height: size.height * 0.3,
    child: Column(
      children: [
        Icon(
          Icons.build_circle,
          size: size.width * 0.3,
          color: AppStyles.secondaryColor,
        ),
        SizedBox(height: size.height * 0.025),
        Text(
          'Página en proceso\nde construcción',
          style: AppStyles.h2TextStyleWhite,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  _backButton(Size size) => SizedBox(
    width: size.width * 0.8,
    height: size.height * 0.05,
    child: ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppStyles.primaryColorDark,
        textStyle: AppStyles.buttonTextStyle,
        backgroundColor: AppStyles.primaryWhite,
      ),
      child: Text(AppStyles.backToLogin),
    ),
  );
}
