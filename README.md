# NativeTavern

<p align="center">
  <a href="README.md">简体中文</a> | <a href="README.en.md">English</a>
</p>

<p align="center">
  🌐 <a href="https://nativetavern.com/">Native Tavern</a>
</p>

一个原生跨平台移动应用（iOS/Android），将 SillyTavern 重新实现为高性能原生应用，完全兼容 SillyTavern 数据格式。


## 截图

<p align="center">
  <img src="photo/Chat.png" width="200" alt="聊天界面"/>
  <img src="photo/Character.png" width="200" alt="角色界面"/>
  <img src="photo/AiConfig.png" width="200" alt="AI配置"/>
</p>

<p align="center">
  <img src="photo/AIPreset.png" width="200" alt="AI预设"/>
  <img src="photo/PromptManager.png" width="200" alt="提示词管理"/>
  <img src="photo/Wordbook.png" width="200" alt="世界书"/>
</p>

| 聊天 | 角色 | AI配置 |
|:---:|:---:|:---:|
| 实时流式聊天，支持消息操作 | 角色卡片，包含头像和详情 | 多提供商LLM配置 |

| AI预设 | 提示词管理 | 世界书 |
|:---:|:---:|:---:|
| 导入SillyTavern预设 | 自定义提示词排序 | 基于关键词的上下文注入 |

## 功能特性

### 核心功能 ✅
- 📱 **原生移动应用** - 使用 Flutter 构建，支持 iOS 和 Android
- ⚡ **高性能** - 针对移动设备优化
- 🤖 **多提供商 LLM 支持** - OpenAI、Claude、OpenRouter、Gemini、DeepSeek、Qwen、SiliconFlow、Moonshot(Kimi)、Z.AI(GLM)、MiniMax、Ollama、KoboldCpp、自定义 OpenAI 兼容端点
- 📦 **完全兼容 ST** - 导入/导出 PNG 卡片、CharX、JSON
- 💬 **流式响应** - 所有提供商的实时 SSE 流式传输

### 角色管理 ✅
- 📥 **导入格式** - PNG V2/V3、CharX（V3规范）、JSON
- 📤 **导出格式** - PNG V3、带资源的 CharX、JSON
- ✏️ **角色编辑器** - 创建/编辑角色的所有字段
- 🖼️ **头像支持** - 自定义头像，支持图片选择器
- 📚 **嵌入式知识库** - 完整的 CharX 知识库支持

### 聊天功能 ✅
- 💬 **消息操作** - 编辑、删除、重新生成、在备选项之间滑动
- 🎛️ **Swipe Picker** - 点按滑动计数器,浏览/跳转/删除全部备选回复
- 👥 **群聊** - 多角色对话，5种响应模式
- 🔖 **书签** - 创建检查点和分支对话
- 📝 **作者注释** - 可配置深度的注入
- 🎭 **人设** - 用户档案管理，包含描述
- 📄 **HTML/Markdown** - 聊天消息富文本渲染

### 世界书 ✅
- 🌍 **关键词匹配** - 基于触发器的上下文注入
- 📍 **多个位置** - 系统提示前/后、角色定义、示例
- 🔄 **递归支持** - 嵌套关键词扫描
- 📊 **分组评分** - 基于优先级的条目选择

### 提示词管理 ✅
- 📋 **提示词管理器** - 排序、启用/禁用提示词
- 📥 **SillyTavern 预设导入** - 完整的 prompts + prompt_order 支持
- 🎯 **自定义提示词** - 添加带角色支持的自定义部分
- 📍 **深度注入** - 在特定消息深度插入提示词

### 高级设置 ✅
- 🎛️ **完整采样器控制** - Temperature、Top-P、Top-K、Min-P、Typical-P
- 🔁 **重复惩罚** - 可配置范围
- 🎲 **Mirostat** - Mode、Tau、Eta 设置
- ✂️ **无尾采样** - TFS 和 Top-A 支持
- 🛑 **停止序列** - 自定义停止标记
- 🧠 **推理强度** - Reasoning Effort(Claude 自适应思考、Gemini thinkingBudget、OpenAI reasoning_effort)
- 💰 **提示词缓存** - Claude Prompt Caching,大幅降低输入费用
- 🔖 **连接档案** - 命名保存连接配置,一键切换
- 🔀 **消息合并** - 兼容要求严格 user/assistant 交替的接口

