# 第 12 章 持续评测：把 eval 接进 CI/CD

> **一句话结论**：把 eval 当成"测试套件"接进 CI，用**逐用例回归门禁 + 基线快照**把质量回退挡在合并之前；离线门禁负责快速拦截，在线 A/B 负责最终裁决。

---

> 本章面向测试开发背景的读者。核心心态只有一句：**评测即测试**。你不需要推翻已有的 CI 直觉——分支保护、PR 门禁、回归用例、baseline 比对——只要把被测对象从"函数"换成"模型输出与 Agent 轨迹"。

## 12.1 为什么评测要进 CI：把"质量回退"当回归 bug 挡在合并前

改一个 prompt、换一个模型、调一次检索参数，都可能悄悄让原本正确的用例变错。这类"质量回退"和代码里的回归 bug 没有本质区别，却常常因为"没人跑评测"而溜到线上。

Anthropic 在讲 Agent 评测时，把 eval 明确分成两类：**capability evals**（探索"能不能做到"）和 **regression evals**（守住"别退化"）。后者天生属于 CI——它要求稳定、可重复、快速反馈，正是回归测试的定位。

> 来源：[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)（Anthropic, 2026-01-09）— ✅

## 12.2 promptfoo：声明式 YAML 用例 + 内置红队

promptfoo 是一个开源 CLI/库，把测试用例写成**声明式 YAML**，用 CLI 或 library 方式运行，并提供 **GitHub Action** 直接嵌入 CI/CD；它还内置 **red-teaming 与 guardrails**，能在同一条流水线里顺带跑安全用例。

