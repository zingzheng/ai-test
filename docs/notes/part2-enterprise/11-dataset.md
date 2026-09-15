# 第 11 章 数据集工程：从生产 trace 到评测集

> **一句话结论**：评测集不是"买一个/下一个"就完事，而是一条从生产 trace 持续回灌的流水线——公开基准负责能力主张，自建集负责产品效果；先 logging、再 golden set、留出 holdout、防住污染，小步高频地迭代。

---

> 前面几章讲的是"用什么方法评"（第 2 章）、"评什么对象"（第 3–8 章）与"用什么工具/方法论"（第 9–10 章）。这一章回到所有评测的共同底座：**数据**。没有一套可信、贴业务、持续更新的评测集，再好的 judge 和 A/B 实验也评不出真东西。

## 11.1 评测集从哪来：公开基准 vs 自建评测集的分工

评测集大致有两个来源，分工要分清：

- **公开基准（public benchmark）**：回答"这个模型/系统在通用能力上有多强"，用于能力主张、选型横向对比。它们由社区维护、可复现，但**不等于你的产品效果**（第 3 章已展开）。
- **自建评测集（in-house / domain-specific eval set）**：回答"在我们的业务场景里，它到底行不行"，覆盖私有领域、特定工具、特定安全边界。

Agent 评测综述把这类"应用级基准"与"通用能力基准"明确区分，并指出 cost-efficiency、safety、robustness 是当前最大空白，必须靠自建集补上。Anthropic 则把评测分成 **capability evals（能力/上限探索）** 与 **regression evals（回归/防退化）**——前者适合借公开基准起步，后者几乎只能自建。

