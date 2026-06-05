# Skill 层 — furina061006 的个性化知识库

## 什么是 Skill？

Skill 是 Claude Code 的**可复用指令模板**，定义了"如何做"（How）。当用户键入 `/skill-name` 时，对应的 Skill 被加载执行。

本目录的 Skill 围绕**学习笔记创作与知识管理**展开，服务于 furina061006 的个人知识库。

## 文件组织

```
skills/
├── README.md              # 本文件
└── note-taking-style/     # 笔记风格 Skill
    └── SKILL.md
```

## 文件命名规范

- 使用小写字母和连字符（kebab-case）
- Skill 目录格式：`{domain}-{action}`
- Skill 定义文件：`SKILL.md`

## 现有 Skill 列表

| Skill | 用途 | 使用场景 |
|-------|------|----------|
| `note-taking-style` | 模仿 furina061006 的个性化笔记风格 | 创建或扩写学习笔记时 |

## 如何创建新的 Skill

1. 在本目录创建新目录，遵循命名规范
2. 在目录内创建 `SKILL.md` 文件，必须包含：
   - **目标**：Skill 的核心目的
   - **使用场景**：何时使用此 Skill
   - **核心要素**：详细的行为规范
   - **调用方式**：如何让 AI 遵循

3. 更新本 README.md，将新 Skill 添加到列表

## 风格传承

本目录的所有 Skill 从 `note-taking-style` 继承基础风格：中文为主、口语化、有温度、有幽默感。

---

*创建于：2026-06-05*
