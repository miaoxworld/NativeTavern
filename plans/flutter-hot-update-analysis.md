# Flutter 移动端热更新技术方案分析

## 需求背景

- **目标平台**: iOS + Android 移动端
- **关键约束**: 需要上架 App Store
- **使用场景**: Bug 修复和小功能更新

---

## ⚠️ 核心结论（先说结论）

### Flutter 天然不支持业务代码热更新

这是由 **技术架构** 和 **平台政策** 双重因素决定的：

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter 编译模式                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  开发模式 (Debug)          发布模式 (Release)                │
│  ┌─────────────────┐      ┌─────────────────┐              │
│  │   Dart VM       │      │   AOT 编译      │              │
│  │   JIT 编译      │      │   机器码        │              │
│  │   ↓             │      │   ↓             │              │
│  │   支持热重载    │      │   不可替换      │              │
│  │   (Hot Reload)  │      │   (Frozen)      │              │
│  └─────────────────┘      └─────────────────┘              │
│                                                             │
│  仅用于开发调试            App Store 发布的是这个版本        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**技术原因**：
- Flutter Release 模式使用 **AOT (Ahead-of-Time) 编译**
- Dart 代码被编译成 **原生机器码** (`libapp.so` / `App.framework`)
- 运行时没有 Dart VM，无法解释执行新代码
- 这是 Flutter 追求性能的设计选择

**政策原因**：
- Apple App Store 审核指南 2.5.2 **明确禁止**下载可执行代码
- 即使技术上能实现，也会被拒绝上架或下架

### 与其他技术的对比

| 技术栈 | 热更新能力 | 原因 |
|--------|-----------|------|
| **Flutter** | ❌ 不支持 | AOT 编译成机器码 |
| **React Native** | ⚠️ 有限 | JavaScript 可动态加载，但 App Store 限制 |
| **原生 iOS** | ❌ 不支持 | 编译型语言 |
| **小程序** | ✅ 支持 | 运行在宿主 App 的容器中 |
| **Web App** | ✅ 支持 | 解释执行 |

### 为什么 React Native 的热更新（CodePush）也有风险？

虽然 React Native 使用 JavaScript（解释型语言），理论上可以动态加载：
- Microsoft CodePush 曾被广泛使用
- 但 Apple 近年来加强了审查
- 多个应用因使用 CodePush 被拒绝或下架
- 政策执行存在不确定性

---

## 核心问题：App Store 政策限制

### Apple App Store 审核指南 2.5.2

> "Apps must be self-contained in their bundles, and may not read or execute code that is not shipped in the approved bundle."

**关键限制**:
1. ❌ 禁止下载可执行代码（包括 Dart AOT 编译的 libapp.so）
2. ❌ 禁止动态执行代码（如 JavaScript 核心业务逻辑）
3. ⚠️ 例外：WebView 中的 JavaScript、JavaScriptCore（有限制）

### Google Play 政策

相对宽松，但也有限制：
- 允许从 Google Play 之外加载可执行代码
- 但要求遵守恶意软件政策
- 动态加载的代码必须符合开发者政策

---

## 技术方案评估

### 方案一：Shorebird（官方推荐）

**原理**: 差分更新 Dart AOT 代码

```
┌─────────────────┐     ┌─────────────────┐
│   Original App  │     │   Patch Server  │
│  (App Store)    │     │   (Shorebird)   │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │   Check for patches   │
         ├──────────────────────►│
         │                       │
         │   Download diff patch │
         │◄──────────────────────┤
         │                       │
         │   Apply patch at      │
         │   runtime             │
         └───────────────────────┘
```

**优点**:
- ✅ Flutter 官方合作伙伴
- ✅ 无需重新上架即可更新 Dart 代码
- ✅ 支持 iOS 和 Android
- ✅ 差分更新，补丁体积小

**缺点**:
- ⚠️ 订阅制收费（免费版有限制）
- ⚠️ iOS App Store 政策灰色地带
- ❌ 不能更新原生代码（Swift/Kotlin）
- ❌ 不能添加新的原生依赖

**App Store 合规性**: ⚠️ **存在风险**
- Shorebird 声称通过"解释"而非"执行"新代码来规避政策
- 但苹果随时可能改变解释或加强审查
- 已有应用因使用类似技术被拒的案例

### 方案二：动态配置/远程配置

**原理**: 通过服务端下发配置来控制应用行为