> 来源：[promptfoo 官方文档](https://www.promptfoo.dev/docs/intro/) — ✅

对测试开发来说，它最亲切的一点是：断言（assert）就是你熟悉的模式——包含某字段、匹配某正则、或交给模型/自定义 scorer 判定。

## 12.3 Langfuse experiment-action：PR 里跑实验，失败即红

Langfuse 提供 `langfuse/experiment-action`：在 `pull_request` 事件上跑 experiment，一旦发现回归就抛 `RegressionError`，**让 CI 直接失败**。它最关键的设计是 **approved baseline 机制**——比对是**逐 case 的 pass/fail**，而不是只看一个平均分。

> 来源：[Langfuse CI/CD 文档](https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd) — ✅

为什么这点重要在 12.4 展开。此外，离线实验可与在线观测打通，Langfuse 以 Trace→Monitor→Dataset→Experiment→Evaluate 组织这套闭环。

> 来源：[Langfuse Evaluation Overview](https://langfuse.com/docs/evaluation/overview) — ✅

## 12.4 回归门禁怎么设计：逐用例 vs 只看均值

只看均值是最常见的反模式：10 条用例里 3 条变错、3 条变好，均值不动，门禁就放过了回归。正确做法是**逐用例比对 baseline**：记录每条用例上一次通过的状态，新提交里任何一条"从 pass 变 fail"都应让门禁变红。这正是 Langfuse approved baseline 的做法（12.3）。

阈值设计还要留出**噪声余量**。Anthropic 的实测显示，仅资源配额变化就能让 Terminal-Bench 2.0 分数摆动约 **6pp**（p<0.01），超过头部模型之间的差距；因此他们建议同时声明 floor 与 ceiling，并对 **<3pp 的排行差异存疑**。门禁阈值也应据此设定，避免把噪声当回归。

> 来源：[Infrastructure Noise](https://www.anthropic.com/engineering/infrastructure-noise)（Anthropic, 2026-02-05）— ✅

门槛还应**按风险校准**：不同任务用不同严格度，而非一套阈值通吃。

> 来源：[Task-Specific LLM Evals that Do & Don't Work](https://eugeneyan.com/writing/evals/)（Eugene Yan）— ✅

## 12.5 离线门禁与在线 A/B 的配合

第 2 章强调过：**离线涨分不等于线上变好**，离线指标只是代理指标。因此 CI 门禁与在线实验是分工而非替代：

- **离线门禁（CI）**：便宜、快、可重复，负责"挡住退化"。LangSmith 等平台把它称为 **offline eval（发布前）**。
- **在线 A/B**：真实流量上的最终裁判，负责回答"到底有没有用"。

> 来源：[LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — ✅
> 来源：[Trustworthy Online Controlled Experiments](https://experimentguide.com/)（Kohavi et al.）— ✅

一个实用节奏是：离线门禁是"合并前必过"，A/B 是"上线后验证"；门禁通过 ≠ 可以全量，仍应小流量实验。

## 12.6 Hamel Husain 的 L1「单元测试级评测」为什么必须高频跑

Hamel Husain 把评测分成三层：**L1 单元测试**（pytest 式断言，能在 CI 里频繁执行）→ L2 人类 + 模型 eval → L3 A/B。他强调 L1 的价值在于**低成本、可常跑**，用来挡住低级回归；同时提醒"移除一切看数据的摩擦""不要迷信通用框架"。

> 来源：[Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/)（Hamel Husain）— ✅

这类"LLM 版 Pytest"的工具体验也被同类框架延续，例如 DeepEval 就自称"LLM 版的 Pytest"。

> 来源：[DeepEval 仓库](https://github.com/confident-ai/deepeval) — ✅

## 12.7 一个最小 CI 评测流水线（文字流程）

```
开发者提交 PR
   │
   ▼
① 触发 CI（GitHub Action）
   │
   ▼
② 装依赖 → 拉取 eval 数据集 + baseline 快照
   │
   ▼
③ 运行评测：promptfoo（YAML 用例 + 红队）
   │           或 Langfuse experiment-action
   │
   ▼
④ 逐用例比对 baseline（pass→fail 即回归）
   │
   ├── 有回归 / 低于阈值 → 抛 RegressionError → CI 红 → 阻断合并
   │
   └── 全通过 → CI 绿 → 允许合并
   │
   ▼
⑤ 合并上线 → 小流量在线 A/B 继续验证
```

其中"把 evals 放进 CI/CD"也是 OpenAI 官方 Cookbook 明确演示的用法，可作为对照参考。

> 来源：[OpenAI Evals Cookbook](https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals) — ✅
> 来源：[OpenAI Evals 仓库](https://github.com/openai/evals) — ✅

---

## 本章要点

- 评测即测试：prompt/模型/检索改动造成的"质量回退"就是回归 bug，应在合并前挡住；对应 Anthropic 的 regression evals。
- promptfoo 提供声明式 YAML 用例、CLI/library、GitHub Action 与内置 red-teaming，适合直接进 CI。
- Langfuse experiment-action 在 PR 上跑 experiment，抛 `RegressionError` 让 CI 失败，核心是 **approved baseline 逐 case 比对**。
- 门禁必须逐用例而非只看均值；阈值要留噪声余量（<3pp 差异应存疑），并按风险校准。
- 离线门禁负责"挡退化"，在线 A/B 才是"最终裁决"；门禁通过仍应小流量实验。
- Hamel Husain 的 L1 单元测试级评测因低成本、可常跑，必须高频执行。

## 来源

- [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅ — capability vs regression evals
- [promptfoo 官方文档](https://www.promptfoo.dev/docs/intro/) — 访问 2026-09-15 — ✅ — YAML 用例 / CI/CD / 红队
- [Langfuse CI/CD 文档](https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd) — 访问 2026-09-15 — ✅ — experiment-action / RegressionError / approved baseline
- [Langfuse Evaluation Overview](https://langfuse.com/docs/evaluation/overview) — 访问 2026-09-15 — ✅ — AI Engineering Loop
- [Infrastructure Noise](https://www.anthropic.com/engineering/infrastructure-noise) — 访问 2026-09-15 — ✅ — 分数摆动 6pp、<3pp 存疑
- [Task-Specific LLM Evals that Do & Don't Work](https://eugeneyan.com/writing/evals/) — 访问 2026-09-15 — ✅ — 按风险校准门槛
- [LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — 访问 2026-09-15 — ✅ — offline vs online eval
- [Trustworthy Online Controlled Experiments](https://experimentguide.com/) — 访问 2026-09-15 — ✅ — 在线 A/B 专著
- [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — 访问 2026-09-15 — ✅ — L1/L2/L3 三层评测
- [DeepEval 仓库](https://github.com/confident-ai/deepeval) — 访问 2026-09-15 — ✅ — LLM 版 Pytest
- [OpenAI Evals Cookbook](https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals) — 访问 2026-09-15 — ✅ — evals 进 CI/CD
- [OpenAI Evals 仓库](https://github.com/openai/evals) — 访问 2026-09-15 — ✅ — JSONL + YAML eval 模板
