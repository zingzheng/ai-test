# 附录 A · 术语表

本表按主题分组，每条给「英文 / 中文 / 一句话定义 / 来源链接」。

> 全部 URL 均取自 [SOURCES.md](../../../SOURCES.md) 与 `docs/research/`，未新增任何未记录来源；合并收录同一族的术语以减少重复。

---

## 1. 通用评测

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| benchmark | 基准 | 一套固定任务、固定数据与固定打分方式的“考卷”，用于横向比较模型或系统 | [评测综述](https://arxiv.org/abs/2307.03109) |
| eval | 评测 | 一次针对特定目标、有组织地把模型输出与标准对照的评估过程；benchmark 只是其材料之一 | [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) |
| metric | 指标 | 把模型输出映射为一个数字的度量函数（如 accuracy、F1），用于量化表现 | [scikit-learn 指标总览](https://scikit-learn.org/stable/modules/model_evaluation.html) |
| accuracy | 准确率 | 预测正确的样本占总样本的比例；类别极不平衡时会严重高估真实效果 | [scikit-learn 指标总览](https://scikit-learn.org/stable/modules/model_evaluation.html) |
| precision / recall | 精确率 / 召回率 | 精确率＝预测为正里真正为正的比例；召回率＝真正为正里被检出的比例 | [Google ML Crash Course](https://developers.google.com/machine-learning/crash-course/classification/precision-and-recall) |
| F1 | F1 分数 | 精确率与召回率的调和平均，用单一数值权衡二者 | [Precision and recall](https://en.wikipedia.org/wiki/Precision_and_recall) |
| ROC-AUC | ROC 曲线下面积 | 随机取一正一负样本时正样本得分更高的概率；对类别不平衡相对不敏感 | [scikit-learn roc_auc_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html) |
| PR-AUC | 精确率-召回率曲线下面积 | 关注正类、极度不平衡时比 ROC-AUC 更有信息量的排序质量指标 | [scikit-learn average_precision_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html) |
| confusion matrix | 混淆矩阵 | 按真实类别与预测类别交叉计数的表格（TP/FP/FN/TN），是精确率、召回率等的来源 | [scikit-learn confusion_matrix](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.confusion_matrix.html) |
| holdout | 留出集 | 从数据中划出、训练期间完全不接触的一部分样本，用于无偏估计泛化表现 | [AI Agents That Matter](https://arxiv.org/abs/2407.01502) |
| golden set | 黄金集 | 由人工精挑细选并标注、作为权威参照的评测样本集合 | [Your AI Product Needs Evals](https://hamel.dev/blog/posts/evals/) |
| contamination | 数据污染 | 测试集内容出现在模型训练数据中，使评测分数虚高、失去区分度 | [TS-Guessing](https://arxiv.org/abs/2311.09783) |
| leaderboard | 榜单 | 把多个模型或系统在同一基准上的分数聚合排序并公开展示的页面 | [Leaderboard Illusion](https://arxiv.org/abs/2504.20879) |

## 2. LLM 专属

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| perplexity | 困惑度 | 语言模型对文本的“意外程度”，越低表示建模越好；只是语言建模内禀指标，不等于下游任务能力 | [Perplexity](https://en.wikipedia.org/wiki/Perplexity) |
| zero-shot / few-shot | 零样本 / 少样本 | 不给示例 / 给少量示例就让模型完成任务，且不更新参数 | [GPT-3 论文](https://arxiv.org/abs/2005.14165) |
| pass@k | k 次至少成功一次 | 为同一任务生成 k 个候选解，其中至少有 1 个正确的概率；代码任务常用 | [Codex / HumanEval](https://arxiv.org/abs/2107.03374) |
| pass^k | k 次全部成功 | 同一任务重复 k 次**全部**成功的概率，衡量可靠性而非“碰运气成功” | [τ-bench 论文](https://arxiv.org/abs/2406.12045) |
| saturation | 饱和 | 基准分数被前沿模型普遍推到接近上限、失去区分能力的现象（如 MMLU） | [MMLU-Pro](https://arxiv.org/abs/2406.01574) |
| LLM-as-Judge | 大模型裁判 | 用一个强 LLM 按给定标准给另一个模型的输出打分或做偏好判断 | [MT-Bench / LLM-as-a-Judge](https://arxiv.org/abs/2306.05685) |
| arena | 竞技场 | 让用户对两个匿名模型的回答做两两投票、再据投票聚合排名的开放评测形式（Arena AI） | [Arena AI](https://lmarena.ai/) |
| Elo / Bradley-Terry | Elo / Bradley-Terry 排名 | 由两两胜负数据估计选手或模型强度并排序的统计模型，是竞技场榜单的计算基础 | [Chatbot Arena 论文](https://arxiv.org/abs/2403.04132) |
| position / verbosity / self-enhancement bias | 位置 / 冗长 / 自我增强偏差 | LLM 裁判的三类系统性偏差：偏爱靠前位置、更长回答、以及自己或同源模型生成的输出 | [MT-Bench / LLM-as-a-Judge](https://arxiv.org/abs/2306.05685) |

## 3. RAG

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| RAG Triad | RAG 三元组 | 用 Context Relevance、Groundedness、Answer Relevance 三问定位“检索错还是生成错”的评测框架 | [TruLens RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/) |
| faithfulness | 忠实度 | 生成答案是否只依据检索到的上下文、不凭空捏造内容 | [RAGAS Faithfulness](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/faithfulness/) |
| groundedness | 有据性 | 答案中的陈述是否可由给定上下文支持，是 RAG Triad 里的幻觉检测维度 | [TruLens RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/) |
| answer relevance | 答案相关性 | 生成的答案是否切题、真正回应了用户的问题 | [RAGAS Answer Relevancy](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/answer_relevance/) |
| context precision / context recall | 上下文精确率 / 召回率 | 检索到的上下文中相关内容的占比 / 全部相关内容被检索回来的占比 | [RAGAS Context Precision](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_precision/) |
| BEIR | 异构检索基准 | 覆盖 18 个数据集、跨任务跨领域的零样本检索评测基准 | [BEIR 论文](https://arxiv.org/abs/2104.08663) |

## 4. Agent

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| task success rate | 任务成功率 | Agent 在端到端任务中达成目标（最终状态正确）的比例，是多数 Agent 基准的主指标 | [Agent 评测综述](https://arxiv.org/abs/2503.16416) |
| trajectory | 轨迹 | Agent 完成任务过程中的观察-思考-动作序列，是过程评测的对象 | [Agent 评测综述](https://arxiv.org/abs/2503.16416) |
| progress rate | 进度率 | 把任务成功分解为可计分子目标，刻画每步增量进展，而非只看最终成败 | [AgentBoard](https://arxiv.org/abs/2401.13178) |
| tool call accuracy | 工具调用准确性 | Agent 是否选对工具、传对参数并正确使用返回结果的比例 | [RAGAS 指标总览](https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/) |
| cost & latency | 成本与延迟 | 完成任务所花的 token/金额与耗时，与准确率同等重要的工程指标 | [HAL](https://arxiv.org/abs/2510.11977) |
| τ³-bench | τ³ 基准 | 在多轮对话中模拟用户、要求 Agent 调用 API 并遵守业务规则，用 pass^k 衡量可靠性（由 τ-bench 演化而来） | [现役仓库](https://github.com/sierra-research/tau2-bench) |
| SWE-bench | 软件工程基准 | 以真实 GitHub issue 为任务、以测试是否通过判分的软件工程 Agent 基准 | [SWE-bench 论文](https://arxiv.org/abs/2310.06770) |
| WebArena | 网页 Agent 基准 | 在四个自建真实网站环境里执行端到端网页任务、以最终状态判分的基准 | [WebArena 论文](https://arxiv.org/abs/2307.13854) |
| OSWorld | 电脑操作基准 | 在真实操作系统桌面环境中执行跨应用任务、采用执行式评估的基准 | [OSWorld 论文](https://arxiv.org/abs/2404.07972) |
| GAIA | 通用助理基准 | 466 道“对人类简单、对 AI 难”的真实问题，需推理、浏览与工具协同 | [GAIA 论文](https://arxiv.org/abs/2311.12983) |

## 5. A/B 与统计

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| H0 / H1 | 原假设 / 备择假设 | 假设检验中待检验的默认假设（无效应）与想要证明的备择假设 | [假设检验](https://en.wikipedia.org/wiki/Statistical_hypothesis_test) |
| p-value | p 值 | 在原假设成立时观测到当前或更极端结果的概率；不是“原假设为真的概率” | [p 值](https://en.wikipedia.org/wiki/P-value) |
| significance | 统计显著性 | 当 p 值小于预先设定的 α（如 0.05）时，称结果在统计上显著、拒绝原假设 | [假设检验](https://en.wikipedia.org/wiki/Statistical_hypothesis_test) |
| power | 统计功效 | 当真实效应存在时检验能正确检出的概率，等于 1−β，惯例目标 ≥80% | [统计功效](https://en.wikipedia.org/wiki/Statistical_power) |
| sample size | 样本量 | 为达到预期功效与最小可检测效应所需的最小样本数，须在实验前估算 | [样本量估算](https://en.wikipedia.org/wiki/Sample_size_determination) |
| confidence interval | 置信区间 | 由样本估计出的、以给定置信水平覆盖真值的区间；两 CI 重叠不代表差异不显著 | [置信区间](https://en.wikipedia.org/wiki/Confidence_interval) |
| CUPED | 协变量方差缩减 | 用实验前协变量调整指标、在不变偏差的前提下降低方差、提高实验灵敏度的方法 | [CUPED 论文](https://www.exp-platform.com/Documents/2013-02-CUPED-ImprovingSensitivityOfControlledExperiments.pdf) |
| SRM | 样本比例失衡 | 实验各组实际样本比例与设计不符的现象，是分流或埋点出问题的数据质量警报 | [Microsoft SRM](https://www.microsoft.com/en-us/research/publication/diagnosing-sample-ratio-mismatch-in-online-controlled-experiments-a-taxonomy-and-rules-of-thumb-for-practitioners/) |
| novelty effect / network effect | 新奇效应 / 网络效应 | 用户因新鲜感产生的短期效果 / 个体受他人影响导致组间相互干扰，二者都会扭曲 A/B 结果 | [新奇效应](https://en.wikipedia.org/wiki/Novelty_effect) |
| multiple comparisons | 多重比较 | 同时检验多个假设会抬高假阳性率，需用 Bonferroni、BH 等校正控制 FWER/FDR | [多重比较](https://en.wikipedia.org/wiki/Multiple_comparisons_problem) |

## 6. 传统 ML / 领域指标

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| NDCG | 归一化折损累计增益 | 按相关性加权并随排名折损、再除以理想排序的排序质量指标 | [scikit-learn ndcg_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.ndcg_score.html) |
| MAP | 平均精度均值 | 对每个查询的平均精度（AP）再取平均，综合排序中相关项的位置 | [IR 评测总览](https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval)) |
| MRR | 平均倒数排名 | 各查询首个相关结果排名倒数的平均，强调“第一个对的结果出现得多靠前” | [Mean reciprocal rank](https://en.wikipedia.org/wiki/Mean_reciprocal_rank) |
| P@K / Recall@K | 前 K 精确率 / 召回率 | 只看排序前 K 个结果的精确率 / 召回率；K 取值会显著改变结论 | [IIR 教材：ranked retrieval 评测](https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html) |
| mAP / IoU | 平均精度 / 交并比 | 检测中 IoU 衡量预测框与真值框的重叠度，mAP（COCO 指多 IoU 阈值平均的 AP）综合精度与定位 | [COCO 检测评测](https://cocodataset.org/#detection-eval) |
| FID | Fréchet Inception Distance | 用 Inception 特征分布间距离衡量生成图像质量，越低越好 | [FID 论文](https://arxiv.org/abs/1706.08500) |
| BLEU | BLEU | 基于 n-gram 精确率并加长度惩罚的机器翻译指标，越高越好但对分词与多参考敏感 | [BLEU 论文](https://aclanthology.org/P02-1040/) |
| ROUGE | ROUGE | 面向摘要、以召回为主的 n-gram 重叠指标（如 ROUGE-N / ROUGE-L） | [ROUGE 论文](https://aclanthology.org/W04-1013/) |
| BERTScore | BERTScore | 用上下文嵌入计算生成文本与参考文本的语义相似度，比 n-gram 指标更贴合语义 | [BERTScore 论文](https://arxiv.org/abs/1904.09675) |
| CTR / CVR | 点击率 / 转化率 | 线上业务指标：点击率＝点击/曝光，转化率＝转化/点击，是推荐与广告的常用在线目标 | [Wide & Deep](https://arxiv.org/abs/1606.07792) |

## 7. 安全合规

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| red teaming | 红队 | 主动以对抗方式探测模型漏洞与有害输出的系统化测试方法 | [Anthropic Red-teaming](https://arxiv.org/abs/2209.07858) |
| jailbreak | 越狱 | 用诱导性提示绕过模型安全对齐、使其输出被禁止内容的攻击 | [JailbreakBench](https://arxiv.org/abs/2404.01318) |
| prompt injection | 提示注入 | 把恶意指令混入输入或外部内容，劫持模型行为、令其忽略原指令的攻击 | [OWASP LLM Top 10 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) |
| OWASP LLM Top 10 | OWASP 大模型十大风险 | 面向 LLM 应用的十大安全风险清单（2026 版将 Prompt Injection 列为首位） | [OWASP LLM Top 10 2026](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) |
| NIST AI RMF | NIST AI 风险管理框架 | NIST 发布的自愿性 AI 风险管理框架，以 Govern / Map / Measure / Manage 四大功能组织 | [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework) |
| EU AI Act | 欧盟人工智能法案 | 全球首部综合性 AI 法规，按不可接受/高/透明度/最小四级风险施加义务，并对 GPAI 设专门要求 | [欧委会](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) |
| GB/T 45654-2025 | 生成式人工智能服务安全基本要求 | 我国面向生成式 AI 服务的国家推荐标准，2025-11-01 实施 | [国标官方页](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A) |

## 8. 训练与调优

| 英文 | 中文 | 一句话定义 | 来源 |
|---|---|---|---|
| SFT | 监督微调 | 在（提示，回答）数据上用 token 级交叉熵微调预训练模型，使其学会遵循指令 | [HF TRL SFT Trainer](https://huggingface.co/docs/trl/main/en/sft_trainer) |
| PEFT | 参数高效微调 | 只训练少量新增或选定参数即可接近全量微调效果的一类方法总称 | [HF PEFT 总览](https://huggingface.co/docs/peft/index) |
| LoRA / QLoRA | 低秩适配 / 量化低秩适配 | LoRA 冻结原权重、只训练低秩增量矩阵；QLoRA 在此基础上用 4-bit 量化基座进一步降显存 | [LoRA 论文](https://arxiv.org/abs/2106.09685) |
| RLHF | 基于人类反馈的强化学习 | 用人类偏好训练奖励模型、再以 RL（通常 PPO）优化策略的三阶段对齐方法 | [InstructGPT](https://arxiv.org/abs/2203.02155) |
| reward model | 奖励模型 | 从人类偏好对学出的、给模型输出打分的代理模型，用作 RLHF 的优化信号 | [HF TRL Reward Trainer](https://huggingface.co/docs/trl/main/en/reward_trainer) |
| DPO | 直接偏好优化 | 用分类式损失直接在偏好数据上优化策略、免去显式奖励模型与 RL 采样的对齐方法 | [DPO 论文](https://arxiv.org/abs/2305.18290) |
| reward hacking | 奖励黑客 | 模型钻代理奖励的漏洞、提高代理分却不提升甚至损害真实目标的现象 | [reward hacking 定义](https://arxiv.org/abs/2209.13085) |

---

## 来源说明

本表所有来源链接均取自项目来源总表 [SOURCES.md](../../../SOURCES.md) 与其对应的 `docs/research/`（01–07 号调研报告），未新增任何未经记录的 URL；术语定义以对应原始论文、官方文档或权威百科为准。基准的停更、换代、更名等时效信息另见 [附录 C · 时效地图](C-freshness-map.md)。
