# 内置世界书配置 / Built-in World Info / 内蔵ワールド情報

本目录包含NativeTavern的内置世界书(Lorebook)配置文件。

## 可用世界书 / Available World Info / 利用可能なワールド情報

### 1. 灵域修真录 (mortal_cultivation.json) 🇨🇳
**中文原创世界观**
**内容：** 原创修真世界《灵域修真录》的世界设定
- 修真境界体系（聚灵期到真灵）
- 宗门势力（青云宗、五宗联盟）
- 法宝灵丹系统
- 修炼功法和资源
- 主角林尘的设定

**适用场景：**
- 修真题材角色扮演
- 东方玄幻故事创作
- 修真世界观探索

**词条数量：** 7个核心设定

---

### 2. Guardian Universe (marvel_universe.json) 🇬🇧
**English Original Content**
**Content:** Guardian Universe original world setting
- The Guardians team
- Cosmic Fragments and Universal Gauntlet
- GDI organization
- Quantum Realm and Dimensional Planes
- Nova City and Crystallium
- Void Lord and major events
- Multiverse and quantum magic

**Use Cases:**
- Superhero-themed roleplay
- Original superhero story creation
- Enhanced individual universe exploration

**Entry Count:** 8 core settings

---

### 3. エルディア伝説 (zelda_legend.json) 🇯🇵
**日本語オリジナルコンテンツ**
**内容：** 『エルディア伝説』オリジナルファンタジー世界観設定
- 聖なる紋章（力・知恵・勇気）
- エルディア王国と種族
- エターナルブレードと聖なる武器
- 古代魔法とクリスタルオーブ
- ダークロードとの戦い
- 守護者アルトとセレナ王女

**適用シーン：**
- ファンタジーテーマのロールプレイ
- オリジナルアドベンチャー創作
- エルディア世界の探索

**エントリー数：** 8つのコア設定

---

## 原创内容声明 / Original Content Notice / オリジナルコンテンツ声明

**重要提示 / Important Notice / 重要なお知らせ：**

本目录中的所有世界书均为**完全原创内容**，不涉及任何版权问题。

All world info files in this directory are **entirely original creations** and do not involve any copyright issues.

このディレクトリのすべてのワールド情報は**完全オリジナルコンテンツ**であり、著作権の問題はありません。

虽然这些世界观受到经典作品的启发，但所有的设定、名称、背景故事都经过重新创作，形成了独特的原创内容：

While these worldbuildings are inspired by classic works, all settings, names, and background stories have been reimagined to create unique original content:

これらの世界観は古典作品からインスピレーションを得ていますが、すべての設定、名前、背景ストーリーは再創造され、ユニークなオリジナルコンテンツとなっています：

- **灵域修真录** - 原创修真世界，非《凡人修仙传》/ Original cultivation world, not "A Record of Mortal's Journey to Immortality" / オリジナル修真世界、「凡人修仙伝」ではない
- **Guardian Universe** - 原创超级英雄宇宙，非漫威宇宙 / Original superhero universe, not Marvel Universe / オリジナルスーパーヒーロー宇宙、マーベルユニバースではない
- **エルディア伝説** - オリジナルファンタジー世界、ゼルダの伝説ではない / Original fantasy world, not The Legend of Zelda / オリジナルファンタジー世界、ゼルダの伝説ではない

---

## 使用方法 / Usage / 使用方法

### 自动读み込み / Auto-loading / 自動読み込み
应用首次启动时会自动加载这些内置世界书到数据库中。
These built-in world infos will be automatically loaded into the database when you first launch the app.
アプリを初めて起動すると、これらの内蔵ワールド情報が自動的にデータベースに読み込まれます。

### 特点 / Features / 特徴
- ✅ 开箱即用 / Ready to use / すぐに使える
- ✅ 智能去重 / Smart deduplication / スマート重複除去
- ✅ 可自由编辑 / Editable / 編集可能
- ✅ 仅加载一次 / Loaded once / 一度だけ読み込み
- ✅ 支持全局和角色绑定 / Global and character-specific / グローバルとキャラクター専用

---

