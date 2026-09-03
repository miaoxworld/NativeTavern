# 参与贡献 NativeTavern

<p align="center">
  <a href="CONTRIBUTING.md">简体中文</a> | <a href="CONTRIBUTING.en.md">English</a>
</p>

感谢你对 NativeTavern 项目的关注与支持！本文档提供了开发者上手指南、环境配置步骤以及开发规范，帮助你快速、高效地为项目贡献力量。

---

## 1. 快速上手与环境初始化

在全新克隆的仓库中，请在仓库根目录下运行自动化配置脚本：

```sh
./setup.sh
```

`setup.sh` 会自动完成以下操作：
1. 校验基础工具链（`git`、`flutter >=3.44.9`、`dart`）。
2. 在不存在 `.env` 时，自动从 `.env.example` 复制初始化 `.env`。
3. 为项目中所有脚本设置执行权限（`build_*.sh`、`tool/*.sh`）。
4. 运行 `flutter doctor -v` 诊断开发环境。
5. 运行 `flutter pub get` 解析并还原依赖。
6. 执行项目完整性检查（Dart 静态代码分析、国际化本地化生成、各平台本地构建预检）。

---

## 2. 本地开发与测试

### 运行应用
日常开发时启动调试应用：

```sh
flutter run
```

### 本地构建脚本
项目为各目标平台提供了专用的本地构建脚本，支持快速重构、自定义 Bundle ID 以及设备安装侧载：

- **iOS 本地构建**:
  ```sh
  ./build_ios_local.sh [options]
  # 常用参数: --check-only, --skip-clean, --export-method <development|ad-hoc>, --bundle-id <id>, --device <id>
  ```
- **Android 本地构建**:
  ```sh
  ./build_android_local.sh [options]
  # 常用参数: --check-only, --debug, --release, --skip-clean, --package <id>, --track <name>, --install (-i)
  ```
  *(当未提供自定义 Release 密钥库时，Release 构建会自动回退到 Debug 签名，生成可直接通过 `adb` 侧载安装的 APK，输出路径为 `build/local_release/`)*。
- **macOS 本地构建**:
  ```sh
  ./build_macos_local.sh [options]
  # 常用参数: --check-only, --debug, --release, --skip-clean, --bundle-id <id>
  ```

---

## 3. 架构规范与代码指南

NativeTavern 严格遵循基于 Riverpod 2.x 和 Drift SQLite 的清晰分层架构（Clean Architecture）：

```
lib/
├── data/           # 数据层：Drift SQLite 数据库、DAO、DTO、存储库实现
├── domain/         # 领域层：业务逻辑、LLM 适配器、服务、解析器
└── presentation/   # 表现层：Riverpod 状态提供者、界面、组件、GoRouter、主题
```

### 核心设计原则
- **Riverpod 2.x**: 优先使用代码生成的 `@riverpod` 或 `StateNotifierProvider` / `NotifierProvider`。针对页面级或临时状态必须使用 `autoDispose` 确保资源及时回收。
- **不可变性**: 数据模型必须使用 `@freezed` 或 `Equatable` 保持不可变，严禁直接原地修改状态。
- **Drift SQLite**: 数据库表结构变更必须递增 `app_database.dart` 中的 `schemaVersion` 并编写显式迁移逻辑。修改表定义后请执行：
  ```sh
  dart run build_runner build --delete-conflicting-outputs
  ```
- **GoRouter**: 所有路由声明统一维护在 `lib/presentation/router/app_router.dart` 中。

更多详细架构设计规范，请查阅 [.agents/rules/architecture.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/architecture.md)。

---

## 4. 界面与多语言国际化规范（强制要求）

1. **严禁硬编码文本**: 任何用户可见的界面文本、对话框提示、底部弹窗以及错误提示，绝不能在代码中直接硬编码字符串。
2. **通过 Localizations 访问**: 统一通过 `AppLocalizations.of(context)!`（或 `l10n`）访问多语言字符串。
3. **新增翻译词条步骤**:
   - 在 `lib/l10n/app_en.arb` 中添加英文键名及对应的 `@key` 描述元数据。
   - 同步在 `lib/l10n/` 下的目标语言文件（如 `app_zh.arb`、`app_ja.arb`、`app_de.arb`、`app_fr.arb`、`app_es.arb` 等）添加对应翻译。
   - 运行生成命令：
     ```sh
     flutter gen-l10n
     ```
4. **用户知情授权同步**: 添加或调整 AI 服务商时，务必保持数据共享知情列表（`aiDataSharingRecipients`）与设置项同步。

---

## 5. 原生运行时与 FFI (Live2D、Spine、Rust)

- **Live2D Cubism SDK**:
  - 固定使用 Cubism Core 6.0.1 运行时。
  - 专有头文件 `Live2DCubismCore.h` 未纳入版本控制。如需在 macOS 下进行 Live2D 原生桥接开发，请先将该头文件复制到 `packages/native_tavern_live2d_macos/macos/CubismCore/include/`。
- **Spine 4.1 兼容层**:
  - 位于 `packages/spine_flutter_4_1_compat/`，锁定 Spine 4.1.14 二进制运行时。
- **Rust 原生核心**:
  - 位于 `rust/`（`native_tavern_core`），通过 `flutter_rust_bridge 2.0` 进行 FFI 绑定。
  - 在修改 Rust 核心后生成 FFI 绑定代码：
    ```sh
    flutter_rust_bridge_codegen generate
    ```

---

## 6. 提交流程与预检验证

在提交 Pull Request 之前，请确保以下校验通过：

1. **格式化与静态代码分析**:
   ```sh
   dart format --output=none --set-exit-if-changed .
   dart analyze lib test
   ```
2. **运行单元测试与组件测试**:
   ```sh
   flutter test
   ```
3. **运行环境完整性检查**:
   ```sh
   ./setup.sh
   ```

---

## 7. 安全规范与发布要求

- **严禁提交敏感凭证**: 请勿将 `.env` 文件、密钥库（`.jks`）、证书（`.p12`）或私钥（`.p8`）提交至版本库。
- **正式发布流程**: 正式发行包必须通过仓库内置的发布脚本构建：
  - iOS: `./build_ios.sh`
  - Android: `./build_android.sh`
  - macOS: `./build_macos.sh`
- 详细发布说明请参考 `docs/release-runbook.md` 以及 [.agents/rules/release_and_security.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/release_and_security.md)。

---

## 8. 技术参考文档

如需了解底层技术实现与数据规范，请查阅 `.agents/docs/` 本地文档：
- [项目架构与依赖总览](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/project_overview.md)
- [SillyTavern 角色卡规范 (V2/V3 与 CharX)](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/sillytavern_card_spec.md)
- [备份与云同步规范 (.ntb, .ntx, .ntm, .jsonl)](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/backup_and_sync_spec.md)
- [Live2D 与 Spine 原生渲染架构](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/live2d_and_spine.md)
- [工具调用与 MCP 规范说明](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/tool_calling_and_mcp.md)
- [Rust 原生核心架构指南](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/docs/rust_native_core.md)
