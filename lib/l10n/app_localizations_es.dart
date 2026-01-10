// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Inicio';

  @override
  String get characters => 'Personajes';

  @override
  String get settings => 'Configuración';

  @override
  String get chats => 'Chats';

  @override
  String get newChat => 'Nuevo chat';

  @override
  String get noChatsYet => 'Aún no hay chats';

  @override
  String get startNewConversation => 'Inicia una conversación con un personaje';

  @override
  String get browseCharacters => 'Explorar personajes';

  @override
  String get groupChats => 'Chats grupales';

  @override
  String get import => 'Importar';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get copy => 'Copiar';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get ok => 'Aceptar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String errorLoadingChats(String error) {
    return 'Error al cargar chats: $error';
  }

  @override
  String get deleteChat => 'Eliminar chat';

  @override
  String get deleteChatConfirmation =>
      '¿Estás seguro de que quieres eliminar este chat? Esta acción no se puede deshacer.';

  @override
  String get chatDeleted => 'Chat eliminado';

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(int count) {
    return 'Hace $count días';
  }

  @override
  String get noMessages => 'Sin mensajes';

  @override
  String get noMessagesYet => 'Aún no hay mensajes';

  @override
  String get chat => 'Chat';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get send => 'Enviar';

  @override
  String get regenerate => 'Regenerar';

  @override
  String get continueGeneration => 'Continuar';

  @override
  String get viewCharacter => 'Ver personaje';

  @override
  String get authorsNote => 'Nota del autor';

  @override
  String get bookmarks => 'Marcadores';

  @override
  String get exportChat => 'Exportar chat';

  @override
  String get importChat => 'Importar chat';

  @override
  String get clearMessages => 'Limpiar mensajes';

  @override
  String get selectModel => 'Seleccionar modelo';

  @override
  String get loadingModels => 'Cargando modelos...';

  @override
  String get noModelsAvailable =>
      'No hay modelos disponibles. Verifica la configuración de API.';

  @override
  String modelChangedTo(String model) {
    return 'Modelo cambiado a $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Error al cargar modelos: $error';
  }

  @override
  String get searchModels => 'Buscar modelos...';

  @override
  String get noModelsMatchSearch => 'No hay modelos que coincidan';

  @override
  String get provider => 'Proveedor';

  @override
  String get apiNotConfigured => 'API no configurada';

  @override
  String get apiNotConfiguredMessage =>
      'Para chatear con personajes, primero debes configurar un proveedor LLM.';

  @override
  String get supportedProviders => 'Proveedores soportados:';

  @override
  String get configureNow => 'Configurar ahora';

  @override
  String get later => 'Más tarde';

  @override
  String get configure => 'Configurar';

  @override
  String get configureApiProvider =>
      'Configura un proveedor LLM para comenzar a chatear';

  @override
  String get startConversation => 'Iniciar conversación';

  @override
  String get deleteMessage => 'Eliminar mensaje';

  @override
  String get deleteMessageConfirmation =>
      '¿Estás seguro de que quieres eliminar este mensaje?';

  @override
  String get deleteMessages => 'Eliminar mensajes';

  @override
  String get deleteMessagesConfirmation =>
      '¿Estás seguro de que quieres eliminar este mensaje y todos los siguientes?';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get generateNewResponse => 'Generar nueva respuesta';

  @override
  String get continueFromHere => 'Continuar desde aquí';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Eliminar mensajes siguientes y regenerar respuesta';

  @override
  String get deleteMessagesAfterThis =>
      'Eliminar todos los mensajes después de este';

  @override
  String get createBookmark => 'Crear marcador';

  @override
  String get saveAsCheckpoint => 'Guardar este punto como checkpoint';

  @override
  String get deleteThisMessage => 'Eliminar este mensaje';

  @override
  String get deleteThisAndAllAfter => 'Eliminar este y todos los siguientes';

  @override
  String get attachImage => 'Adjuntar imagen';

  @override
  String get chooseFromGallery => 'Elegir de la galería';

  @override
  String get takePhoto => 'Tomar foto';

  @override
  String failedToPickImage(String error) {
    return 'Error al seleccionar imagen: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Error al tomar foto: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Error al agregar adjunto: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Exportar chat con $character';
  }

  @override
  String messagesCount(int count) {
    return '$count mensajes';
  }

  @override
  String get chooseExportFormat => 'Elige el formato de exportación:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (formato ST)';

  @override
  String get noChatToExport => 'No hay chat para exportar';

  @override
  String exportFailed(String error) {
    return 'Error en la exportación: $error';
  }

  @override
  String get importChatHistory =>
      'Importar historial de chat desde un archivo.';

  @override
  String get supportedFormats => 'Formatos soportados:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (formato SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (formato NativeTavern)';

  @override
  String get importNote =>
      'Nota: Los mensajes importados se agregarán al chat actual.';

  @override
  String get chooseFile => 'Elegir archivo';

  @override
  String get noFileSelected => 'No se seleccionó archivo o formato inválido';

  @override
  String get importConfirmation => 'Confirmación de importación';

  @override
  String get character => 'Personaje';

  @override
  String get user => 'Usuario';

  @override
  String get messages => 'Mensajes';

  @override
  String get date => 'Fecha';

  @override
  String get hasAuthorsNote => 'Tiene nota del autor';

  @override
  String get importMessagesToCurrentChat =>
      '¿Importar estos mensajes al chat actual?';

  @override
  String get noActiveChat => 'No hay chat activo';

  @override
  String importedMessages(int count) {
    return 'Se importaron $count mensajes';
  }

  @override
  String importFailed(String error) {
    return 'Error en la importación: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      '¿Estás seguro de que quieres limpiar todos los mensajes? Esta acción no se puede deshacer.';

  @override
  String get clear => 'Limpiar';

  @override
  String get thinking => 'Pensando';

  @override
  String get noSwipesAvailable => 'No hay deslizamientos disponibles';

  @override
  String get system => 'Sistema';

  @override
  String get backgroundFeatureComingSoon => 'Función de fondo próximamente';

  @override
  String get authorsNoteUpdated => 'Nota del autor actualizada';

  @override
  String get commandError => 'Error de comando';

  @override
  String get enabled => 'Habilitado';

  @override
  String get disabled => 'Deshabilitado';

  @override
  String get personas => 'Personas';

  @override
  String get createPersona => 'Crear persona';

  @override
  String get editPersona => 'Editar persona';

  @override
  String get deletePersona => 'Eliminar persona';

  @override
  String deletePersonaConfirmation(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"?';
  }

  @override
  String get noPersonasYet => 'Aún no hay personas';

  @override
  String get createPersonaDescription =>
      'Crea una persona para representarte en los chats';

  @override
  String get name => 'Nombre';

  @override
  String get enterPersonaName => 'Ingresa el nombre de la persona';

  @override
  String get description => 'Descripción';

  @override
  String get describePersona => 'Describe esta persona (opcional)';

  @override
  String get personaDescriptionHelp =>
      'La descripción se incluirá en el prompt del sistema para ayudar a la IA a entender quién eres.';

  @override
  String get pleaseEnterName => 'Por favor ingresa un nombre';

  @override
  String get default_ => 'Predeterminado';

  @override
  String get active => 'Activo';

  @override
  String get setAsDefault => 'Establecer como predeterminado';

  @override
  String get removeAvatar => 'Eliminar avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Error al guardar avatar: $error';
  }

  @override
  String get selectAvatarImage => 'Seleccionar imagen de avatar';

  @override
  String get aiConfiguration => 'Configuración de IA';

  @override
  String get llmProvider => 'Proveedor LLM';

  @override
  String get apiUrl => 'URL de API';

  @override
  String get apiKey => 'Clave de API';

  @override
  String get model => 'Modelo';

  @override
  String get temperature => 'Temperatura';

  @override
  String get maxTokens => 'Tokens máximos';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Penalización de frecuencia';

  @override
  String get presencePenalty => 'Penalización de presencia';

  @override
  String get repetitionPenalty => 'Penalización de repetición';

  @override
  String get streamingEnabled => 'Streaming habilitado';

  @override
  String get testConnection => 'Probar conexión';

  @override
  String get connectionSuccessful => '¡Conexión exitosa!';

  @override
  String connectionFailed(String error) {
    return 'Conexión fallida: $error';
  }

  @override
  String get openai => 'OpenAI';

  @override
  String get claude => 'Claude';

  @override
  String get openRouter => 'OpenRouter';

  @override
  String get gemini => 'Gemini';

  @override
  String get ollama => 'Ollama';

  @override
  String get koboldCpp => 'KoboldCpp';

  @override
  String get local => 'Local';

  @override
  String get aiPresets => 'Presets de IA';

  @override
  String get createPreset => 'Crear preset';

  @override
  String get editPreset => 'Editar preset';

  @override
  String get deletePreset => 'Eliminar preset';

  @override
  String get presetName => 'Nombre del preset';

  @override
  String get promptManager => 'Gestor de prompts';

  @override
  String get systemPrompt => 'Prompt del sistema';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Info del mundo';

  @override
  String get createEntry => 'Crear entrada';

  @override
  String get editEntry => 'Editar entrada';

  @override
  String get deleteEntry => 'Eliminar entrada';

  @override
  String get keywords => 'Palabras clave';

  @override
  String get content => 'Contenido';

  @override
  String get priority => 'Prioridad';

  @override
  String get groups => 'Grupos';

  @override
  String get createGroup => 'Crear grupo';

  @override
  String get editGroup => 'Editar grupo';

  @override
  String get deleteGroup => 'Eliminar grupo';

  @override
  String get groupName => 'Nombre del grupo';

  @override
  String get members => 'Miembros';

  @override
  String get addMember => 'Agregar miembro';

  @override
  String get removeMember => 'Eliminar miembro';

  @override
  String get tags => 'Etiquetas';

  @override
  String get createTag => 'Crear etiqueta';

  @override
  String get editTag => 'Editar etiqueta';

  @override
  String get deleteTag => 'Eliminar etiqueta';

  @override
  String get tagName => 'Nombre de etiqueta';

  @override
  String get color => 'Color';

  @override
  String get quickReplies => 'Respuestas rápidas';

  @override
  String get createQuickReply => 'Crear respuesta rápida';

  @override
  String get editQuickReply => 'Editar respuesta rápida';

  @override
  String get deleteQuickReply => 'Eliminar respuesta rápida';

  @override
  String get label => 'Etiqueta';

  @override
  String get message => 'Mensaje';

  @override
  String get autoSend => 'Envío automático';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Crear regex';

  @override
  String get editRegex => 'Editar regex';

  @override
  String get deleteRegex => 'Eliminar regex';

  @override
  String get pattern => 'Patrón';

  @override
  String get replacement => 'Reemplazo';

  @override
  String get backup => 'Respaldo';

  @override
  String get createBackup => 'Crear respaldo';

  @override
  String get restoreBackup => 'Restaurar respaldo';

  @override
  String get backupCreated => 'Respaldo creado exitosamente';

  @override
  String get backupRestored => 'Respaldo restaurado exitosamente';

  @override
  String backupFailed(String error) {
    return 'Error en el respaldo: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Error en la restauración: $error';
  }

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get systemTheme => 'Seguir sistema';

  @override
  String get primaryColor => 'Color primario';

  @override
  String get accentColor => 'Color de acento';

  @override
  String get advanced => 'Avanzado';

  @override
  String get advancedSettings => 'Configuración avanzada';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get totalChats => 'Total de chats';

  @override
  String get totalMessages => 'Total de mensajes';

  @override
  String get totalCharacters => 'Total de personajes';

  @override
  String get tokenizer => 'Tokenizador';

  @override
  String get tts => 'Texto a voz';

  @override
  String get stt => 'Voz a texto';

  @override
  String get translation => 'Traducción';

  @override
  String get imageGeneration => 'Generación de imágenes';

  @override
  String get vectorStorage => 'Almacenamiento vectorial';

  @override
  String get sprites => 'Sprites';

  @override
  String get backgrounds => 'Fondos';

  @override
  String get cfgScale => 'Escala CFG';

  @override
  String get logitBias => 'Sesgo Logit';

  @override
  String get variables => 'Variables';

  @override
  String get listView => 'Vista de lista';

  @override
  String get gridView => 'Vista de cuadrícula';

  @override
  String get search => 'Buscar';

  @override
  String get searchCharacters => 'Buscar personajes...';

  @override
  String get noCharactersFound => 'No se encontraron personajes';

  @override
  String get noCharactersYet => 'Aún no hay personajes';

  @override
  String get importCharacter => 'Importa un personaje para comenzar';

  @override
  String get createCharacter => 'Crear personaje';

  @override
  String get editCharacter => 'Editar personaje';

  @override
  String get deleteCharacter => 'Eliminar personaje';

  @override
  String deleteCharacterConfirmation(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"? También se eliminarán todos los chats con este personaje.';
  }

  @override
  String get characterDeleted => 'Personaje eliminado';

  @override
  String get startChat => 'Iniciar chat';

  @override
  String get personality => 'Personalidad';

  @override
  String get scenario => 'Escenario';

  @override
  String get firstMessage => 'Primer mensaje';

  @override
  String get exampleDialogue => 'Diálogo de ejemplo';

  @override
  String get creatorNotes => 'Notas del creador';

  @override
  String get alternateGreetings => 'Saludos alternativos';

  @override
  String get characterBook => 'Libro del personaje';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get languageChanged => 'Idioma cambiado';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get licenses => 'Licencias';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get feedback => 'Comentarios';

  @override
  String get rateApp => 'Calificar app';

  @override
  String get shareApp => 'Compartir app';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get noUpdatesAvailable => 'No hay actualizaciones disponibles';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get downloadUpdate => 'Descargar actualización';

  @override
  String get bookmarkCreated => 'Marcador creado';

  @override
  String get bookmarkName => 'Nombre del marcador';

  @override
  String get enterBookmarkName => 'Ingresa el nombre del marcador';

  @override
  String get noBookmarksYet => 'Aún no hay marcadores';

  @override
  String get createBookmarkDescription =>
      'Crea marcadores para guardar puntos importantes en tu conversación';

  @override
  String get jumpToBookmark => 'Ir al marcador';

  @override
  String get deleteBookmark => 'Eliminar marcador';

  @override
  String get bookmarkDeleted => 'Marcador eliminado';

  @override
  String get saveAsJsonl => 'Guardar como JSONL';

  @override
  String get saveAsJson => 'Guardar como JSON';

  @override
  String get keyboardShortcuts => 'Atajos de teclado:';

  @override
  String get bold => 'Negrita';

  @override
  String get italic => 'Cursiva';

  @override
  String get underline => 'Subrayado';

  @override
  String get strikethrough => 'Tachado';

  @override
  String get inlineCode => 'Código en línea';

  @override
  String get link => 'Enlace';

  @override
  String get slashCommands => 'Comandos de barra';

  @override
  String get availableCommands => 'Comandos disponibles:';

  @override
  String get commandHelp => 'Escribe / para ver los comandos disponibles';
}
