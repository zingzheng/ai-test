# 第 14 章 可复现性危机

> **一句话结论**：可复现性危机不是某一篇论文的指控，而是一条由"成本缺失、基础设施噪声、榜单失真、基准缺陷"四环扣成的证据链——它意味着**排行榜上那点分差，往往比评测者愿意承认的更不可信**。

---

> 本章对应第 3 章"读榜单的正确姿势"的深水区。上一章讲怎么把评测做成引擎，这一章讲为什么很多公开分数根本不值得当真。**注意：并不存在一篇同名的"可复现性危机"权威论文**；它是由下面四篇（项）工作共同支撑的结论。

## 14.1 什么是"可复现性危机"

科学意义上的**可复现性（reproducibility）**指：换一个人、换一台机器、用同样配置，能否得到同样的结论。LLM/Agent 评测在这件事上先天脆弱——模型是黑箱、推理有随机性、工具与网络环境会漂移、排行榜由厂商或平台自己运营。

于是"危机"不是单点造假，而是一组**系统性偏差的叠加**：报分数时不报成本，换机器就掉几个点，榜单规则可被选择性地利用，基准的评分脚本本身还会算错。任何一环单独看都像是"工程细节"，四环合起来就足以颠覆"谁比谁强 2 个百分点"这类结论。来源：[AI Agents That Matter](https://arxiv.org/abs/2407.01502)、[Anthropic：基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise)、[The Leaderboard Illusion](https://arxiv.org/abs/2504.20879)、[ABC](https://arxiv.org/abs/2507.02825)。

## 14.2 只看精度不看成本：《AI Agents That Matter》

这篇论文的批评有两层。第一层是**只盯 accuracy、忽略 cost**：一个 Agent 多调十倍工具、多烧十倍 token 换来的几个百分点提升（示意），被当成纯粹的进步来宣传，而部署方一眼就会否掉。第二层是**holdout 不足**：Agent 基准常被反复调参、针对性优化，等于把测试集当训练集用，成绩虚高。

论文的总判断是：这一领域存在 **"pervasive lack of reproducibility"（普遍的可复现性缺失）**。它因此成为本主题最常被引用的锚点。来源：[AI Agents That Matter](https://arxiv.org/abs/2407.01502)。

## 14.3 基础设施噪声：同一模型，分数自己会动

Anthropic 在 2026-02-05 的工程博客里给出了一个残酷的对照实验：在 **Terminal-Bench 2.0** 上，仅仅改变**资源配额**（CPU/内存等基础设施配置），同一个模型的分数就能摆动约 **6 个百分点**（p<0.01）——这个幅度**超过了头部模型之间的差距**。

换句话说，你看到的"模型 A 比模型 B 强"，很可能只是 A 分到了更宽松的机器。Anthropic 的建议是：报告成绩时**同时声明 floor 与 ceiling**（最差与最好配置下的区间），并据此判断——**排行里 <3pp 的差异本身就应存疑**。来源：[Anthropic：基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise)（2026-02-05）。

## 14.4 榜单失真：《The Leaderboard Illusion》

如果说 14.3 是"机器不公平"，这一篇讲的是"规则不公平"。论文对 Chatbot Arena 的分析指出三种系统性做法：

- **私有测试**：厂商可先私下测试多个变体，只把最好的那个放上公开榜——报告称 Meta 曾使用 27 个私有变体。
- **选择性披露**：只公开对自己有利的结果。
- **抽样与移除不对称**：不同参与方在数据获取与下架规则上受到的待遇不同——Google 与 OpenAI 各获得约 19–20% 的数据。

这些做法单独都不违规，但叠加起来会**系统性抬高排名**，并让后来者无法复现同样的排名。论文也给出了改革建议。来源：[The Leaderboard Illusion](https://arxiv.org/abs/2504.20879)（arXiv 2504.20879，2025-05）。

## 14.5 基准本身的缺陷：Agentic Benchmark Checklist（ABC）

前两节说的是"怎么用"，这一节说的是**考卷本身印错了**。ABC 论文点名批评现存 Agentic benchmark 的严谨性：

- **SWE-bench Verified**：测试用例（test cases）不足，导致通过率被高估。
- **TAU-bench**（原 τ-bench，现役为 τ³-bench）：把**空响应也判定为成功**，直接制造假阳性。

论文估计，这些缺陷可造成**相对误差高达 100%**——也就是"成绩可能翻倍地错"。为此它提出 **Agentic Benchmark Checklist（ABC）**，在 CVE-Bench 上把高估降低了 **33%**。来源：[Agentic Benchmark Checklist](https://arxiv.org/abs/2507.02825)（arXiv 2507.02825，v5 2025-08）。

> 相关基准：SWE-bench Verified 见 [官方说明](https://www.swebench.com/verified.html) 与 [OpenAI 介绍](https://openai.com/index/introducing-swe-bench-verified/)；τ-bench 见 [论文](https://arxiv.org/abs/2406.12045)。

## 14.6 一份"信得过"的评测报告应包含什么

综合上述证据链，一份能被别人复现的报告至少要有四件东西：

| 要素 | 要写什么 | 依据 |
|---|---|---|
| **成本** | 不只是分数，还要报 token、调用次数、延迟、金钱成本 | [AI Agents That Matter](https://arxiv.org/abs/2407.01502) |
| **Holdout** | 明确哪些数据从未用于调参；避免把测试集当训练集 | [AI Agents That Matter](https://arxiv.org/abs/2407.01502) |
| **配置** | 硬件、资源配额、版本、prompt/工具设置全部公开 | [基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise) |
| **方差/置信区间** | 跑多次报区间；同时给 floor 与 ceiling；<3pp 差异存疑 | [基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise) |

补充两点：报告应说明**评测列表是否可能被私有测试/选择性披露污染**（见 14.4），以及**评分脚本是否经过审查**（见 14.5）。做到这些，才算把"可复现"从口号变成可执行的清单。

---

## 本章要点

- "可复现性危机"不是单一论文，而是四环证据链：成本缺失、基础设施噪声、榜单失真、基准缺陷。
- 《AI Agents That Matter》批评**只看精度不看成本**与 **holdout 不足**，点出"pervasive lack of reproducibility"。
- Anthropic 发现**资源配额**可让 Terminal-Bench 2.0 摆动约 **6pp**（p<0.01），超过头部模型差距；报告应给 **floor+ceiling**，**<3pp 的排行差异应存疑**。
- 《The Leaderboard Illusion》揭示**私有测试、选择性披露、抽样与移除不对称**会系统性抬高排名。
- ABC 指出 **SWE-bench Verified 测试用例不足、TAU-bench 把空响应算成功**，相对误差可高达 **100%**。
- 信得过的报告 = **成本 + holdout + 配置 + 方差/置信区间**，并交代榜单与评分脚本的可疑之处。

## 来源

- [AI Agents That Matter](https://arxiv.org/abs/2407.01502) — 访问 2026-09-15 — ✅ — 成本、holdout、可复现性缺失
- [Anthropic：基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise) — 访问 2026-09-15 — ✅ — 6pp 摆动、floor+ceiling、<3pp 存疑
- [The Leaderboard Illusion](https://arxiv.org/abs/2504.20879) — 访问 2026-09-15 — ✅ — 私有测试、选择性披露、抽样/移除不对称
- [Agentic Benchmark Checklist（ABC）](https://arxiv.org/abs/2507.02825) — 访问 2026-09-15 — ✅ — SWE-bench Verified、TAU-bench、100% 相对误差、33% 降低
- [SWE-bench Verified 官方说明](https://www.swebench.com/verified.html) — 访问 2026-09-15 — ✅ — 基准背景
- [OpenAI：Introducing SWE-bench Verified](https://openai.com/index/introducing-swe-bench-verified/) — 访问 2026-09-15 — ✅ — 基准背景
- [τ-bench](https://arxiv.org/abs/2406.12045) — 访问 2026-09-15 — ✅ — 被 ABC 点名的基准
- [数据污染综述](https://arxiv.org/abs/2502.14425) — 访问 2026-09-15 — ✅ — 训练/测试重叠导致虚高
