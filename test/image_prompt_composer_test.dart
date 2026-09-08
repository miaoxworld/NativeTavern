import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/image_prompt_composer.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/domain/services/slash_command_service.dart';

void main() {
  const composer = ImagePromptComposer();

  test('fallback prompt keeps the character and cleaned scene', () {
    expect(
      composer.fallbackPrompt(
        sceneText: '<p>She  opens the lantern.</p>',
        characterName: 'Mira',
      ),
      'Mira, She opens the lantern.',
    );
  });

  test('compose messages ask the model for a single prompt', () {
    final messages = composer.composeMessages(
      sceneText: 'A rainy harbor at dusk',
      characterName: 'Mira',
    );

    expect(messages, hasLength(2));
    expect(messages.first['role'], 'system');
    expect(messages.first['content'], contains('Output only the prompt'));
    expect(messages.last['content'], contains('Subject: Mira'));
    expect(messages.last['content'], contains('A rainy harbor at dusk'));
  });

  test('normalizeModelOutput strips fences and quotes', () {
    expect(
      composer
          .normalizeModelOutput('```text\n"cinematic portrait of Mira"\n```'),
      'cinematic portrait of Mira',
    );
  });

  test('/imagine still parses prompt options for the existing chat handler',
      () {
    final parsed = SlashCommandService().parse(
      '/imagine rainy harbor --width 768 --height 1024',
    );
    expect(parsed.command, SlashCommands.imagine);
    expect(parsed.argument, 'rainy harbor --width 768 --height 1024');

    final request = ImageGenerationService().parseImagineCommand(
      '/imagine rainy harbor --width 768 --height 1024',
    );
    expect(request, isNotNull);
    expect(request!.prompt, 'rainy harbor');
    expect(request.width, 768);
    expect(request.height, 1024);
  });

  test('compose messages includes character, chat, and lorebook tags', () {
    final messages = composer.composeMessages(
      sceneText: 'Walking down the ancient corridor',
      characterName: 'Mira',
      characterTags: ['mage', 'silver hair'],
      chatTags: ['dungeon', 'candlelight'],
      lorebookTags: ['forgotten kingdom'],
      positiveExtension: 'masterpiece, 8k resolution',
    );

    expect(messages, hasLength(2));
    final content = messages.last['content'] as String;
    expect(content, contains('Character Tags: mage, silver hair'));
    expect(content, contains('Chat / Scene Tags: dungeon, candlelight'));
    expect(content, contains('World / Lore Tags: forgotten kingdom'));
    expect(content, contains('Style / Positive Modifiers: masterpiece, 8k resolution'));
  });

  test('combinePrompt combines base and extension cleanly', () {
    expect(
      ImagePromptComposer.combinePrompt('portrait of Mira', 'cinematic lighting, 8k'),
      'portrait of Mira, cinematic lighting, 8k',
    );
    expect(
      ImagePromptComposer.combinePrompt('portrait of Mira', ''),
      'portrait of Mira',
    );
  });

  test('/image alias parses correctly like /imagine', () {
    final parsed = SlashCommandService().parse('/image castle on a hill --ar 16:9');
    expect(parsed.command, SlashCommands.imagine);
    expect(parsed.argument, 'castle on a hill --ar 16:9');

    final request = ImageGenerationService().parseImagineCommand(
      '/image castle on a hill --ar 16:9',
      positiveExtension: 'sharp focus',
    );
    expect(request, isNotNull);
    expect(request!.prompt, 'castle on a hill, sharp focus');
    expect(request.width, 1024);
    expect(request.height, 576);
  });
}
