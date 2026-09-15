# 第 4 章 主观评测与 LLM-as-Judge

> **一句话结论**：当任务没有唯一正确答案时，BLEU/ROUGE 这类字面指标会失灵；人类偏好竞技场与 LLM-as-Judge（模型裁判）是当前最可扩展的两条主观评测路径，但它们都带系统性偏差，必须校准后才能作为工程依据。

---

> 本章承接第 2 章 2.5 节留下的伏笔，专题展开「LLM-as-Judge」这一类方法论：它填补了"自动评测太死板、人工评测太贵"之间的空档。第 3 章讲的是有标准答案的学术基准，本章讲的是**没有标准答案时怎么评**。

## 4.1 为什么客观指标不够

自然语言生成（NLG）早期沿用机器翻译与摘要的字面重叠指标：**BLEU** 看 n-gram 精确率、**ROUGE** 看 n-gram 召回率，**METEOR**、**chrF** 又在词形与同义上做了折中。它们便宜、可复现、无需人工，但致命弱点是**只看表面字符串是否重合**——同一个意思换个说法，分数可能骤降；反之一段流畅却事实错误的输出，也可能拿到高分。对开放问答、对话、指令遵循这类任务，字面指标与人类判断的相关性很差。

> 来源：[BLEU (Papineni 2002)](https://aclanthology.org/P02-1040/)、[ROUGE (Lin 2004)](https://aclanthology.org/W04-1013/)、[METEOR](https://aclanthology.org/W05-0909/)、[chrF](https://aclanthology.org/W15-3049/)

指标演进大致分三段：**n-gram 字面指标**（BLEU/ROUGE）→ **学习型语义指标**（BERTScore 用上下文嵌入算语义相似度，BLEURT 用预训练模型微调出打分器）→ **LLM 裁判**（直接用大模型给开放输出打分或比较）。前两段仍回答不了"事实对不对、指令有没有遵守、有没有害"，这正是 LLM-as-Judge 登场的原因。

> 来源：[BERTScore](https://arxiv.org/abs/1904.09675)、[BLEURT](https://arxiv.org/abs/2004.04696)

## 4.2 人类偏好与竞技场：从 Chatbot Arena 到 Arena AI

最接近"金标准"的主观信号是**真人偏好**。Chatbot Arena 的做法是：用户随机收到两个**匿名**模型的回答，投票选出更好的那个（**pairwise**，成对比较），再把海量两两胜负用 **Bradley-Terry / Elo** 统计模型聚合成全局榜单。匿名是为了消除品牌偏置，pairwise 是为了把"给绝对分数"这种难事变成"二选一"这种易事。

**注意品牌更名**：该平台由 LMSYS 的 "Chatbot Arena" 起步，官网一度名为 "LMArena"，**现已更名为 Arena AI**（官网标题为 "Arena AI: The Official AI Ranking & LLM Leaderboard"）。写作与检索时不要沿用旧名。

> 来源：[Chatbot Arena 论文](https://arxiv.org/abs/2403.04132)、[Arena AI 官网](https://lmarena.ai/)

榜单也并非绝对公正：有研究指出部分实验室可通过私下测试、选择性公布等策略影响排名，这类现象被称为 **Leaderboard Illusion**。

> 来源：[Leaderboard Illusion](https://arxiv.org/abs/2504.20879)

## 4.3 MT-Bench 与 LLM-as-Judge

MT-Bench 与 Chatbot Arena 的同一篇工作系统性地回答了"模型能不能当裁判"：在受控设置下，**强 LLM 裁判（GPT-4）与人类偏好的一致率可以超过 80%**，已与人类标注者之间的一致率相当。这就是"用模型评模型"在工程上成立的依据。

> 来源：[Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena](https://arxiv.org/abs/2306.05685)（NeurIPS 2023）

但同一个工作也点明：这个 >80% 是有前提的——任务设计、评分 rubric 与裁判模型的能力都会影响结果。裁判本身也会犯错，并且**犯的是可预测的系统性错误**（见 4.5）。更完整的偏差分类与方法梳理可参考 LLM-as-a-Judge 综述。

> 来源：[LLM-as-a-Judge 综述](https://arxiv.org/abs/2411.15594)

## 4.4 G-Eval

G-Eval 是把"让模型打分"做得更结构化的一篇代表作：先用 **CoT（思维链）** 让裁判在打分前把理由一步步写出来，再用 **form-filling（表单填充）** 把评分约束成固定的字段与区间，最后按 token 概率加权得到分数。它在摘要任务上与人类判断的 Spearman 相关达到 **0.514**，明显优于传统重叠指标。G-Eval 也较早指出一个关键风险：**LLM 评审会偏好 LLM 自己生成的文本**——这正是后文"自我增强偏差"的雏形。

> 来源：[G-Eval](https://arxiv.org/abs/2303.16634)

## 4.5 LLM 裁判的典型偏差

实践中最常见的三类系统性偏差：

- **位置偏差（position bias）**：pairwise 比较时，裁判更容易选"第一个"或"第二个"出现的回答，与内容质量无关。
- **冗长偏差（verbosity bias）**：更长的回答更容易被判为好，哪怕只是啰嗦。
- **自我增强偏差（self-enhancement bias）**：裁判倾向于给自己或同源模型生成的文本打高分。

这三类偏差在 MT-Bench / Chatbot Arena 工作中被系统验证，是设计裁判 prompt 与解读分数时必须对冲的对象。工程上常用的缓解手段包括：**交换两个回答的位置各评一次再平均**（打散位置偏差）、给 rubric 明确惩罚冗余、用与候选模型不同族的模型当裁判。Hamel Husain 与 Eugene Yan 的实践博客给出了更细的落地指南，包括对裁判本身做人工抽检校准。

> 来源：[Judging LLM-as-a-Judge](https://arxiv.org/abs/2306.05685)、[Hamel Husain: LLM-as-a-Judge 指南](https://hamel.dev/blog/posts/llm-judge/)、[Eugene Yan: Evaluating LLM-Evaluators](https://eugeneyan.com/writing/llm-evaluators/)

裁判的**分辨率**（能否区分质量相近的回答）与其去偏方法，仍是活跃的研究方向。

> 来源：[去偏即测量干预（judge 分辨率）](https://arxiv.org/abs/2609.12439)

## 4.6 什么时候该用 judge、什么时候不该

回到第 2 章的方法论地图：四种方法分布在「离线↔在线」「便宜↔可信」两个轴上，是**组合**而非替代关系。

**适合用 judge 的场景**：开放生成、对话、指令遵循等没有唯一答案、又需要规模化判断的任务——有确定判定规则的别用裁判，直接写断言更便宜、更可靠（呼应 2.2 的 L1 自动评测）。

**不适合单独依赖 judge 的场景**：
- 有确定正确答案或可执行判定（代码编译、结构化抽取）——用程序化评测。
- 高风险、面向用户的最终裁决——需要人工评测建立**黄金标准**，并用它给裁判做校准；Anthropic 把 grader 分为 code / model / human 三类，明确指出 human grader 的价值在于灵活性与权威性。
- 需要回答"上线后到底有没有用"——只能靠在线 A/B Test。

**正确姿势是漏斗**：自动评测挡明显退化 → LLM-as-Judge 规模化打分（人工抽检校准）→ 人工评测定标准 → 在线实验做终极裁判。记住一个心态：**离线涨分不等于线上变好**，judge 给出的只是代理指标（proxy metric），最终仍要由真实流量验证。

> 来源：[Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/)、[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)、[Agent-as-Judge](https://arxiv.org/abs/2410.10934)

---

## 本章要点

- 开放生成没有唯一答案，BLEU/ROUGE 等字面指标会失灵；指标演进为 n-gram → 学习型 → LLM 裁判三段。
- Arena AI（原 Chatbot Arena / LMArena，**品牌已更名**）用匿名 pairwise 投票 + Bradley-Terry/Elo 聚合人类偏好，但存在 Leaderboard Illusion 风险。
- MT-Bench 证明强 LLM 裁判与人类一致率 **>80%**，是 LLM-as-Judge 成立的依据，前提是任务设计与校准到位。
- G-Eval 用 CoT + form-filling 结构化打分，并较早点出"LLM 偏好 LLM 文本"的偏差。
- 三大偏差必须记住：**位置偏差、冗长偏差、自我增强偏差**；常用缓解是互换位置取平均、rubric 惩罚冗余、异族模型当裁判。
- 选型原则：有确定答案用自动评测，高价值用人工定标准，LLM-as-Judge 负责规模化，终极裁决交给在线实验。

## 来源

- [BLEU (Papineni 2002)](https://aclanthology.org/P02-1040/) — 访问 2026-09-15 — ✅ — n-gram 精确率指标
- [ROUGE (Lin 2004)](https://aclanthology.org/W04-1013/) — 访问 2026-09-15 — ✅ — n-gram 召回指标
- [METEOR](https://aclanthology.org/W05-0909/) — 访问 2026-09-15 — ✅ — 同义/词形折中指标
- [chrF](https://aclanthology.org/W15-3049/) — 访问 2026-09-15 — ✅ — 字符级指标
- [BERTScore](https://arxiv.org/abs/1904.09675) — 访问 2026-09-15 — ✅ — 学习型语义相似度
- [BLEURT](https://arxiv.org/abs/2004.04696) — 访问 2026-09-15 — ✅ — 学习型打分器
- [Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena](https://arxiv.org/abs/2306.05685) — 访问 2026-09-15 — ✅ — >80% 一致性、位置/冗长/自我增强偏差
- [Chatbot Arena 论文](https://arxiv.org/abs/2403.04132) — 访问 2026-09-15 — ✅ — pairwise + Bradley-Terry/Elo
- [Arena AI 官网](https://lmarena.ai/) — 访问 2026-09-15 — ✅ — 品牌已更名（原 LMArena）
- [Leaderboard Illusion](https://arxiv.org/abs/2504.20879) — 访问 2026-09-15 — ✅ — 榜单操纵风险
- [G-Eval](https://arxiv.org/abs/2303.16634) — 访问 2026-09-15 — ✅ — CoT + form-filling，Spearman 0.514
- [LLM-as-a-Judge 综述](https://arxiv.org/abs/2411.15594) — 访问 2026-09-15 — ✅ — 裁判偏差与方法梳理
- [去偏即测量干预（judge 分辨率）](https://arxiv.org/abs/2609.12439) — 访问 2026-09-15 — ✅ — 裁判分辨率与去偏
- [Hamel Husain: LLM-as-a-Judge 指南](https://hamel.dev/blog/posts/llm-judge/) — 访问 2026-09-15 — ✅ — 裁判落地与校准
- [Eugene Yan: Evaluating LLM-Evaluators](https://eugeneyan.com/writing/llm-evaluators/) — 访问 2026-09-15 — ✅ — 评估器选型实践
- [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) — 访问 2026-09-15 — ✅ — 漏斗式评测工作流
- [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅ — code/model/human 三类 grader
- [Agent-as-Judge](https://arxiv.org/abs/2410.10934) — 访问 2026-09-15 — ✅ — 裁判用于 Agent 评测