### 主题 ✅
- 🎨 **18个内置主题** - 7个深色 + 11个浅色主题
- 🌙 **深色主题** - 默认深色、午夜、森林、日落、玫瑰、海洋、AMOLED
- ☀️ **浅色主题** - 纯净白、暖奶油、柔和薰衣草、薄荷清新、天空蓝、玫瑰粉、蜜桃、鼠尾草绿、纸张、复古
- 🖌️ **主题编辑器** - 完整的颜色自定义

### 思维链支持 ✅
- 🧠 **OpenAI o1/o3** - 解析 `reasoning_content` 字段
- 💭 **Claude** - 解析 `thinking` 块(含自适应思考)
- 🤔 **Gemini 2.0 Flash Thinking** - 解析 `thought` 字段
- 🏷️ **内嵌标签解析** - DeepSeek R1 等模型的 `<think>` 标签自动摘取(流式+非流式)
- 💾 **推理存储** - 保存消息和滑动的推理内容
- 📦 **可折叠UI** - 可展开的推理块，支持复制
- ⏳ **流式显示** - 实时推理，带脉冲动画

### 角色标签 ✅
- 🏷️ **标签管理** - 创建、编辑、删除标签
- 🎨 **标签颜色** - 自定义十六进制颜色
- 😀 **标签图标** - 表情符号图标用于视觉识别
- 🔗 **角色分配** - 为角色分配多个标签
- 🔍 **标签过滤** - 按标签过滤角色列表

### Markdown输入 ✅
- ⌨️ **键盘快捷键** - ⌘B 粗体、⌘I 斜体、⌘U 下划线
- 📝 **格式化工具栏** - 紧凑的格式化按钮工具栏
- 🔗 **链接支持** - ⌘K 快速插入链接
- 💻 **代码块** - 行内代码和代码块快捷键

### 表情精灵 ✅
- 🎭 **情绪检测** - 从消息中自动检测情绪
- 📁 **精灵管理** - 每个角色独立的精灵文件夹
- 🖼️ **15种情绪** - 开心、悲伤、愤怒、惊讶、害怕等
- ✨ **动画效果** - 平滑的淡入/缩放过渡
- ⚙️ **可自定义** - 大小、位置、透明度设置
- 🎬 **动作检测** - 检测 *微笑*、*大笑* 等动作

### 文字转语音 🚧
- 🔊 **多种提供商** - ElevenLabs、Azure、火山引擎(Volcengine)、GPT-SoVITS、OpenAI 兼容端点
- 🎭 **角色独立语音** - 每个角色不同的语音
- 🎚️ **语音控制** - 速度、音调、音量调节
- 📝 **文本清理** - 移除markdown/HTML以获得自然语音
- ⚠️ **状态说明** - 语音合成接口已就绪(返回音频字节),播放集成开发中

### 语音转文字 🚧
- 🎤 **语音输入** - 使用语音口述消息(接口层就绪,录音集成开发中)
- 🌍 **16种语言** - 支持主要语言
- 🔄 **多种提供商** - 系统STT、Whisper、Azure

### 翻译 ✅
- 🌐 **30+种语言** - 在主要语言之间翻译
- 🔄 **多种提供商** - Google、DeepL、LibreTranslate
- 🔀 **自动翻译** - 接收和发送的消息
- 🔍 **语言检测** - 自动检测源语言
- 📝 **显示原文** - 在翻译旁显示原文
- 🔘 **翻译按钮** - 按需翻译消息

