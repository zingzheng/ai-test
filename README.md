# AI Test —— 大模型 / AI / Agent 测评学习笔记

> **状态：需求定义阶段（Phase 0）**
> 本文档 = 项目需求说明书。后续实现请在本目录内进行。
> 最后更新：2026-09-15

---

## 0. 一句话定位

一个**类 Wiki 的系统性学习笔记项目**，把「大模型 / AI / Agent 测评」从基础概念、行业前沿到企业落地方案讲清楚；**所有知识点必须可溯源，禁止杜撰**。

---

## 1. 背景与目标

### 1.1 为什么做

作者（申申）是 10 年经验的测试开发专家，做过压测、协议测试、兼容性测试、UI 自动化等专项测试；近一年在做 LLM 相关的 **测试 Agent 开发**。在「AI 测评」这个方向上存在**体系化知识缺口**（俗称"野路子焦虑"），需要一个能长期沉淀、可对外分享的知识底座。

### 1.2 目标

1. **系统化**：把散落的测评知识组织成有层次的体系（不是链接堆砌）。
2. **可溯源**：每条事实性知识都带权威来源 URL（详见 §5）。
3. **可实践**：核心章节配可动手的小实验（Lab），不止是"知道"。
4. **跟得上**：包含 2025–2026 的行业前沿与"变动事实"（哪些基准已停更/换代/更名）。
5. **可分享**：产出 honkit 静态 Wiki，能像 `agentic` 项目一样本地/上线浏览。

### 1.3 目标读者

- **主要**：申申本人（测开背景，想要能落地的测评方法论）。
- **次要**：测试/质量团队的同事，作为新人培训与团队分享材料。

---

## 2. 范围（Scope）

### ✅ 在范围内

| 板块 | 内容 |
|---|---|
| **基础知识** | 评测方法论（自动 / 人工 / A-B / LLM-as-Judge）；测评术语与指标；模型级基准；主观评测；RAG 测评；Agent 测评；跨领域指标（传统 ML / 推荐 / CV / NLP / RL）；安全测评与红队 |
| **行业前沿** | 可复现性危机、数据污染、Judge 偏差与分辨率、Agentic eval 自动化、2026 变动事实 |
| **企业落地** | 测评工具链与可观测性（OTel）、数据集工程、CI/CD 持续评测、合规与治理、端到端落地蓝图 |

### ❌ 明确不做（Out of Scope，除非后续追加）

- 不教「如何从零训练大模型」；只讲与**测评**相关的训练侧概念（如 reward model 的作用）。
- 不做工具的商业化采购建议/报价对比（只做能力维度对比）。
- 不复刻已停服平台的完整功能；停服平台作为**案例**讲。
- 不追求覆盖所有基准与论文；按「代表性 + 时效性」取舍。

---

## 3. 内容架构（章节大纲 v3 · 待申申确认）

采用**三大部分 + 附录**结构，与需求中的「基础知识 / 行业前沿 / 企业落地」一一对应。

### 设计原则（2026-09-15 拍板）

| 决策 | 落法 |
|---|---|
| 形态 = honkit Wiki | 复用 `agentic` 模式 |
| **不做动手 Lab**，深入浅出 | 删除所有 Lab；每章以「结论 → 概念 → 对照表 → 来源」组织 |
| **安全合规降权** | 由独立大块 → 压缩为第一部分最后一章（速览级） |
| **训练侧了解即可** | 正文只在导论一段话提及；细节放附录 D |
| τ-bench 命名 | 主名 **τ³-bench**，首次出现注明「原 τ-bench 已废弃」 |
| **对齐测评岗位 JD** | 补「评测方法论全景」章 + 「跨领域评测」章 + 附录 E；成熟度 =「能正确用术语、判断指标选得对不对」，不推导公式 |
| 来源可溯源 | 不变，仍是最硬约束（§5） |

### 第一部分 · 基础知识 ——「测评到底在测什么」（8 章）

