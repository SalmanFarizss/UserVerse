import 'package:flutter/cupertino.dart';

class ErrorText extends StatelessWidget {
  final String text;
  const ErrorText({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}