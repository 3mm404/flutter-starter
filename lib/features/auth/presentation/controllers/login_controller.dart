import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/app_failure.dart';
import 'session_controller.dart';

/// Administra el formulario, sus validaciones y el estado de envío del login.
class LoginController extends GetxController {
  LoginController(this.session);
  final SessionController session;
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final loading = false.obs;
  final obscure = true.obs;
  final errorKey = RxnString();

  /// Comprueba que el correo esté presente y tenga un formato válido.
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'validation.required'.tr;
    if (!GetUtils.isEmail(value.trim())) return 'validation.email'.tr;
    return null;
  }

  /// Comprueba que el usuario haya ingresado una contraseña.
  String? validatePassword(String? value) =>
      value == null || value.isEmpty ? 'validation.required'.tr : null;

  /// Valida y envía el formulario evitando peticiones duplicadas.
  Future<void> submit() async {
    if (loading.value || formKey.currentState?.validate() != true) return;
    loading.value = true;
    errorKey.value = null;
    session.errorKey.value = null;
    try {
      await session.login(email.text.trim(), password.text);
    } on AppFailure catch (error) {
      errorKey.value = error.translationKey;
    } catch (_) {
      errorKey.value = 'error.unexpected';
    } finally {
      loading.value = false;
    }
  }

  @override
  /// Libera los controladores de texto al salir de la pantalla.
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
