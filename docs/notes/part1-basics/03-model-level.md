# 第 3 章 模型级测评：经典基准与"基准生命周期"

> **一句话结论**：模型级基准是给"能力主张"准备的标准化考卷，但基准是有生命周期的——先被刷榜、再被污染、最终饱和退场；会读榜单的人，读的是"哪张考卷、什么时候、怎么打分"，而不是那个孤零零的分数。

---

> 本章对应第 1 章说的第一类测评对象：**模型级**。它回答"这个模型有多聪明"，用的是学术基准（benchmark）和公开榜单（leaderboard）。先建立"经典基准地图"，再理解"基准为什么会死"。

## 3.1 为什么要模型级基准：能力主张 vs 标准化考卷

宣称"我们的模型更强"几乎零成本，证明它强在哪、强多少则需要**所有人用同一张考卷、同一套评分**。模型级基准的价值就在于此：它把开放的能力比较，压缩成可复现、可横向对比的数字。评测领域综述把这件事拆成**评什么（what）、在哪评（where）、怎么评（how）** 三维度，经典基准解决的主要是"评什么"。

> 来源：[A Survey on Evaluation of Large Language Models](https://arxiv.org/abs/2307.03109)（arXiv 2307.03109，ACM TIST）— ✅

代价是：基准只测"考卷上的能力"，不等于真实产品效果。这一点会在第 5、6 章展开。

## 3.2 能力轴上的经典基准

不同基准测的是不同能力轴。下表是绕不开的一张"地图"：

| 能力轴 | 经典基准 | 一句话说明 | 2026 时效 |
|---|---|---|---|
| 知识 | [MMLU](https://arxiv.org/abs/2009.03300) | 57 学科多选题，考世界知识与解题（ICLR 2021，arXiv 2009.03300） | 已饱和、区分度低 |
| 知识 | [MMLU-Pro](https://arxiv.org/abs/2406.01574) | 选项 4→10 并加入推理题，比 MMLU 难 16–33%，prompt 敏感性 4–5%→2%（NeurIPS 2024） | **当前推荐替代 MMLU** |
| 常识 | [HellaSwag](https://arxiv.org/abs/1905.07830) | 常识句子补全，用 Adversarial Filtering 构造（ACL 2019） | 经典但基本饱和 |
| 数学 | [GSM8K](https://arxiv.org/abs/2110.14168) | 8.5K 小学数学应用题，推理评测里程碑 | 现代模型已接近饱和 |
| 数学 | [MATH](https://arxiv.org/abs/2103.03874) | 12,500 道竞赛数学题（NeurIPS 2021） | 仍用于高难数学，但前沿模型趋饱和 |
| 代码 | [HumanEval](https://arxiv.org/abs/2107.03374) | 164 题 Python 功能正确性，**pass@k** 指标出处（Codex 论文） | 已向 LiveCodeBench / SWE-bench 演进 |

**pass@k** 的定义是"生成 k 个答案、至少有 1 个正确的概率"，代码任务常用它把"能写对"和"碰巧写对"区分开来。

> 来源：[Evaluating Large Language Models Trained on Code](https://arxiv.org/abs/2107.03374)（HumanEval / pass@k）— ✅

## 3.3 基准为什么会"死"：饱和、污染与三个 2026 变动事实

基准不是永动机。它衰亡通常走三步：

1. **饱和（saturation）**：前沿模型分数顶到天花板，区分度归零。MMLU、GSM8K、HumanEval 都进入这个阶段，于是催生了 MMLU-Pro 这类"加难版"。
2. **数据污染（contamination）**：测试集内容混进训练数据，分数虚高。检测方法如 TS-Guessing 发现 GPT-4 在 MMLU 中"猜缺失选项"的精确匹配率达 57%。
3. **工程负担与维护成本**：跑基准、防污染、更新版本都需要人和钱，很多基准因此停更。

> 来源：[A Survey on Data Contamination for Large Language Models](https://arxiv.org/abs/2502.14425) — ✅
> 来源：[TS-Guessing（A Survey on Data Contamination）](https://arxiv.org/abs/2311.09783)（NAACL 2024）— ✅

三个值得记住的 2026 年变动事实：

- **BIG-bench 归档**：这个 450 作者、204 任务的协作基准（TMLR 2023）仓库已于 **2026-04-17 归档为只读**，历史意义仍在，但不再演进。
- **HF Open LLM Leaderboard 终止**：置顶讨论帖标题即「It's been a wild ride, folks :) (end of the Open LLM Leaderboard)」，开源模型榜单时代告一段落。
- **HELM 进入维护模式**：Stanford HELM 于 **2026-06-01 进入维护模式**。

> 来源：[BIG-bench 论文](https://arxiv.org/abs/2206.04615) ／ [BIG-bench 仓库（已归档）](https://github.com/google/BIG-bench) — ✅
> 来源：[HF Open LLM Leaderboard（已终止）](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard) — ✅

## 3.4 评测框架与平台：三个定位不同的角色

| 平台 | 定位 | 状态（2026） |
|---|---|---|
| [lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness) | 开源、统一的**少样本评测框架**，60+ 基准，后端覆盖 HF/vLLM/SGLang/API；曾是 HF 榜单官方后端 | 🔄 活跃：2026/09 加插件系统 |
| [HELM](https://crfm.stanford.edu/helm/) | 7 指标（accuracy/calibration/robustness/fairness/bias/toxicity/efficiency）×16 场景的**整体评测**，公开全部 prompt 与输出 | ⚠️ 2026-06-01 起维护模式 |
| [OpenCompass](https://github.com/open-compass/opencompass) | 一站式：CompassKit/Hub/Rank，100+ 数据集，支持 HF 与 API 模型 | 🔄 活跃：2026/08 集成 VLMEvalKit |

> 来源：[HELM 论文](https://arxiv.org/abs/2211.09110) — ✅
> 来源：[OpenCompass 榜单](https://rank.opencompass.org.cn/) ／ [OpenCompass 官网](https://opencompass.org.cn/) — ✅/⚠️

三者关系可以这样记：**harness 是"跑分的引擎"，HELM 是"严谨的整体体检"，OpenCompass 是"一站式平台 + 榜单"**。

## 3.5 中文基准

中文能力不能靠翻译英文基准来测，于是有了专门的中文基准：

| 基准 | 说明 | 状态 |
|---|---|---|
| [C-Eval](https://arxiv.org/abs/2305.08322) | 13,948 题、52 学科、4 难度层级的中文评测（NeurIPS 2023） | 2025-07-27 已公开完整测试集；已接入 harness 与 OpenCompass |
| [CMMLU](https://arxiv.org/abs/2306.09212) | 67 主题中文多任务理解，含"中国特定主题"，随机基线 25% | 已接入 harness 与 OpenCompass |
| [SuperCLUE](https://github.com/CLUEbenchmark/SuperCLUE) | 中文通用大模型综合基准，含主观 OPEN 题 + 客观 OPT 题、Agent、Safety 子榜 | 活跃 |
| [FlagEval](https://github.com/FlagOpen/FlagEval) | 智源（BAAI）综合评测体系：800+ 模型、40+ 能力维度 | 活跃：Roadmap 2025–2026 提出 nightly 回归评测 |

> 来源：[C-Eval 仓库](https://github.com/hkust-nlp/ceval) ／ [CMMLU 仓库](https://github.com/haonan-li/CMMLU) ／ [SuperCLUE 官网](https://www.superclueai.com/)（⚠️ JS 单页）／ [FlagEval 官网](https://flageval.baai.ac.cn/)（⚠️ JS 单页）— ✅/⚠️

中文评测的特殊坑：翻译题失真、文化特定答案、以及中文语料被大规模爬取带来的**污染**。

## 3.6 读榜单的正确姿势

拿到一张榜单，先问三个问题，能避开绝大多数误判：

- **污染了吗**：测试集是否公开、模型是否可能见过？公开测试集（如 C-Eval 2025-07 起）尤其要警惕。
- **prompt 敏感吗**：同一模型换 prompt 模板分数会漂移；MMLU 的模板敏感性约 4–5%，MMLU-Pro 降到约 2%，这本身就是选基准的参考。
- **还新鲜吗**：榜单有生命周期。看到"某模型 MMLU 90+"，先确认这个数字是不是早被饱和、且榜单是否已停更/进维护模式。

还有一个更隐蔽的问题：榜单本身可以被"经营"。研究指出，部分平台允许选择性报告、私下测试等做法，会系统性抬高排名，这就是所谓 **Leaderboard Illusion**。

> 来源：[Leaderboard Illusion](https://arxiv.org/abs/2504.20879) — ✅

---

## 本章要点

- 模型级基准把"能力主张"变成标准化考卷，但只测考卷能力，不等于产品效果。
- 按能力轴记经典基准：知识 MMLU→MMLU-Pro、常识 HellaSwag、数学 GSM8K/MATH、代码 HumanEval/pass@k。
- 基准会"死"：先饱和、再污染、后停更；三个 2026 事实是 BIG-bench 归档、HF Open LLM Leaderboard 终止、HELM 进维护模式。
- 框架定位：lm-evaluation-harness 是跑分引擎，HELM 是整体体检，OpenCompass 是一站式平台与榜单。
- 中文基准看 C-Eval / CMMLU / SuperCLUE / FlagEval，并警惕翻译失真与污染。
- 读榜单三问：污染了吗、prompt 敏感吗、还新鲜吗；榜单本身也可能被"经营"。

## 来源

- [A Survey on Evaluation of Large Language Models](https://arxiv.org/abs/2307.03109) — 访问 2026-09-15 — ✅ — 评测 what/where/how 框架
- [MMLU](https://arxiv.org/abs/2009.03300) — 访问 2026-09-15 — ✅ — 57 学科多选题基准
- [MMLU-Pro](https://arxiv.org/abs/2406.01574) — 访问 2026-09-15 — ✅ — 更难的 MMLU 替代
- [HellaSwag](https://arxiv.org/abs/1905.07830) — 访问 2026-09-15 — ✅ — 常识推理基准
- [GSM8K](https://arxiv.org/abs/2110.14168) — 访问 2026-09-15 — ✅ — 小学数学推理
- [MATH](https://arxiv.org/abs/2103.03874) — 访问 2026-09-15 — ✅ — 竞赛数学
- [HumanEval / pass@k](https://arxiv.org/abs/2107.03374) — 访问 2026-09-15 — ✅ — 代码功能正确性
- [BIG-bench 论文](https://arxiv.org/abs/2206.04615) — 访问 2026-09-15 — ✅ — 协作基准
- [BIG-bench 仓库](https://github.com/google/BIG-bench) — 访问 2026-09-15 — ✅ — 2026-04-17 归档只读
- [数据污染综述](https://arxiv.org/abs/2502.14425) — 访问 2026-09-15 — ✅ — 污染检测总览
- [TS-Guessing 污染检测](https://arxiv.org/abs/2311.09783) — 访问 2026-09-15 — ✅ — GPT-4 猜缺失选项
- [HELM 论文](https://arxiv.org/abs/2211.09110) — 访问 2026-09-15 — ✅ — 多指标整体评测
- [HELM 官网](https://crfm.stanford.edu/helm/) — 访问 2026-09-15 — ⚠️ — 2026-06-01 进维护模式
- [lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness) — 访问 2026-09-15 — ✅ — 开源少样本评测框架
- [OpenCompass 仓库](https://github.com/open-compass/opencompass) — 访问 2026-09-15 — ✅ — 一站式评测
- [OpenCompass 榜单](https://rank.opencompass.org.cn/) — 访问 2026-09-15 — ⚠️ — CompassRank
- [HF Open LLM Leaderboard](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard) — 访问 2026-09-15 — ✅ — 已终止
- [C-Eval 论文](https://arxiv.org/abs/2305.08322) — 访问 2026-09-15 — ✅ — 中文多学科
- [CMMLU 论文](https://arxiv.org/abs/2306.09212) — 访问 2026-09-15 — ✅ — 中文多任务理解
- [SuperCLUE 仓库](https://github.com/CLUEbenchmark/SuperCLUE) — 访问 2026-09-15 — ✅ — 中文综合基准
- [FlagEval 仓库](https://github.com/FlagOpen/FlagEval) — 访问 2026-09-15 — ✅ — 智源评测体系
- [Leaderboard Illusion](https://arxiv.org/abs/2504.20879) — 访问 2026-09-15 — ✅ — 榜单可被经营
