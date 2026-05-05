# Claude Code Sound Notifications

Claude Code hook 事件觸發時自動播放對應音檔。跨平台（Windows / macOS / Linux），零相依（純 shell / PowerShell）。

## 運作方式

Hook 觸發 → 查找 `<repo>/sounds/{EventName}.mp3`（相對於腳本所在目錄）→ 有就播，沒有就跳過（`exit 0`，不會讓 hook 失敗）。

播放腳本：

- Windows：`play-sound.ps1`（透過 `winmm.dll` MCI）
- macOS / Linux：`play-sound.sh`（依序偵測 `afplay` / `mpg123` / `ffplay` / `paplay`）

---

## 安裝

### 1. 取得這份 repo

建議放到 `~/.claude/hooks/claude-hooks-sound`：

```bash
# macOS / Linux
git clone https://github.com/<your-fork>/claude-hooks-sound.git ~/.claude/hooks/claude-hooks-sound
chmod +x ~/.claude/hooks/claude-hooks-sound/play-sound.sh
```

```powershell
# Windows (PowerShell)
git clone https://github.com/<your-fork>/claude-hooks-sound.git "$env:USERPROFILE\.claude\hooks\claude-hooks-sound"
```

> 也可以手動下載 / 複製到任意位置。腳本用 `$PSScriptRoot` / `BASH_SOURCE` 解析自身路徑，不綁死目錄結構。

### 2. 確認音檔

`<repo>/sounds/` 已預置 5 個事件的音檔，`git clone` 完直接用：

```
claude-hooks-sound/
├── play-sound.ps1
├── play-sound.sh
└── sounds/
    ├── Notification.mp3
    ├── PermissionDenied.mp3
    ├── PermissionRequest.mp3
    ├── Stop.mp3
    └── TaskCompleted.mp3
```

要新增事件 → 把 `.mp3` 放進 `sounds/`，檔名對應 event name（見下方〈已掛載事件〉表格）。要移除某事件的聲音 → 刪掉 mp3 即可，腳本會自動跳過。

### 3. macOS / Linux 播放器需求

`play-sound.sh` 會自動挑選系統可用的播放器，至少需要其中一個：

| 系統 | 內建工具 | 安裝指令（如沒有） |
|------|---------|-------------------|
| macOS | `afplay`（內建） | 無需安裝 |
| Ubuntu / Debian | — | `sudo apt install mpg123` 或 `sudo apt install pulseaudio-utils`（提供 `paplay`） |
| Fedora / Arch | — | `sudo dnf install mpg123` / `sudo pacman -S mpg123` |
| 任意 | `ffplay` | 隨 `ffmpeg` 安裝 |

---

## 設定 `~/.claude/settings.json`

在 `hooks` 區塊註冊事件 → 對應腳本指令。完整路徑 + event name 作為第一個參數傳入。

本 repo 的 `sounds/` 已預置 5 個音檔：`Notification`、`PermissionDenied`、`PermissionRequest`、`Stop`、`TaskCompleted`。下方範例**全部對應這 5 個事件**——複製進去就能開箱即用。

> 提醒：`settings.json` 是 Claude Code 全域設定，跟其他設定（`env`、`permissions`、`statusLine` 等）並列在同一份檔案裡。**只新增 `hooks` 區塊**，不要覆寫整份；若已有 `hooks`，把下方 5 個 event 鍵合併進去即可。

### Windows 範例（開箱即用）

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<USER>/.claude/hooks/claude-hooks-sound/play-sound.ps1\" \"Stop\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<USER>/.claude/hooks/claude-hooks-sound/play-sound.ps1\" \"Notification\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<USER>/.claude/hooks/claude-hooks-sound/play-sound.ps1\" \"PermissionRequest\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "PermissionDenied": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<USER>/.claude/hooks/claude-hooks-sound/play-sound.ps1\" \"PermissionDenied\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<USER>/.claude/hooks/claude-hooks-sound/play-sound.ps1\" \"TaskCompleted\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ]
  }
}
```

> 把 `<USER>` 換成你自己的 Windows 使用者名稱；或全部改用 `$env:USERPROFILE` 也行（但 JSON 字面值不會展開變數，所以建議直接寫絕對路徑）。

### macOS / Linux 範例（開箱即用）

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$HOME/.claude/hooks/claude-hooks-sound/play-sound.sh\" \"Stop\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$HOME/.claude/hooks/claude-hooks-sound/play-sound.sh\" \"Notification\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$HOME/.claude/hooks/claude-hooks-sound/play-sound.sh\" \"PermissionRequest\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "PermissionDenied": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$HOME/.claude/hooks/claude-hooks-sound/play-sound.sh\" \"PermissionDenied\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$HOME/.claude/hooks/claude-hooks-sound/play-sound.sh\" \"TaskCompleted\"",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ]
  }
}
```

### 想擴充到 24 個全事件？

把所有事件一次掛起來、之後再慢慢補音檔也行——缺音檔的事件會自動靜音（`exit 0`），不影響運作。複製上方任一格式 → 替換 event name 與 mp3 檔名即可。完整事件列表見下方〈已掛載事件〉。

---

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
| `PermissionRequest` | 出現權限對話框 | `PermissionRequest.mp3` | O |
| `PermissionDenied` | 工具呼叫被自動模式拒絕 | `PermissionDenied.mp3` | O |

### Subagent / Task / Teammate

| Event | 觸發時機 | 音檔名稱 | 備檔 |
|-------|---------|----------|------|
| `SubagentStart` | Subagent 被啟動 | `SubagentStart.mp3` | - |
| `SubagentStop` | Subagent 完成任務回報 | `SubagentStop.mp3` | - |
| `TaskCreated` | 透過 `TaskCreate` 建立任務 | `TaskCreated.mp3` | - |
| `TaskCompleted` | 任務被標記完成 | `TaskCompleted.mp3` | O |
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

---

## 自行測試

不需重啟 Claude Code，直接呼叫腳本驗證音檔能不能播：

```powershell
# Windows
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File "$env:USERPROFILE\.claude\hooks\claude-hooks-sound\play-sound.ps1" "Stop"
```

```bash
# macOS / Linux
bash ~/.claude/hooks/claude-hooks-sound/play-sound.sh Stop
```

聽到聲音 = OK。沒聲音先檢查：

1. `<repo>/sounds/Stop.mp3` 存不存在
2. （macOS/Linux）`afplay` / `mpg123` / `ffplay` / `paplay` 至少一個有裝
3. （Windows）系統音量沒靜音、預設輸出裝置正常

---

## 新增事件

1. 在 `~/.claude/settings.json` 的 `hooks` 區塊加入新事件（複製現有格式，替換 event name）
2. 放入對應的 `{EventName}.mp3` 到 `<repo>/sounds/`

---

## 相關檔案

- 播放腳本（Windows）：`<repo>/play-sound.ps1`
- 播放腳本（macOS / Linux）：`<repo>/play-sound.sh`
- 音檔目錄：`<repo>/sounds/`
- Hook 設定：`~/.claude/settings.json` → `hooks`