```
1.  导论：为什么测评是 AI 工程的第一性问题
    - 能力主张 vs 可验证证据；三种测评对象（模型 / 应用 / Agent）
    - 术语速查：benchmark / eval / metric / accuracy / perplexity / pass@k / pass^k / contamination
    - 模型训练侧在测评里的位置（一段话，细节见附录 D）
2.  评测方法论全景：自动评测 / 人工评测 / A/B Test / LLM-as-Judge   ← JD 第一条
    - 它们不是并列关系：离线 vs 在线 × 便宜 vs 可信 两个轴
    - 自动评测：脚本断言、指标计算；适用与盲区
    - 人工评测：标注、众包、领域专家；成本与一致性
    - A/B Test：假设检验 / p 值 / 显著性 / 样本量 / 置信区间 / CUPED / 常见陷阱
    - LLM-as-Judge：何时该用（技术细节见第 4 章）
    - 四类方法选型对照表 + 离线/在线的衔接工作流
3.  模型级测评：经典基准与"基准生命周期"
    - MMLU → MMLU-Pro（饱和与升级）；GSM8K / MATH；HumanEval / pass@k
    - BIG-bench 的兴衰：基准为什么会"死"
    - 评测框架：lm-evaluation-harness / HELM / OpenCompass
    - 中文基准：C-Eval / CMMLU / SuperCLUE / FlagEval
4.  主观评测与 LLM-as-Judge：当答案是开放的时候
    - 为什么 BLEU / ROUGE 不够（指标演进：n-gram → 学习型 → LLM 裁判）
    - Chatbot Arena → Arena AI：pairwise + Elo 的统计学
    - MT-Bench / G-Eval；LLM-as-a-Judge 的典型偏差（位置/冗长/自我增强）
5.  应用级测评（上）：RAG 怎么测
    - 为什么必须拆开看：检索错 or 生成错
    - RAG Triad（TruLens）三指标
    - RAGAS 四指标：Faithfulness / Answer Relevancy / Context Precision / Context Recall
    - ARES / BEIR / DeepEval 各自解决什么
6.  应用级测评（下）：Agent 怎么测
    - 从"答题"到"行动"：环境、工具、多轮、长程
    - 按域看代表基准：SWE-bench / WebArena / OSWorld / GAIA / τ³-bench / MLE-bench
    - 不只看成功率：轨迹、progress rate、工具调用正确性、成本、pass^k
    - 组件级 vs 端到端
7.  跨领域评测指标：传统 ML / 推荐 / CV / NLP / RL   ← JD 第二条
    - 通用 ML 指标：分类（Accuracy/P/R/F1/AUC/PR-AUC）、回归（MSE/MAE/R²/MAPE）、排序（P@K/MAP/MRR/NDCG）
    - 推荐：离线准确率族 + 超准确率族（Coverage/Diversity/Novelty）+ 在线（CTR/CVR）
    - CV：检测分割（IoU/AP/COCO 协议）、生成（PSNR/SSIM/FID/IS/CLIPScore）、分类（Top-1/Top-5）
    - NLP：BLEU/ROUGE/METEOR/chrF、BERTScore/BLEURT、GLUE/SuperGLUE/SQuAD
    - RL：return / sample efficiency / success rate / regret（术语与评测口径，细节见附录 D）
    - 收尾：指标"选得对不对"检查清单
8.  安全与合规速览（轻）
    - 红队与越狱一页表：JailbreakBench / HarmBench / Garak / PyRIT
    - OWASP LLM Top 10（2026 版）速览（与 2023 v1.1 对照）
    - 标准与法规一句话版：NIST AI RMF / EU AI Act / GB/T 45654-2025 / 备案与内容标识
    - 收尾：测开该关心什么
```

### 第二部分 · 企业落地 ——「怎么把它用起来」（5 章）

```
9.  工具链与可观测性
    - 六款主流工具对照：LangSmith / Langfuse / Phoenix / Weave / Braintrust / PromptLayer
    - Humanloop 退场案例（选型风险）
    - OTel GenAI Semantic Conventions：trace 即评测数据源
10. 大厂方法论拆解
    - Anthropic 的 8 步路线与三类 grader（code / model / human）
    - OpenAI Evals（含 2026-11 停服与迁移）
    - Google rubrics + AutoSxS；Azure 内置 evaluator
    - 共识与分歧
11. 数据集工程：从生产 trace 到评测集
    - 真实 trace 回灌；golden set / holdout
    - 合成数据与它的风险
12. 持续评测：把 eval 接进 CI/CD
    - promptfoo、Langfuse experiment-action
    - baseline gate、逐用例回归 vs 只看均值
    - 在线实验（A/B）与离线门禁的配合
    - "评测即测试"：测开的主场
13. 端到端落地蓝图
    - 30-50 例起步 → 域专家 pass/fail + critique → judge 校准 → 进 CI → 生产监控
    - LLM-as-Judge 工程化（Critique Shadowing）
    - 小团队 / 大团队的不同路径；合规落地要点（衔接第 8 章）
```

