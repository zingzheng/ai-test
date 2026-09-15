# 第 6 章 应用级测评（下）：Agent 怎么测

> **一句话结论**：Agent 测评测的不是"答对没有"，而是"在真实环境里行动得对不对、花得值不值、稳不稳"——任务成败只是其中一格，过程、工具调用、成本与可靠性必须一起看。

---

> 上一章讲 RAG，本质仍是"给一段输入、看一段输出"。Agent 不一样：它会**自己决定下一步做什么**，会调用工具、修改环境、和用户来回多轮。这类系统的评测难题，几乎全部来自这一个差异。

## 6.1 从"答题"到"行动"：新难题从哪来

静态 QA 的评分很干净：答案对或错。Agent 引入了四层新变量，每一层都能让结论失真：

- **环境（environment）**：任务发生在可写的世界里（代码仓库、网页、操作系统），最终状态才是判据，而不是文本输出。
- **工具（tools）**：Agent 通过 API 或命令行行动，调用顺序、参数、是否该调用，都会影响结果。
- **多轮（multi-turn）**：交互轮数不固定，早期一步走错可能后面全崩。
- **长程（long-horizon）**：一个任务可能几十步，错误会累积，成功与否带强随机性。

由此，评测的核心指标从"答案准确率"变成**执行式任务成功率（task success rate）**：多数基准直接比对任务的**最终状态**，而非 Agent 说了什么（τ-bench 家族即比对对话结束时数据库状态与标注目标状态）。

