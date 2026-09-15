# 调研报告 01 · 模型级测评基础与基准

> 调研日期：2026-09-15
> 方法：webfetch 逐条实测（非记忆）
> 验证图例：✅ = 实测可访问且内容吻合；⚠️ = 可访问但内容为 SPA/仅标题/未解析；❌ = 无法访问

---

## 一、核心概念与术语

| 术语 | 权威来源 | 说明 |
|---|---|---|
| 测评领域总览（what/where/how） | ✅ https://arxiv.org/abs/2307.03109 | 《A Survey on Evaluation of LLMs》(ACM TIST, 45页)，把测评拆成"评什么/在哪评/怎么评"三维度，是讲清 benchmark/eval/metric 概念的**最佳综述入口** |
| perplexity（困惑度） | ✅ https://en.wikipedia.org/wiki/Perplexity | 信息论定义 + "perplexity per word" 在 NLP 的用法；低困惑度=模型对样本预测越好 |
| few-shot / zero-shot | ✅ https://arxiv.org/abs/2005.14165 | GPT-3 论文《Language Models are Few-Shot Learners》，zero/few-shot 术语的源头 |
| pass@k | ✅ https://arxiv.org/abs/2107.03374 | Codex/HumanEval 论文，pass@k 指标出处（生成 k 个解中至少 1 个通过测试的概率） |
| contamination（数据污染） | ✅ https://arxiv.org/abs/2311.09783 | NAACL 2024，提出 TS-Guessing 检测法；发现 GPT-4 在 MMLU 中"猜缺失选项"精确匹配率达 57% |
| benchmark / eval / metric / accuracy / leaderboard | ⚠️ 无单一权威 URL | 通用术语，建议用综述（上表第一行）串讲，不要硬凑来源 |

> accuracy = 任务正确率（多选题常用）；metric = 度量函数总称；leaderboard = 榜单聚合展示。这些没有"原始论文"，应作为**叙述性定义**写，别伪造引用。

---

## 二、经典学术基准

| 基准 | 权威来源 | 一句话说明 | 时效备注（2026） |
|---|---|---|---|
| MMLU | ✅ https://arxiv.org/abs/2009.03300 | 57 学科多选题，考世界知识与解题（ICLR 2021） | 已被认为**饱和/区分度低**，被 MMLU-Pro 取代 |
| MMLU-Pro | ✅ https://arxiv.org/abs/2406.01574 | 选项 4→10、加入推理题，比 MMLU 难 16–33%，prompt 敏感性 4-5%→2%（NeurIPS 2024） | **当前推荐替代 MMLU** |
| BIG-bench | ✅ https://arxiv.org/abs/2206.04615 ／ ✅ https://github.com/google/BIG-bench | 450 作者、204 任务的协作基准（TMLR 2023） | ⚠️ **仓库 2026-04-17 已归档只读**，历史重要但不再演进 |
| HellaSwag | ✅ https://arxiv.org/abs/1905.07830 | 常识句子补全，用 Adversarial Filtering 构造（ACL 2019） | 经典但基本饱和 |
| GSM8K | ✅ https://arxiv.org/abs/2110.14168 | 8.5K 小学数学应用题，推理评测里程碑 | 现代模型已接近饱和 |
| HumanEval | ✅ https://arxiv.org/abs/2107.03374 | 164 题 Python 功能正确性，pass@k 出处（Codex 论文） | 代码评测起点，现已向 LiveCodeBench/SWE-bench 演进 |
| MATH | ✅ https://arxiv.org/abs/2103.03874 | 12,500 道竞赛数学题（NeurIPS 2021） | 仍用于高难数学，但前沿模型也趋饱和 |

---

## 三、综合性评测体系 / 平台

| 平台 | 权威来源 | 说明 | 时效备注 |
|---|---|---|---|
| Stanford HELM | ✅ 论文 https://arxiv.org/abs/2211.09110 ／ ✅ 官网 https://crfm.stanford.edu/helm/ ／ ✅ 代码 https://github.com/stanford-crfm/helm | 7 指标（accuracy/calibration/robustness/fairness/bias/toxicity/efficiency）×16 场景的"整体评测"，公开全部 prompt/输出（TMLR 2023） | ⚠️ **2026-06-01 进入维护模式**；旗舰榜单为 HELM Capabilities / Safety / VHELM |
| EleutherAI lm-evaluation-harness | ✅ https://github.com/EleutherAI/lm-evaluation-harness | 开源统一的少样本评测框架，60+ 基准、后端丰富（HF/vLLM/SGLang/API…）；**是 HF Open LLM Leaderboard 的官方后端** | 🔄 活跃：2026/09 加插件系统、2025/12 CLI 重构、2025/12 拆分后端安装 |
| OpenCompass（司南） | ✅ 代码 https://github.com/open-compass/opencompass ／ ✅ 榜单 https://rank.opencompass.org.cn/ ／ ✅ 官网 https://opencompass.org.cn/ | 一站式评测：CompassKit/Hub/Rank，100+ 数据集、支持 HF 与 API 模型 | 🔄 活跃：2026/08 集成 VLMEvalKit、2026/07 支持 OpenAI Responses API 与 LiteLLM、Multi-IF 多轮评测 |
| HF Open LLM Leaderboard | ✅ Space https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard ／ ✅ 终止公告（讨论区） | 开源模型榜单 | ❌ **已终止**：置顶讨论 #1135「It's been a wild ride, folks :) (end of the Open LLM Leaderboard)」 |

---

## 四、主观 / 开放性生成评测

