# 🧪 Skill 运营发现日志

> 每次遇到关于 Claude Code Skill 系统的新发现，就往这里记。

---

## 2026-06-05 — 初始建立：Skill 的正确注册方式

### 发现
Claude Code 的自定义 slash command skill 必须放在**项目根目录的 `.claude/skills/`** 下，而不是 `note-taking_copilot/skills/`。

### 正确路径
```
项目根目录/.claude/skills/<skill-name>/SKILL.md
```

### 关键规则
- **自动注册**：放对位置 + 有 YAML frontmatter（`name`、`description`），Claude 自动识别
- **无需 settings.json 配置**
- **需要新建会话**才能生效（老会话里不会检测到新加的 skill）
- 验证方式：新会话里输入 `/skills` 查看列表

### 两个有效路径
| 范围 | 路径 |
|------|------|
| 项目级 | `.claude/skills/<name>/SKILL.md` |
| 用户级（全局） | `~/.claude/skills/<name>/SKILL.md` |

### SKILL.md 支持的前置字段
| 字段 | 用途 |
|------|------|
| `name` | slash command 名称（全小写，连字符，≤64字符） |
| `description` | 自动补全时显示；用于自动匹配 |
| `user-invocable` | `false` 则隐藏不从 `/` 菜单显示（默认 `true`） |
| `disable-model-invocation` | `true` 则阻止 Claude 自动调用 |
| `argument-hint` | 自动补全时的提示文本，如 `[filename]` |
| `arguments` | 命名位置参数，用于 `$name` 替换 |
| `allowed-tools` | 免许可允许的工具列表 |
| `model` | 覆盖模型：`haiku`/`sonnet`/`opus` |
| `effort` | 努力级别：`low`/`medium`/`high`/`xhigh`/`max` |
| `context` | 设为 `fork` 则在独立 subagent 中运行 |
| `paths` | Glob 模式，限定 skill 何时自动激活 |

---



---

## 2026-06-06 — Pre-push hook 保护本地目录不被推送到远程

### 发现
`.claude/` 和 `note-taking_copilot/` 需要本地 git 提交（方便版本管理），但不能误推到 GitHub。

### 解决方案
使用 `.git/hooks/pre-push` hook，在 `git push` 时自动拦截。
- 备份脚本位置：`note-taking_copilot/scripts/pre-push-hook.sh`
- 绕过方式：`git push --no-verify origin main`

### 注意事项
- `.git/hooks/` 不被 git 跟踪，重装仓库后 hook 会丢失
- 新克隆仓库后需手动将备份脚本复制到 `.git/hooks/pre-push` 并 `chmod +x`

### 验证方法
```bash
printf "refs/heads/main <sha> refs/heads/main <sha>" | bash .git/hooks/pre-push
echo "EXIT CODE: $?"  # 0=放行, 1=拦截
```

---

## 2026-06-06 — Git 工作流规则：保护目录必须分开 commit

### 规则（以后 AI 自动执行）
当需要同时修改**受保护目录**和**普通目录**时，必须拆分成两个 commit：

**Step 1** — 暂存并提交普通文件（笔记、NEUP 等）：
```bash
git add C语言杂项笔记.md NEUP/  # 等普通文件
git commit -m "update: xxx"
git push                            # ✅ 放行
```

**Step 2** — 暂存并提交保护目录（仅本地）：
```bash
git add .claude/ note-taking_copilot/
git commit -m "update: xxx"
git push                            # ❌ hook 拦截，留在本地
```

### 受保护目录列表
| 目录 | 原因 |
|------|------|
| `.claude/` | Claude Code 技能和配置 |
| `note-taking_copilot/` | AI 协作配置和 skill 文档 |

### 如果搞混了怎么办
如果不小心合在了一个 commit 里且还没 push：
```bash
git reset --soft HEAD~1                # 撤销 commit，改动保留在 stage
git restore --staged .claude/ note-taking_copilot/  # 取出保护目录
git commit -m "普通改动"                # 先提交普通文件
git push
git add .claude/ note-taking_copilot/
git commit -m "本地改动"                # 再提交本地文件
```
