import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String bgImage;
    if (kIsWeb) {
      bgImage = isDark
          ? 'assets/images/darkBG_web.png'
          : 'assets/images/lightBG_web.png';
    } else {
      bgImage = isDark
          ? 'assets/images/darkBG.png'
          : 'assets/images/lightBG.png';
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
