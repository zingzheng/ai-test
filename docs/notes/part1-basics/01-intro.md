# 第 1 章 导论：为什么测评是 AI 工程的第一性问题

> **一句话结论**：在大模型时代，"能不能做"由模型决定，"做得对不对、够不够好"只能由测评回答。没有测评，AI 工程就退化成凭感觉调参。

---

## 1.1 从"能力主张"到"可验证证据"

宣称一个模型或产品"很强"几乎零成本；证明它到底强在哪、强多少、在什么情况下会翻车，成本极高。**测评（evaluation）的本质，就是把"能力主张"变成"可验证证据"。**

学术上，这个领域已经被系统地拆解过。《A Survey on Evaluation of Large Language Models》把 LLM 评测归纳为三个问题——**评什么（what to evaluate）、在哪评（where to evaluate）、怎么评（how to evaluate）**，这是本章乃至整本笔记的骨架来源。

> 来源：[A Survey on Evaluation of Large Language Models](https://arxiv.org/abs/2307.03109)（arXiv 2307.03109，ACM TIST）

在工程实践里，测评的地位更直接。AI 产品与传统软件最大的区别是：行为是概率性的、输入是开放的、正确性往往没有唯一答案。这让"写个断言看看对不对"失效，也正因为如此，**评测系统的质量，直接决定了 AI 产品的迭代速度上限**。行业里被反复引用的一句话是："AI 产品需要 evals"，并且要把"看数据的摩擦"降到最低。

> 来源：[Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/)（Hamel Husain）

## 1.2 三种测评对象：别把"考试"和"实战"混为一谈

测评首先要问一句：**你到底在测什么？** 常见的三类对象，方法论差别很大。

| 对象 | 典型问题 | 代表手段 | 本笔记对应章节 |
|---|---|---|---|
| **模型级** | 这个模型有多聪明？ | 学术基准（MMLU 等）、竞技场人类偏好 | 第 3、4 章 |
| **应用级** | 我的 RAG / Agent 好不好用？ | 组件指标 + 端到端任务成败 | 第 5、6 章 |
| **系统/业务级** | 上线后对业务有没有正向影响？ | 在线 A/B Test、护栏指标 | 第 2 章、第 12 章 |

把模型级分数直接当成应用效果，是最常见也最贵的误判——这部分会在第 5、6 章展开。

## 1.3 术语速查

先把最常被混用的词对齐。**这些定义会贯穿全篇**。

| 术语 | 一句话定义 | 来源 |
|---|---|---|
| benchmark（基准） | 一套固定任务 + 固定打分方式的"考卷"，用于横向比较模型 | [LLM 评测综述](https://arxiv.org/abs/2307.03109) |
| eval（评测） | 一次针对特定目标的、有组织的评估过程；benchmark 只是其中一种材料 | 同上 |
| metric（指标） | 把模型输出映射成一个数字的度量函数（如 accuracy、F1） | 同上 |
| accuracy（准确率） | 预测正确样本占总样本的比例；类别不平衡时会严重误导 | [scikit-learn 指标总览](https://scikit-learn.org/stable/modules/model_evaluation.html) |
| perplexity（困惑度） | 语言模型对文本的"意外程度"，越低越好；是**语言建模内禀指标**，不等于下游任务能力 | [Perplexity](https://en.wikipedia.org/wiki/Perplexity) |
| zero-shot / few-shot | 不给示例 / 给少量示例就让模型完成任务，不更新参数 | [GPT-3 论文](https://arxiv.org/abs/2005.14165) |
| pass@k | 生成 k 个答案，至少有 1 个正确的概率；代码任务常用 | [Codex / HumanEval 论文](https://arxiv.org/abs/2107.03374) |
| pass^k | 同一任务重复 k 次**全部**成功的概率；衡量可靠性而非"碰运气成功" | [τ-bench 论文](https://arxiv.org/abs/2406.12045) |
| contamination（数据污染） | 测试集内容出现在训练数据里，导致分数虚高 | [TS-Guessing 论文](https://arxiv.org/abs/2311.09783) |

> pass@k 与 pass^k 只差一个符号，含义几乎相反：前者关心"k 次里能不能成一次"，后者关心"k 次是不是次次都成"。做 Agent 可靠性评估时用错会得出完全相反的结论。

## 1.4 模型训练侧在测评里的位置（先知道个大概）

你可能听说过"有模型训练经验者优先""了解 RLHF"这类说法。对测评工作来说，训练侧的知识主要用在一处：**理解"分数是怎么被优化出来的"**。例如 RLHF 会训练一个 reward model 当"自动裁判"，而过度优化这个裁判会导致 reward hacking。

这些内容本笔记不展开推导，统一收在**附录 D · 模型训练与调优速览**里，够你在评审与日常沟通中正确使用术语即可。

## 1.5 这本笔记怎么用

- **速览（半天）**：第 1 → 2 → 3 → 5 → 6 → 13 章，先建立"测什么、怎么落地"的骨架。
- **工程实践**：第 2 → 6 → 12 → 13 章。
- **完整学习**：从第 1 章顺序读到第 16 章。
- **速查**：附录 A（术语）、C（时效地图）。

---

## 本章要点

- 测评是把"能力主张"变成"可验证证据"的工程活动，是 AI 产品的迭代引擎。
- 先分清三类对象：模型级 / 应用级 / 系统级，方法论完全不同。
- 记住三个易混术语：perplexity（内禀指标）、pass@k（k 次成一次）、pass^k（k 次全成）。
- 训练侧知识"够用即可"，细节见附录 D。

## 来源

- [A Survey on Evaluation of Large Language Models](https://arxiv.org/abs/2307.03109) — 访问 2026-09-15 — ✅ — 评测的"评什么/在哪评/怎么评"框架
- [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — 访问 2026-09-15 — ✅ — 评测是 AI 产品迭代核心
- [scikit-learn: Metrics and scoring](https://scikit-learn.org/stable/modules/model_evaluation.html) — 访问 2026-09-15 — ✅ — accuracy 等指标定义
- [Perplexity](https://en.wikipedia.org/wiki/Perplexity) — 访问 2026-09-15 — ✅ — 困惑度定义
- [Language Models are Few-Shot Learners](https://arxiv.org/abs/2005.14165) — 访问 2026-09-15 — ✅ — zero/few-shot 出处
- [Evaluating Large Language Models Trained on Code](https://arxiv.org/abs/2107.03374) — 访问 2026-09-15 — ✅ — pass@k 出处
- [τ-bench: A Benchmark for Tool-Agent-User Interaction](https://arxiv.org/abs/2406.12045) — 访问 2026-09-15 — ✅ — pass^k 出处
- [A Survey on Data Contamination for Large Language Models](https://arxiv.org/abs/2502.14425) — 访问 2026-09-15 — ✅ — 数据污染综述
