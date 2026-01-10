# 内置角色配置 / Built-in Characters / 内蔵キャラクター

本目录包含NativeTavern的内置助手角色配置文件。

## 可用角色 / Available Characters / 利用可能なキャラクター

### 1. AI画像生成アシスタント (image_generation_assistant.json) 🇯🇵
**日本語で対応**
**機能：** プロフェッショナルなAI画像生成プロンプト作成アシスタント
- ユーザーのアイデアを詳細なStable Diffusion/Midjourneyプロンプトに変換
- 構造化されたプロンプト（ポジティブ/ネガティブ）を提供
- パラメータ設定とモデル選択を推奨
- 様々なアートスタイルに対応

**適用シーン：**
- AI画像生成プロンプトが必要な時
- プロンプトエンジニアリングの学習
- 異なるアートスタイルの探索

---

### 2. 小红书文案编辑 (xiaohongshu_copywriter.json) 🇨🇳
**中文服务**
**功能：** 专业的小红书内容创作助手
- 撰写吸引眼球的标题
- 生成符合平台风格的文案
- 提供话题标签建议
- 优化内容结构和排版

**适用场景：**
- 小红书内容创作
- 社交媒体营销
- 种草/分享类内容

---

### 3. Coding Assistant (coding_assistant.json) 🇬🇧
**English Support**
**Features:** Professional programming assistant
- Write and optimize code
- Debug and fix bugs
- Explain technical concepts
- Code review and refactoring suggestions
- Performance optimization

**Use Cases:**
- Daily programming tasks
- Learning new technologies
- Troubleshooting code issues
- Technical solution design

---

### 4. 灵脉求生模拟器 (cultivation_survival_game.json) 🇨🇳
**中文原创修真世界**
**功能：** 原创修真世界观的生存模拟游戏
- 资源管理和决策系统
- 修为境界提升机制
- 随机事件触发
- 多结局探索

**适用场景：**
- 修真题材角色扮演
- 策略生存游戏
- 资源管理模拟

---

### 5. エルディア冒険クエスト (hyrule_adventure_quest.json) 🇯🇵
**日本語オリジナルファンタジー**
**機能：** オリジナルファンタジー世界のテキストアドベンチャー
- 謎解き、戦闘、探索要素
- ターン制戦闘システム
- アイテム収集とステータス管理
- 複数の選択肢による物語分岐

**適用シーン：**
- ファンタジーアドベンチャーRPG
- インタラクティブストーリー体験
- 謎解きゲーム

---

### 6. Guardian Protocol Manager (marvel_crisis_manager.json) 🇬🇧
**English Original Superhero Universe**
**Features:** Strategic crisis management in an original superhero setting
- Manage enhanced individual teams
- Resource allocation and decision-making
- Multiple simultaneous threats
- Consequence-based gameplay

**Use Cases:**
- Superhero strategy simulation
- Crisis management scenarios
- Team coordination games

---

## 使用方法 / Usage / 使用方法

### 自动加载 / Auto-loading / 自動読み込み
应用首次启动时会自动加载这些内置角色到角色列表中。
These built-in characters will be automatically loaded into the character list when you first launch the app.
アプリを初めて起動すると、これらの内蔵キャラクターが自動的にキャラクターリストに読み込まれます。

### 特点 / Features / 特徴
- ✅ 开箱即用，无需手动导入 / Ready to use, no manual import needed / すぐに使える、手動インポート不要
- ✅ 智能去重，避免重复创建 / Smart deduplication, prevents duplicates / スマート重複除去、重複作成を防止
- ✅ 可自由编辑或删除 / Freely editable or deletable / 自由に編集・削除可能
- ✅ 仅在首次启动时加载一次 / Loaded only once on first launch / 初回起動時のみ一度だけ読み込み

---

## 自定义角色 / Custom Characters / カスタムキャラクター

你可以参考这些JSON文件的格式创建自己的角色配置：
You can create your own character configurations based on these JSON file formats:
これらのJSONファイルの形式を参考に、独自のキャラクター設定を作成できます：

