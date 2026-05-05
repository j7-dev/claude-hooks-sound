# Claude Code Sound Notifications

Claude Code hook 事件觸發時自動播放對應音檔。

## 運作方式

Hook 觸發 → 查找 `~/.claude/sounds/{EventName}.mp3` → 有就播，沒有就跳過。

## 已掛載事件

備檔狀態：`O` 表示音檔已存在（會發聲）、`-` 表示未備檔（靜音）。

### Session 生命週期

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `SessionStart` | 會話開始或恢復 | `SessionStart.mp3` | - |
| `Setup` | 以 `--init` / `--maintenance` 啟動時 | `Setup.mp3` | - |
| `SessionEnd` | 會話結束 | `SessionEnd.mp3` | - |
| `InstructionsLoaded` | CLAUDE.md / `.claude/rules/*.md` 載入時 | `InstructionsLoaded.mp3` | - |

### 用戶輸入

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `UserPromptSubmit` | 用戶送出提示詞 | `UserPromptSubmit.mp3` | - |
| `UserPromptExpansion` | 自訂指令展開為 prompt 時 | `UserPromptExpansion.mp3` | - |

### 權限

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `PermissionRequest` | 出現權限對話框 | `PermissionRequest.mp3` | - |
| `PermissionDenied` | 工具呼叫被自動模式拒絕 | `PermissionDenied.mp3` | - |

### Subagent / Task / Teammate

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `SubagentStart` | Subagent 被啟動 | `SubagentStart.mp3` | - |
| `SubagentStop` | Subagent 完成任務回報 | `SubagentStop.mp3` | - |
| `TaskCreated` | 透過 `TaskCreate` 建立任務 | `TaskCreated.mp3` | - |
| `TaskCompleted` | 任務被標記完成 | `TaskCompleted.mp3` | - |
| `TeammateIdle` | Agent Team 隊員即將進入 idle | `TeammateIdle.mp3` | - |

### 回應週期

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `Notification` | Claude Code 發送通知（等待回覆 / 權限） | `Notification.mp3` | O |
| `Stop` | Claude 完成回應 | `Stop.mp3` | O |
| `StopFailure` | Turn 因 API 錯誤結束 | `StopFailure.mp3` | - |

### Context 壓縮

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `PreCompact` | 上下文壓縮前 | `PreCompact.mp3` | - |
| `PostCompact` | 上下文壓縮完成後 | `PostCompact.mp3` | - |

### 設定 / 工作目錄

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `ConfigChange` | 會話進行中設定檔變動 | `ConfigChange.mp3` | - |
| `CwdChanged` | 工作目錄切換 | `CwdChanged.mp3` | - |

### Worktree

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `WorktreeCreate` | 建立 worktree | `WorktreeCreate.mp3` | - |
| `WorktreeRemove` | 移除 worktree | `WorktreeRemove.mp3` | - |

### MCP 互動

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `Elicitation` | MCP 伺服器在工具呼叫中請求用戶輸入 | `Elicitation.mp3` | - |
| `ElicitationResult` | 用戶回應 MCP elicitation 後 | `ElicitationResult.mp3` | - |

合計：24 個事件已掛載。

## 使用方式

將 `.mp3` 檔案放入此目錄，檔名對應 hook event name：

```
~/.claude/sounds/
├── Stop.mp3              # 已備檔
├── Notification.mp3      # 已備檔
├── SubagentStop.mp3      # 待補
└── ...其他事件依需求補檔
```

不需要的事件不放檔案即可，腳本會自動跳過（`exit 0`）。

## 新增事件

1. 在 `~/.claude/settings.json` 的 `hooks` 區塊加入新事件（複製現有格式，替換 event name）
2. 放入對應的 `{EventName}.mp3`

## 相關檔案

- 播放腳本：`~/.claude/hooks/play-sound.ps1`
- Hook 設定：`~/.claude/settings.json` → `hooks`
