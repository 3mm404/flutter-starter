import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/content_card.dart';
import '../controllers/login_controller.dart';

/// Muestra el formulario de acceso y los estados de carga o error del controlador.
class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpace.large),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: AppSpace.medium),
                      Text(
                        'app.name'.tr,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.xlarge),
                  Text(
                    'login.eyebrow'.tr,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpace.small),
                  Text(
                    'login.title'.tr,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpace.small),
                  Text(
                    'login.subtitle'.tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpace.large),
                  ContentCard(
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            key: const Key('login-email'),
                            controller: controller.email,
                            validator: controller.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            autofillHints: const [AutofillHints.username],
                            decoration: InputDecoration(
                              labelText: 'email'.tr,
                              prefixIcon: const Icon(Icons.alternate_email),
                            ),
                          ),
                          const SizedBox(height: AppSpace.medium),
                          Obx(
                            () => TextFormField(
                              key: const Key('login-password'),
                              controller: controller.password,
                              validator: controller.validatePassword,
                              obscureText: controller.obscure.value,
                              enableSuggestions: false,
                              autocorrect: false,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => controller.submit(),
                              decoration: InputDecoration(
                                labelText: 'password'.tr,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip:
                                      (controller.obscure.value
                                              ? 'password.show'
                                              : 'password.hide')
                                          .tr,
                                  onPressed: () => controller.obscure.toggle(),
                                  icon: Icon(
                                    controller.obscure.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpace.medium),
                          Obx(() {
                            final key =
                                controller.errorKey.value ??
                                controller.session.errorKey.value;
                            return key == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpace.medium,
                                    ),
                                    child: InlineMessage(text: key.tr),
                                  );
                          }),
                          Obx(
                            () => FilledButton(
                              key: const Key('login-submit'),
                              onPressed: controller.loading.value
                                  ? null
                                  : controller.submit,
                              child: controller.loading.value
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpace.small),
                                        Flexible(
                                          child: Text('login.loading'.tr),
                                        ),
                                      ],
                                    )
                                  : Text('login.submit'.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpace.large),
                  Text(
                    'login.footer'.tr,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
