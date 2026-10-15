import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/presentation/controllers/login_controller.dart';
import '../features/auth/presentation/controllers/session_controller.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/home/presentation/controllers/home_controller.dart';
import '../features/home/presentation/views/home_view.dart';

/// Impide entrar a Home cuando no hay una sesión local activa.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      Get.find<SessionController>().signedIn
      ? null
      : const RouteSettings(name: '/login');
}

/// Centraliza las pantallas y las dependencias de cada ruta.
abstract final class AppRoutes {
  /// Registra login y Home con sus controladores y protección de acceso.
  static final pages = [
    GetPage(
      name: '/login',
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController(Get.find()));
      }),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      middlewares: [AuthGuard()],
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
    ),
  ];
}
