import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:owner_app/size_config.dart';

class ContactOptionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String svgAsset;
  const ContactOptionButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.svgAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          width: (100.w - 40) / 2 - 20,
          decoration: BoxDecoration(
              border: Border.all(
                color: SizeConfig.kPrimaryColor,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    offset: Offset(-5, 4),
                    blurRadius: 16,
                    color: Color.fromRGBO(0, 0, 0, 0.16))
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(svgAsset),
              SizeConfig.kverticalMargin8,
              Text(text)
            ],
          ),
        ));
  }
}
