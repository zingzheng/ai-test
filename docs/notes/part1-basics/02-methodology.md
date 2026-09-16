# 第 2 章 评测方法论全景：自动 / 人工 / A-B / LLM-as-Judge

> **一句话结论**：这四种方法不是"四选一"，而是分布在「离线 ↔ 在线」和「便宜 ↔ 可信」两个轴上的工具；好的评测体系是四者按成本递增、可信度递增地**组合**使用。

---

> 本章先建立一张**顶层方法论地图**：自动评测、人工评测、A/B Test、LLM-as-Judge——它们不是四选一，而是组合关系。先看清地图，再谈具体评测对象。

## 2.1 为什么先讲方法论

同一个模型能力，用不同方法评测会得到不同结论。方法选错，结论就错——而且往往错得看不出来。因此第一步不是学某个工具，而是搞清楚**每种方法各自能回答什么问题、代价是什么、什么时候会骗人**。

一个有用的心智模型是两条轴：

- **离线（offline）↔ 在线（online）**：是在实验室里用固定数据集评，还是在真实用户流量上评？
- **便宜（cheap）↔ 可信（trustworthy）**：是脚本一行算出来，还是要领域专家逐条判断？

| 方法 | 相对位置 | 成本 | 可信度 | 速度 |
|---|---|---|---|---|
| 自动评测 | 离线 · 便宜 | 低 | 中（取决于规则质量） | 快 |
| LLM-as-Judge | 离线 · 中等 | 中 | 中高（需校准） | 快 |
| 人工评测 | 离线 · 可信 | 高 | 高 | 慢 |
| A/B Test | 在线 · 可信 | 很高 | 最高（终极裁判） | 很慢 |

## 2.2 自动评测（Automated / Programmatic）

**是什么**：用代码断言或指标计算来判定对错。典型形态包括单元测试式断言（输出必须包含某字段、必须能通过编译）、精确匹配（EM）、以及各类数值指标（accuracy、F1、BLEU）。

**什么时候用**：有确定的正确答案或判定规则时——代码生成、结构化抽取、分类、检索排序。

**盲区**：开放生成（写文案、答问题、做 Agent 决策）往往没有唯一答案，硬套字面指标会给出误导性结论。

行业成熟做法是把自动评测当作**最底层、最常跑**的一层，用来挡住低级回归——Hamel Husain 把它称为 L1（单元测试级），要求能在 CI 里频繁执行。

> 来源：[Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/)（Hamel Husain）— ✅

## 2.3 人工评测（Human Evaluation）

**是什么**：由人来做判断，可以是众包标注、也可以是领域专家逐条 review。

**什么时候用**：需要判断"好不好、对不对、安全不安全"这类主观或高风险维度；或者要给其他评测方法（尤其是 LLM-as-Judge）建立**黄金标准**。

**代价与坑**：
- **贵、慢**，不可能对每条数据都做；
- **一致性**是最大挑战——不同标注者对同一输出的判断可能不一致，需要统一的评分标准与一致性检验；
- 存在**标注者偏差**。

Anthropic 在讲 Agent 评测时，把 grader（评分者）分为 code / model / human 三类，并明确指出 human grader 的优势是灵活性、劣势是成本与可扩展性——这几乎是所有团队最终都要面对的权衡。

> 来源：[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)（Anthropic, 2026-01-09）— ✅

## 2.4 A/B Test（在线实验）

**是什么**：把用户随机分成对照组和实验组，各自看到不同版本，用统计方法判断差异是否真实。它是**唯一能回答"上线后到底有没有用"的方法**。

**核心概念**（够用即可）：

| 概念 | 一句话理解 |
|---|---|
| 原假设 H0 / 备择假设 H1 | 默认"没有差异"，用数据尝试推翻它 |
| p 值 | 在 H0 成立时，观察到这等极端结果的概率；**它不是"H0 为真的概率"** |
| 显著性水平 α | 允许的假阳性率，惯例 0.05 |
| 统计功效（power） | 真有差异时能检测出来的概率，惯例 ≥ 0.8 |
| 样本量 | 由 α、power、最小可检测效应共同决定，**必须实验前算** |
| 置信区间 | 比单个 p 值信息更多；注意"两个 CI 重叠 ≠ 不显著" |
| CUPED | 用实验前数据做协变量，降低指标方差、提升灵敏度 |

**常见陷阱**（实践中最容易踩）：

- **多重比较**：同时看 20 个指标，总有一个"显著"——需 Bonferroni / BH 等校正。
- **SRM（样本比例失配）**：分流比例偏离预期，是数据质量出问题的"发烧症状"，一旦出现应停止分析。
- **新奇效应 / 首因效应**：用户对新功能短期行为的偏差，需要跑足够久。
- **网络效应**：用户之间会互相影响时，随机化假设被破坏（社交、双边市场）。
- **辛普森悖论**：分组结论与整体结论相反，源于混杂。