> 来源：[τ-bench 论文](https://arxiv.org/abs/2406.12045)

## 6.2 按域看代表基准

Agent 的"域"差别太大，很难有一个通用考卷。下表按任务场景给出代表性基准。

| 域 | 代表基准 | 核心内容 |
|---|---|---|
| 代码 | **SWE-bench** / **SWE-bench Verified** | 2,294 个真实 GitHub issue（12 个 Python 仓库），改代码让 FAIL_TO_PASS / PASS_TO_PASS 通过；Verified 是与 OpenAI 合作人工筛选的 **500 题**子集 |
| ML 工程 | **MLE-bench** | 从 Kaggle 精选 **75 个 ML 竞赛**，评测端到端 ML 工程能力 |
| 网页 | **WebArena** | 4 类真实网站环境（电商/论坛/协作开发/CMS）的端到端网页任务 |
| 电脑操作 | **OSWorld** | 真实 Ubuntu/Windows/macOS 环境，369 个跨应用任务、执行式评估 |
| 通用助理 | **GAIA** | 466 道"对人类简单、对 AI 难"的真实问题，需推理+多模态+浏览+工具 |
| 工具-用户对话 | **τ³-bench** | 用 LLM 模拟用户，评测多轮对话中调用 API、遵守业务规则；**pass^k** 由原 τ-bench 提出、τ³ 沿用 |
| 多环境综合 | **AgentBench** / **AgentBoard** | 8 个交互环境评测 LLM-as-Agent；AgentBoard 强调细粒度 **progress rate** |
| 成本敏感榜单 | **HAL**（Holistic Agent Leaderboard） | 标准化 harness + 榜单，默认纳入**成本** |

一个值得记住的量级：WebArena 论文中最佳 GPT-4 agent 仅 **14.41%**，人类 **78.24%**；OSWorld 人类 **72.36%**、最佳模型 **12.24%**。这说明这些基准离"解决"还很远，也说明随手上线一个 Agent 的风险有多大。

> 来源：[SWE-bench 论文](https://arxiv.org/abs/2310.06770)、[SWE-bench 官网](https://swebench.com/)、[SWE-bench Verified](https://www.swebench.com/verified.html)、[MLE-bench 论文](https://arxiv.org/abs/2410.07095)、[WebArena 论文](https://arxiv.org/abs/2307.13854)、[OSWorld 论文](https://arxiv.org/abs/2404.07972)、[GAIA 论文](https://arxiv.org/abs/2311.12983)、[τ³-bench 仓库](https://github.com/sierra-research/tau2-bench)、[AgentBench 论文](https://arxiv.org/abs/2308.03688)、[AgentBoard 论文](https://arxiv.org/abs/2401.13178)、[HAL 论文](https://arxiv.org/abs/2510.11977)

**τ³-bench 的命名需要特别说明**：最初它叫 **τ-bench**，原仓库 `sierra-research/tau-bench` **已废弃**，**现役代码是 `tau2-bench`**。τ² 是 Dual-Control 版本（agent 与用户都能操作共享世界，新增 Telecom 域），τ³ 是当前版本，新增 banking / banking_knowledge 域、voice 全双工等。本章统一用 **τ³-bench** 这个名字。

> 来源：[τ²-bench 论文](https://arxiv.org/abs/2506.07982)、[τ³-bench 仓库](https://github.com/sierra-research/tau2-bench)、[实时榜 taubench.com](https://taubench.com)

## 6.3 不只看成功率：四个必须一起报的维度

**只看 task success rate 会得出危险结论**。成熟做法至少补四项：

- **轨迹评估（trajectory evaluation）与 progress rate**：把整条操作序列当评分对象，刻画每一步的增量进展，而不是只在最后判定生死。AgentBoard 是这方面的代表。
- **工具调用正确性（tool-call correctness）**：工具是否被正确选择、参数是否正确。RAGAS 提供 Tool Call Accuracy / Tool Call F1；DeepEval 有 Tool Correctness / Argument Correctness；TruLens 有 ToolSelection / ToolCalling / ToolQuality。
- **成本与延迟（cost & latency）**：同一成功率可能对应 10 倍成本。HAL 把成本作为一等指标，是成本敏感评测的标杆。动机可参考《AI Agents That Matter》。
- **pass^k 可靠性**：同一任务重复 k 次**全部**成功的概率，衡量"稳定"而非"碰运气"。τ-bench 给出过 retail 域上 GPT-4o 从 pass^1=0.604 掉到 pass^4=0.383 的例子——单次跑分漂亮，重复跑就露馅。

> 来源：[AgentBoard 论文](https://arxiv.org/abs/2401.13178)、[RAGAS 指标文档](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/)、[DeepEval 指标文档](https://docs.confident-ai.com/docs/metrics-introduction)、[TruLens 仓库](https://github.com/truera/trulens)、[HAL 论文](https://arxiv.org/abs/2510.11977)、[AI Agents That Matter](https://arxiv.org/abs/2407.01502)、[τ-bench 论文](https://arxiv.org/abs/2406.12045)（pass^k 与上述 retail 数据出处）

## 6.4 组件级 vs 端到端

和 RAG 一章的逻辑一致，Agent 也有两条评估路线：

- **组件级（component-level）**：分别评测规划、工具选择、参数生成等环节。优点：**归因精确、便宜、可回归**；缺点：无法反映真实交互效应。
- **端到端（end-to-end）**：把整个 Agent 当黑盒，只看任务成败。优点：贴近真实价值；缺点：**贵、难归因、受脚手架与环境的噪声干扰**。

务实做法是两者并用：组件级用于快速定位和回归门禁，端到端用于守住"最终到底行不行"。DeepEval 明确同时支持两者；TruLens 用 RAG Triad + OTel span 把"每个环节"和"整条链"都打分，是打通两端的教学案例。

> 来源：[DeepEval 仓库](https://github.com/confident-ai/deepeval)、[TruLens RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/)、[Anthropic: Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)

## 6.5 时效地图（用前必查）

Agent 评测领域更新极快，引用榜单前务必核对现状：

| 项目 | 现状 |
|---|---|
| τ-bench 原仓库 | **已废弃** → 现役 **τ³-bench**（`sierra-research/tau2-bench`，taubench.com 有实时榜） |
| HAL harness | **2026-07-01 归档**，停止接收新提交、榜单暂停更新，团队转向 agent reliability |
| SWE-bench 仓库 | 从 `princeton-nlp` **迁至 `SWE-bench` 组织** |
| SWE-bench Verified | 现役维护方 = SWE-bench 团队，榜首提供 **bash-only（mini-SWE-agent）** 对比 |
| τ³-bench v1.0.1 | 2026-07 修复 banking_knowledge 评分，**旧结果不可比** |

**原则**：引用任何分数都注明版本与日期，跨版本比较要先确认评分逻辑没变。

> 来源：[τ³-bench 仓库](https://github.com/sierra-research/tau2-bench)、[SWE-bench 仓库](https://github.com/SWE-bench/SWE-bench)、[HAL 官网](https://hal.cs.princeton.edu/)

## 6.6 方法论总纲

如果想系统建立 Agent 评测的方法论，首选综述《Survey on Evaluation of LLM-based Agents》。它从核心能力、应用级基准、通用 agent、基准维度、评测框架五个视角梳理，并明确指出 **cost-efficiency、safety、robustness** 是当前最大的空白。

> 来源：[Survey on Evaluation of LLM-based Agents](https://arxiv.org/abs/2503.16416)

---

## 本章要点

- Agent 引入了环境、工具、多轮、长程四层新变量，主指标从"答案对错"变成执行式任务成功率。
- 按域选基准：代码 SWE-bench(Verified) / MLE-bench、网页 WebArena、电脑 OSWorld、助理 GAIA、对话 τ³-bench、多环境 AgentBench / AgentBoard、成本榜 HAL。
- 成功率之外必须报：progress rate、工具调用正确性、成本与延迟、pass^k。
- 组件级负责归因与回归，端到端负责守最终价值，两者并用。
- 引用前先查时效：τ-bench 原仓库已废弃、HAL 已归档、SWE-bench 已迁仓。
- 方法论总纲见 arXiv 2503.16416。

## 来源

- [Survey on Evaluation of LLM-based Agents](https://arxiv.org/abs/2503.16416) — 访问 2026-09-15 — ✅ — 方法论总纲
- [SWE-bench 论文](https://arxiv.org/abs/2310.06770) — 访问 2026-09-15 — ✅
- [SWE-bench 官网](https://swebench.com/) — 访问 2026-09-15 — ✅
- [SWE-bench Verified](https://www.swebench.com/verified.html) — 访问 2026-09-15 — ✅
- [SWE-bench 仓库（SWE-bench 组织）](https://github.com/SWE-bench/SWE-bench) — 访问 2026-09-15 — ✅ — 迁仓说明
- [MLE-bench 论文](https://arxiv.org/abs/2410.07095) — 访问 2026-09-15 — ✅
- [WebArena 论文](https://arxiv.org/abs/2307.13854) — 访问 2026-09-15 — ✅
- [OSWorld 论文](https://arxiv.org/abs/2404.07972) — 访问 2026-09-15 — ✅
- [GAIA 论文](https://arxiv.org/abs/2311.12983) — 访问 2026-09-15 — ✅
- [τ-bench 论文](https://arxiv.org/abs/2406.12045) — 访问 2026-09-15 — ✅ — pass^k 出处
- [τ²-bench 论文](https://arxiv.org/abs/2506.07982) — 访问 2026-09-15 — ✅
- [τ³-bench 仓库（tau2-bench）](https://github.com/sierra-research/tau2-bench) — 访问 2026-09-15 — ✅ — 现役代码
- [taubench.com 实时榜](https://taubench.com) — 访问 2026-09-15 — ✅
- [AgentBench 论文](https://arxiv.org/abs/2308.03688) — 访问 2026-09-15 — ✅
- [AgentBoard 论文](https://arxiv.org/abs/2401.13178) — 访问 2026-09-15 — ✅ — progress rate
- [HAL 论文](https://arxiv.org/abs/2510.11977) — 访问 2026-09-15 — ✅ — 成本敏感
- [HAL 官网](https://hal.cs.princeton.edu/) — 访问 2026-09-15 — ✅ — 已归档状态
- [AI Agents That Matter](https://arxiv.org/abs/2407.01502) — 访问 2026-09-15 — ✅ — 成本与可复现性
- [RAGAS 指标文档](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/) — 访问 2026-09-15 — ✅ — Tool Call Accuracy/F1
- [DeepEval 指标文档](https://docs.confident-ai.com/docs/metrics-introduction) — 访问 2026-09-15 — ✅ — Tool Correctness / Argument Correctness
- [DeepEval 仓库](https://github.com/confident-ai/deepeval) — 访问 2026-09-15 — ✅ — 组件级 + 端到端
- [TruLens 仓库](https://github.com/truera/trulens) — 访问 2026-09-15 — ✅ — Agent 专用评估器
- [TruLens RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/) — 访问 2026-09-15 — ✅ — 组件↔端到端
- [Anthropic: Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅
