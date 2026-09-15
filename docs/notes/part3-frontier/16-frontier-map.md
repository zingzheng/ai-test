# 第 16 章 2026 变动地图与开放问题

> **一句话结论**：AI 测评领域最危险的不是"不知道"，而是"拿三年前的中文资料当今天的事实"——本章把所有已终止、已归档、已更名、已关停、已换代的变动集中标注，并诚实指出哪些问题还没有答案。

---

本章是第三部分的收口，也是整本书的"保鲜层"。前 15 章讲的是方法论与工具，这一章讲的是：**这些结论什么时候会过期、过期后该看哪里**。

## 16.1 为什么 AI 测评需要一张"变动地图"

测评知识有一个特殊性质：它既是**方法**，也是**具体对象**。方法论（如 LLM-as-Judge 的偏差、precision/recall 校准）相对稳定；但被评测的对象——榜单、基准、仓库、平台、法规——更新极快。后果是中文互联网上大量"看起来还很新"的教程其实是错的：

- 仍在教你用 `Azure/PyRIT`，但现役主仓库已是 `microsoft/PyRIT`，旧仓库 **2026-03-27 已归档只读**。来源：[microsoft/PyRIT](https://github.com/microsoft/PyRIT)、[Azure/PyRIT（旧，已归档）](https://github.com/Azure/PyRIT)。
- 仍把竞技场写作 "Chatbot Arena / LMArena"，但官网已更名为 **Arena AI**。来源：[Arena AI 官网](https://lmarena.ai/)。
- 仍在引用 `tau-bench`，但原仓库已废弃，现役是 **τ³-bench**。来源：[τ³-bench 仓库](https://github.com/sierra-research/tau2-bench)、[taubench.com](https://taubench.com)。

这类错误的代价不是"细节不准"，而是让人照着过时文档做错选型（例如选一个马上要关停的平台）。所以 §5.4 的时效地图值得单独成章。

## 16.2 变动地图

下表把 README §5.4 展开成可核对条目；日期均来自素材，未标注者表示素材中未给出确切日期。

| 类型 | 具体事实 | 关键日期 | 来源 |
|---|---|---|---|
| 榜单终止 | HF Open LLM Leaderboard 已终止（Space 讨论区置顶公告） | 截至 2026-09 | [HF Open LLM Leaderboard](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard) |
| 进入维护模式 | Stanford HELM 进入维护模式 | 2026-06-01 | [HELM 官网](https://crfm.stanford.edu/helm/)、[HELM 仓库](https://github.com/stanford-crfm/helm) |
| 仓库归档 | BIG-bench 仓库归档只读，不再演进 | 2026-04-17 | [google/BIG-bench](https://github.com/google/BIG-bench)、[BIG-bench 论文](https://arxiv.org/abs/2206.04615) |
| 仓库归档 | HAL harness 归档、停止接收新提交、榜单暂停更新，团队转向 agent reliability | 2026-07-01 | [hal-harness](https://github.com/princeton-pli/hal-harness)、[HAL 官网](https://hal.cs.princeton.edu/) |
| 品牌更名 | LMSYS Chatbot Arena / LMArena → **Arena AI** | 截至 2026-09 | [Arena AI](https://lmarena.ai/) |
| 基准换代 | tau-bench → **τ²/τ³-bench**（旧仓库废弃）；τ³ 于 v1.0.1 修复 banking_knowledge 评分，旧结果不可比 | 2026-07 | [τ³-bench 仓库](https://github.com/sierra-research/tau2-bench)、[τ² 论文](https://arxiv.org/abs/2506.07982) |
| 基准换代 | MMLU 被认为饱和 → 推荐 **MMLU-Pro** | — | [MMLU-Pro 论文](https://arxiv.org/abs/2406.01574) |
| 基准停办 | ILSVRC（ImageNet 挑战赛）2017 年后停办，Top-1/Top-5 仍惯用 | 2017 后 | [ImageNet 挑战页](https://www.image-net.org/)、[ILSVRC 论文](https://arxiv.org/abs/1409.0575) |
| 组织迁移 | SWE-bench：`princeton-nlp` → **`SWE-bench` 组织** | — | [SWE-bench 仓库](https://github.com/SWE-bench/SWE-bench)、[swebench.com](https://swebench.com/) |
| 组织迁移 | PyRIT：`Azure/` → **`microsoft/`**（旧仓库归档只读） | 2026-03-27 | [microsoft/PyRIT](https://github.com/microsoft/PyRIT) |
| 组织迁移 | OTel GenAI semconv 从主 semconv **拆为独立仓库** | 2025 起 | [semantic-conventions-genai](https://github.com/open-telemetry/semantic-conventions-genai) |
| 组织迁移 | FlagEval 主代码迁至 `flageval-baai` 组织 | — | [FlagOpen/FlagEval](https://github.com/FlagOpen/FlagEval) |
| 版本更新 | OWASP LLM Top 10 **2026 版**发布，风险排序与范围不同于 2023 v1.1 | 2026-08-03 | [OWASP 2026 发布页](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/)、[规范源](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10) |
| 版本更新 | TC260《人工智能安全治理框架 **3.0**》发布 | 2026-09-14 | [TC260 新闻页](https://www.tc260.org.cn/tc260/xwdt1/202609/d513a007d04347f58e483fabaefb34b8.shtml) |
| 版本更新 | C-Eval 公开完整测试集（此前测试集不公开） | 2025-07-27 | [C-Eval 仓库](https://github.com/hkust-nlp/ceval) |
| 平台关停/退场 | OpenAI Evals 平台：转只读 → 关停，官方建议改用 Datasets | 2026-10-31 / 2026-11-30 | [OpenAI Evals 指南](https://platform.openai.com/docs/guides/evals) |
| 平台关停/退场 | Humanloop 平台 sunset（团队加入 Anthropic） | 截至 2026-09 | [Humanloop 官网](https://humanloop.com/) |
| 文档/品牌迁移 | Google Vertex AI 评测文档迁至 **Gemini Enterprise Agent Platform** | 截至 2026-09 | [Gemini Enterprise Agent Platform 评测](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/evaluation-overview) |
| 标准落地 | 国标 **GB/T 45654-2025** 发布 → 实施（生成式 AI 安全基线） | 2025-04-25 / 2025-11-01 | [国家标准全文公开系统](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A) |
| 法规落地 | EU AI Act **全面适用**；AI Omnibus（简化修法）生效，高风险时间线后延（Annex III→2027-12-02、Annex I→2028-08-02）；新增禁止第 9 类 2026-12-02 适用 | 2026-08-02 / 2026-07-27 | [EU AI Act 官方页](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)、[实施时间线](https://artificialintelligenceact.eu/implementation-timeline/) |

> 读表方式：**先看"类型"，再看"日期"**。凡正文或旧资料与本表冲突，以本表和最新官方源为准。这张表本身也需要持续维护——它是会过期的元数据。

## 16.3 开放问题

变动地图记录"已有答案但已变旧"的部分。下面五类则是**尚无定论**的开放问题，也是 2026 年前沿的着力点。

**① 多模态评测。** GAIA 这类"对人类简单、对 AI 难"的任务已要求推理 + 多模态 + 浏览 + 工具协同；MLCommons AILuminate 也已把 Multimodal 列为工作流之一。但如何公平地评"看图 + 推理 + 行动"的组合能力，仍缺统一口径。来源：[GAIA 论文](https://arxiv.org/abs/2311.12983)、[AILuminate](https://mlcommons.org/ailuminate/)。

**② 长时程 agent。** OSWorld、τ³-bench 把任务从"答题"推到多步真实操作，但任务越长，环境与脚手架噪声、随机性、失败归因就越难剥离；Anthropic 已观察到资源配额可让 Terminal-Bench 2.0 分数摆动 **6pp**（p<0.01），超过头部模型差距，并建议同时声明 floor 与 ceiling。来源：[OSWorld 论文](https://arxiv.org/abs/2404.07972)、[基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise)。

**③ 评测成本。** 《AI Agents That Matter》指出只盯 accuracy、忽略 cost 是普遍问题；HAL 用约 $40k、21,730 次 rollout 才做出一版成本敏感榜单，而它本身已归档。**谁来承担持续评测的成本、如何让成本可复现**，仍是空白。来源：[AI Agents That Matter](https://arxiv.org/abs/2407.01502)、[HAL 论文](https://arxiv.org/abs/2510.11977)。

**④ 评测饱和。** MMLU 饱和后被 MMLU-Pro 取代，但对前沿模型而言，新基准的"有效期"越来越短。ABC 清单进一步指出，现存 agentic benchmark 的缺陷（测试用例不足、把空响应当成功）可导致**相对误差高达 100%**。饱和与"榜单失真"是同一枚硬币的两面。来源：[MMLU-Pro](https://arxiv.org/abs/2406.01574)、[ABC 清单](https://arxiv.org/abs/2507.02825)。

**⑤ judge 的分辨率。** 一味去除偏差会压低 judge 的分辨率——把真实差距误判为 Tie；有研究因此呼吁联合报告 bias suppression / resolution / Tie cost（该工作已被 EMNLP 2026 接收）。Agent-as-Judge 则试图用 agent 评 agent 来补足中间反馈。来源：[去偏即测量干预](https://arxiv.org/abs/2609.12439)、[LLM-as-a-Judge 综述](https://arxiv.org/abs/2411.15594)、[Agent-as-Judge](https://arxiv.org/abs/2410.10934)。

## 16.4 怎么保持不过时

与其背结论，不如把**可追踪的来源**加进收藏夹，按"仓库 → issue/讨论区 → 官方博客"三层盯：

- **框架/基准仓库（看 commit 与归档状态）**：[lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness)、[stanford-crfm/helm](https://github.com/stanford-crfm/helm)、[SWE-bench/SWE-bench](https://github.com/SWE-bench/SWE-bench)、[sierra-research/tau2-bench](https://github.com/sierra-research/tau2-bench)。
- **榜单与讨论区（公告常在此）**：[HF Open LLM Leaderboard Space](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard)、[taubench.com](https://taubench.com)、[hal.cs.princeton.edu](https://hal.cs.princeton.edu/)、[Arena AI](https://lmarena.ai/)。
- **官方博客/文档（看停服与迁移公告）**：[OpenAI Evals](https://platform.openai.com/docs/guides/evals)、[Humanloop](https://humanloop.com/)、[Gemini Enterprise Agent Platform](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/evaluation-overview)、[Anthropic Engineering](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)、[Hamel Husain](https://hamel.dev/blog/posts/llm-judge/)。
- **标准与法规官网（看实施日期）**：[TC260](https://www.tc260.org.cn/)、[国家标准全文公开系统](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A)、[EU AI Act 时间线](https://artificialintelligenceact.eu/implementation-timeline/)、[NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework)。
- **一手论文（看方法是否被后继工作推翻）**：[arXiv](https://arxiv.org/) 上的 MMLU-Pro、ABC、judge 分辨率等条目。

## 16.5 结语：回到"评测是迭代引擎"

第 13 章说评测是"持续迭代的引擎"。引擎要稳定输出，前提是**输入不腐坏**——数据会漂移、基准会饱和、平台会关停、法规会改时间表。所以"保鲜"不是附赠品，而是评测工程的一部分：一张持续维护的变动地图，让团队不至于把三年前的结论当成今天的基线；而诚实地列出开放问题，则提醒我们——**评测没有终局，只有下一轮循环**。

---

## 本章要点

- 测评知识分两层：方法论相对稳定，**具体对象（榜单/基准/仓库/平台/法规）变化极快**。
- 变动地图按类型记录：榜单终止、维护模式、仓库归档、品牌更名、基准换代、组织迁移、版本更新、平台关停、标准/法规落地，每条带日期与来源。
- 典型陷阱：`Azure/PyRIT` 已归档、LMArena 已更名 Arena AI、`tau-bench` 已换代为 τ³-bench、OpenAI Evals 平台 2026-11-30 关停。
- 五大开放问题：多模态、长时程 agent、评测成本、评测饱和、judge 分辨率。
- 保持不过时的做法：盯仓库 commit/归档、榜单讨论区公告、官方停服迁移公告、法规官网实施日期、一手论文。
- 评测是迭代引擎，而"保鲜"是引擎的输入保障。

## 来源

- [HF Open LLM Leaderboard（Space）](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard) — 访问 2026-09-15 — ✅ — 榜单终止公告
- [Stanford HELM 官网](https://crfm.stanford.edu/helm/) — 访问 2026-09-15 — ⚠️ — 2026-06-01 维护模式
- [stanford-crfm/helm](https://github.com/stanford-crfm/helm) — 访问 2026-09-15 — ✅ — HELM 代码
- [google/BIG-bench](https://github.com/google/BIG-bench) — 访问 2026-09-15 — ✅ — 2026-04-17 归档
- [BIG-bench 论文](https://arxiv.org/abs/2206.04615) — 访问 2026-09-15 — ✅ — 协作基准
- [princeton-pli/hal-harness](https://github.com/princeton-pli/hal-harness) — 访问 2026-09-15 — ✅ — 2026-07-01 归档
- [HAL 官网](https://hal.cs.princeton.edu/) — 访问 2026-09-15 — ✅ — 成本敏感榜单与 reliability
- [HAL 论文](https://arxiv.org/abs/2510.11977) — 访问 2026-09-15 — ✅ — rollout 与成本
- [Arena AI 官网](https://lmarena.ai/) — 访问 2026-09-15 — ✅ — 原 LMArena 更名
- [sierra-research/tau2-bench](https://github.com/sierra-research/tau2-bench) — 访问 2026-09-15 — ✅ — τ³-bench 现役仓库
- [taubench.com](https://taubench.com) — 访问 2026-09-15 — ✅ — τ³ 实时榜
- [τ²-bench 论文](https://arxiv.org/abs/2506.07982) — 访问 2026-09-15 — ✅ — Dual-Control
- [τ-bench 论文](https://arxiv.org/abs/2406.12045) — 访问 2026-09-15 — ✅ — 原 τ-bench 与 pass^k
- [MMLU-Pro 论文](https://arxiv.org/abs/2406.01574) — 访问 2026-09-15 — ✅ — MMLU 换代
- [ImageNet 官网](https://www.image-net.org/) — 访问 2026-09-15 — ✅ — ILSVRC 停办
- [ILSVRC 论文](https://arxiv.org/abs/1409.0575) — 访问 2026-09-15 — ✅ — Top-1/Top-5 协议
- [SWE-bench 仓库](https://github.com/SWE-bench/SWE-bench) — 访问 2026-09-15 — ✅ — 组织迁移
- [swebench.com](https://swebench.com/) — 访问 2026-09-15 — ✅ — 现役榜单
- [microsoft/PyRIT](https://github.com/microsoft/PyRIT) — 访问 2026-09-15 — ✅ — 现役主仓库
- [Azure/PyRIT（旧，已归档）](https://github.com/Azure/PyRIT) — 访问 2026-09-15 — ✅ — 2026-03-27 归档
- [semantic-conventions-genai](https://github.com/open-telemetry/semantic-conventions-genai) — 访问 2026-09-15 — ✅ — OTel GenAI 拆仓
- [FlagOpen/FlagEval](https://github.com/FlagOpen/FlagEval) — 访问 2026-09-15 — ✅ — 迁至 flageval-baai
- [OWASP LLM Top 10 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) — 访问 2026-09-15 — ✅ — 2026-08-03 发布
- [OWASP GenAI-LLM-Top10 规范源](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10) — 访问 2026-09-15 — ✅ — 2026 规范
- [OWASP 旧版（2023 v1.1）](https://owasp.org/www-project-top-10-for-large-language-model-applications/) — 访问 2026-09-15 — ✅ — 版本对照
- [TC260 新闻页（治理框架 3.0）](https://www.tc260.org.cn/tc260/xwdt1/202609/d513a007d04347f58e483fabaefb34b8.shtml) — 访问 2026-09-15 — ✅ — 2026-09-14 发布
- [TC260 官网](https://www.tc260.org.cn/) — 访问 2026-09-15 — ✅ — 应用安全指引
- [C-Eval 仓库](https://github.com/hkust-nlp/ceval) — 访问 2026-09-15 — ✅ — 2025-07-27 公开测试集
- [OpenAI Evals 指南](https://platform.openai.com/docs/guides/evals) — 访问 2026-09-15 — ✅ — 2026-11-30 关停
- [Humanloop 官网](https://humanloop.com/) — 访问 2026-09-15 — ✅ — 平台 sunset
- [Gemini Enterprise Agent Platform 评测](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/evaluation-overview) — 访问 2026-09-15 — ✅ — Vertex 文档迁移
- [GB/T 45654-2025（国家标准全文公开系统）](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A) — 访问 2026-09-15 — ✅ — 2025-11-01 实施
- [EU AI Act 官方页](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) — 访问 2026-09-15 — ✅ — 全面适用与 AI Omnibus
- [EU AI Act 实施时间线](https://artificialintelligenceact.eu/implementation-timeline/) — 访问 2026-09-15 — ✅ — 时间线后延
- [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework) — 访问 2026-09-15 — ✅ — Govern/Map/Measure/Manage
- [GAIA 论文](https://arxiv.org/abs/2311.12983) — 访问 2026-09-15 — ✅ — 多模态 + 工具协同
- [MLCommons AILuminate](https://mlcommons.org/ailuminate/) — 访问 2026-09-15 — ✅ — Multimodal 工作流（含中文 T2T）
- [OSWorld 论文](https://arxiv.org/abs/2404.07972) — 访问 2026-09-15 — ✅ — 长时程电脑操作
- [Anthropic：基础设施噪声](https://www.anthropic.com/engineering/infrastructure-noise) — 访问 2026-09-15 — ✅ — 6pp 摆动
- [AI Agents That Matter](https://arxiv.org/abs/2407.01502) — 访问 2026-09-15 — ✅ — 成本与可复现性
- [Agentic Benchmark Checklist（ABC）](https://arxiv.org/abs/2507.02825) — 访问 2026-09-15 — ✅ — 相对误差可达 100%
- [去偏即测量干预（judge 分辨率）](https://arxiv.org/abs/2609.12439) — 访问 2026-09-15 — ✅ — 已被 EMNLP 2026 接收
- [LLM-as-a-Judge 综述](https://arxiv.org/abs/2411.15594) — 访问 2026-09-15 — ✅ — judge 可靠性
- [Agent-as-Judge](https://arxiv.org/abs/2410.10934) — 访问 2026-09-15 — ✅ — 用 agent 评 agent
- [EleutherAI lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness) — 访问 2026-09-15 — ✅ — 持续活跃可追踪
- [Anthropic《Demystifying evals for AI agents》](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅ — 官方方法论更新
- [Hamel Husain《LLM-as-a-Judge 完整指南》](https://hamel.dev/blog/posts/llm-judge/) — 访问 2026-09-15 — ✅ — 2026-09 更新
