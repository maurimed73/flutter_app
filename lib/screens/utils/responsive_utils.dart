import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  /// Retorna um valor proporcional à largura da tela
  static double widthPercent(BuildContext context, double percent) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (percent / 100);
  }

  /// Retorna um valor proporcional à altura da tela
  static double heightPercent(BuildContext context, double percent) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * (percent / 100);
  }

  /// Retorna um valor proporcional à menor dimensão (útil para fontes)
  static double scalePercent(BuildContext context, double percent) {
    final size = MediaQuery.of(context).size;
    final base = size.width < size.height ? size.width : size.height;
    return base * (percent / 100);
  }
}
