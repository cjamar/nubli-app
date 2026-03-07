import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_equipo_app/core/theme/styles_utils.dart';
import 'package:notas_equipo_app/core/utils/widgets_utils.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:notas_equipo_app/features/auth/presentation/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isFormValid.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              WidgetsUtils.appSnackbar(context, state.message);
            }
          },
          child: _loginBody(size),
        ),
        backgroundColor: AppStyles.primaryColor,
      ),
    );
  }

  _loginBody(Size size) => LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_imgLogin(size), _formBody(size)],
            ),
          ),
        ),
      );
    },
  );

  _imgLogin(Size size) => SizedBox(
    width: size.width * 0.4,
    height: size.height * 0.4,
    child: Image(
      image: AssetImage('assets/images/logo2.png'),
      fit: BoxFit.contain,
    ),
  );

  _formBody(Size size) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: size.width,
        height: size.height * 0.6,
        padding: EdgeInsets.only(
          top: size.height * 0.05,
          bottom: size.height * 0.1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(size.width * 0.1),
            topLeft: Radius.circular(size.width * 0.1),
          ),
          color: AppStyles.primaryWhite,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _titleLogin(size),
              _textFieldsArea(size),
              _forgetAndRememberArea(size),
              _submitButtons(size),
            ],
          ),
        ),
      ),
    ],
  );

  _submitButtons(Size size) => SizedBox(
    height: size.height * 0.12,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_loginButton(size), _registerButton(size)],
    ),
  );

  _textFieldsArea(Size size) => SizedBox(
    width: size.width * 0.8,
    height: size.height * 0.15,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_emailTextfield(size), _passwordTextfield(size)],
    ),
  );

  _titleLogin(Size size) => Center(
    child: Text(
      AppStyles.loginText2,
      style: AppStyles.h2TextStyle.copyWith(color: AppStyles.primaryColor),
    ),
  );

  _emailTextfield(Size size) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: _emailController,
    builder: (context, value, _) => TextFormField(
      controller: _emailController,
      focusNode: _emailFocus,
      style: AppStyles.mainTextStyle,
      validator: (value) => value == null || value.trim().isEmpty
          ? AppStyles.errorTextfield
          : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppStyles.primaryWhite,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: _inputBorder(size, AppStyles.secondaryWhite),
        enabledBorder: _inputBorder(size, AppStyles.secondaryWhite),
        focusedBorder: _inputBorder(size, AppStyles.secondaryWhite),
        errorBorder: _inputBorder(size, AppStyles.alertColor),
        focusedErrorBorder: _inputBorder(size, AppStyles.alertColor),
        hintText: AppStyles.emailText,
        hintStyle: AppStyles.hintTextStyle,
        suffixIcon: value.text.isNotEmpty && _emailFocus.hasFocus
            ? _clearTextfield(_emailController)
            : null,
      ),
    ),
  );

  _passwordTextfield(Size size) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: _passwordController,
    builder: (context, value, _) => TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      style: AppStyles.mainTextStyle,
      validator: (value) => value == null || value.trim().isEmpty
          ? AppStyles.errorTextfield
          : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppStyles.primaryWhite,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: _inputBorder(size, AppStyles.secondaryWhite),
        enabledBorder: _inputBorder(size, AppStyles.secondaryWhite),
        focusedBorder: _inputBorder(size, AppStyles.secondaryWhite),
        errorBorder: _inputBorder(size, AppStyles.alertColor),
        focusedErrorBorder: _inputBorder(size, AppStyles.alertColor),
        hintText: AppStyles.passwordText,
        hintStyle: AppStyles.hintTextStyle,
        labelStyle: AppStyles.mainTextStyle,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value.text.isNotEmpty && _passwordFocus.hasFocus)
              _clearTextfield(_passwordController),
            _obscureTextIconButton(),
          ],
        ),
      ),
      obscureText: _obscurePassword,
    ),
  );

  _obscureTextIconButton() => IconButton(
    padding: EdgeInsets.zero,
    constraints: BoxConstraints(),
    icon: Icon(
      _obscurePassword ? Icons.visibility : Icons.visibility_off,
      color: Colors.grey.shade400,
      size: 22,
    ),
    onPressed: () {
      setState(() {
        _obscurePassword = !_obscurePassword;
      });
    },
  );

  _clearTextfield(TextEditingController controller) => IconButton(
    padding: EdgeInsets.zero,
    constraints: BoxConstraints(),
    onPressed: () => setState(() {
      controller.clear();
    }),
    icon: Icon(Icons.close, color: AppStyles.primaryGrey, size: 20),
  );

  _forgetAndRememberArea(Size size) => SizedBox(
    width: size.width * 0.9,
    height: size.height * 0.05,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_rememberMeCheckbox(size), _forgotPassword(size)],
    ),
  );

  _rememberMeCheckbox(Size size) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Checkbox(
        value: _rememberMe,
        onChanged: (value) => setState(() {
          _rememberMe = value!;
        }),
        side: BorderSide(color: AppStyles.primaryGrey),
        checkColor: AppStyles.primaryWhite,
        activeColor: AppStyles.primaryColor,
      ),
      Text(AppStyles.rememberMeText, style: AppStyles.secondaryTextStyle),
    ],
  );

  _forgotPassword(Size size) => Container(
    height: size.height * 0.05,
    // color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
    child: TextButton(
      onPressed: () {},
      child: Text(
        AppStyles.forgotPasswordText,
        style: AppStyles.secondaryColoredTextStyle,
      ),
    ),
  );

  _loginButton(Size size) => ValueListenableBuilder<bool>(
    valueListenable: _isFormValid,
    builder: (context, isValid, _) {
      return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.05,
            child: ElevatedButton(
              onPressed: (isValid && !isLoading) ? _onSubmit : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: AppStyles.primaryWhite,
                disabledForegroundColor: AppStyles.primaryGrey,
                textStyle: AppStyles.formTextStyle,
                disabledBackgroundColor: AppStyles.disabledColor,
                backgroundColor: AppStyles.primaryColor,
              ),
              child: isLoading
                  ? WidgetsUtils.loader(AppStyles.primaryColor)
                  : Text(AppStyles.loginText),
            ),
          );
        },
      );
    },
  );

  _registerButton(Size size) => ValueListenableBuilder<bool>(
    valueListenable: _isFormValid,
    builder: (context, isValid, _) {
      return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.05,
            child: ElevatedButton(
              onPressed: (isValid && !isLoading) ? _onRegister : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                side: BorderSide(
                  color: isValid
                      ? AppStyles.secondaryColorDark
                      : AppStyles.disabledColor,
                  width: 1,
                ),
                foregroundColor: AppStyles.secondaryColorDark,
                disabledForegroundColor: AppStyles.primaryGrey,
                textStyle: AppStyles.formTextStyle,
                disabledBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
              child: isLoading
                  ? WidgetsUtils.loader(AppStyles.primaryColor)
                  : Text(AppStyles.registerText),
            ),
          );
        },
      );
    },
  );

  _validateForm() {
    final isValid =
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
    _isFormValid.value = isValid;
  }

  _onSubmit() {
    if (!_isFormValid.value) return;

    context.read<AuthBloc>().add(
      SignInEvent(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      ),
    );
  }

  _onRegister() {
    if (!_isFormValid.value) return;

    _emailController.clear();
    _passwordController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  InputBorder _inputBorder(Size size, Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(size.width * 0.02),
    borderSide: BorderSide(
      color: color,
      width: 1, // fino
    ),
  );
}
