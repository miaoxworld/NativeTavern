# Tool Calling & Model Context Protocol (MCP) in NativeTavern

## Overview

NativeTavern integrates both native LLM function/tool calling and the **Model Context Protocol (MCP)** via `package:mcp_dart` (version `^2.4.0`), enabling characters and the chat engine to execute real-world tools, access external databases, and browse web content.

---

## 1. Tool Calling Architecture

### Execution Loop
```
User Message
    │
    ▼
Prompt Assembler (Injects tool schemas into system/tools payload)
    │
    ▼
LLM Dispatch (Streaming or synchronous completion)
    │
    ├── Assistant returns text -> Display to user
    │
    └── Assistant returns ToolCall(name, args)
            │
            ▼
        Tool Dispatcher (Validates & routes to local tool or MCP server)
            │
            ▼
        Tool Result returned to LLM context
            │
            ▼
        LLM generates final response incorporating tool results
```

---

## 2. Model Context Protocol (MCP)

### Client Orchestration (`lib/domain/services/mcp_service.dart`)
- **Transport Layers**:
  - `StdioClientTransport`: Communicates with local CLI-based MCP servers over standard I/O (macOS, desktop).
  - `WebSocketClientTransport` / `SseClientTransport`: Connects to remote or local network MCP daemon servers.
- **Dynamic Tool Discovery**:
  - `listTools()` queries connected MCP servers.
  - Automatically registers tool definitions into the active character's tool execution scope.
- **Safety & Permissions**:
  - Destructive or filesystem tools can be configured to require explicit user approval in the UI before execution.

---

## 3. Supported AI Providers

- **xAI (Grok)**: Native support for Grok models with system prompts, streaming, and tool calls.
- **OpenAI**: GPT-4o, GPT-4o-mini, function calling schemas.
- **Anthropic Claude**: Claude 3.5 Sonnet, Claude 3 Opus, tool-use JSON blocks.
- **OpenRouter**: Unified endpoint supporting hundreds of open and commercial models.
- **Local Runtimes**: Ollama, LM Studio, vLLM, Aphrodite (via OpenAI-compatible API endpoints).