权威参考是 Kohavi 等人的 A/B 测试专著，以及 CUPED 原始论文与 Microsoft 关于 SRM 的论文。

> 来源：[Trustworthy Online Controlled Experiments（官方站）](https://experimentguide.com/) — ✅
> 来源：[CUPED: Improving the Sensitivity of Online Controlled Experiments](https://www.exp-platform.com/Documents/2013-02-CUPED-ImprovingSensitivityOfControlledExperiments.pdf)（WSDM 2013）— ✅
> 来源：[Diagnosing Sample Ratio Mismatch in Online Controlled Experiments](https://www.microsoft.com/en-us/research/publication/diagnosing-sample-ratio-mismatch-in-online-controlled-experiments-a-taxonomy-and-rules-of-thumb-for-practitioners/)（KDD 2019）— ✅
> 来源：[A/B testing](https://en.wikipedia.org/wiki/A/B_testing)、[P-value](https://en.wikipedia.org/wiki/P-value)、[Statistical power](https://en.wikipedia.org/wiki/Statistical_power) — ✅

## 2.5 LLM-as-Judge

**是什么**：用一个大模型当"裁判"，给另一个模型的输出打分或做 pairwise 比较。它填补了"自动评测太死板、人工评测太贵"之间的空档。

**关键事实**：MT-Bench / Chatbot Arena 的工作系统性地证明，强 LLM 裁判与人类偏好的一致率可以超过 80%，与人类标注者之间的一致率相当；但同时也暴露了**位置偏差、冗长偏差、自我增强偏差**等系统性缺陷。

**什么时候用**：开放生成、对话、指令遵循等没有唯一答案的任务；以及需要规模化人工判断的场合。

**注意**：judge 的可靠性高度依赖任务设计与校准。其典型偏差见**第 4 章**，分辨率与自动化见**第 15 章**，工程化校准方法（Critique Shadowing）见**第 13 章**。

> 来源：[Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena](https://arxiv.org/abs/2306.05685)（NeurIPS 2023）— ✅

## 2.6 选型与工作流：四种方法怎么配合

没有一种方法能独立支撑评测体系。实践中典型的工作流是**漏斗式**的：

```
离线自动评测（快速筛掉明显退化）
        ↓
LLM-as-Judge（规模化打分，可人工抽检校准）
        ↓
人工评测（对高风险 / 高价值样本建立黄金标准）
        ↓
在线 A/B Test（真实流量验证，终极裁判）
```

对应到工具上，LangSmith 等平台把前两步区分为 **offline eval（发布前）** 与 **online eval（生产实时监控）** 两条轨道。

> 来源：[LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — ✅

一个重要的心态：**离线涨分不等于线上变好**。离线指标是代理指标（proxy metric），最终必须由在线实验或持续监控来验证。

---

## 本章要点

- 四种方法分布在「离线↔在线」「便宜↔可信」两个轴上，是组合关系不是替代关系。
- 自动评测负责"挡退化"，人工评测负责"定标准"，LLM-as-Judge 负责"规模化"，A/B Test 负责"最终裁决"。
- A/B Test 必须记住：样本量实验前算、SRM 出现就停、多重比较要校正、p 值不等于"H0 为真概率"。
- LLM-as-Judge 与人类一致性可 >80%，但有位置/冗长/自我增强偏差，必须校准。
- 离线指标只是代理，能否上线最终看在线实验。

## 来源

- [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — 访问 2026-09-15 — ✅ — L1/L2/L3 三层评测
- [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅ — code/model/human 三类 grader
- [LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — 访问 2026-09-15 — ✅ — offline vs online eval
- [Judging LLM-as-a-Judge (MT-Bench / Chatbot Arena)](https://arxiv.org/abs/2306.05685) — 访问 2026-09-15 — ✅ — LLM 裁判一致性与偏差
- [Trustworthy Online Controlled Experiments](https://experimentguide.com/) — 访问 2026-09-15 — ✅ — A/B 测试专著
- [CUPED (WSDM 2013)](https://www.exp-platform.com/Documents/2013-02-CUPED-ImprovingSensitivityOfControlledExperiments.pdf) — 访问 2026-09-15 — ✅ — 方差缩减
- [Diagnosing SRM (KDD 2019)](https://www.microsoft.com/en-us/research/publication/diagnosing-sample-ratio-mismatch-in-online-controlled-experiments-a-taxonomy-and-rules-of-thumb-for-practitioners/) — 访问 2026-09-15 — ✅ — SRM 诊断
- [Statistical hypothesis testing](https://en.wikipedia.org/wiki/Statistical_hypothesis_test) / [P-value](https://en.wikipedia.org/wiki/P-value) / [Statistical power](https://en.wikipedia.org/wiki/Statistical_power) / [Sample size determination](https://en.wikipedia.org/wiki/Sample_size_determination) — 访问 2026-09-15 — ✅