## 世界书工作原理 / How World Info Works / ワールド情報の仕組み

### 关键词触发 / Keyword Triggering / キーワードトリガー
当对话中出现特定关键词时，相关条目会自动插入到提示词中：
When specific keywords appear in conversation, related entries are automatically inserted into prompts:
会話に特定のキーワードが現れると、関連エントリーが自動的にプロンプトに挿入されます：

- **主关键词 (keys)**: 触发条目的主要词汇
- **次要关键词 (secondaryKeys)**: 可选的二次确认词汇
- **选择性触发 (selective)**: 需要主次关键词同时出现

### 插入位置 / Insertion Position / 挿入位置
- `beforeCharDefs`: 角色定义之前
- `afterCharDefs`: 角色定义之后
- `atDepth`: 特定深度位置

### 优先级控制 / Priority Control / 優先順位制御
- `insertionOrder`: 插入顺序（数字越小越靠前）
- `constant`: 常驻条目（始终插入）
- `probability`: 触发概率（0-100）

---

## 自定义世界书 / Custom World Info / カスタムワールド情報

你可以参考这些JSON文件创建自己的世界书：
You can create your own world info based on these JSON files:
これらのJSONファイルを参考に独自のワールド情報を作成できます：

```json
{
  "id": "unique_world_info_id",
  "name": "世界书名称 / World Info Name / ワールド情報名",
  "description": "世界书描述 / Description / 説明",
  "enabled": true,
  "isGlobal": false,
  "characterId": null,
  "entries": [
    {
      "id": "entry_001",
      "worldInfoId": "unique_world_info_id",
      "keys": ["关键词1", "关键词2"],
      "secondaryKeys": [],
      "content": "当关键词出现时插入的内容",
      "comment": "条目说明",
      "enabled": true,
      "constant": false,
      "selective": false,
      "insertionOrder": 100,
      "position": 1,
      "depth": 4
    }
  ],
  "createdAt": "2026-01-10T00:00:00.000Z",
  "modifiedAt": "2026-01-10T00:00:00.000Z"
}
```

---

## 最佳实践 / Best Practices / ベストプラクティス

1. **关键词选择 / Keyword Selection / キーワード選択**
   - 使用核心词汇作为主关键词
   - 避免过于常见的词（如"的"、"是"）
   - 考虑同义词和变体

2. **内容编写 / Content Writing / コンテンツ作成**
   - 简洁明了，包含关键信息
   - 使用第三人称描述
   - 避免冗长的叙述

3. **插入控制 / Insertion Control / 挿入制御**
   - 常用信息使用较低的insertionOrder
   - 重要设定可设为constant
   - 根据需要调整position

4. **性能优化 / Performance / パフォーマンス**
   - 避免创建过多条目（建议<100）
   - 使用selective减少不必要的插入
   - 定期清理未使用的条目

---

## 多语言设计 / Multilingual Design / 多言語設計

每个世界书使用特定语言以提供最佳体验：
Each world info uses a specific language for the best experience:
各ワールド情報は最高の体験を提供するため特定の言語を使用：

- 🇨🇳 **中文** - 灵域修真录（原创修真文化）
- 🇬🇧 **English** - Guardian Universe（原创超级英雄文化）
- 🇯🇵 **日本語** - エルディア伝説（オリジナルファンタジー文化）

这样设计确保：
This design ensures:
この設計により：

1. 使用原创语言保持真实性
2. 符合目标用户群体习惯
3. 专业术语准确无误

---

## 贡献 / Contributing / 貢献

欢迎贡献更多优质的世界书配置！
Welcome to contribute more quality world info configurations!
より質の高いワールド情報設定の貢献を歓迎します！

请确保：/ Please ensure: / 確認してください：
- JSON格式正确 / Correct JSON format / 正しいJSON形式
- 内容准确专业 / Accurate and professional content / 正確で専門的な内容
- 关键词合理 / Reasonable keywords / 適切なキーワード
- 包含完整字段 / Complete field information / 完全なフィールド情報
- **原创内容，不侵犯版权 / Original content, no copyright infringement / オリジナルコンテンツ、著作権侵害なし**