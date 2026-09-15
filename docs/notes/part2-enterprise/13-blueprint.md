# 第 13 章 端到端落地蓝图

> **一句话结论**：把评测落地的核心不是"买一个平台"，而是一条可复制的循环——**约 30 例真实数据起步 → 域专家 pass/fail + critique → 校准 judge → 接进 CI → 生产监控回灌**，让评测从一次性验收变成持续迭代的引擎。

---

本章是第二部分的收口。前面几章分别讲了工具链、大厂方法论、数据集与 CI，这一章把它们拧成一条**能照着走的路**。路上每一步都有明确的输入与输出，走不通时也知道该回到哪一步。

## 13.1 一个可复制的五步流程

```
① 约 30 例起步 → ② 域专家 pass/fail + critique → ③ judge 校准
        ↑                                                    ↓
        └──────── ⑤ 生产监控回灌 ←────── ④ 进 CI ────────────┘
```

**第 1 步：约 30 例起步。** 输入是**真实 trace**（生产日志、用户反馈、已知失败案例），输出是一份小而真实的初始评测集与初步失败模式。Hamel Husain 明确建议从约 30 例开始，而不是先攒几千条；Anthropic 给出的经验区间是 20–50 例。来源：[Hamel Husain《LLM-as-a-Judge 完整指南》](https://hamel.dev/blog/posts/llm-judge/)、[Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/)。

**第 2 步：域专家判 pass/fail 并写 critique。** 输入是第 1 步的评测集，输出是**专家标注 + 每条失败的具体批评**。为什么要专家而不是众包？因为这一步产出的是**黄金标准**，要给后面的 judge 当校准锚点；Anthropic 也把 grader 分 code / model / human 三类，human 的价值在于**权威（黄金标准）并能校准 model grader**，代价是贵、慢、难规模化（"灵活"是 model grader 的优点，别张冠李戴）。来源：[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)。

**第 3 步：校准 judge。** 输入是专家标注，输出是一个**与专家对齐、且报出 precision/recall 的 judge**。验证每类失败模式建议用约 100 例。来源：[Hamel Husain（同前）](https://hamel.dev/blog/posts/llm-judge/)。

**第 4 步：进 CI。** 输入是校准后的 judge 与基线快照，输出是**每次 PR 的回归门禁**——回归时按用例逐条 pass/fail 拦下，而不是只看均值。来源：[Langfuse CI/CD](https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd)、[promptfoo](https://www.promptfoo.dev/docs/intro/)、[LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation)。

**第 5 步：生产监控与回灌。** 输入是线上 trace，输出是持续指标与**新的失败样本**——它们又回到第 1 步，闭环成引擎。来源：[Langfuse Evaluation Overview](https://langfuse.com/docs/evaluation/overview)。

## 13.2 LLM-as-Judge 工程化

**Critique Shadowing。** Hamel Husain 提出的这套七步法，本质是让领域专家逐条"影子评审"：先少量样本，专家给出判断与书面 critique，再用 critique 反过来改写 judge prompt，反复迭代到 judge 与专家一致。它把"调 prompt"从玄学变成了有反馈信号的工程。来源：[Hamel Husain《LLM-as-a-Judge 完整指南》](https://hamel.dev/blog/posts/llm-judge/)。

**为什么二元判断 + critique 优于 1–5 分仪表盘。** 1–5 分要求不同标注者在没有共同锚点的刻度上对齐，**一致性差、且无法定位问题**；二元的 pass/fail 让标准更容易共享，而附带的 critique 会直接告诉你"哪里错、为什么错"，这些文本还能回灌成新数据。来源同上。

**用 precision/recall，而不是 raw agreement。** 原始一致率会被**类别不平衡**欺骗：当真实失败率很低时，judge 全部判 pass 也能拿到很高的 agreement。precision 回答"被 judge 判失败的里有多少是真失败"，recall 回答"真实失败里有多少被 judge 抓到"，两者分开看才暴露真相。来源：[Hamel Husain（同前）](https://hamel.dev/blog/posts/llm-judge/)、[Precision/Recall（Google 教程）](https://developers.google.com/machine-learning/crash-course/classification/precision-and-recall)、[Eugene Yan《Evaluating LLM-Evaluators》](https://eugeneyan.com/writing/llm-evaluators/)。

**criteria drift。** 团队对"什么算好"的理解会随时间漂移——今天认可的输出，三个月后可能被判失败。Shankar 提出的 criteria drift 提醒我们：judge 不是校准一次就一劳永逸，**标准本身需要定期重新评审**。来源：[Hamel Husain（同前，引用 Shankar）](https://hamel.dev/blog/posts/llm-judge/)。

## 13.3 小团队 vs 大团队的不同路径

| 维度 | 小团队（1–5 人） | 大团队（有平台/专职） |
|---|---|---|
| 起步 | 就用 30–50 例 + 一个 judge，先用电子表格/notebook | 建 dataset/experiment/evaluator 三件套 |
| 角色 | 全员兼标注，域专家是关键稀缺资源 | 专职 eval/数据工程、标注运营、平台 |
| 工具 | 开源、可自托管优先（Langfuse / Phoenix / promptfoo） | 可上 LangSmith / Braintrust 等托管平台 |
| CI | GitHub Action 跑 `experiment` 抛回归即可 | 分级门禁、baseline 审批、trace 数据治理 |
| 重点 | **移除看数据的摩擦**，别买复杂框架 | 标准化 trace 语义（如 OTel GenAI）、跨团队复用 |

小团队最常见的错误是"还没看数据就先搭平台"；大团队最常见的错误是"平台搭好了，却没人真去看失败样本"。来源：[Hamel Husain《Your AI Product Needs Evals》](https://hamel.dev/blog/posts/evals/)、[OTel GenAI Semantic Conventions](https://github.com/open-telemetry/semantic-conventions-genai)、[Arize Phoenix](https://arize.com/docs/phoenix)。

## 13.4 常见反模式清单

- **1–5 分仪表盘**：刻度无锚点、一致性差、无法定位问题；改用二元 pass/fail + critique。
- **只看均值**：均值掩盖长尾失败；回归门禁要**逐用例 pass/fail**。
- **迷信工具/框架**：eval 是"看数据"的系统工程，工具只是容器；先有数据和标准，再谈平台。
- **离线涨分当线上变好**：离线指标只是代理指标（proxy metric），最终必须由在线实验或生产监控验证。
- **用 LLM 裁判却不校准**：不校准的 judge 等于给错误盖了层"自动化"的章；必须用专家标注报 precision/recall。
- **只报精度不报成本**：Agent 评测里 cost/latency 与准确率同样重要。
- **复现性不足**：忽略基础设施噪声时，**<3pp 的排行差异本身就应存疑**；只跑一次就下结论是危险的。

来源：[Hamel Husain](https://hamel.dev/blog/posts/llm-judge/)、[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)、[Langfuse CI/CD](https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd)、[AI Agents That Matter](https://arxiv.org/abs/2407.01502)、[Anthropic：基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise)。

## 13.5 合规落地要点

合规不是文档，而是能变成测试用例的检查项（详见第 8 章）：

- **安全评测**：把越狱与红队纳入 CI——[JailbreakBench](https://jailbreakbench.github.io/)、[HarmBench](https://arxiv.org/abs/2402.04249)、[NVIDIA Garak](https://github.com/NVIDIA/garak)；应用侧按 [OWASP LLM Top 10 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) 建用例。通用聊天安全可参考 [MLCommons AILuminate](https://mlcommons.org/ailuminate/)（含**中文** T2T）。
- **内容标识**：AI 生成合成内容须遵守《[人工智能生成合成内容标识办法](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm)》（2025-09-01 施行）。
- **备案与评估**：面向公众提供生成式 AI 服务须遵守《[生成式人工智能服务管理暂行办法](https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm)》（2023-08-15 施行）；具舆论属性/社会动员能力的服务须做**安全评估 + 算法备案**。
- **技术基线**：[GB/T 45654-2025](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A) 是现行安全国家推荐标准；[TC260 治理框架 3.0](https://www.tc260.org.cn/) 为 2026 最新动态。

> 来源衔接：[第 8 章 安全与合规速览](../part1-basics/08-safety-compliance.md)；国际侧可对照 [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework) 的 Measure 与 EU AI Act 时间线。

## 13.6 回到第 1 章：评测如何成为迭代引擎

第 1 章提出的问题是"评测到底解决什么"。走完这一章可以回答：评测的价值不在那张成绩单，而在**它让团队更快、更准地知道下一步改什么**。30–50 例让循环能启动，专家 critique 让循环有方向，校准 judge 让循环能规模化，CI 让循环自动化，生产监控让循环永不停止——这就是把"一次性验收"变成"持续迭代引擎"的全部秘密。

---

## 本章要点

- 五步循环：30–50 例起步 → 域专家 pass/fail + critique → judge 校准 → 进 CI → 生产监控回灌。
- Critique Shadowing 让调 judge 变成有反馈的工程；二元 + critique 优于 1–5 分仪表盘。
- judge 要报 **precision/recall** 而非 raw agreement，并警惕 **criteria drift**。
- 小团队先看数据、后搭平台；大团队别让平台沦为没人看的摆设。
- 反模式记住五条：1–5 分仪表盘、只看均值、迷信工具、离线涨当线上涨、裁判不校准。
- 合规落地 = 把安全评测、内容标识、备案变成可执行的上线检查项。
- 评测的终点不是分数，而是让产品持续变好的迭代引擎。

## 来源

- [Hamel Husain《Your AI Product Needs Evals》](https://hamel.dev/blog/posts/evals/) — 访问 2026-09-15 — ✅ — L1/L2/L3 与 30 例起步
- [Hamel Husain《LLM-as-a-Judge 完整指南》](https://hamel.dev/blog/posts/llm-judge/) — 访问 2026-09-15 — ✅ — Critique Shadowing、precision/recall、criteria drift
- [Anthropic《Demystifying evals for AI agents》](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅ — 三类 grader、路线
- [Eugene Yan《Evaluating LLM-Evaluators》](https://eugeneyan.com/writing/llm-evaluators/) — 访问 2026-09-15 — ✅ — 评估器选型与偏差
- [Langfuse Evaluation Overview](https://langfuse.com/docs/evaluation/overview) — 访问 2026-09-15 — ✅ — AI Engineering Loop
- [Langfuse CI/CD](https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd) — 访问 2026-09-15 — ✅ — experiment-action 与回归门禁
- [promptfoo](https://www.promptfoo.dev/docs/intro/) — 访问 2026-09-15 — ✅ — YAML 用例与 CI
- [LangSmith Evaluation](https://docs.langchain.com/langsmith/evaluation) — 访问 2026-09-15 — ✅ — offline/online 双轨
- [Arize Phoenix](https://arize.com/docs/phoenix) — 访问 2026-09-15 — ✅ — OTel 可观测
- [OTel GenAI Semantic Conventions](https://github.com/open-telemetry/semantic-conventions-genai) — 访问 2026-09-15 — ✅ — trace 语义标准
- [Precision/Recall（Google 教程）](https://developers.google.com/machine-learning/crash-course/classification/precision-and-recall) — 访问 2026-09-15 — ✅ — precision/recall 定义
- [AI Agents That Matter](https://arxiv.org/abs/2407.01502) — 访问 2026-09-15 — ✅ — 成本与可复现性
- [Anthropic：基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise) — 访问 2026-09-15 — ✅ — <3pp 差异应存疑
- [JailbreakBench](https://jailbreakbench.github.io/) — 访问 2026-09-15 — ✅ — 越狱鲁棒性基准
- [HarmBench](https://arxiv.org/abs/2402.04249) — 访问 2026-09-15 — ✅ — 自动化红队框架
- [NVIDIA Garak](https://github.com/NVIDIA/garak) — 访问 2026-09-15 — ✅ — LLM 漏洞扫描器
- [OWASP LLM Top 10 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) — 访问 2026-09-15 — ✅ — 应用风险清单
- [MLCommons AILuminate](https://mlcommons.org/ailuminate/) — 访问 2026-09-15 — ✅ — 含中文 T2T
- [生成式人工智能服务管理暂行办法](https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm) — 访问 2026-09-15 — ✅ — 备案与安全评估
- [人工智能生成合成内容标识办法](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm) — 访问 2026-09-15 — ✅ — 内容标识
- [GB/T 45654-2025](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A) — 访问 2026-09-15 — ✅ — 安全技术基线
- [TC260 官网](https://www.tc260.org.cn/) — 访问 2026-09-15 — ✅ — 治理框架 3.0
- [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework) — 访问 2026-09-15 — ✅ — Govern/Map/Measure/Manage