### 图像生成 ✅
- 🎨 **多种提供商** - GPT-Image-2、Gemini、NovelAI、Pollinations(免费)、ComfyUI、Automatic1111
- 📐 **尺寸预设** - 512x512、768x768、1024x1024等
- ⚙️ **生成设置** - 步数、CFG比例、采样器选择
- 🚫 **负面提示词** - 排除不需要的元素
- 🎲 **采样器选项** - Euler、Euler A、DPM++、DDIM等
- 🔧 **API配置** - 自定义端点和API密钥

### 正则脚本 ✅
- 🔍 **查找/替换模式** - 对消息应用正则表达式
- 📝 **脚本管理** - 创建、编辑、删除、重排序脚本
- 🎯 **应用位置** - 用户输入、AI输出、斜杠命令
- 📦 **预设** - 内置预设脚本
- 🔄 **导入/导出** - 以JSON格式分享脚本
- 🧪 **测试工具** - 应用前测试模式

### 变量系统 ✅
- 🌐 **全局变量** - 应用范围的持久存储
- 💬 **本地变量** - 每个聊天的变量存储
- 📝 **变量宏** - {{getvar}}、{{setvar}}、{{incvar}}等
- 🔢 **类型支持** - 数字、字符串、数组、对象
- ➕ **操作** - 递增、递减、添加、连接

### RAG / 向量存储 🚧
- 🧲 **多种 Embedding 提供商** - OpenAI 兼容、SiliconFlow、Cohere、Gemini、Ollama
- 📚 **知识库集合** - 文档分块、批量嵌入、本地持久化
- 🔍 **相似度检索** - Top-K + 阈值过滤
- 💬 **提示词注入** - 按最新用户消息检索,以模板注入上下文

### 聊天备份 ✅
- 💾 **自动备份** - 可配置间隔（每小时、每天、每周）
- 📁 **聊天备份** - 单独聊天导出（JSONL）
- 📦 **完整备份** - 完整数据导出（JSON）
- 🗑️ **保留策略** - 自动清理旧备份
- 👁️ **查看/恢复** - 浏览和恢复备份

### 宏系统 ✅(Macros 2.0)
- `{{user}}` / `{{char}}` - 人设与角色名称
- `{{time}}` / `{{date}}` / `{{weekday}}` - 日期/时间宏
- `{{random:min:max}}` / `{{roll:NdM}}` / `{{pick::...}}`(聊天内稳定)
- `{{if 条件}}...{{else}}...{{/if}}` - 作用域条件块,惰性求值、支持嵌套
- `{{.局部变量}}` / `{{$全局变量}}` - 变量简写,支持 `= += -= ++ -- == != > < ?? ||` 等运算符
- `{{greeting::N}}` - 按索引访问备选问候语
- `{{maxContextTokens}}` / `{{maxResponseTokens}}` / `{{group}}`
- `{{idle_duration}}` / `{{lastMessage}}` / `{{lastUserMessage}}` / `{{lastCharMessage}}`

### 斜杠命令 ✅
- `/continue` - 继续生成
- `/regenerate` - 重新生成最后一条消息
- `/swipe` - 导航滑动
- `/persona` - 切换人设
- `/sys` - 发送系统消息
- `/bg` - 更改背景
- `/help` - 显示命令帮助
- `/clear` - 清除消息
- `/edit` - 编辑最后一条消息
- `/delete` - 删除消息
- `/bookmark` - 创建书签
- `/note` - 设置作者注释

### 背景 ✅
- 🖼️ **自定义背景** - 设置聊天背景
- 📁 **背景图库** - 管理背景图片
- 🎚️ **透明度控制** - 调整背景透明度
- 💬 **每个聊天的背景** - 不同聊天使用不同背景

## 技术栈

| 组件 | 技术 |
|-----------|------------|
| UI框架 | Flutter (Dart) |
| 状态管理 | Riverpod |
| 导航 | go_router |
| 数据库 | SQLite (drift) |
| 原生核心 | Rust (通过 FFI) |
| HTTP客户端 | Dio |

## 项目结构

