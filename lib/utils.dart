import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:owner_app/size_config.dart';

showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(text),
    duration: Duration(milliseconds: 2000),
  ));
}

String? validateEmail(String? email) {
  if (email != null) {
    if (EmailValidator.validate(email)) {
      return null;
    }
    return 'Enter a valid email';
  }
  return 'Enter a valid email';
}

String? validatePhone(String? phoneNumber) {
  if (phoneNumber != null) {
    if (phoneNumber.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      return null;
    }
  }
  return 'Enter a valid phone number';
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

Widget loadingAnimation() {
  // return SizedBox(
  //   width: 300,
  //   height: 300,
  //   child: RiveAnimation.asset(
  //     'assets/animations/clean_the_car.riv',
  //   ),
  // );
  final spinkit = SpinKitThreeInOut(
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.all(6.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? SizeConfig.kPrimaryColor : Color(0xffbfdcff),
          ),
        ),
      );
    },
  );
  return spinkit;
}

PreferredSizeWidget getAppBarWithBackButton(
    {required BuildContext context, Widget? title, List<Widget>? actions}) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarBrightness: Brightness.dark),
    title: title,
    actions: actions,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_outlined, color: Colors.black),
      onPressed: () => Navigator.maybePop(context),
    ),
    actionsIconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
