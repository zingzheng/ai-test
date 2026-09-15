# 调研报告 02 · 应用级测评（RAG 与 Agent）

> 调研日期：2026-09-15
> 方法：curl 批量探测状态码 + webfetch 实读关键页确认内容
> 重要时效提醒：
> - `sierra-research/tau-bench` 原仓库**已废弃**，现役是 **[τ³-bench](https://github.com/sierra-research/tau2-bench)**（taubench.com 有实时榜）。
> - **HAL harness 已于 2026-07-01 归档**，不再更新榜单，团队转向 agent reliability。
> - **SWE-bench 仓库已从 `princeton-nlp` 迁到 [`SWE-bench` 组织](https://github.com/SWE-bench/SWE-bench)**。

---

## 一、RAG 测评

### 1.1 RAGAS
- **论文**：✅ https://arxiv.org/abs/2309.15217（v2 于 2025-04-28 修订）——reference-free（无需人工标注答案）的 RAG 评测框架，覆盖检索质量与生成忠实度多个维度。
- **官方文档（指标总览）**：✅ https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/ ——RAG 指标（Context Precision / Context Recall / Context Entities Recall / Noise Sensitivity / Response Relevancy / Faithfulness）、**Agents/Tool-use 指标**（Tool Call Accuracy、Tool Call F1、Agent Goal Accuracy、Topic adherence）、通用指标（Aspect Critic、Rubrics based scoring）。说明 RAGAS 已从纯 RAG 扩展到 Agent 评测。
- **四个核心 RAG 指标文档页（均实测 200）**：
  - Faithfulness：✅ https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/faithfulness/
  - Answer/Response Relevancy：✅ https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/answer_relevance/
  - Context Precision：✅ https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_precision/
  - Context Recall：✅ https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_recall/
- **仓库**：✅ https://github.com/explodinggradients/ragas

### 1.2 TruLens / RAG Triad
- **官方文档「RAG Triad」**：✅ https://www.trulens.org/getting_started/core_concepts/rag_triad/ ——RAG 三元组 = **Context Relevance + Groundedness + Answer Relevance**；组成"幻觉检测"闭环，可定位是检索错还是生成错。
- **官方仓库**：✅ https://github.com/truera/trulens（OpenTelemetry-native）——除 tracing/成本记录外，还有 **7 个 Agent 专用评估器**（LogicalConsistency、ExecutionEfficiency、PlanAdherence、PlanQuality、ToolSelection、ToolCalling、ToolQuality）。
- **Honest/Harmless/Helpful 评估框架**：✅ https://www.trulens.org/getting_started/core_concepts/honest_harmless_helpful_evals/

### 1.3 ARES
- **论文**：✅ https://arxiv.org/abs/2311.09476（NAACL 2024，v2）——自动化评测 RAG 的 **context relevance / answer faithfulness / answer relevance** 三维；用合成数据微调轻量 LM judge，再用 **PPI（Prediction-Powered Inference）** 结合少量人工标注消偏。
- **官方仓库**：✅ https://github.com/stanford-futuredata/ARES（PyPI 包 `ares-ai`，支持 vLLM 本地跑）

### 1.4 DeepEval
- **官方仓库**：✅ https://github.com/confident-ai/deepeval ——"LLM 版的 Pytest"。指标覆盖 RAG、**Agentic**（Task Completion、Tool Correctness、Goal Accuracy、Step Efficiency、Plan Adherence、Plan Quality、Tool Use、Argument Correctness）、多轮对话、MCP、多模态等。
- **文档入口**：✅ https://docs.confident-ai.com/docs/metrics-introduction

### 1.5 检索评测基准 BEIR
- **论文**：✅ https://arxiv.org/abs/2104.08663（NeurIPS 2021 D&B）——跨 18 个数据集、多任务多域的**异构零样本检索评测**。
- **仓库**：✅ https://github.com/UKPLab/beir ／ ✅ https://github.com/beir-cellar/beir

### 1.6 RAG 常见指标体系

| 层次 | 指标 | 代表来源 |
|---|---|---|
| 检索层 | Context Precision / Context Recall / Context Relevance / NDCG@k / Recall@k / MRR | RAGAS、TruLens、BEIR |
| 生成层 | Faithfulness / Groundedness / Answer Relevancy / Factual Correctness / Hallucination | RAGAS、TruLens、DeepEval |
| 端到端 | Exact Match / Semantic Similarity / BLEU / ROUGE / G-Eval | RAGAS、DeepEval |
| 鲁棒性 | Noise Sensitivity | RAGAS |

---

## 二、Agent 测评基准

| 基准 | 核心内容 | 权威 URL（均已验证） |
|---|---|---|
| **AgentBench** | 8 个交互环境评测 LLM-as-Agent 的推理/决策；ICLR 2024，v3 修订于 2025-10-04 | ✅ https://arxiv.org/abs/2308.03688 ／ ✅ https://github.com/THUDM/AgentBench |
| **SWE-bench** | 2,294 个真实 GitHub issue（12 个 Python 仓库），改代码让 FAIL_TO_PASS/PASS_TO_PASS 通过；ICLR 2024 | ✅ https://arxiv.org/abs/2310.06770 ／ ✅ https://swebench.com/ ／ ✅ https://github.com/SWE-bench/SWE-bench |
| **SWE-bench Verified** | 与 OpenAI 合作人工筛选的 **500 题**子集；现役维护方= SWE-bench 团队；榜首提供 **bash-only（mini-SWE-agent）** 对比 | ✅ https://www.swebench.com/verified.html ／ ✅ https://openai.com/index/introducing-swe-bench-verified/ ／ ✅ https://huggingface.co/datasets/princeton-nlp/SWE-bench_Verified |
| **WebArena** | 4 类真实网站环境（电商/论坛/协作开发/CMS）的端到端网页任务；论文中最佳 GPT-4 agent 14.41% vs 人类 78.24% | ✅ https://arxiv.org/abs/2307.13854 ／ ✅ https://webarena.dev/ ／ ✅ https://github.com/web-arena-x/webarena |
| **GAIA** | 466 道"对人类简单、对 AI 难"的真实问题，需推理+多模态+浏览+工具 | ✅ https://arxiv.org/abs/2311.12983 ／ ✅ https://huggingface.co/spaces/gaia-benchmark/leaderboard（动态 Space，排名值未读出） |
| **τ-bench (tau-bench)** | 用 LLM 模拟用户，评测 agent 多轮对话中调用 API 工具、遵守业务规则；提出 **pass^k** | ✅ https://arxiv.org/abs/2406.12045 |
| **τ²/τ³-bench（现役版）** | τ²=Dual-Control（agent 与用户都能操作共享世界，新增 Telecom 域）；**τ³=当前版本**，新增 banking/banking_knowledge 域、voice 全双工、75+ 任务修复；2026-07 v1.0.1 修复 banking_knowledge 评分（旧结果不可比） | ✅ https://arxiv.org/abs/2506.07982 ／ ✅ https://github.com/sierra-research/tau2-bench ／ ✅ https://taubench.com |
| **OSWorld** | 真实 Ubuntu/Windows/macOS 电脑环境，369 个跨应用任务、执行式评估；人类 72.36% vs 最佳模型 12.24% | ✅ https://arxiv.org/abs/2404.07972 ／ ✅ https://os-world.github.io/ ／ ✅ https://github.com/xlang-ai/OSWorld |
| **AgentBoard** | 多轮 agent 的**分析式**评测板，强调**细粒度 progress rate** 而非只看最终成功率；NeurIPS 2024 Oral | ✅ https://arxiv.org/abs/2401.13178 ／ ✅ https://github.com/hkust-nlp/AgentBoard |
| **HAL（Holistic Agent Leaderboard）** | 标准化评测 harness + 榜单，默认纳入**成本**；21,730 次 rollout（9 模型×9 基准，约 $40k），公开 2.5B tokens 的 agent 日志 | ✅ https://arxiv.org/abs/2510.11977 ／ ✅ https://hal.cs.princeton.edu/ ／ ✅ https://github.com/princeton-pli/hal-harness（**已归档**） |
| **MLE-bench** | 从 Kaggle 精选 **75 个 ML 工程竞赛**，评测端到端 ML 工程能力；最佳配置（o1-preview + AIDE）16.9% 达铜牌；OpenAI 出品 | ✅ https://arxiv.org/abs/2410.07095 ／ ✅ https://github.com/openai/mle-bench |

**HAL 的重要状态**：**2026-07-01 归档、停止接收新提交、榜单暂停更新**，团队转向 [agent reliability](https://hal.cs.princeton.edu/reliability/)。定位为"成本敏感评测的代表作 + 已进入维护尾声"。

---

## 三、Agent 测评的方法论

- **任务成功率（task success rate）**：WebArena/OSWorld/AgentBench/GAIA 的主指标，多为执行式/最终状态比对（τ-bench 用**对话结束时数据库状态与标注目标状态比对**）。
- **轨迹评估（trajectory evaluation）**：AgentBoard 提出 **progress rate** 刻画每步增量进展（arXiv 2401.13178）；DeepEval 支持对完整 trajectory 打分；τ-bench 提供 **auto error identification**（故障归属：user/agent/environment + 故障类型）。
- **过程奖励（process reward）**：AgentBoard 的 progress rate；TruLens 的 `PlanAdherence`/`ExecutionEfficiency`；DeepEval 的 `Step Efficiency`/`Plan Adherence`。**未找到被广泛引用的、专门命名"process reward for agent eval"的权威基准**，建议归为"过程导向指标"。
- **工具调用正确性**：RAGAS 的 **Tool Call Accuracy / Tool Call F1**；DeepEval 的 **Tool Correctness / Argument Correctness**；TruLens 的 ToolSelection/ToolCalling/ToolQuality。
- **成本与延迟（cost & latency）**：HAL 是标杆（arXiv 2510.11977）；动机论文 "AI Agents That Matter" ✅ https://arxiv.org/abs/2407.01502。
- **pass^k 可靠性**：由 τ-bench 提出（arXiv 2406.12045）；τ-bench README 给出 Pass^1..Pass^4（如 GPT-4o retail Pass^1=0.604 → Pass^4=0.383）。
- **方法论总纲综述**：**Survey on Evaluation of LLM-based Agents**，✅ https://arxiv.org/abs/2503.16416（ACL Findings，v2 修订于 2026-04-23）——从核心能力 / 应用级基准 / 通用 agent / 基准维度 / 评测框架五视角梳理，指出 **cost-efficiency、safety、robustness** 是当前最大空白。**强推作为方法论总纲。**

---

## 四、组件级评估 vs 端到端评估

- **组件级（component-level）**：分别评测检索组件（Context Precision/Recall、NDCG@k）与生成组件（Faithfulness/Relevancy）。优点：定位问题精确、便宜、可回归；缺点：无法反映真实交互效应。
- **端到端（end-to-end / black-box）**：把整个 RAG/Agent 当黑盒，看最终任务成败（WebArena/OSWorld/SWE-bench/GAIA/τ-bench）或最终答案质量。优点：贴近真实价值；缺点：贵、难归因、受环境与脚手架噪声影响。
- **桥接两者的现成工具**：DeepEval 明确宣称同时支持 end-to-end 与 component-level；TruLens 用 **RAG Triad + OTel span** 把"每个环节"和"整条链"都打分，是"组件↔端到端"打通的最佳教学案例。

---

## 五、章节大纲建议（应用级）

```
第 0 章  为什么应用级测评 ≠ 模型级测评
  - 模型级"考卷" vs 应用级"实战"
  - 三类评测对象：检索组件 / 生成组件 / 端到端系统
第 1 章  RAG 测评
  1.1 检索错 or 生成错？  1.2 RAG Triad  1.3 RAGAS 指标体系
  1.4 ARES  1.5 DeepEval（eval 做成 Pytest / CI）  1.6 BEIR
  1.7 动手小实验：用 RAGAS 或 DeepEval 给一个最小 RAG 打分
第 2 章  Agent 测评
  2.1 从"答题"到"行动"：环境、工具、多轮、长程
  2.2 按域分类：代码 / 网页 / 电脑操作 / 通用助理 / 工具-用户对话 / 多环境综合
  2.3 榜单基础设施与成本：HAL（含归档现状）
  2.4 时效地图：哪些基准已换代/停更/迁移
第 3 章  Agent 评测方法论
  3.1 任务成功率  3.2 轨迹与过程  3.3 工具调用正确性
  3.4 过程奖励与中间信号  3.5 pass^k  3.6 成本与延迟
  3.7 基准的常见坑：污染、脚手架混淆、只报精度不报成本、任务缺陷
第 4 章  组件级 vs 端到端：方法论对照
第 5 章  上手与选型
  - 轻量自测：DeepEval / RAGAS；跑公开基准：各官方 repo
  - 建自己的评测集：生产 trace 采样 → golden set → CI 门禁
```

---

## 六、未验证 / 存疑项

- GAIA 榜单当前排名（HF Space 动态加载，未读到数值）。
- 各基准**当前 SOTA 分数**未逐一核对（榜单会变）。
- 引用的历史基线均来自论文。