```json
{
  "id": "unique_character_id",
  "name": "角色名称 / Character Name / キャラクター名",
  "description": "角色描述 / Description / 説明",
  "personality": "性格特点 / Personality / 性格",
  "scenario": "使用场景 / Scenario / シナリオ",
  "firstMessage": "第一条消息 / First Message / 最初のメッセージ",
  "alternateGreetings": ["备选问候语 / Alternate Greetings / 代替挨拶"],
  "exampleMessages": "对话示例 / Example Dialogues / 対話例",
  "systemPrompt": "系统提示词 / System Prompt / システムプロンプト",
  "postHistoryInstructions": "后续指令 / Post Instructions / 後続指示",
  "tags": ["标签 / Tags / タグ"],
  "creator": "创建者 / Creator / 作成者",
  "version": "1.0",
  "createdAt": "2026-01-10T00:00:00.000Z",
  "modifiedAt": "2026-01-10T00:00:00.000Z",
  "isFavorite": false,
  "extensions": {
    "builtin": true,
    "category": "assistant"
  }
}
```

---

## 多语言支持 / Multilingual Support / 多言語サポート

每个角色都使用特定语言设计，以提供最佳的用户体验：
Each character is designed in a specific language for the best user experience:
各キャラクターは最高のユーザー体験を提供するため、特定の言語で設計されています：

- 🇯🇵 **日本語** - AI画像生成アシスタント（画像生成に特化）、エルディア冒険クエスト（オリジナルファンタジー）
- 🇨🇳 **中文** - 小红书文案编辑（中国社交媒体に特化）、灵脉求生模拟器（原创修真世界）
- 🇬🇧 **English** - Coding Assistant（プログラミングに特化）、Guardian Protocol Manager（オリジナルスーパーヒーロー）

这样设计是为了：
This design ensures:
この設計により：

1. 提供最自然的对话体验 / Most natural conversation experience / 最も自然な会話体験を提供
2. 使用该语言社区的专业术语 / Use community-specific terminology / その言語コミュニティの専門用語を使用
3. 符合目标用户群体的使用习惯 / Match target user preferences / 対象ユーザーグループの使用習慣に適合

---

## 原创内容声明 / Original Content Notice / オリジナルコンテンツ声明

**重要提示 / Important Notice / 重要なお知らせ：**

本目录中的游戏角色（灵脉求生模拟器、エルディア冒険クエスト、Guardian Protocol Manager）均为**完全原创内容**，不涉及任何版权问题。

The game characters in this directory (灵脉求生模拟器, エルディア冒険クエスト, Guardian Protocol Manager) are **entirely original creations** and do not involve any copyright issues.

このディレクトリのゲームキャラクター（灵脉求生模拟器、エルディア冒険クエスト、Guardian Protocol Manager）は**完全オリジナルコンテンツ**であり、著作権の問題はありません。

虽然这些角色受到经典作品的启发（修仙小说、奇幻游戏、超级英雄漫画），但所有的世界观、角色名称、设定细节都经过重新创作，形成了独特的原创内容。

While these characters are inspired by classic works (cultivation novels, fantasy games, superhero comics), all worldbuilding, character names, and setting details have been reimagined to create unique original content.

これらのキャラクターは古典作品（修真小説、ファンタジーゲーム、スーパーヒーローコミック）からインスピレーションを得ていますが、すべての世界観、キャラクター名、設定の詳細は再創造され、ユニークなオリジナルコンテンツとなっています。

---

## 最佳实践 / Best Practices / ベストプラクティス

1. **systemPrompt**: 清晰定义角色的能力、限制和行为准则
   - Clearly define character capabilities, limitations, and behavior guidelines
   - キャラクターの能力、制限、行動ガイドラインを明確に定義

2. **exampleMessages**: 提供高质量的对话示例
   - Provide high-quality conversation examples
   - 高品質な会話例を提供

3. **firstMessage**: 简洁明了地介绍角色功能
   - Concisely introduce character features
   - 簡潔にキャラクターの機能を紹介

4. **tags**: 使用准确的标签便于搜索和分类
   - Use accurate tags for easy search and categorization
   - 正確なタグを使用して検索と分類を容易に

---

## 贡献 / Contributing / 貢献

欢迎贡献更多优质的角色配置！
Welcome to contribute more quality character configurations!
より質の高いキャラクター設定の貢献を歓迎します！

请确保：/ Please ensure: / 確認してください：
- JSON格式正确 / Correct JSON format / 正しいJSON形式
- 内容专业且有价值 / Professional and valuable content / 専門的で価値のある内容
- 遵循现有的结构和风格 / Follow existing structure and style / 既存の構造とスタイルに従う
- 包含完整的字段信息 / Include complete field information / 完全なフィールド情報を含む
- **原创内容，不侵犯版权 / Original content, no copyright infringement / オリジナルコンテンツ、著作権侵害なし**