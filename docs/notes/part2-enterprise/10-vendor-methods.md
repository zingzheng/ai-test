# 第 10 章 大厂方法论拆解

> **一句话结论**：四家官方方法论表面各说各话，内核高度一致——都要求把「跑一次分」升级成「可回归、可校准、多层拦截」的系统，差异只在 Anthropic 讲得最透、OpenAI 最工程化却即将关停、Google 偏成对评判、Azure 偏开箱即用。

---

> 本章对应第 4 章建议的「大厂方法论拆解」。四家厂商是 AI 评测实践的天花板，读它们的一手文档，比读二手总结更能建立正确心智。

## 10.1 为什么要看大厂方法论

大厂方法论的价值不在于「照抄」，而在于它们是**已被真实生产验证过的抽象**：Anthropic 在自家多款 Agent 上跑过，OpenAI 把 eval 做成了平台 API，Google 与 Azure 把评测嵌进了云产品。它们替你先踩了坑，把「评测到底该由哪些零件组成」沉淀成了术语和流程。理解这套共同语言后，再看第 9 章工具链，就能一眼看出每个工具在补哪块板。

## 10.2 Anthropic《Demystifying evals for AI agents》（2026-01-09）

这是四家中最值得精读的一篇，它几乎给出了 Agent 评测的「标准词表」。

**核心术语定义**：

| 术语 | 定义 |
|---|---|
| task（problem / test case） | 一个带明确输入与成功标准的测试 |
| trial | 对同一个 task 的一次尝试；因模型输出有随机性，需多次 trial |
| grader | 给 Agent 表现某方面打分的逻辑；一个 task 可有多个 grader，每个含多条 assertion/check |
| transcript（trace / trajectory） | 一次 trial 的完整记录：输出、工具调用、推理、中间结果 |
| outcome | trial 结束时的**环境最终状态**；订票 Agent 说「已订好」不算数，数据库里有没有订单才算 |
| eval harness | 端到端跑评测的基础设施：发指令与工具、并发跑 task、记录、打分、汇总 |
| agent harness（scaffold） | 让模型能以 Agent 方式行动的系统；评「Agent」= harness 与模型一起评 |

> 来源：[Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)（Anthropic, 2026-01-09）— ✅

**三类 grader 的优缺点**：code-based（快、便宜、客观、可复现，但对合法变体脆弱、缺细腻度）、model-based（灵活、可扩展、能处理开放式输出，但非确定性、更贵、需人类校准）、human（黄金标准、可校准模型 grader，但贵、慢、难规模化）。

**capability vs regression evals**：capability（质量）eval 问「这个 Agent 还能做什么」，起点应是低通过率，给团队一个要爬的山；regression eval 问「它是否还搞得定以前的任务」，通过率应接近 100%，用于防回退。当一个 capability eval 的通过率变高，它可以「毕业」成持续运行的回归套件。

**pass@k vs pass^k**：pass@k 是 k 次尝试中**至少一次**成功的概率，k 越大越高，适合「一次对就行」的工具；pass^k 是 k 次**全部**成功的概率，k 越大越低，适合要求稳定一致的面向用户 Agent。原文举例：单次成功率 75%、跑 3 次全过的概率约 (0.75)³ ≈ 42%。k=1 时两者相等，k=10 时一个趋近 100%、另一个趋近 0%。

**从 0 到 1 的路线（原文 Step 0–8）**：Step 0 尽早开始（20–50 个来自真实失败的任务就是好起点）；Step 1 从你已经在手动测的东西出发；Step 2 写出无歧义、且带 reference solution 的 task；Step 3 构建正负样例平衡的问题集（只测「该做而没做」会催生过度触发的 Agent）；Step 4 搭建隔离、环境稳定的 eval harness；Step 5 用心设计 grader（尽量确定性，评产出而非死板路径，多组件给部分分）；Step 6 读 transcript；Step 7 监控 capability eval 饱和；Step 8 靠开放贡献与维护让套件长期健康。

**Swiss Cheese 多层验证**：如同安全工程的瑞士奶酪模型，没有任何单层评测能抓住所有问题，自动 eval、生产监控、A/B、用户反馈、人工读 transcript、系统性人工研究各挡一层，漏过一层的失败会被另一层接住。

> 来源同上 — ✅

## 10.3 OpenAI Evals：API 与开源框架（重要时效）

OpenAI 提供两条路径：**云端 Evals API**（用 `data_source_config` 描述数据、用 `testing_criteria` 定义 grader，跑出 eval run 与 report）与**开源框架**（`openai/evals`：JSONL 数据集 + YAML eval 模板，含 basic 与 model-graded 模板、合成数据生成，可放进 CI/CD）。

**必须记住的时效事实**：OpenAI 正在弃用 Evals 平台——**2026-10-31 转为只读，2026-11-30 正式关停，官方建议改用 Datasets**。也就是说，本笔记记录它主要出于「演进史」与「迁移提醒」的价值，新项目不应再押注这套 API。

