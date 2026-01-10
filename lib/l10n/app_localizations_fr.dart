// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Accueil';

  @override
  String get characters => 'Personnages';

  @override
  String get settings => 'Paramètres';

  @override
  String get chats => 'Discussions';

  @override
  String get newChat => 'Nouvelle discussion';

  @override
  String get noChatsYet => 'Pas encore de discussions';

  @override
  String get startNewConversation =>
      'Commencez une conversation avec un personnage';

  @override
  String get browseCharacters => 'Parcourir les personnages';

  @override
  String get groupChats => 'Discussions de groupe';

  @override
  String get import => 'Importer';

  @override
  String get delete => 'Supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get copy => 'Copier';

  @override
  String get retry => 'Réessayer';

  @override
  String get close => 'Fermer';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String errorLoadingChats(String error) {
    return 'Erreur lors du chargement des discussions : $error';
  }

  @override
  String get deleteChat => 'Supprimer la discussion';

  @override
  String get deleteChatConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cette discussion ? Cette action est irréversible.';

  @override
  String get chatDeleted => 'Discussion supprimée';

  @override
  String get yesterday => 'Hier';

  @override
  String daysAgo(int count) {
    return 'Il y a $count jours';
  }

  @override
  String get noMessages => 'Aucun message';

  @override
  String get noMessagesYet => 'Pas encore de messages';

  @override
  String get chat => 'Discussion';

  @override
  String get typeMessage => 'Tapez un message...';

  @override
  String get send => 'Envoyer';

  @override
  String get regenerate => 'Régénérer';

  @override
  String get continueGeneration => 'Continuer';

  @override
  String get viewCharacter => 'Voir le personnage';

  @override
  String get authorsNote => 'Note de l\'auteur';

  @override
  String get bookmarks => 'Signets';

  @override
  String get exportChat => 'Exporter la discussion';

  @override
  String get importChat => 'Importer une discussion';

  @override
  String get clearMessages => 'Effacer les messages';

  @override
  String get selectModel => 'Sélectionner le modèle';

  @override
  String get loadingModels => 'Chargement des modèles...';

  @override
  String get noModelsAvailable =>
      'Aucun modèle disponible. Vérifiez la configuration de l\'API.';

  @override
  String modelChangedTo(String model) {
    return 'Modèle changé en $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Échec du chargement des modèles : $error';
  }

  @override
  String get searchModels => 'Rechercher des modèles...';

  @override
  String get noModelsMatchSearch => 'Aucun modèle ne correspond';

  @override
  String get provider => 'Fournisseur';

  @override
  String get apiNotConfigured => 'API non configurée';

  @override
  String get apiNotConfiguredMessage =>
      'Pour discuter avec des personnages, vous devez d\'abord configurer un fournisseur LLM.';

  @override
  String get supportedProviders => 'Fournisseurs pris en charge :';

  @override
  String get configureNow => 'Configurer maintenant';

  @override
  String get later => 'Plus tard';

  @override
  String get configure => 'Configurer';

  @override
  String get configureApiProvider =>
      'Configurez un fournisseur LLM pour commencer à discuter';

  @override
  String get startConversation => 'Démarrer une conversation';

  @override
  String get deleteMessage => 'Supprimer le message';

  @override
  String get deleteMessageConfirmation =>
      'Êtes-vous sûr de vouloir supprimer ce message ?';

  @override
  String get deleteMessages => 'Supprimer les messages';

  @override
  String get deleteMessagesConfirmation =>
      'Êtes-vous sûr de vouloir supprimer ce message et tous les suivants ?';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get generateNewResponse => 'Générer une nouvelle réponse';

  @override
  String get continueFromHere => 'Continuer à partir d\'ici';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Supprimer les messages suivants et régénérer la réponse';

  @override
  String get deleteMessagesAfterThis =>
      'Supprimer tous les messages après celui-ci';

  @override
  String get createBookmark => 'Créer un signet';

  @override
  String get saveAsCheckpoint => 'Enregistrer ce point comme checkpoint';

  @override
  String get deleteThisMessage => 'Supprimer ce message';

  @override
  String get deleteThisAndAllAfter => 'Supprimer celui-ci et tous les suivants';

  @override
  String get attachImage => 'Joindre une image';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String failedToPickImage(String error) {
    return 'Échec de la sélection de l\'image : $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Échec de la prise de photo : $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Échec de l\'ajout de la pièce jointe : $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Exporter la discussion avec $character';
  }

  @override
  String messagesCount(int count) {
    return '$count messages';
  }

  @override
  String get chooseExportFormat => 'Choisissez le format d\'exportation :';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (format ST)';

  @override
  String get noChatToExport => 'Aucune discussion à exporter';

  @override
  String exportFailed(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get importChatHistory =>
      'Importer l\'historique de discussion depuis un fichier.';

  @override
  String get supportedFormats => 'Formats pris en charge :';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (format SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (format NativeTavern)';

  @override
  String get importNote =>
      'Note : Les messages importés seront ajoutés à la discussion actuelle.';

  @override
  String get chooseFile => 'Choisir un fichier';

  @override
  String get noFileSelected => 'Aucun fichier sélectionné ou format invalide';

  @override
  String get importConfirmation => 'Confirmation d\'importation';

  @override
  String get character => 'Personnage';

  @override
  String get user => 'Utilisateur';

  @override
  String get messages => 'Messages';

  @override
  String get date => 'Date';

  @override
  String get hasAuthorsNote => 'A une note de l\'auteur';

  @override
  String get importMessagesToCurrentChat =>
      'Importer ces messages dans la discussion actuelle ?';

  @override
  String get noActiveChat => 'Aucune discussion active';

  @override
  String importedMessages(int count) {
    return '$count messages importés';
  }

  @override
  String importFailed(String error) {
    return 'Échec de l\'importation : $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Êtes-vous sûr de vouloir effacer tous les messages ? Cette action est irréversible.';

  @override
  String get clear => 'Effacer';

  @override
  String get thinking => 'Réflexion';

  @override
  String get noSwipesAvailable => 'Aucun balayage disponible';

  @override
  String get system => 'Système';

  @override
  String get backgroundFeatureComingSoon =>
      'Fonctionnalité d\'arrière-plan bientôt disponible';

  @override
  String get authorsNoteUpdated => 'Note de l\'auteur mise à jour';

  @override
  String get commandError => 'Erreur de commande';

  @override
  String get enabled => 'Activé';

  @override
  String get disabled => 'Désactivé';

  @override
  String get personas => 'Personas';

  @override
  String get createPersona => 'Créer un persona';

  @override
  String get editPersona => 'Modifier le persona';

  @override
  String get deletePersona => 'Supprimer le persona';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ?';
  }

  @override
  String get noPersonasYet => 'Pas encore de personas';

  @override
  String get createPersonaDescription =>
      'Créez un persona pour vous représenter dans les discussions';

  @override
  String get name => 'Nom';

  @override
  String get enterPersonaName => 'Entrez le nom du persona';

  @override
  String get description => 'Description';

  @override
  String get describePersona => 'Décrivez ce persona (optionnel)';

  @override
  String get personaDescriptionHelp =>
      'La description sera incluse dans le prompt système pour aider l\'IA à comprendre qui vous êtes.';

  @override
  String get pleaseEnterName => 'Veuillez entrer un nom';

  @override
  String get default_ => 'Par défaut';

  @override
  String get active => 'Actif';

  @override
  String get setAsDefault => 'Définir par défaut';

  @override
  String get removeAvatar => 'Supprimer l\'avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Échec de l\'enregistrement de l\'avatar : $error';
  }

  @override
  String get selectAvatarImage => 'Sélectionner une image d\'avatar';

  @override
  String get aiConfiguration => 'Configuration IA';

  @override
  String get llmProvider => 'Fournisseur LLM';

  @override
  String get apiUrl => 'URL de l\'API';

  @override
  String get apiKey => 'Clé API';

  @override
  String get model => 'Modèle';

  @override
  String get temperature => 'Température';

  @override
  String get maxTokens => 'Tokens maximum';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Pénalité de fréquence';

  @override
  String get presencePenalty => 'Pénalité de présence';

  @override
  String get repetitionPenalty => 'Pénalité de répétition';

  @override
  String get streamingEnabled => 'Streaming activé';

  @override
  String get testConnection => 'Tester la connexion';

  @override
  String get connectionSuccessful => 'Connexion réussie !';

  @override
  String connectionFailed(String error) {
    return 'Échec de la connexion : $error';
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
  String get aiPresets => 'Préréglages IA';

  @override
  String get createPreset => 'Créer un préréglage';

  @override
  String get editPreset => 'Modifier le préréglage';

  @override
  String get deletePreset => 'Supprimer le préréglage';

  @override
  String get presetName => 'Nom du préréglage';

  @override
  String get promptManager => 'Gestionnaire de prompts';

  @override
  String get systemPrompt => 'Prompt système';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Info monde';

  @override
  String get createEntry => 'Créer une entrée';

  @override
  String get editEntry => 'Modifier l\'entrée';

  @override
  String get deleteEntry => 'Supprimer l\'entrée';

  @override
  String get keywords => 'Mots-clés';

  @override
  String get content => 'Contenu';

  @override
  String get priority => 'Priorité';

  @override
  String get groups => 'Groupes';

  @override
  String get createGroup => 'Créer un groupe';

  @override
  String get editGroup => 'Modifier le groupe';

  @override
  String get deleteGroup => 'Supprimer le groupe';

  @override
  String get groupName => 'Nom du groupe';

  @override
  String get members => 'Membres';

  @override
  String get addMember => 'Ajouter un membre';

  @override
  String get removeMember => 'Supprimer un membre';

  @override
  String get tags => 'Tags';

  @override
  String get createTag => 'Créer un tag';

  @override
  String get editTag => 'Modifier le tag';

  @override
  String get deleteTag => 'Supprimer le tag';

  @override
  String get tagName => 'Nom du tag';

  @override
  String get color => 'Couleur';

  @override
  String get quickReplies => 'Réponses rapides';

  @override
  String get createQuickReply => 'Créer une réponse rapide';

  @override
  String get editQuickReply => 'Modifier la réponse rapide';

  @override
  String get deleteQuickReply => 'Supprimer la réponse rapide';

  @override
  String get label => 'Libellé';

  @override
  String get message => 'Message';

  @override
  String get autoSend => 'Envoi automatique';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Créer une regex';

  @override
  String get editRegex => 'Modifier la regex';

  @override
  String get deleteRegex => 'Supprimer la regex';

  @override
  String get pattern => 'Motif';

  @override
  String get replacement => 'Remplacement';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get createBackup => 'Créer une sauvegarde';

  @override
  String get restoreBackup => 'Restaurer une sauvegarde';

  @override
  String get backupCreated => 'Sauvegarde créée avec succès';

  @override
  String get backupRestored => 'Sauvegarde restaurée avec succès';

  @override
  String backupFailed(String error) {
    return 'Échec de la sauvegarde : $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Échec de la restauration : $error';
  }

  @override
  String get theme => 'Thème';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get systemTheme => 'Suivre le système';

  @override
  String get primaryColor => 'Couleur principale';

  @override
  String get accentColor => 'Couleur d\'accent';

  @override
  String get advanced => 'Avancé';

  @override
  String get advancedSettings => 'Paramètres avancés';

  @override
  String get statistics => 'Statistiques';

  @override
  String get totalChats => 'Total des discussions';

  @override
  String get totalMessages => 'Total des messages';

  @override
  String get totalCharacters => 'Total des personnages';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Synthèse vocale';

  @override
  String get stt => 'Reconnaissance vocale';

  @override
  String get translation => 'Traduction';

  @override
  String get imageGeneration => 'Génération d\'images';

  @override
  String get vectorStorage => 'Stockage vectoriel';

  @override
  String get sprites => 'Sprites';

  @override
  String get backgrounds => 'Arrière-plans';

  @override
  String get cfgScale => 'Échelle CFG';

  @override
  String get logitBias => 'Biais Logit';

  @override
  String get variables => 'Variables';

  @override
  String get listView => 'Vue liste';

  @override
  String get gridView => 'Vue grille';

  @override
  String get search => 'Rechercher';

  @override
  String get searchCharacters => 'Rechercher des personnages...';

  @override
  String get noCharactersFound => 'Aucun personnage trouvé';

  @override
  String get noCharactersYet => 'Pas encore de personnages';

  @override
  String get importCharacter => 'Importez un personnage pour commencer';

  @override
  String get createCharacter => 'Créer un personnage';

  @override
  String get editCharacter => 'Modifier le personnage';

  @override
  String get deleteCharacter => 'Supprimer le personnage';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ? Toutes les discussions avec ce personnage seront également supprimées.';
  }

  @override
  String get characterDeleted => 'Personnage supprimé';

  @override
  String get startChat => 'Démarrer une discussion';

  @override
  String get personality => 'Personnalité';

  @override
  String get scenario => 'Scénario';

  @override
  String get firstMessage => 'Premier message';

  @override
  String get exampleDialogue => 'Dialogue exemple';

  @override
  String get creatorNotes => 'Notes du créateur';

  @override
  String get alternateGreetings => 'Salutations alternatives';

  @override
  String get characterBook => 'Livre du personnage';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get languageChanged => 'Langue modifiée';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get licenses => 'Licences';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get feedback => 'Commentaires';

  @override
  String get rateApp => 'Noter l\'application';

  @override
  String get shareApp => 'Partager l\'application';

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String get noUpdatesAvailable => 'Aucune mise à jour disponible';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get downloadUpdate => 'Télécharger la mise à jour';

  @override
  String get bookmarkCreated => 'Signet créé';

  @override
  String get bookmarkName => 'Nom du signet';

  @override
  String get enterBookmarkName => 'Entrez le nom du signet';

  @override
  String get noBookmarksYet => 'Pas encore de signets';

  @override
  String get createBookmarkDescription =>
      'Créez des signets pour sauvegarder les points importants de votre conversation';

  @override
  String get jumpToBookmark => 'Aller au signet';

  @override
  String get deleteBookmark => 'Supprimer le signet';

  @override
  String get bookmarkDeleted => 'Signet supprimé';

  @override
  String get saveAsJsonl => 'Enregistrer en JSONL';

  @override
  String get saveAsJson => 'Enregistrer en JSON';

  @override
  String get keyboardShortcuts => 'Raccourcis clavier :';

  @override
  String get bold => 'Gras';

  @override
  String get italic => 'Italique';

  @override
  String get underline => 'Souligné';

  @override
  String get strikethrough => 'Barré';

  @override
  String get inlineCode => 'Code en ligne';

  @override
  String get link => 'Lien';

  @override
  String get slashCommands => 'Commandes slash';

  @override
  String get availableCommands => 'Commandes disponibles :';

  @override
  String get commandHelp => 'Tapez / pour voir les commandes disponibles';
}