### 第三部分 · 行业前沿 ——「坑在哪、往哪走」（3 章）

```
14. 可复现性危机
    - AI Agents That Matter：成本与 holdout
    - 基础设施噪声（Anthropic：6pp 摆动）；Leaderboard Illusion；ABC 清单
15. Judge 的偏差、分辨率与自动化
    - κ / τ / ρ 一致性指标怎么用；去偏与 Tie 代价
    - Agent-as-Judge / AI 生成评测用例
16. 2026 变动地图与开放问题
    - 时效地图速查：已停更 / 已换代 / 已更名 / 已关停
    - 开放问题：多模态、长时程 agent、评测成本、评测饱和
```

### 附录（5 个）

```
A. 术语表（中英对照，含一句话定义 + 来源）
B. 权威来源总清单（按主题索引，含 URL + 访问日期 + 验证状态）
C. 时效地图：已停更 / 已换代 / 已更名 / 已关停 速查
D. 模型训练与调优速览（了解即可）
   - RL 术语与评测指标 / 经典算法一页纸
   - RLHF 三阶段（SFT→RM→PPO）、DPO、Constitutional AI
   - reward model 评测、reward hacking / overoptimization
   - 调优谱系：预训练 → SFT → PEFT（LoRA / QLoRA / Adapter / Prefix / Prompt Tuning）
   - 调优后如何评测（MMLU / HELM / lm-evaluation-harness）
E. 测评岗位能力地图（JD 关键词 → 章节映射 + 面试高频问题）
```

### 阅读路径建议

- **速览路线（半天）**：1 → 2 → 3 → 5 → 6 → 13 —— 建立"测评在测什么、企业怎么落地"的骨架。
- **岗位/面试路线**：2 → 7 → 12 → 13 → 附录 E。
- **完整路线**：1 → 16 顺序读。
- **速查**：直接翻附录 A / C / E。

---

## 4. 目录结构（目标态）

> 这是**实现完成后**的目录形态。Phase 0 只创建了 `README.md`（本文件）、`docs/research/`、`SOURCES.md`。

```
ai-test/
├── README.md                  # 本文件（需求 + 总览）
├── SOURCES.md                 # 权威来源总索引（Phase 0 已建）
├── SUMMARY.md                 # honkit 目录（Phase 1 建）
├── book.json                  # honkit 配置（Phase 1 建）
├── serve.sh                   # 本地文档服务脚本（复用 agentic 模式，Phase 1 建）
├── docs/
│   ├── research/              # Phase 0 调研原始素材（已完成，7 份）
│   │   ├── 01-model-level.md
│   │   ├── 02-application-agent.md
│   │   ├── 03-safety-compliance.md
│   │   ├── 04-enterprise-frontier.md
│   │   ├── 05-ml-metrics-abtest.md      # 传统 ML 指标 + A/B Test
│   │   ├── 06-domain-metrics.md         # 推荐 / CV / NLP 指标
│   │   └── 07-rl-training.md            # RL + RLHF + 大模型调优
│   └── notes/                 # 正式笔记（Phase 1+ 逐步填充）
│       ├── part1-基础/
│       ├── part2-企业落地/
│       └── part3-前沿/
└── labs/                      # （不做）曾计划动手实验，2026-09-15 拍板取消
```

---

## 5. 来源与引用规范（⭐ 本项目最硬的约束）

> 需求原话：「你所搜罗的所有知识必须有来源，不可以杜撰。」

### 5.1 每条事实必须可溯源

- **事实性内容**（数字、结论、定义、版本、时间、排名）必须紧随其后给出可点击的权威 URL。
- 无法找到权威来源的内容：**要么不写，要么显式标注「（未找到权威来源，属观点/推测）」**。
- **严禁**编造 URL、把记忆当来源、把二手摘要当原文。

### 5.2 来源优先级（从高到低）

