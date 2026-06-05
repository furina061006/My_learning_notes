# AGENTS.md — 知识库入口地图

## 本目录是什么？

`note-taking_copilot/` 是 furina061006 个人知识库的**AI 协作配置目录**。它负责告诉 AI：
- 笔记的主人是什么风格
- 笔记是如何组织的
- AI 在协助记笔记时应遵循什么规范

---

## 核心原则

1. **风格一致**：所有笔记遵循 `skills/note-taking-style/SKILL.md` 定义的个人风格
2. **知识积累**：笔记是持续积累的过程，不是一次性的文档
3. **坦诚为美**：不懂就不懂，标注出来，以后补充

---

## 目录结构

```
note-taking-copilot/
├── AGENTS.md              # 本文件 — 入口地图
├── README.md              # 项目说明
├── skills/                # AI Skill 定义
│   ├── README.md          # Skill 目录说明
│   └── note-taking-style/ # 笔记风格 Skill
│       └── SKILL.md
├── references/            # 参考资料索引
│   ├── MESSAGE.md
│   ├── repo/
│   └── docs/
└── docs/                  # 文档目录
    └── memory/            # 记忆归档
```

---

## 可用 Skill

| Skill | 用途 | 触发方式 |
|-------|------|----------|
| `note-taking-style` | 模仿 furina061006 的笔记风格创作内容 | `/note-taking-style` |

---

## 笔记文件分布

- **根目录** `My_markdown_files/`：主要笔记文件
  - `C语言杂项笔记.md`
  - `stm32硬件与keil5软件的学习笔记.md`
  - `linux命令行.md`
  - `计算机组成原理笔记.md`
  - `寒假补完计划.md`
- **NEUP/**：东北大学相关材料
  - `Build_Process/markdowns/`：例会材料、分享文档

---

*最后更新：2026-06-05*