```
native_tavern/
├── lib/                    # Flutter/Dart 代码
│   ├── main.dart          # 入口点
│   ├── app.dart           # 应用配置
│   ├── core/              # 核心工具
│   ├── data/              # 数据层（模型、数据库、仓库）
│   │   ├── models/        # 数据模型（Character、Chat、Message等）
│   │   ├── database/      # 使用 Drift 的 SQLite 数据库
│   │   └── repositories/  # 数据访问层
│   ├── domain/            # 业务逻辑
│   │   └── services/      # LLM服务、宏服务等
│   └── presentation/      # UI层
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

## 开始使用

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
| ST预设 | SillyTavern AI 预设 JSON | ✅ 支持 |

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
| **3B** | 世界书、CharX完整导入、角色编辑器 | ✅ 完成 |
| **4A** | 群聊、聊天书签 | ✅ 完成 |
| **4B** | 宏系统 | ✅ 完成 |
| **5** | 作者注释、提示词管理、高级设置、快捷回复、主题、统计、思维链 | ✅ 完成 |
| **6** | 斜杠命令、标签、背景、HTML/Markdown | ✅ 完成 |
| **7** | 表情精灵、TTS、STT、翻译、图像生成 | ✅ 完成 |
| **8** | 正则脚本、变量、聊天备份 | ✅ 完成 |
| **9** | RAG/向量(embedding + 检索注入) | 🚧 基础可用 |
| **10** | 扩展、TTS/STT 播放集成 | ⏳ 计划中 |

## 与 SillyTavern 功能对比

| 功能 | SillyTavern Web | NativeTavern | 状态 |
|---------|-----------------|--------------|--------|
| 角色导入/导出 | ✅ | ✅ | 完全对等 |
| LLM提供商 | 10+ | 13 | 含国产主流模型 |
| 流式传输 | ✅ | ✅ | 完全对等 |
| 消息操作 | ✅ | ✅ | 完全对等 |
| 群聊 | ✅ | ✅ | 完全对等 |
| 世界书 | ✅ | ✅ | 完全对等 |
| 提示词管理 | ✅ | ✅ | 完全对等 |
| 宏 | ✅ | ✅ | 完全对等 |
| 主题 | ✅ | ✅ | 18个内置 |
| 斜杠命令 | ✅ | ✅ | 完全对等 |
| 背景 | ✅ | ✅ | 完全对等 |
| HTML/Markdown | ✅ | ✅ | 完全对等 |
| 思维链 | ✅ | ✅ | 完全对等 |
| 角色标签 | ✅ | ✅ | 完全对等 |
| 推理UI | ✅ | ✅ | 完全对等 |
| Markdown快捷键 | ✅ | ✅ | 完全对等 |
| 表情精灵 | ✅ | ✅ | 完全对等 |
| TTS | ✅ | 🚧 | 合成就绪,播放开发中 |
| STT | ✅ | 🚧 | 接口就绪,录音开发中 |
| 翻译 | ✅ | ✅ | 完全对等 |
| 图像生成 | ✅ | ✅ | 完全对等 |
| 正则脚本 | ✅ | ✅ | 完全对等 |
| 变量系统 | ✅ | ✅ | 完全对等 |
| 聊天备份 | ✅ | ✅ | 完全对等 |
| RAG/向量存储 | ✅ | 🚧 | 基础可用 |
| 扩展 | ✅ | ⏳ | 计划中 |

**总体完成度：约98%** 的核心 SillyTavern 功能

## 贡献指南

欢迎参与 NativeTavern 的开发与改进！请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 了解开发者环境初始化 (`./setup.sh`)、代码规范、多平台本地构建脚本以及 Pull Request 提交流程。

## 许可证

AGPL-3.0 - 详见 [LICENSE](LICENSE)。

## 致谢

- [SillyTavern](https://github.com/SillyTavern/SillyTavern) - 原始 Web 项目
- [Flutter](https://flutter.dev) - 跨平台 UI 框架
- [Riverpod](https://riverpod.dev) - 状态管理