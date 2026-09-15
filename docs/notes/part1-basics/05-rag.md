# 第 5 章 应用级测评（上）：RAG 怎么测

> **一句话结论**：RAG 评测的关键不是"给整个系统打一个分"，而是把「检索」和「生成」拆开分别量——先定位错在哪一环，再谈整条链好不好用。

---

## 5.1 为什么应用级测评 ≠ 模型级测评

第 1 章把测评对象分成三类：模型级、应用级、系统/业务级。模型级回答"这个模型有多聪明"，用 MMLU 之类的固定考卷即可；但**RAG 是一个由你亲手搭出来的系统**，它的效果不只取决于底层模型，还取决于你的切分策略、向量检索、prompt、重排等一大堆工程选择。

> 来源：[A Survey on Evaluation of Large Language Models](https://arxiv.org/abs/2307.03109)

对 RAG 来说，最要命的是一句朴素的话：**答案错了，到底是检索没找到，还是模型拿着正确材料说了胡话？** 这两类故障的修复方向完全相反——前者要改检索，后者要改生成。所以 RAG 评测的第一原则是**拆开看**。TruLens 的 RAG Triad 正是为这个目的设计的：它把整条链拆成三段分别打分，组成一个"幻觉检测"闭环，从而把错误归因到具体环节。

> 来源：[TruLens RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/)

## 5.2 RAG Triad（TruLens）：三个问题定位故障

TruLens 提出的 RAG 三元组，用三个问题覆盖一条 RAG 链：

| 指标 | 回答的问题 | 出问题时该改哪 |
|---|---|---|
| **Context Relevance** | 检索出来的上下文跟问题相关吗？ | 检索 / 切分 / 重排 |
| **Groundedness** | 答案有没有"扎根"在给定上下文里？ | 生成（幻觉） |
| **Answer Relevance** | 答案是否切题地回答了用户的问题？ | 生成 / 提问理解 |

三者合起来可以判断：检索错了、检索对了但模型乱编、还是模型答非所问。

> 来源：[TruLens RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/) ／ [TruLens 仓库](https://github.com/truera/trulens)

## 5.3 RAGAS 四指标

RAGAS 是一个覆盖检索与生成两端的 RAG 评测框架。它的生成类指标（Faithfulness、Answer Relevancy）**无需人工标注标准答案（reference-free）**，而检索类指标（Context Recall）仍需参考答案才能计算。它最常被引用的四个核心指标如下。

> 来源：[RAGAS 论文](https://arxiv.org/abs/2309.15217)

| 指标 | 层次 | 回答什么问题 |
|---|---|---|
| **Faithfulness** | 生成 | 答案里的陈述是否都能由检索到的上下文支持？（对幻觉的度量） |
| **Answer Relevancy** | 生成 | 答案是否直接回应了问题，而非答非所问或含糊其辞？ |
| **Context Precision** | 检索 | 检索到的上下文里，真正有用的内容排得靠前吗？ |
| **Context Recall** | 检索 | 回答问题所需的信息，被检索结果覆盖到了吗？ |

> 来源：[Faithfulness](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/faithfulness/) ／ [Answer Relevancy](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/answer_relevance/) ／ [Context Precision](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_precision/) ／ [Context Recall](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_recall/)

一组好记的配对是：**Context Precision/Recall 管检索，Faithfulness/Answer Relevancy 管生成**。RAGAS 官方还提供 Context Entities Recall、Noise Sensitivity 等更多指标，并可扩展到 Agent 工具调用评测。

> 来源：[RAGAS 指标总览](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/) ／ [RAGAS 仓库](https://github.com/explodinggradients/ragas)

## 5.4 ARES：合成数据 + 微调 judge + PPI 消偏

ARES 同样从 **context relevance / answer faithfulness / answer relevance** 三个维度自动评测 RAG。它的三件套很有教学价值：

1. **合成数据**：自动生成训练数据，避免全靠人工标注；
2. **微调轻量 LM 当 judge**：比每次调用大模型裁判更省；
3. **PPI（Prediction-Powered Inference）**：用少量人工标注来校正 judge 的系统性偏差。

> 来源：[ARES 论文](https://arxiv.org/abs/2311.09476)（NAACL 2024）／ [ARES 仓库](https://github.com/stanford-futuredata/ARES)

它提醒我们：**judge 也会偏**，能用一小撮人工标注来"消偏"是工程上很务实的一招。

## 5.5 DeepEval："LLM 版 Pytest"

DeepEval 把自己定位成 **"LLM 版的 Pytest"**——把评测写成测试用例，从而能进 CI 流水线。它明确宣称同时支持 **端到端（end-to-end）与组件级（component-level）** 评测，指标覆盖 RAG、Agentic（Task Completion、Tool Correctness、Goal Accuracy、Plan Adherence 等）、多轮对话等。

> 来源：[DeepEval 仓库](https://github.com/confident-ai/deepeval) ／ [DeepEval 文档](https://docs.confident-ai.com/docs/metrics-introduction)

对工程团队而言，"能进 CI"这一点比指标数量更重要——它让评测从一次性报告变成持续门禁。

## 5.6 检索专项基准 BEIR

当你想单独把**检索**这一层压测到极限时，BEIR 是标准答案：它覆盖 **18 个数据集、多任务多域**，专门做**异构零样本检索评测**，考察检索器换到没见过的领域还灵不灵。

> 来源：[BEIR 论文](https://arxiv.org/abs/2104.08663)（NeurIPS 2021 D&B）／ [BEIR 仓库](https://github.com/UKPLab/beir) ／ [beir-cellar](https://github.com/beir-cellar/beir)

RAG 的检索组件通常还会看 NDCG@k、Recall@k、MRR 等经典排序指标。

## 5.7 组件级 vs 端到端：何时拆、何时整

| 方式 | 做法 | 优点 | 缺点 |
|---|---|---|---|
| **组件级** | 分别测检索（Context Precision/Recall、NDCG@k）与生成（Faithfulness/Relevancy） | 定位精确、便宜、可回归 | 无法反映真实交互效应 |
| **端到端** | 把整条 RAG 当黑盒，看最终答案质量或任务成败 | 贴近真实价值 | 贵、难归因、易受脚手架噪声影响 |

实践建议是**先拆后合**：日常迭代用组件级指标快速定位与防回归；里程碑或上线前用端到端评测确认真实效果。TruLens 用 RAG Triad + OpenTelemetry span 把"每个环节"和"整条链"同时打分，是打通两者的好范例。

> 来源：[TruLens 仓库](https://github.com/truera/trulens)

## 5.8 一个 RAG 评测清单

可直接对照使用（本清单为上述方法的工程化汇总）：

- [ ] **先分类错误**：答案错时，能区分是检索问题还是生成问题吗？
- [ ] **检索层**：查 Context Precision / Recall，必要时用 BEIR 做零样本检索压测。
- [ ] **生成层**：查 Faithfulness（幻觉）与 Answer Relevancy（切题）。
- [ ] **归因**：用 RAG Triad 三类指标定位出错环节。
- [ ] **judge 校准**：LLM-as-Judge 是否用少量人工标注校准过（参考 ARES 的 PPI 思路）？
- [ ] **入 CI**：能否像 DeepEval 那样把关键用例做成可重复执行的测试？
- [ ] **端到端兜底**：有没有一组贴近真实场景的黑盒用例，防止组件指标"好看但没用"？

---

## 本章要点

- 应用级测评 ≠ 模型级测评：RAG 效果取决于你的工程选择，而不只是底层模型。
- RAG 出错先分两类：检索错还是生成错——这是拆开看指标的根本理由。
- TruLens 的 RAG Triad = Context Relevance + Groundedness + Answer Relevance，用于故障归因。
- RAGAS 四指标：Context Precision/Recall 管检索，Faithfulness/Answer Relevancy 管生成；且为 reference-free。
- ARES 用合成数据 + 微调 judge + PPI 消偏，解决 judge 偏差与成本。
- DeepEval 是"LLM 版 Pytest"，支持端到端与组件级，可进 CI。
- BEIR 用于异构零样本检索评测；组件级与端到端应"先拆后合"。

## 来源

- [RAGAS 论文](https://arxiv.org/abs/2309.15217) — 访问 2026-09-15 — ✅ — reference-free RAG 评测框架
- [RAGAS 指标总览](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/) — 访问 2026-09-15 — ✅ — RAG 与 Agent 指标
- [RAGAS: Faithfulness](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/faithfulness/) — 访问 2026-09-15 — ✅
- [RAGAS: Answer Relevancy](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/answer_relevance/) — 访问 2026-09-15 — ✅
- [RAGAS: Context Precision](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_precision/) — 访问 2026-09-15 — ✅
- [RAGAS: Context Recall](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_recall/) — 访问 2026-09-15 — ✅
- [RAGAS 仓库](https://github.com/explodinggradients/ragas) — 访问 2026-09-15 — ✅
- [TruLens RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/) — 访问 2026-09-15 — ✅ — 三元组与幻觉检测
- [TruLens 仓库](https://github.com/truera/trulens) — 访问 2026-09-15 — ✅ — OTel-native、组件↔端到端
- [TruLens: Honest/Harmless/Helpful Evals](https://www.trulens.org/getting_started/core_concepts/honest_harmless_helpful_evals/) — 访问 2026-09-15 — ✅
- [ARES 论文](https://arxiv.org/abs/2311.09476) — 访问 2026-09-15 — ✅ — 合成数据 + 微调 judge + PPI
- [ARES 仓库](https://github.com/stanford-futuredata/ARES) — 访问 2026-09-15 — ✅
- [DeepEval 仓库](https://github.com/confident-ai/deepeval) — 访问 2026-09-15 — ✅ — "LLM 版 Pytest"
- [DeepEval 文档](https://docs.confident-ai.com/docs/metrics-introduction) — 访问 2026-09-15 — ✅ — 指标入口
- [BEIR 论文](https://arxiv.org/abs/2104.08663) — 访问 2026-09-15 — ✅ — 异构零样本检索评测
- [BEIR 仓库](https://github.com/UKPLab/beir) — 访问 2026-09-15 — ✅
- [beir-cellar](https://github.com/beir-cellar/beir) — 访问 2026-09-15 — ✅
- [A Survey on Evaluation of Large Language Models](https://arxiv.org/abs/2307.03109) — 访问 2026-09-15 — ✅ — 评测 what / where / how 框架
- [Survey on Evaluation of LLM-based Agents](https://arxiv.org/abs/2503.16416) — 访问 2026-09-15 — ✅ — 应用级/组件级方法论总纲
