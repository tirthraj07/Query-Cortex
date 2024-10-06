import 'package:flutter/material.dart';

import '../../colors.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              buttonColor),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Align(alignment: Alignment.center, child: Text(text, style: const TextStyle(color: Colors.white),)),
        ),
      ),
    );
  }
}
