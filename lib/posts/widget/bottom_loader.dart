import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
          strokeWidth: 1.5
      ),
    );
  }
}
