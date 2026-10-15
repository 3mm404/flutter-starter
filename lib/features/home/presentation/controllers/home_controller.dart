import 'package:get/get.dart';

/// Administra la selección de los cuatro destinos de la barra inferior.
class HomeController extends GetxController {
  /// Identifica el destino activo: 0 es Inicio y 1, 2 y 3 son secciones provisionales.
  final selectedIndex = 0.obs;
  /// Cambia el destino activo únicamente si su índice está entre 0 y 3.
  void select(int value) {
    if (value >= 0 && value < 4) selectedIndex.value = value;
  }
}