1. **一手论文**（arXiv / 顶会 proceedings）
2. **官方文档 / 官方仓库 / 官方标准页**（.org / .gov / 厂商官方 docs）
3. **权威机构**（NIST、MLCommons、TC260、CAC、ISO）
4. **知名工程博客**（Anthropic Engineering、Hamel Husain、Eugene Yan 等，需注明作者与日期）
5. 其余（维基、媒体报道）仅作辅助，**不作为关键结论的唯一来源**。

### 5.3 引用格式（每条来源标注四要素）

```
- [来源标题](URL) — 访问日期 YYYY-MM-DD — 验证状态 ✅/⚠️/❌ — 一句话说明
```

- ✅ 已实测可访问且内容吻合
- ⚠️ 可访问但内容未解析（JS 渲染 / PDF / 仅标题）
- ❌ 本次无法访问（**不代表 URL 永久失效**）

### 5.4 「时效地图」是必需产物

AI 测评领域变化极快，且**大量中文资料是错的/过时的**。附录 C 必须维护一张「变动事实地图」，记录（截至 2026-09 已确认）：

| 变动类型 | 具体事实 |
|---|---|
| 榜单终止 | HF Open LLM Leaderboard 已终止（Space 讨论区置顶公告） |
| 进入维护模式 | Stanford HELM（2026-06-01） |
| 仓库归档 | BIG-bench（2026-04-17）、HAL harness（2026-07-01） |
| 品牌更名 | LMSYS Chatbot Arena / LMArena → **Arena AI** |
| 基准换代 | tau-bench → **τ²/τ³-bench**（旧仓库已废弃）；MMLU → MMLU-Pro |
| 组织迁移 | SWE-bench：`princeton-nlp` → **`SWE-bench` 组织**；PyRIT：`Azure/` → **`microsoft/`**；OTel GenAI semconv 拆出独立仓库 |
| 版本更新 | OWASP LLM Top 10 **2026 版**（与 2023 v1.1 不同）；TC260 治理框架 **3.0**（2026-09-14） |
| 平台关停/退场 | OpenAI Evals 平台 2026-11-30 关停；Humanloop 平台 sunset；Google Vertex AI 评测文档迁至 **Gemini Enterprise Agent Platform** |
| 标准落地 | GB/T 45654-2025（2025-11-01 实施）；EU AI Act（2026-08-02 全面适用 + AI Omnibus 时间线后延） |

> 该表必须**持续维护**：每次实现/更新时核对，新增条目标注发现日期。

---

## 6. 技术方案

### 6.1 文档形态

- 复用 `agentic` 项目的 **honkit** 方案：`book.json` + `SUMMARY.md` + `serve.sh`。
- 纯 Markdown 编写，中文为主，技术术语保留英文原词。
- 目标是本地可 `./serve.sh start` 浏览；是否对外部署（nginx / 域名）由申申后续决定。

### 6.2 写作规范

- 4 空格缩进（项目约定）；Markdown 列表用 `-`。
- 每章统一结构：**一句话结论 → 核心概念 → 对照表/图示 → 来源**。
- 面向"深入浅出"：先讲清楚"这是什么、为什么重要"，再给细节；不堆公式，必要的数学只给直觉。
- 术语首次出现给中英对照。
- 代码/命令用 fenced code block；URL 用可点击 Markdown 链接。
- **不写无意义注释**；图表优先用 Markdown 表格。

### 6.3 每章「完成」的定义

一章算完成，必须同时满足：
1. 大纲中的每个小节都有内容，无 `TODO` 残留；
2. 所有事实性陈述都带来源（§5.3 格式）；
3. 末尾有「来源」小节；
4. 若涉及 2026 变动事实，已核对 §5.4 时效地图；
5. 通过自查清单（§7）。

---

## 7. 验收标准

- [ ] **来源可查**：随机抽查任意 10 条事实，均能在正文找到 URL，且 URL 可访问或已标注验证状态。
- [ ] **无杜撰**：不存在无来源的硬结论；不确定处已显式标注。
- [ ] **结构完整**：§3 大纲三大部分 + 附录全部成稿。
- [ ] **时效准确**：§5.4 中每条变动事实在正文都被正确反映（例如不再称"LMArena"为主名、不再引用 `Azure/PyRIT`）。
- [ ] **可构建**：`honkit build` 成功，`SUMMARY.md` 链接无死链。
- [ ] **可分享**：非作者的技术同事能独立看懂第一部分。
- [ ] **深入浅出**：不依赖动手实验即可理解；无公式推导负担。
- [ ] **JD 覆盖**：测评岗位 JD 中的名词均可在正文或附录 E 找到对应章节。