| 主题 | 权威来源 | 说明 | 时效备注 |
|---|---|---|---|
| Chatbot Arena | ✅ https://arxiv.org/abs/2403.04132 | pairwise 人类偏好 + 众包投票、Bradley-Terry/Elo 统计排名的开放平台 | 平台已更名 **Arena AI** |
| LMArena 官网 | ✅ https://lmarena.ai/ | 实时网页标题为「**Arena AI: The Official AI Ranking & LLM Leaderboard**」 | ⚠️ **品牌已从 "LMSYS Chatbot Arena/LMArena" 改为 "Arena AI"** |
| MT-Bench + LLM-as-a-Judge | ✅ https://arxiv.org/abs/2306.05685 | 多轮问答集 MT-Bench + Arena 论文；系统分析 LLM 裁判的位置/冗长/自我增强偏差，GPT-4 裁判与人类一致性 >80%（NeurIPS 2023） | MT-Bench 现多作经典/基线 |
| G-Eval | ✅ https://arxiv.org/abs/2303.16634 | 用 CoT + form-filling 让 GPT-4 评 NLG，摘要任务与人类 Spearman 相关 0.514；指出 LLM 评审偏好 LLM 生成文本的偏差 | 与 LLM-as-a-Judge 同源方法论 |

---

## 五、中文基准

| 基准 | 权威来源 | 说明 | 时效备注 |
|---|---|---|---|
| C-Eval | ✅ 论文 https://arxiv.org/abs/2305.08322 ／ ✅ 代码 https://github.com/hkust-nlp/ceval | 13,948 题、52 学科、4 难度层级的中文评测（NeurIPS 2023） | 2025-07-27 已**公开完整测试集**；已接入 lm-eval-harness 与 OpenCompass |
| CMMLU | ✅ 论文 https://arxiv.org/abs/2306.09212 ／ ✅ 代码 https://github.com/haonan-li/CMMLU | 67 主题中文多任务理解，含"中国特定主题"；随机基线 25% | 已接入 lm-eval-harness 与 OpenCompass |
| SuperCLUE | ✅ 代码/报告 https://github.com/CLUEbenchmark/SuperCLUE ／ ⚠️ 官网 https://www.superclueai.com/ | 中文通用大模型综合基准，含 OPEN 主观题 + OPT 客观题、Agent、Safety 子榜 | 活跃：仓库含《2025 年度报告》《State of Chinese AI 2025》 |
| FlagEval | ⚠️ 官网 https://flageval.baai.ac.cn/ ／ ✅ 代码 https://github.com/FlagOpen/FlagEval | 智源研究院（BAAI）综合评测体系：800+ 模型、40+ 能力维度 | 活跃：Roadmap 2025–2026 提出 nightly 回归评测；主代码已迁至 flageval-baai 组织 |

---

## 六、未验证 / 存疑项（诚实声明）

1. ❌ `https://cevalbenchmark.com/` 返回 Transport error（无法连接）。C-Eval 的可用入口是 GitHub 仓库。
2. ❌ `https://huggingface.co/blog/open-llm-leaderboard` 返回 404。"HF 榜单终止"结论来自 Space 讨论区置顶帖，未找到官方 blog 公告交叉佐证。
3. ⚠️ FlagEval 官网、SuperCLUE 官网、OpenCompass 官网返回 JS 单页应用的标题页，仅确认站点在线与标题，未深入核验站内数据。
4. ⚠️ pass@k 的公式在 arXiv 摘要页看不到，需读论文正文。
5. ⚠️ 未找到 MMLU/HellaSwag/GSM8K 等官方榜单的当前活跃维护状态（多为数据集而非动态榜单）。

---

## 七、章节大纲建议（模型级）

```
第 0 章  为什么需要测评（动机）
  - 能力主张 vs 可验证证据；榜单污染的激励问题
第 1 章  术语与语言
  1.1 benchmark / eval / metric / accuracy
  1.2 perplexity（内禀指标 vs 下游指标）
  1.3 zero-shot / few-shot / CoT
  1.4 pass@k（代码任务）
  1.5 contamination（数据污染）+ 检测方法
  1.6 leaderboard 的统计学：Elo / Bradley-Terry / 置信区间
第 2 章  经典学术基准（按能力轴）
  2.1 知识：MMLU → MMLU-Pro（"饱和"概念）
  2.2 常识推理：HellaSwag（BIG-bench 作为历史）
  2.3 数学：GSM8K → MATH
  2.4 代码：HumanEval / pass@k
  2.5 综合协作基准：BIG-bench 的历史与归档（"基准生命周期"）
第 3 章  评测框架与平台（工程视角）
  3.1 lm-evaluation-harness
  3.2 HELM：多指标整体评测与可复现性
  3.3 OpenCompass：一站式 + CompassRank
  3.4 HF Open LLM Leaderboard 的兴衰（榜单为何终止）
  3.5 复现实验要点：prompt 模板、canary、答案抽取、去污染
第 4 章  主观与开放性生成评测
  4.1 人类偏好的必要性（BLEU/ROUGE 的局限）
  4.2 Chatbot Arena / Arena AI：pairwise + Elo
  4.3 LLM-as-a-Judge：偏差与缓解
  4.4 G-Eval：CoT + form-filling
第 5 章  中文基准
  5.1 C-Eval / CMMLU  5.2 SuperCLUE / FlagEval
  5.3 中文评测的特殊坑：翻译题、文化特定答案、数据污染
第 6 章  基准的演进与批判
  6.1 饱和与"基准升级"  6.2 污染与榜单激励
  6.3 2026 现状：哪些已停更/维护模式/更名
  6.4 从 model-level 走向 application/agent-level
```
