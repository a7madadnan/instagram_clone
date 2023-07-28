import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instant_gram/views/constants/strings.dart';
import 'package:instant_gram/views/constants/app_colors.dart';

class FaceBookButton extends StatelessWidget {
  const FaceBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.facebook,
            color: AppColors.facebookColor,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(Strings.facebook)
        ],
      ),
    );
  }
}
