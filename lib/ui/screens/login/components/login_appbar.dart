import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owner_app/size_config.dart';

class LoginScreenAppBar extends StatelessWidget with PreferredSizeWidget {
  const LoginScreenAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        SizedBox(
          width: 100.w,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 16.0, left: 8, top: 8, bottom: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 30.w,
                ),
                Spacer(),
              ],
            ),
          ),
        )
      ],
    );
    ;
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(0);
}
