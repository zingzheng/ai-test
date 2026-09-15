# 第 9 章 工具链与可观测性

> **一句话结论**：工具链不是"买一个平台就完事"，而是把 offline eval（发布前把关）和 online eval（生产监控）两条轨道，用 dataset / experiment / evaluator 三件套串成闭环；选型的关键不在功能列表（各家高度同质），而在**能否自托管、是否 OTel 原生、是否 agent 专精、prompt 管理是否顺手**。

---

> 前几章讲的是"怎么评"和"评什么"，本章回答工程上绕不开的一问：**这些东西用什么来管？** 一个能被反复执行、能被追溯、能进 CI 的评测体系，必须要有 trace 采集、数据集管理、实验编排与生产监控的支撑。这一章建立工具链地图，并记住两个动态：Humanloop 退场、OTel GenAI 独立成库。

## 9.1 为什么需要工具链：offline vs online，三件套

评测在生产环境里是两条轨道：

- **offline eval（发布前）**：在固定 dataset 上跑实验，比较新旧版本，作为上线门禁。
- **online eval（生产监控）**：在真实流量上持续打分，捕捉离线看不见的分布漂移与长尾失败。

这个划分正是 LangSmith 的组织方式——它还列出 evaluator 的几种形态（人类 / 代码 / LLM-as-judge / pairwise）与 tracing、Studio 等配套，并支持 cloud / hybrid / self-hosted 部署。