---

## 8. 决策记录

### 8.1 已拍板（2026-09-15）

| # | 决策 |
|---|---|
| Q1 | **形态 = honkit 静态 Wiki**（复用 `agentic` 模式） |
| Q3 | **不做动手 Lab**；深度 = 深入浅出，以概念与判断力为主 |
| Q4 | **安全合规降权**：压缩为第一部分最后一章（速览级），不再单列大块 |
| Q6 | **模型训练侧了解即可**：正文一段话，细节放附录 D |
| Q9 | **统一用 τ³-bench**（Zing 定），首次出现注明"原 τ-bench 已废弃" |

### 8.2 默认采纳（未明确反对即执行）

| # | 决策 |
|---|---|
| Q2 | 正文按学习顺序组织 + 附录可速查（教材/手册兼容） |
| Q5 | 中文生态作为"本土化对照"成节，不单独成章 |
| Q7 | 暂不做"自己的测评集"；先打好知识底座 |
| Q8 | Phase 1 建 Git 仓库；是否部署上线等内容成型后再定 |
| Q10 | ISO 42001 / CAICT 等未验证来源：先标注"待核验"，不阻塞写作 |

### 8.3 JD 对齐追加决策（2026-09-15 第二轮）

> 触发：申申提供「测评岗位 JD」，要求课程涉猎其中名词。

| # | 决策 |
|---|---|
| J1 | 新增 **第 2 章「评测方法论全景」**（自动/人工/A-B/LLM-as-Judge），对齐 JD 第一条 |
| J2 | 新增 **第 7 章「跨领域评测指标」**（传统 ML / 推荐 / CV / NLP / RL），**放正文**，对齐 JD 第二条 |
| J3 | 成熟度 = **能正确使用术语、判断指标选得对不对**；不推导公式、不教调参 |
| J4 | 扩写 **附录 D → 模型训练与调优速览**（RL/RLHF/PEFT），仍属"了解即可" |
| J5 | 新增 **附录 E「测评岗位能力地图」**（JD 关键词 → 章节映射 + 面试高频问题） |
| J6 | 新增内容需**先补调研**（传统指标、A/B、推荐/CV/NLP/RL）——已完成：`docs/research/05~07` |

**大纲版本**：v3（16 章 + 5 附录），正文 14→16 章。

---

## 9. 交付进度

| 阶段 | 状态 | 产出 |
|---|---|---|
| **Phase 0** 调研 + 需求 | ✅ 完成 | `docs/research/01~07`（来源逐条实测）；本文件（大纲 v3）；`SOURCES.md` |
| **Phase 1** 骨架 + 基础知识 | ✅ 完成 | `book.json` / `SUMMARY.md` / `serve.sh`；第一部分 8 章成稿（共引用 151 条 URL） |
| **Phase 2** 企业落地 | ✅ 完成 | 第二部分 5 章成稿（共引用 44 条 URL） |
| **Phase 3** 行业前沿 + 附录 | ✅ 完成 | 第三部分 3 章 + 附录 A/C/D/E 成稿（附录 B 复用 `SOURCES.md`） |
| **Phase 4** 构建与分享 | 🟡 部分 | `honkit build` 通过、死链检查通过；对外部署待定 |

> 质检口径（每个 Phase 都执行）：正文提取的全部 URL 与 `SOURCES.md` + `docs/research/` 构成的来源池做**差集必须为空**（防编造）；`honkit build` 通过；`SUMMARY.md` 无死链。

## 10. 后续可选工作

- **内容维护**：随行业变化更新；每次更新先核对附录 C「时效地图」，并回填新增来源到 `SOURCES.md`。
- **对外部署**：如需上线，参照 `agentic` 的 honkit 部署方式（nginx + 域名）；仅本地浏览用 `./serve.sh start`。
- **扩展选题**：多模态评测、长时程 Agent、评测成本优化等（见第 16 章开放问题）。