> 来源：[OpenAI Evals 指南](https://platform.openai.com/docs/guides/evals) — ✅（2026-11-30 关停）
> 来源：[OpenAI Evals Cookbook](https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals) — ✅
> 来源：[openai/evals 仓库](https://github.com/openai/evals) — ✅

## 10.4 Google：rubric-based metrics 与 AutoSxS

Google Cloud 的评测文档现已迁到 **Gemini Enterprise Agent Platform** 品牌，旧的 Vertex AI 链接会 301 重定向到新域名。其方法论重点是 **rubric-based metrics**（用评分规则而非单一正确答案来度量开放式输出）与 **AutoSxS**（Automatic Side-by-Side，用一个 judge model 做 A/B 式成对比较），并覆盖 judge model 配置、evaluation SDK 与 Agent 评测。成对比较与 rubric 正是第 2 章讲过的 LLM-as-Judge 在云产品里的工程化落地。

> 来源：[Gemini Enterprise Agent Platform 评测总览](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/evaluation-overview) — ✅（原 Vertex AI 链接重定向）

## 10.5 Microsoft Azure AI Foundry Evaluation SDK

Azure 走「开箱即用」路线：内置 evaluator 分成 **General / 文本相似度 / RAG / 风险与安全 / Agentic / AzureOpenAI graders** 几大类，通过统一的 `evaluate()` API 调用，支持 JSONL、多轮 conversation 与多模态输入。一个值得注意的透明度差异：**质量类 evaluator 的 prompt 是开源的，风险/安全类不开源**——安全评测的可解释性因此弱于质量评测。

> 来源：[Azure AI Foundry Evaluation SDK](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/develop/evaluate-sdk) — ✅

## 10.6 四家共识与分歧

| 维度 | Anthropic | OpenAI | Google | Microsoft Azure |
|---|---|---|---|---|
| 主要形态 | 工程博客方法论 | Evals API + 开源框架 | 云平台评测服务 | Evaluation SDK |
| 核心抓手 | task/trial/grader/harness | `testing_criteria`(graders) | rubric + **AutoSxS** 成对比较 | 六大类内置 evaluator |
| grader 主张 | 混合 code/model/human | 程序化 + model-graded 模板 | rubric metrics + judge | 预制 + AzureOpenAI graders |
| 独特贡献 | pass@k / pass^k、8 步路线、Swiss Cheese | 平台化 API、开源 registry | 成对评测工程化 | 开箱即用、多模态/多轮 |
| 透明度 | 高（全公开） | 高（仓库开源） | 中 | 质量类开源，安全类不开源 |
| 2026 时效 | 现役 | **2026-11-30 关停** | 品牌迁移 | 现役 |

**共识**：都走向「混合 grader + 可回归套件 + 人工校准」；都强调按风险分层，而非单一分数。**分歧**：开放程度（Azure 安全类闭源）、是否成对比较（Google 的 AutoSxS 最突出）、以及平台生命周期（OpenAI 正在退场）。

---

## 本章要点

- Anthropic 给出最完整词表：task / trial / grader / transcript / outcome / eval harness / agent harness；评 Agent 就是评 harness 与模型之和。
- 三类 grader 各有所长：code 客观但脆弱，model 灵活但需校准，human 是黄金标准但昂贵。
- capability eval 追求「能爬的山」，regression eval 追求「不摔下来」；前者可毕业为后者。
- pass@k 看「至少一次对」，pass^k 看「每次都稳」，两者随 k 增大而分道扬镳。
- OpenAI Evals 平台 2026-10-31 只读、11-30 关停，官方建议改用 Datasets。
- Google 用 rubric + AutoSxS；Azure 预制六大类 evaluator，安全类 prompt 不开源。
- 四家殊途同归：混合 grader、多层验证（Swiss Cheese）、回归门禁。

## 来源

- [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — 访问 2026-09-15 — ✅ — Anthropic 评测方法论（2026-01-09）
- [OpenAI Evals 指南](https://platform.openai.com/docs/guides/evals) — 访问 2026-09-15 — ✅ — Evals API（2026-11-30 关停）
- [OpenAI Evals Cookbook](https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals) — 访问 2026-09-15 — ✅ — 入门与 CI 集成
- [openai/evals 仓库](https://github.com/openai/evals) — 访问 2026-09-15 — ✅ — JSONL + YAML 开源框架
- [Gemini Enterprise Agent Platform 评测总览](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/evaluation-overview) — 访问 2026-09-15 — ✅ — rubric / AutoSxS（原 Vertex AI 重定向）
- [Azure AI Foundry Evaluation SDK](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/develop/evaluate-sdk) — 访问 2026-09-15 — ✅ — 内置 evaluator 分类