```dart
// 示例：远程配置控制功能开关
class RemoteConfig {
  static Future<Map<String, dynamic>> fetchConfig() async {
    final response = await dio.get('https://api.example.com/config');
    return response.data;
  }
}

// 使用配置控制UI显示
Widget build(BuildContext context) {
  final config = ref.watch(remoteConfigProvider);
  
  if (config['enable_new_feature'] == true) {
    return NewFeatureWidget();
  }
  return OldFeatureWidget();
}
```

**适用场景**:
- ✅ 功能开关（Feature Flags）
- ✅ A/B 测试
- ✅ 文案/图片/配置更新
- ✅ API 端点切换
- ✅ 业务规则参数调整

**优点**:
- ✅ 完全符合 App Store 政策
- ✅ 无额外成本（自建或用 Firebase）
- ✅ 实时生效

**缺点**:
- ❌ 不能修复代码 Bug
- ❌ 不能添加新功能逻辑
- ❌ 需要预先在代码中埋点

**推荐工具**:
- Firebase Remote Config
- LaunchDarkly
- ConfigCat
- 自建配置服务

### 方案三：WebView 混合架构

**原理**: 将部分业务逻辑放在 WebView 中，通过 H5 热更新

```
┌─────────────────────────────────────────┐
│            Flutter App Shell            │
│  ┌───────────────────────────────────┐  │
│  │         Native Features           │  │
│  │  (Camera, Storage, etc.)          │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │           WebView Area            │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │    H5 Business Logic       │  │  │
│  │  │    (Hot Updatable)         │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

**适用场景**:
- ✅ 活动页面
- ✅ 运营配置页面
- ✅ 频繁变更的业务模块

**优点**:
- ✅ 完全符合 App Store 政策
- ✅ 真正的代码热更新
- ✅ 可以修复 Bug 和添加功能

**缺点**:
- ❌ 性能不如原生
- ❌ 需要维护两套技术栈
- ❌ 交互体验可能不一致
- ❌ 不适合核心功能

### 方案四：模块化 + 插件动态下载（仅 Android）

**原理**: 使用 Android Dynamic Feature Modules

```kotlin
// Android Dynamic Feature
val request = SplitInstallRequest.newBuilder()
    .addModule("feature_chat")
    .build()

splitInstallManager.startInstall(request)
```

**优点**:
- ✅ Google Play 官方支持
- ✅ 可以动态下载模块

**缺点**:
- ❌ 仅 Android 可用
- ❌ iOS 不支持
- ❌ Flutter 集成复杂

### 方案五：服务端驱动 UI（Server-Driven UI）

**原理**: UI 结构由服务端下发 JSON 描述

```json
{
  "type": "column",
  "children": [
    {
      "type": "text",
      "value": "Welcome",
      "style": {"fontSize": 24, "fontWeight": "bold"}
    },
    {
      "type": "button",
      "label": "Click Me",
      "action": {"type": "navigate", "route": "/home"}
    }
  ]
}
```

```dart
// Flutter 端解析并渲染
Widget buildFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'column':
      return Column(
        children: (json['children'] as List)
            .map((c) => buildFromJson(c))
            .toList(),
      );
    case 'text':
      return Text(json['value'], style: parseStyle(json['style']));
    case 'button':
      return ElevatedButton(
        onPressed: () => handleAction(json['action']),
        child: Text(json['label']),
      );
    // ... 更多组件
  }
}
```

**优点**:
- ✅ 符合 App Store 政策
- ✅ 可以动态调整 UI 布局
- ✅ 无需发版即可上线新页面

**缺点**:
- ⚠️ 实现复杂度高
- ⚠️ 需要定义完整的组件库
- ❌ 不能添加新的原生交互
- ❌ 调试困难

**成熟方案**:
- Airbnb 的 Lona
- Shopify 的 Hydrogen

---

## 针对 NativeTavern 的推荐方案

基于项目特点（AI 聊天应用，核心功能相对稳定），推荐采用**组合策略**：

### 层级 1：远程配置（解决 80% 问题）

```dart
// lib/core/services/remote_config_service.dart
class RemoteConfigService {
  static const String _configUrl = 'https://api.nativetavern.app/config';
  