> 来源：[Survey on Evaluation of LLM-based Agents](https://arxiv.org/abs/2503.16416)（arXiv 2503.16416）— ✅
> 来源：[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)（Anthropic, 2026-01-09）— ✅

## 11.2 从生产 trace 采样：先 logging、再建"数据飞轮"

自建集的高质量样本，最可靠的来源不是凭空想象，而是**真实生产 trace**。这也是 Hamel Husain 反复强调的第一步：**先做 logging，把每次调用/工具调用/检索结果完整记下来**，然后"移除一切看数据的摩擦（remove friction to looking at your data）"——数据就在那里，难的是让人愿意、方便地反复去看。

工具链已经把这套流程产品化。Langfuse 用「AI Engineering Loop」串起 **Trace → Monitor → Dataset → Experiment → Evaluate**：trace 沉淀为 dataset，实验产出再回流成新的评测样本，形成"数据飞轮"；LangSmith 则把这条轨道分成 **offline eval（发布前）与 online eval（生产实时监控）** 两条。

> 来源：[Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/)（Hamel Husain）— ✅
> 来源：[Langfuse Evaluation](https://langfuse.com/docs/evaluation/overview) — ✅
> 来源：[LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — ✅

关键动作是**主动采样**，不是随机抽：优先取线上失败、用户重试、以及高风险/高价值链路，让评测集始终盯住最该修的地方。

## 11.3 golden set 与 holdout：为什么要留出集

从 trace 里挑一批样本，人工标注好答案与评分标准，就得到 **golden set（黄金标准集）**。但一个常见错误是：**所有样本都用来调 prompt、调 judge，没有一个真实留出（holdout）**。

《AI Agents That Matter》的批评正打在这里：只盯 accuracy、忽视 cost，且 **holdout 不足会导致过拟合与走捷径**；全文还以「pervasive lack of reproducibility（普遍缺乏可复现性）」作为一个锚点结论。也就是说，当评测集被反复"针对"优化，分数涨的是**你记住了题**，不是**系统变强了**。Agentic Benchmark Checklist（ABC）进一步给出可操作的严谨性清单，在 CVE-Bench 上把高估降低了 33%。

> 来源：[AI Agents That Matter](https://arxiv.org/abs/2407.01502)（arXiv 2407.01502）— ✅
> 来源：[Agentic Benchmark Checklist (ABC)](https://arxiv.org/abs/2507.02825)（arXiv 2507.02825）— ✅

实践上：**golden set 用于日常调优，holdout 只在关键节点揭盲**；一旦 holdout 也被拿去做优化，就该重建一份新的。

## 11.4 合成数据与它的风险

数据不够时，合成数据是重要补充。OpenAI 的评测 Cookbook 就把"合成数据生成"列为标准工作流之一，用于快速铺开测试用例。

> 来源：[OpenAI Evals Cookbook](https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals) — ✅

但要注意**自产自测的偏差**：用模型生成数据、再用同一代模型去评，容易形成同源偏见。ARES 提供了有价值的对照思路——它**用合成数据微调轻量 LM judge**，但再用少量人工标注通过 **PPI（Prediction-Powered Inference）** 去消偏，而不是让模型自己给自己打分。换句话说，合成数据可以放大规模，但**可信度仍需人类/外部信号兜底**。

> 来源：[ARES](https://arxiv.org/abs/2311.09476)（arXiv 2311.09476, NAACL 2024）— ✅
> 来源：[ARES 仓库](https://github.com/stanford-futuredata/ARES) — ✅

## 11.5 数据污染：训练/测试重叠、动态 benchmark、检测方法

**数据污染（contamination）** 指测试集内容混进了训练数据，导致成绩虚高。数据污染综述系统梳理了训练/测试重叠的成因，并归纳出三类免污染路径（数据更新、改写、预防）与 **white-box / gray-box / black-box** 三档检测方法，同时提倡使用**动态 benchmark**（持续刷新题目，让模型无法预先记题）。

一个经典的检测方法是 TS-Guessing：它发现 GPT-4 在 MMLU 中"猜缺失选项"的精确匹配率达 **57%**，说明模型对测试内容存在记忆。

> 来源：[A Survey on Data Contamination for Large Language Models](https://arxiv.org/abs/2502.14425)（arXiv 2502.14425）— ✅
> 来源：[TS-Guessing](https://arxiv.org/abs/2311.09783)（NAACL 2024）— ✅

自建集同样要防污染：**公开测试集尤其危险**（例如 C-Eval 于 2025-07-27 公开完整测试集），一旦公开，任何"背过题"的模型都可能虚高。对策包括：保留私有 holdout、定期换题、把评测样本排除出训练语料。

> 来源：[C-Eval](https://arxiv.org/abs/2305.08322) — ✅

## 11.6 起步规模建议

最后一个反直觉但被反复验证的建议：**不要一开始就造几千条的大评测集**。Hamel 的经验值是**从约 30 例起步**——先跑起来、先让人反复看数据，随着失败模式暴露再扩；若要验证 judge 的每一类失败模式，则建议约 **100 例**量级。Anthropic 的"从 0 到 1 的路线（原文 Step 0–8）"同样主张小步开始、逐步加严。

小规模高频迭代优于大规模一次到位：前者的反馈闭环短，能持续纠偏；后者往往一次就做错方向，且维护成本高到没人愿意更新。

> 来源：[Using LLM-as-a-Judge: A Complete Guide](https://hamel.dev/blog/posts/llm-judge/)（Hamel Husain, 2026-09 更新）— ✅
> 来源：[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)（Anthropic, 2026-01-09）— ✅

---

## 本章要点

- 公开基准解决"能力主张"，自建评测集解决"产品效果"；Anthropic 区分 capability evals 与 regression evals。
- 自建集从生产 trace 来：先 logging、再"移除看数据的摩擦"（Hamel），经 Trace→Dataset→Experiment→Evaluate 形成数据飞轮。
- golden set 用于调优，holdout 只在节点揭盲；holdout 不足会过拟合、走捷径（AI Agents That Matter / ABC）。
- 合成数据能扩大规模，但有自产自测偏差；ARES 用合成数据训 judge、再用 PPI + 人工标注消偏，可作对照。
- 数据污染以训练/测试重叠为主，用动态 benchmark 与 white/gray/black-box 检测应对；TS-Guessing 在 MMLU 上匹配率达 57%。
- 起步约 30 例、验证 judge 失败模式约 100 例；小规模高频迭代优于大规模一次到位。

## 来源

- [Survey on Evaluation of LLM-based Agents](https://arxiv.org/abs/2503.16416) — 访问 2026-09-15 — ✅ — 应用级 vs 通用基准
- [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅ — capability vs regression evals、Step 0–8 路线
- [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — 访问 2026-09-15 — ✅ — 先 logging、移除看数据的摩擦
- [Using LLM-as-a-Judge: A Complete Guide](https://hamel.dev/blog/posts/llm-judge/) — 访问 2026-09-15 — ✅ — 起点约 30 例、验证 judge 约 100 例
- [Langfuse Evaluation](https://langfuse.com/docs/evaluation/overview) — 访问 2026-09-15 — ✅ — Trace→Dataset→Experiment 循环
- [LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — 访问 2026-09-15 — ✅ — offline vs online eval
- [AI Agents That Matter](https://arxiv.org/abs/2407.01502) — 访问 2026-09-15 — ✅ — holdout 不足、可复现性危机
- [Agentic Benchmark Checklist (ABC)](https://arxiv.org/abs/2507.02825) — 访问 2026-09-15 — ✅ — 评测严谨性清单
- [OpenAI Evals Cookbook](https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals) — 访问 2026-09-15 — ✅ — 合成数据生成
- [ARES](https://arxiv.org/abs/2311.09476) — 访问 2026-09-15 — ✅ — 合成数据训 judge + PPI 消偏
- [ARES 仓库](https://github.com/stanford-futuredata/ARES) — 访问 2026-09-15 — ✅ — 实现
- [A Survey on Data Contamination for LLMs](https://arxiv.org/abs/2502.14425) — 访问 2026-09-15 — ✅ — 污染成因、检测与动态 benchmark
- [TS-Guessing](https://arxiv.org/abs/2311.09783) — 访问 2026-09-15 — ✅ — GPT-4 猜缺失选项 57%
- [C-Eval](https://arxiv.org/abs/2305.08322) — 访问 2026-09-15 — ✅ — 2025-07-27 公开完整测试集
