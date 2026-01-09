# NativeTavern

<p align="center">
  <a href="README.md">English</a> | <a href="README.zh-CN.md">简体中文</a>
</p>

一款原生跨平台移动应用（iOS/Android），以高性能原生应用的形式重新实现 SillyTavern，完全兼容 SillyTavern 数据格式。

## 截图

<p align="center">
  <img src="photo/Chat.png" width="200" alt="聊天界面"/>
  <img src="photo/Character.png" width="200" alt="角色界面"/>
  <img src="photo/AiConfig.png" width="200" alt="AI 配置"/>
</p>

<p align="center">
  <img src="photo/AIPreset.png" width="200" alt="AI 预设"/>
  <img src="photo/PromptManager.png" width="200" alt="提示词管理器"/>
  <img src="photo/Wordbook.png" width="200" alt="世界书"/>
</p>

| 聊天 | 角色 | AI 配置 |
|:---:|:---:|:---:|
| 实时流式聊天，支持消息操作 | 角色卡片，包含头像和详情 | 多服务商 LLM 配置 |

| AI 预设 | 提示词管理器 | 世界书 |
|:---:|:---:|:---:|
| 导入 SillyTavern 预设 | 自定义提示词排序 | 基于关键词的上下文注入 |

## 功能特性

### 核心功能 ✅
- 📱 **原生移动应用** - 使用 Flutter 构建，支持 iOS 和 Android
- ⚡ **高性能** - 针对移动设备优化
- 🤖 **多服务商 LLM 支持** - OpenAI、Claude、OpenRouter、Gemini、Ollama、KoboldCpp
- 📦 **完全兼容 ST** - 导入/导出 PNG 卡片、CharX、JSON
- 💬 **流式响应** - 所有服务商均支持实时 SSE 流式传输

### 角色管理 ✅
- 📥 **导入格式** - PNG V2/V3、CharX（V3 规范）、JSON
- 📤 **导出格式** - PNG V3、带资源的 CharX、JSON
- ✏️ **角色编辑器** - 创建/编辑角色的所有字段
- 🖼️ **头像支持** - 自定义头像，支持图片选择器
- 📚 **内嵌世界书** - 完整支持 CharX 世界书

### 聊天功能 ✅
- 💬 **消息操作** - 编辑、删除、重新生成、滑动切换备选回复
- 👥 **群聊** - 多角色对话，支持 5 种响应模式
- 🔖 **书签** - 创建检查点和分支对话
- 📝 **作者注释** - 可配置深度的注入
- 🎭 **人设** - 用户档案管理，支持描述

### 世界书 / Lorebook ✅
- 🌍 **关键词匹配** - 基于触发词的上下文注入
- 📍 **多种位置** - 系统提示前/后、角色定义、示例对话
- 🔄 **递归支持** - 嵌套关键词扫描
- 📊 **分组评分** - 基于优先级的条目选择

### 提示词管理 ✅
- 📋 **提示词管理器** - 排序、启用/禁用提示词
- 📥 **SillyTavern 预设导入** - 完整支持 prompts + prompt_order
- 🎯 **自定义提示词** - 添加自定义部分，支持角色设置
- 📍 **深度注入** - 在特定消息深度插入提示词

### 高级设置 ✅
- 🎛️ **完整采样器控制** - Temperature、Top-P、Top-K、Min-P、Typical-P
- 🔁 **重复惩罚** - 可配置范围
- 🎲 **Mirostat** - Mode、Tau、Eta 设置
- ✂️ **无尾采样** - TFS 和 Top-A 支持
- 🛑 **停止序列** - 自定义停止标记

### 主题 ✅
- 🎨 **18 个内置主题** - 7 个深色 + 11 个浅色主题
- 🌙 **深色主题** - 默认深色、午夜、森林、日落、玫瑰、海洋、AMOLED
- ☀️ **浅色主题** - 纯净白、暖奶油、柔和薰衣草、薄荷清新、天空蓝、玫瑰粉、蜜桃、鼠尾草绿、纸张、复古棕
- 🖌️ **主题编辑器** - 完整颜色自定义

### 思维链支持 ✅
- 🧠 **OpenAI o1/o3** - 解析 `reasoning_content` 字段
- 💭 **Claude** - 解析 `thinking` 块
- 🤔 **Gemini 2.0 Flash Thinking** - 解析 `thought` 字段
- 💾 **推理存储** - 保存消息和滑动切换的推理过程