> 来源：[LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — ✅

不管选哪家，抽象出来的核心都是**三件套**：

| 概念 | 作用 |
|---|---|
| **dataset** | 评测用例的集合，含 input、期望输出、元数据；来源可以是人工构造，也可以是回灌的真实 trace |
| **experiment** | 一次评测运行：某版本（prompt / 模型 / 代码）+ 某 dataset + 某 evaluator，产出可对比的分数 |
| **evaluator** | 打分器：代码断言、LLM judge、人工标注，或 pairwise 比较 |

Langfuse 用一个"AI Engineering Loop"（Trace→Monitor→Dataset→Experiment→Evaluate）把这条闭环讲得更清楚：online/offline 评测、annotation queue、code/LLM evaluator、Score Analytics，实验还可经 OTel 执行。更进一步，评测可以进 CI：Langfuse 提供 `experiment-action`，在 `pull_request` 上跑实验，用 **approved baseline** 做逐 case 的 pass/fail 门禁，回归时抛 `RegressionError` 让 CI 失败。开源侧的 promptfoo 也走同一思路，用声明式 YAML 定义测试用例并接入 CI/CD（GitHub Action）。

> 来源：[Langfuse Evaluation Overview](https://langfuse.com/docs/evaluation/overview) — ✅
> 来源：[Langfuse CI/CD](https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd) — ✅
> 来源：[promptfoo](https://www.promptfoo.dev/docs/intro/) — ✅

迁移到工具上，第 2 章那张漏斗图就变成了：**离线跑实验 → judge 规模化 → 人工校准 → 上线 A/B + 持续监控**。

## 9.2 六款主流工具对照

工具同质化很严重，差异点集中在四维度上：

| 工具 | 定位 | 开源 / 自托管 | OTel 原生 | agent 专精 | prompt 管理 |
|---|---|---|---|---|---|
| [LangSmith](https://docs.langchain.com/langsmith/evaluation) | LangChain 官方评测+观测 | 支持 self-hosted（cloud/hybrid/self-hosted） | — | 覆盖 agent tracing | 有（Studio） |
| [Langfuse](https://langfuse.com/docs/evaluation/overview) | 开源 AI 工程闭环 | **开源可自托管** | 实验可经 OTel 执行 | 支持 | 有 |
| [Arize Phoenix](https://arize.com/docs/phoenix) | 开源观测+评测 | **开源**（Docker/K8s）；企业版 Arize AX | **构建在 OTel + OpenInference 上** | 支持 | Prompt Playground |
| [W&B Weave](https://weave-docs.wandb.ai/) | W&B 的观测+评测 | — | **OTel-compatible SDK** | 支持 | 有 |
| [Braintrust](https://www.braintrust.dev/docs) | agent「active observability」 | — | — | **面向 agent**，`autoevals` 预置 scorer | 有 |
| [PromptLayer](https://docs.promptlayer.com/introduction) | Prompt 管理+观测+evals | **支持 self-hosting、MCP** | **支持 OpenTelemetry** | — | **Prompt Registry** |

记住一句话选型口诀：**要完全掌控数据就走开源自托管（Langfuse / Phoenix）；要标准化、怕被厂商锁定就看 OTel 支持（Phoenix / Weave / PromptLayer）；做 agent 优先看行为追踪深度（Braintrust）；prompt 资产重就重点看 PromptLayer。**

## 9.3 Humanloop：一个选型风险案例

工具链选型有一条容易被忽视的风险：**供应商退场**。Humanloop 首页曾贴出公告「As we sunset the Humanloop platform」——团队加入了 Anthropic，平台正在 sunset，其 `/docs` 路径也已 404。

> 来源：[Humanloop](https://humanloop.com/) — ✅（团队加入 Anthropic，平台正在 sunset；`/docs` 为 ❌ 404）

教训很直接：

- 评测平台会沉淀你的 dataset、trace、prompt 等**长期资产**，供应商一退场，迁移成本极高；
- 因此"是否开源可自托管""数据能否导出""是否基于开放标准"不是加分项，而是**风险对冲项**。

这也是 9.2 里把"开源/OTel"单列为关键维度的原因。

## 9.4 可观测性标准：OTel GenAI 与 OpenInference

要让 trace 在不同厂商之间可移植，得有统一语义。两块拼图：

- **OTel GenAI Semantic Conventions**：用统一的 span/metric/event 语义描述 LLM 调用、工具调用、检索与 MCP，并覆盖 GenAI client 与 provider-specific（如 OpenAI）。**2025 年起它从主 semconv 拆分为独立仓库**，这是 2026 年最重要的标准化动态之一。OTel 官方的 GenAI semconv 页面已迁移，只剩跳转提示。
- **OpenInference（Arize）**：一套与 OTel **互补**的 AI tracing 约定加 instrumentation，覆盖 OpenAI / Anthropic / Bedrock / LangChain / LlamaIndex / DSPy / MCP / agno 等。

> 来源：[OTel GenAI semconv 入口（已迁移）](https://opentelemetry.io/docs/specs/semconv/gen-ai/) — ⚠️
> 来源：[semantic-conventions-genai 仓库](https://github.com/open-telemetry/semantic-conventions-genai) — ✅
> 来源：[OpenInference](https://github.com/Arize-ai/openinference) — ✅

一个实用判断：**看一个评测/观测平台是否"标准友好"，第一条就看它能不能吐出 OTel 兼容的 trace。**

## 9.5 为什么说"trace 即评测数据源"

系统的真实行为都记录在 trace 里——每一次 LLM 调用、工具调用、检索、失败重试。这意味着评测数据不必凭空造：

- **从生产 trace 回灌 dataset**：把线上真实请求（尤其是失败、异常、用户反馈差的样本）抽成评测用例，是最高信噪比的数据来源；
- **Hamel Husain 的 L1–L3** 明确要求"先 logging traces，再看数据"，并把"移除一切看数据的摩擦"当作第一原则——trace 是这条路径的入口；
- **可复现性**是评测可信度的基础。《AI Agents That Matter》批评成本被忽略、holdout 不足导致过拟合走捷径，并使用了"pervasive lack of reproducibility"这一提法作为锚点。

> 来源：[Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — ✅
> 来源：[AI Agents That Matter](https://arxiv.org/abs/2407.01502) — ✅

**闭环**：trace（真实行为）→ dataset（固化用例）→ experiment（跑分）→ evaluator（打分）→ 回到 online eval 持续监控。工具链的价值，就是让这个环转得足够便宜、足够快，以至于团队真的愿意一直转下去。

---

## 本章要点

- offline eval 管发布前门禁，online eval 管生产真实流量，两条轨道都要有。
- 一切平台都可抽象为 dataset / experiment / evaluator 三件套；评测可进 CI，用逐 case baseline 门禁挡回归。
- 六款工具高度同质，选型看四维：开源可自托管、OTel 原生、agent 专精、prompt 管理。
- Humanloop 团队加入 Anthropic、平台 sunset，提醒我们把"开源/可导出/开放标准"当风险对冲。
- OTel GenAI semconv 已于 2025 起独立成库，OpenInference 与之互补；标准友好的平台应能吐出 OTel trace。
- trace 是最佳评测数据源：生产真实行为 → 回灌 dataset → 实验 → 监控，形成闭环。

## 来源

- [LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — 访问 2026-09-15 — ✅ — offline vs online eval、evaluator、tracing、Studio
- [Langfuse Evaluation Overview](https://langfuse.com/docs/evaluation/overview) — 访问 2026-09-15 — ✅ — AI Engineering Loop、annotation queue、Score Analytics
- [Langfuse CI/CD](https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd) — 访问 2026-09-15 — ✅ — experiment-action、RegressionError、approved baseline
- [promptfoo](https://www.promptfoo.dev/docs/intro/) — 访问 2026-09-15 — ✅ — 开源声明式 YAML、GitHub Action、red-teaming
- [Arize Phoenix](https://arize.com/docs/phoenix) — 访问 2026-09-15 — ✅ — 构建在 OTel + OpenInference 之上
- [W&B Weave](https://weave-docs.wandb.ai/) — 访问 2026-09-15 — ✅ — OTel-compatible SDK
- [Braintrust](https://www.braintrust.dev/docs) — 访问 2026-09-15 — ✅ — agent active observability、autoevals
- [PromptLayer](https://docs.promptlayer.com/introduction) — 访问 2026-09-15 — ✅ — Prompt Registry、OpenTelemetry、self-hosting、MCP
- [Humanloop](https://humanloop.com/) — 访问 2026-09-15 — ✅ — 团队加入 Anthropic，平台 sunset（`/docs` ❌ 404）
- [OTel GenAI semconv 入口](https://opentelemetry.io/docs/specs/semconv/gen-ai/) — 访问 2026-09-15 — ⚠️ — 页面已迁移，仅剩跳转
- [semantic-conventions-genai](https://github.com/open-telemetry/semantic-conventions-genai) — 访问 2026-09-15 — ✅ — GenAI 语义约定，2025 起独立仓库
- [OpenInference](https://github.com/Arize-ai/openinference) — 访问 2026-09-15 — ✅ — 与 OTel 互补的 AI tracing 约定
- [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — 访问 2026-09-15 — ✅ — 先 logging traces 再看数据
- [AI Agents That Matter](https://arxiv.org/abs/2407.01502) — 访问 2026-09-15 — ✅ — 成本、holdout、可复现性