  Future<AppConfig> fetchConfig() async {
    final response = await dio.get(_configUrl);
    return AppConfig.fromJson(response.data);
  }
}

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    @Default(true) bool enableStreaming,
    @Default([]) List<String> supportedModels,
    @Default({}) Map<String, dynamic> featureFlags,
    @Default('') String minSupportedVersion,
    @Default('') String latestVersion,
    @Default('') String updateMessage,
    @Default(false) bool forceUpdate,
  }) = _AppConfig;
}
```

**可热更新的内容**:
- 支持的 LLM 模型列表
- API 端点配置
- 功能开关
- 错误提示文案
- 默认参数值

### 层级 2：动态资源更新

```dart
// 动态下载和缓存资源
class DynamicResourceService {
  Future<void> updateResources() async {
    // 下载新的提示词模板
    await downloadPromptTemplates();
    // 下载新的角色卡
    await downloadCharacterPresets();
    // 下载新的主题配置
    await downloadThemeConfigs();
  }
}
```

**可热更新的资源**:
- 预设角色卡
- 提示词模板
- 主题配置
- 正则脚本
- World Info 模板

### 层级 3：强制更新提示

```dart
// 当有重大 Bug 需要修复时
class UpdateCheckService {
  Future<void> checkForUpdates() async {
    final config = await remoteConfig.fetchConfig();
    final currentVersion = await PackageInfo.fromPlatform();
    
    if (config.forceUpdate && 
        isVersionLower(currentVersion.version, config.minSupportedVersion)) {
      showForceUpdateDialog(config.updateMessage);
    } else if (isVersionLower(currentVersion.version, config.latestVersion)) {
      showOptionalUpdateDialog();
    }
  }
}
```

### 层级 4：考虑 Shorebird（可选）

如果业务需要频繁修复 Dart 代码 Bug，可以评估 Shorebird：

```bash
# 安装 Shorebird
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash

# 初始化项目
shorebird init

# 发布补丁
shorebird patch --platform ios
shorebird patch --platform android
```

**风险评估**:
- 目前大量应用使用，尚未有大规模下架报告
- 但政策风险始终存在
- 建议作为辅助手段，不要过度依赖

---

## 实施建议

### 阶段一：基础设施搭建

1. **搭建配置服务**
   - 使用 Firebase Remote Config 或自建服务
   - 设计配置数据结构
   - 实现客户端获取和缓存逻辑

2. **实现版本检查**
   - 强制更新逻辑
   - 可选更新提示
   - App Store/Google Play 跳转

3. **动态资源系统**
   - 资源版本管理
   - 增量下载
   - 本地缓存

### 阶段二：代码预埋点

1. **功能开关埋点**
   ```dart
   if (remoteConfig.isFeatureEnabled('new_chat_ui')) {
     return NewChatScreen();
   }
   return ChatScreen();
   ```

2. **参数外置**
   ```dart
   final defaultTemperature = remoteConfig.getDouble('default_temperature', 0.8);
   ```

3. **错误处理可配置**
   ```dart
   final errorMessage = remoteConfig.getString('api_error_message', 'An error occurred');
   ```

### 阶段三：评估 Shorebird（可选）

1. 小范围测试
2. 监控审核结果
3. 建立回滚机制

---

## 技术对比总结

| 方案 | App Store 合规 | Bug 修复 | 新功能 | 实现难度 | 成本 |
|------|---------------|----------|--------|----------|------|
| Shorebird | ⚠️ 灰色地带 | ✅ | ⚠️ 有限 | 低 | 付费 |
| 远程配置 | ✅ | ❌ | ⚠️ 开关 | 低 | 低/免费 |
| WebView 混合 | ✅ | ✅ 部分 | ✅ 部分 | 高 | 中 |
| Server-Driven UI | ✅ | ⚠️ UI层 | ⚠️ UI层 | 很高 | 高 |
| 强制更新 | ✅ | ✅ | ✅ | 低 | 低 |

---

## 最终建议

对于 NativeTavern 项目，建议采用以下策略：

1. **短期（立即可做）**:
   - 实现远程配置系统
   - 实现版本检查和更新提示
   - 将可配置项外置

2. **中期（1-2个月）**:
   - 建立动态资源更新系统
   - 在代码中埋入功能开关
   - 评估是否引入 Shorebird

3. **长期（根据需求）**:
   - 如果确实需要频繁更新业务逻辑，考虑将特定模块用 WebView 实现
   - 持续关注 Flutter/Shorebird 的政策变化

**核心原则**: 优先保证 App Store 合规性，在此基础上最大化灵活性。