### 宏系统 ✅
- `{{user}}` - 当前人设名称
- `{{char}}` - 角色名称
- `{{time}}` / `{{date}}` / `{{weekday}}` - 日期/时间宏
- `{{random:min:max}}` - 随机数生成
- `{{roll:NdM}}` - 掷骰子
- `{{idle_duration}}` - 距上次消息的时间
- `{{lastMessage}}` / `{{lastUserMessage}}` / `{{lastCharMessage}}`

## 技术栈

| 组件 | 技术 |
|-----------|------------|
| UI 框架 | Flutter (Dart) |
| 状态管理 | Riverpod |
| 导航 | go_router |
| 数据库 | SQLite (drift) |
| 原生核心 | Rust (via FFI) |
| HTTP 客户端 | Dio |

## 项目结构

```
native_tavern/
├── lib/                    # Flutter/Dart 代码
│   ├── main.dart          # 入口点
│   ├── app.dart           # 应用配置
│   ├── core/              # 核心工具
│   ├── data/              # 数据层（模型、数据库、仓库）
│   │   ├── models/        # 数据模型（Character、Chat、Message 等）
│   │   ├── database/      # 使用 Drift 的 SQLite 数据库
│   │   └── repositories/  # 数据访问层
│   ├── domain/            # 业务逻辑
│   │   └── services/      # LLM 服务、宏服务等
│   └── presentation/      # UI 层
│       ├── providers/     # Riverpod 状态管理
│       ├── screens/       # 应用界面
│       ├── widgets/       # 可复用组件
│       └── theme/         # 主题配置
├── rust/                   # Rust 原生核心
│   └── src/
│       ├── png_parser.rs  # PNG 角色卡片解析
│       ├── charx_parser.rs # CharX 归档处理
│       └── models.rs      # 数据模型
├── ios/                    # iOS 平台代码
├── android/                # Android 平台代码
└── plans/                  # 架构文档
```

## 快速开始

### 前置要求

- Flutter SDK >= 3.16.0
- Rust 工具链（用于原生核心）
- Xcode（用于 iOS 开发）
- Android Studio（用于 Android 开发）

### 安装

1. **克隆仓库**
   ```bash
   git clone https://github.com/yourusername/NativeTavern.git
   cd NativeTavern
   ```

2. **安装 Flutter 依赖**
   ```bash
   flutter pub get
   ```

3. **构建 Rust 核心**（可选，用于原生功能）
   ```bash
   cd rust
   cargo build --release
   ```

4. **运行应用**
   ```bash
   flutter run
   ```

## SillyTavern 兼容性

### 支持的导入格式

| 格式 | 描述 | 状态 |
|--------|-------------|--------|
| PNG V2 | 带有 `chara` tEXt 块的角色卡片 | ✅ 支持 |
| PNG V3 | 带有 `ccv3` tEXt 块的角色卡片 | ✅ 支持 |
| CharX | 包含 card.json + 资源的 ZIP 归档 | ✅ 支持 |
| JSON | 原始角色 JSON 导出 | ✅ 支持 |
| ST 预设 | SillyTavern AI 预设 JSON | ✅ 支持 |

### 支持的导出格式

| 格式 | 描述 | 状态 |
|--------|-------------|--------|
| PNG V3 | 导出为带有嵌入元数据的 PNG | ✅ 支持 |
| CharX | 导出包含所有资源 | ✅ 支持 |
| JSON | 原始导出用于备份 | ✅ 支持 |

## 开发阶段

| 阶段 | 功能 | 状态 |
|-------|----------|--------|
| **1-2** | 核心基础、聊天核心 | ✅ 完成 |
| **3A** | 消息操作、人设、指令模式 | ✅ 完成 |
| **3B** | 世界书、CharX 完整导入、角色编辑器 | ✅ 完成 |
| **4A** | 群聊、聊天书签 | ✅ 完成 |
| **4B** | 宏系统 | ✅ 完成 |
| **5** | 作者注释、提示词管理器、高级设置、快捷回复、主题、统计、思维链 | ✅ 完成 |
| **6** | 斜杠命令、标签、背景 | 🔄 部分完成 |
| **7+** | 扩展、立绘、TTS/STT、图像生成、翻译、RAG | ⏳ 计划中 |

## 许可证

AGPL-3.0 - 详见 [LICENSE](LICENSE)。

## 致谢

- [SillyTavern](https://github.com/SillyTavern/SillyTavern) - 原始网页版项目
- [Flutter](https://flutter.dev) - 跨平台 UI 框架
- [Riverpod](https://riverpod.dev) - 状态管理