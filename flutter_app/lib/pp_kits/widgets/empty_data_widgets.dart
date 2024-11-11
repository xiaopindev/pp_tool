import 'package:flutter/material.dart';
import 'package:flutter_app/generated/assets.dart';

class EmptyDataView extends StatelessWidget {
  const EmptyDataView({
    super.key,
    this.icon = A.ppkitsNodata,
    this.text = 'No data available~',
    this.button,
  });

  final String icon;
  final String text;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
          if (button != null) ...[
            const SizedBox(height: 24),
            button!,
          ],
        ],
      ),
    );
  }
}
