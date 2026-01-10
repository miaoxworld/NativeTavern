// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Início';

  @override
  String get characters => 'Personagens';

  @override
  String get settings => 'Configurações';

  @override
  String get chats => 'Conversas';

  @override
  String get newChat => 'Nova conversa';

  @override
  String get noChatsYet => 'Ainda não há conversas';

  @override
  String get startNewConversation => 'Inicie uma conversa com um personagem';

  @override
  String get browseCharacters => 'Explorar personagens';

  @override
  String get groupChats => 'Conversas em grupo';

  @override
  String get import => 'Importar';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get edit => 'Editar';

  @override
  String get copy => 'Copiar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get close => 'Fechar';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String errorLoadingChats(String error) {
    return 'Erro ao carregar conversas: $error';
  }

  @override
  String get deleteChat => 'Excluir conversa';

  @override
  String get deleteChatConfirmation =>
      'Tem certeza de que deseja excluir esta conversa? Esta ação não pode ser desfeita.';

  @override
  String get chatDeleted => 'Conversa excluída';

  @override
  String get yesterday => 'Ontem';

  @override
  String daysAgo(int count) {
    return 'Há $count dias';
  }

  @override
  String get noMessages => 'Sem mensagens';

  @override
  String get noMessagesYet => 'Ainda não há mensagens';

  @override
  String get chat => 'Conversa';

  @override
  String get typeMessage => 'Digite uma mensagem...';

  @override
  String get send => 'Enviar';

  @override
  String get regenerate => 'Regenerar';

  @override
  String get continueGeneration => 'Continuar';

  @override
  String get viewCharacter => 'Ver personagem';

  @override
  String get authorsNote => 'Nota do autor';

  @override
  String get bookmarks => 'Favoritos';

  @override
  String get exportChat => 'Exportar conversa';

  @override
  String get importChat => 'Importar conversa';

  @override
  String get clearMessages => 'Limpar mensagens';

  @override
  String get selectModel => 'Selecionar modelo';

  @override
  String get loadingModels => 'Carregando modelos...';

  @override
  String get noModelsAvailable =>
      'Nenhum modelo disponível. Verifique a configuração da API.';

  @override
  String modelChangedTo(String model) {
    return 'Modelo alterado para $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Falha ao carregar modelos: $error';
  }

  @override
  String get searchModels => 'Pesquisar modelos...';

  @override
  String get noModelsMatchSearch => 'Nenhum modelo corresponde à pesquisa';

  @override
  String get provider => 'Provedor';

  @override
  String get apiNotConfigured => 'API não configurada';

  @override
  String get apiNotConfiguredMessage =>
      'Para conversar com personagens, você precisa configurar um provedor LLM primeiro.';

  @override
  String get supportedProviders => 'Provedores suportados:';

  @override
  String get configureNow => 'Configurar agora';

  @override
  String get later => 'Mais tarde';

  @override
  String get configure => 'Configurar';

  @override
  String get configureApiProvider =>
      'Configure um provedor LLM para começar a conversar';

  @override
  String get startConversation => 'Iniciar conversa';

  @override
  String get deleteMessage => 'Excluir mensagem';

  @override
  String get deleteMessageConfirmation =>
      'Tem certeza de que deseja excluir esta mensagem?';

  @override
  String get deleteMessages => 'Excluir mensagens';

  @override
  String get deleteMessagesConfirmation =>
      'Tem certeza de que deseja excluir esta mensagem e todas as seguintes?';

  @override
  String get deleteAll => 'Excluir tudo';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get generateNewResponse => 'Gerar nova resposta';

  @override
  String get continueFromHere => 'Continuar daqui';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Excluir mensagens seguintes e regenerar resposta';

  @override
  String get deleteMessagesAfterThis => 'Excluir todas as mensagens após esta';

  @override
  String get createBookmark => 'Criar favorito';

  @override
  String get saveAsCheckpoint => 'Salvar este ponto como checkpoint';

  @override
  String get deleteThisMessage => 'Excluir esta mensagem';

  @override
  String get deleteThisAndAllAfter => 'Excluir esta e todas as seguintes';

  @override
  String get attachImage => 'Anexar imagem';

  @override
  String get chooseFromGallery => 'Escolher da galeria';

  @override
  String get takePhoto => 'Tirar foto';

  @override
  String failedToPickImage(String error) {
    return 'Falha ao selecionar imagem: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Falha ao tirar foto: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Falha ao adicionar anexo: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Exportar conversa com $character';
  }

  @override
  String messagesCount(int count) {
    return '$count mensagens';
  }

  @override
  String get chooseExportFormat => 'Escolha o formato de exportação:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (formato ST)';

  @override
  String get noChatToExport => 'Nenhuma conversa para exportar';

  @override
  String exportFailed(String error) {
    return 'Falha na exportação: $error';
  }

  @override
  String get importChatHistory =>
      'Importar histórico de conversa de um arquivo.';

  @override
  String get supportedFormats => 'Formatos suportados:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (formato SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (formato NativeTavern)';

  @override
  String get importNote =>
      'Nota: As mensagens importadas serão adicionadas à conversa atual.';

  @override
  String get chooseFile => 'Escolher arquivo';

  @override
  String get noFileSelected => 'Nenhum arquivo selecionado ou formato inválido';

  @override
  String get importConfirmation => 'Confirmação de importação';

  @override
  String get character => 'Personagem';

  @override
  String get user => 'Usuário';

  @override
  String get messages => 'Mensagens';

  @override
  String get date => 'Data';

  @override
  String get hasAuthorsNote => 'Tem nota do autor';

  @override
  String get importMessagesToCurrentChat =>
      'Importar estas mensagens para a conversa atual?';

  @override
  String get noActiveChat => 'Nenhuma conversa ativa';

  @override
  String importedMessages(int count) {
    return '$count mensagens importadas';
  }

  @override
  String importFailed(String error) {
    return 'Falha na importação: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Tem certeza de que deseja limpar todas as mensagens? Esta ação não pode ser desfeita.';

  @override
  String get clear => 'Limpar';

  @override
  String get thinking => 'Pensando';

  @override
  String get noSwipesAvailable => 'Nenhum deslize disponível';

  @override
  String get system => 'Sistema';

  @override
  String get backgroundFeatureComingSoon => 'Recurso de fundo em breve';

  @override
  String get authorsNoteUpdated => 'Nota do autor atualizada';

  @override
  String get commandError => 'Erro de comando';

  @override
  String get enabled => 'Ativado';

  @override
  String get disabled => 'Desativado';

  @override
  String get personas => 'Personas';

  @override
  String get createPersona => 'Criar persona';

  @override
  String get editPersona => 'Editar persona';

  @override
  String get deletePersona => 'Excluir persona';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"?';
  }

  @override
  String get noPersonasYet => 'Ainda não há personas';

  @override
  String get createPersonaDescription =>
      'Crie uma persona para representar você nas conversas';

  @override
  String get name => 'Nome';

  @override
  String get enterPersonaName => 'Digite o nome da persona';

  @override
  String get description => 'Descrição';

  @override
  String get describePersona => 'Descreva esta persona (opcional)';

  @override
  String get personaDescriptionHelp =>
      'A descrição será incluída no prompt do sistema para ajudar a IA a entender quem você é.';

  @override
  String get pleaseEnterName => 'Por favor, digite um nome';

  @override
  String get default_ => 'Padrão';

  @override
  String get active => 'Ativo';

  @override
  String get setAsDefault => 'Definir como padrão';

  @override
  String get removeAvatar => 'Remover avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Falha ao salvar avatar: $error';
  }

  @override
  String get selectAvatarImage => 'Selecionar imagem de avatar';

  @override
  String get aiConfiguration => 'Configuração de IA';

  @override
  String get llmProvider => 'Provedor LLM';

  @override
  String get apiUrl => 'URL da API';

  @override
  String get apiKey => 'Chave da API';

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
  String get frequencyPenalty => 'Penalidade de frequência';

  @override
  String get presencePenalty => 'Penalidade de presença';

  @override
  String get repetitionPenalty => 'Penalidade de repetição';

  @override
  String get streamingEnabled => 'Streaming ativado';

  @override
  String get testConnection => 'Testar conexão';

  @override
  String get connectionSuccessful => 'Conexão bem-sucedida!';

  @override
  String connectionFailed(String error) {
    return 'Falha na conexão: $error';
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
  String get aiPresets => 'Predefinições de IA';

  @override
  String get createPreset => 'Criar predefinição';

  @override
  String get editPreset => 'Editar predefinição';

  @override
  String get deletePreset => 'Excluir predefinição';

  @override
  String get presetName => 'Nome da predefinição';

  @override
  String get promptManager => 'Gerenciador de prompts';

  @override
  String get systemPrompt => 'Prompt do sistema';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Info do mundo';

  @override
  String get createEntry => 'Criar entrada';

  @override
  String get editEntry => 'Editar entrada';

  @override
  String get deleteEntry => 'Excluir entrada';

  @override
  String get keywords => 'Palavras-chave';

  @override
  String get content => 'Conteúdo';

  @override
  String get priority => 'Prioridade';

  @override
  String get groups => 'Grupos';

  @override
  String get createGroup => 'Criar grupo';

  @override
  String get editGroup => 'Editar grupo';

  @override
  String get deleteGroup => 'Excluir grupo';

  @override
  String get groupName => 'Nome do grupo';

  @override
  String get members => 'Membros';

  @override
  String get addMember => 'Adicionar membro';

  @override
  String get removeMember => 'Remover membro';

  @override
  String get tags => 'Tags';

  @override
  String get createTag => 'Criar tag';

  @override
  String get editTag => 'Editar tag';

  @override
  String get deleteTag => 'Excluir tag';

  @override
  String get tagName => 'Nome da tag';

  @override
  String get color => 'Cor';

  @override
  String get quickReplies => 'Respostas rápidas';

  @override
  String get createQuickReply => 'Criar resposta rápida';

  @override
  String get editQuickReply => 'Editar resposta rápida';

  @override
  String get deleteQuickReply => 'Excluir resposta rápida';

  @override
  String get label => 'Rótulo';

  @override
  String get message => 'Mensagem';

  @override
  String get autoSend => 'Envio automático';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Criar regex';

  @override
  String get editRegex => 'Editar regex';

  @override
  String get deleteRegex => 'Excluir regex';

  @override
  String get pattern => 'Padrão';

  @override
  String get replacement => 'Substituição';

  @override
  String get backup => 'Backup';

  @override
  String get createBackup => 'Criar backup';

  @override
  String get restoreBackup => 'Restaurar backup';

  @override
  String get backupCreated => 'Backup criado com sucesso';

  @override
  String get backupRestored => 'Backup restaurado com sucesso';

  @override
  String backupFailed(String error) {
    return 'Falha no backup: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Falha na restauração: $error';
  }

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get systemTheme => 'Seguir sistema';

  @override
  String get primaryColor => 'Cor primária';

  @override
  String get accentColor => 'Cor de destaque';

  @override
  String get advanced => 'Avançado';

  @override
  String get advancedSettings => 'Configurações avançadas';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get totalChats => 'Total de conversas';

  @override
  String get totalMessages => 'Total de mensagens';

  @override
  String get totalCharacters => 'Total de personagens';

  @override
  String get tokenizer => 'Tokenizador';

  @override
  String get tts => 'Texto para fala';

  @override
  String get stt => 'Fala para texto';

  @override
  String get translation => 'Tradução';

  @override
  String get imageGeneration => 'Geração de imagens';

  @override
  String get vectorStorage => 'Armazenamento vetorial';

  @override
  String get sprites => 'Sprites';

  @override
  String get backgrounds => 'Fundos';

  @override
  String get cfgScale => 'Escala CFG';

  @override
  String get logitBias => 'Viés Logit';

  @override
  String get variables => 'Variáveis';

  @override
  String get listView => 'Visualização em lista';

  @override
  String get gridView => 'Visualização em grade';

  @override
  String get search => 'Pesquisar';

  @override
  String get searchCharacters => 'Pesquisar personagens...';

  @override
  String get noCharactersFound => 'Nenhum personagem encontrado';

  @override
  String get noCharactersYet => 'Ainda não há personagens';

  @override
  String get importCharacter => 'Importe um personagem para começar';

  @override
  String get createCharacter => 'Criar personagem';

  @override
  String get editCharacter => 'Editar personagem';

  @override
  String get deleteCharacter => 'Excluir personagem';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Todas as conversas com este personagem também serão excluídas.';
  }

  @override
  String get characterDeleted => 'Personagem excluído';

  @override
  String get startChat => 'Iniciar conversa';

  @override
  String get personality => 'Personalidade';

  @override
  String get scenario => 'Cenário';

  @override
  String get firstMessage => 'Primeira mensagem';

  @override
  String get exampleDialogue => 'Diálogo de exemplo';

  @override
  String get creatorNotes => 'Notas do criador';

  @override
  String get alternateGreetings => 'Saudações alternativas';

  @override
  String get characterBook => 'Livro do personagem';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get languageChanged => 'Idioma alterado';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get licenses => 'Licenças';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get termsOfService => 'Termos de serviço';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateApp => 'Avaliar app';

  @override
  String get shareApp => 'Compartilhar app';

  @override
  String get checkForUpdates => 'Verificar atualizações';

  @override
  String get noUpdatesAvailable => 'Nenhuma atualização disponível';

  @override
  String get updateAvailable => 'Atualização disponível';

  @override
  String get downloadUpdate => 'Baixar atualização';

  @override
  String get bookmarkCreated => 'Favorito criado';

  @override
  String get bookmarkName => 'Nome do favorito';

  @override
  String get enterBookmarkName => 'Digite o nome do favorito';

  @override
  String get noBookmarksYet => 'Ainda não há favoritos';

  @override
  String get createBookmarkDescription =>
      'Crie favoritos para salvar pontos importantes na sua conversa';

  @override
  String get jumpToBookmark => 'Ir para favorito';

  @override
  String get deleteBookmark => 'Excluir favorito';

  @override
  String get bookmarkDeleted => 'Favorito excluído';

  @override
  String get saveAsJsonl => 'Salvar como JSONL';

  @override
  String get saveAsJson => 'Salvar como JSON';

  @override
  String get keyboardShortcuts => 'Atalhos de teclado:';

  @override
  String get bold => 'Negrito';

  @override
  String get italic => 'Itálico';

  @override
  String get underline => 'Sublinhado';

  @override
  String get strikethrough => 'Tachado';

  @override
  String get inlineCode => 'Código inline';

  @override
  String get link => 'Link';

  @override
  String get slashCommands => 'Comandos de barra';

  @override
  String get availableCommands => 'Comandos disponíveis:';

  @override
  String get commandHelp => 'Digite / para ver os comandos disponíveis';
}
