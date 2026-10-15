import 'package:get/get.dart';

/// Agrupa los textos de interfaz en español, inglés, francés y portugués.
class AppTranslations extends Translations {
  /// Define el orden compartido de los códigos, nombres y traducciones.
  static const languages = ['es', 'en', 'fr', 'pt'];
  static const nativeNames = ['Español', 'English', 'Français', 'Português'];

  /// Asocia cada clave con sus textos en el orden es, en, fr y pt.
  static const _values = <String, List<String>>{
    'app.name': ['Deli', 'Deli', 'Deli', 'Deli'],
    'login.eyebrow': [
      'TU ESPACIO, A TU MANERA',
      'YOUR SPACE, YOUR WAY',
      'VOTRE ESPACE, VOTRE STYLE',
      'SEU ESPAÇO, DO SEU JEITO',
    ],
    'login.title': [
      'Qué gusto verte',
      'Welcome back',
      'Heureux de vous revoir',
      'Que bom ver você',
    ],
    'login.subtitle': [
      'Inicia sesión para continuar.',
      'Sign in to continue.',
      'Connectez-vous pour continuer.',
      'Entre para continuar.',
    ],
    'email': [
      'Correo electrónico',
      'Email address',
      'Adresse e-mail',
      'E-mail',
    ],
    'password': ['Contraseña', 'Password', 'Mot de passe', 'Senha'],
    'password.show': [
      'Mostrar contraseña',
      'Show password',
      'Afficher le mot de passe',
      'Mostrar senha',
    ],
    'password.hide': [
      'Ocultar contraseña',
      'Hide password',
      'Masquer le mot de passe',
      'Ocultar senha',
    ],
    'login.submit': ['Iniciar sesión', 'Sign in', 'Se connecter', 'Entrar'],
    'login.loading': ['Ingresando…', 'Signing in…', 'Connexion…', 'Entrando…'],
    'login.footer': [
      'Tu sesión se guarda de forma segura.',
      'Your session is stored securely.',
      'Votre session est enregistrée en sécurité.',
      'Sua sessão é armazenada com segurança.',
    ],
    'validation.required': [
      'Este campo es obligatorio.',
      'This field is required.',
      'Ce champ est obligatoire.',
      'Este campo é obrigatório.',
    ],
    'validation.email': [
      'Ingresa un correo válido.',
      'Enter a valid email.',
      'Saisissez un e-mail valide.',
      'Digite um e-mail válido.',
    ],
    'nav.home': ['Inicio', 'Home', 'Accueil', 'Início'],
    'nav.two': ['Sección 2', 'Section 2', 'Section 2', 'Seção 2'],
    'nav.three': ['Sección 3', 'Section 3', 'Section 3', 'Seção 3'],
    'nav.four': ['Sección 4', 'Section 4', 'Section 4', 'Seção 4'],
    'home.greeting': [
      'Hola, @name',
      'Hello, @name',
      'Bonjour, @name',
      'Olá, @name',
    ],
    'home.subtitle': [
      'Este es tu punto de partida.',
      'This is your starting point.',
      'Voici votre point de départ.',
      'Este é o seu ponto de partida.',
    ],
    'home.profile': ['Tu perfil', 'Your profile', 'Votre profil', 'Seu perfil'],
    'profile.birth': [
      'Fecha de nacimiento',
      'Date of birth',
      'Date de naissance',
      'Data de nascimento',
    ],
    'profile.roles': ['Roles', 'Roles', 'Rôles', 'Perfis'],
    'role.one': ['@count rol', '@count role', '@count rôle', '@count perfil'],
    'role.many': [
      '@count roles',
      '@count roles',
      '@count rôles',
      '@count perfis',
    ],
    'profile.empty': [
      'Sin información',
      'Not provided',
      'Non renseigné',
      'Não informado',
    ],
    'session.confirmed': [
      'Sesión validada',
      'Session verified',
      'Session vérifiée',
      'Sessão validada',
    ],
    'session.pending': [
      'Sesión local: pendiente de confirmar con el servidor.',
      'Local session: awaiting server confirmation.',
      'Session locale : confirmation du serveur en attente.',
      'Sessão local: aguardando confirmação do servidor.',
    ],
    'session.retry': ['Reintentar', 'Retry', 'Réessayer', 'Tentar novamente'],
    'logout': ['Cerrar sesión', 'Sign out', 'Se déconnecter', 'Sair'],
    'settings': [
      'Personaliza tu espacio',
      'Make it yours',
      'Personnalisez votre espace',
      'Personalize seu espaço',
    ],
    'settings.subtitle': [
      'Los cambios se guardan en este dispositivo.',
      'Changes are saved on this device.',
      'Les changements sont enregistrés sur cet appareil.',
      'As alterações são salvas neste dispositivo.',
    ],
    'settings.language': ['Idioma', 'Language', 'Langue', 'Idioma'],
    'settings.theme': ['Apariencia', 'Appearance', 'Apparence', 'Aparência'],
    'settings.palette': [
      'Paleta de color',
      'Color palette',
      'Palette de couleurs',
      'Paleta de cores',
    ],
    'theme.system': ['Sistema', 'System', 'Système', 'Sistema'],
    'theme.light': ['Claro', 'Light', 'Clair', 'Claro'],
    'theme.dark': ['Oscuro', 'Dark', 'Sombre', 'Escuro'],
    'palette.ocean': ['Océano', 'Ocean', 'Océan', 'Oceano'],
    'palette.forest': ['Bosque', 'Forest', 'Forêt', 'Floresta'],
    'palette.berry': ['Frambuesa', 'Berry', 'Framboise', 'Framboesa'],
    'palette.violet': ['Violeta', 'Violet', 'Violet', 'Violeta'],
    'palette.coral': ['Coral', 'Coral', 'Corail', 'Coral'],
    'placeholder.title': [
      'Destino provisional',
      'Placeholder destination',
      'Destination provisoire',
      'Destino provisório',
    ],
    'placeholder.body': [
      'La sección @number aún no tiene funcionalidades. Puedes volver a Inicio.',
      'Section @number has no features yet. You can return to Home.',
      'La section @number ne propose pas encore de fonctionnalités. Revenez à l’accueil.',
      'A seção @number ainda não tem funcionalidades. Você pode voltar ao Início.',
    ],
    'error.credentials': [
      'El correo o la contraseña son incorrectos.',
      'Incorrect email or password.',
      'E-mail ou mot de passe incorrect.',
      'E-mail ou senha incorretos.',
    ],
    'error.unauthorized': [
      'Tu sesión venció. Inicia sesión nuevamente.',
      'Your session expired. Please sign in again.',
      'Votre session a expiré. Reconnectez-vous.',
      'Sua sessão expirou. Entre novamente.',
    ],
    'error.validation': [
      'Revisa los datos ingresados.',
      'Check the information entered.',
      'Vérifiez les informations saisies.',
      'Verifique os dados informados.',
    ],
    'error.offline': [
      'No se pudo conectar. Revisa tu conexión.',
      'Could not connect. Check your connection.',
      'Connexion impossible. Vérifiez votre réseau.',
      'Não foi possível conectar. Verifique sua conexão.',
    ],
    'error.timeout': [
      'El servidor tardó demasiado. Intenta nuevamente.',
      'The server took too long. Try again.',
      'Le serveur met trop de temps. Réessayez.',
      'O servidor demorou demais. Tente novamente.',
    ],
    'error.server': [
      'El servicio no está disponible. Intenta más tarde.',
      'The service is unavailable. Try later.',
      'Le service est indisponible. Réessayez plus tard.',
      'O serviço está indisponível. Tente mais tarde.',
    ],
    'error.unexpected': [
      'Recibimos una respuesta inesperada. Intenta nuevamente.',
      'We received an unexpected response. Try again.',
      'Réponse inattendue. Réessayez.',
      'Recebemos uma resposta inesperada. Tente novamente.',
    ],
    'error.storage': [
      'No se pudieron guardar o recuperar los datos locales.',
      'Could not save or retrieve local data.',
      'Impossible de lire ou enregistrer les données locales.',
      'Não foi possível salvar ou recuperar os dados locais.',
    ],
  };
  @override
  /// Convierte el catálogo en los diccionarios por idioma que utiliza GetX.
  Map<String, Map<String, String>> get keys => {
    for (var i = 0; i < languages.length; i++)
      languages[i]: {
        for (final entry in _values.entries) entry.key: entry.value[i],
      },
  };
}
