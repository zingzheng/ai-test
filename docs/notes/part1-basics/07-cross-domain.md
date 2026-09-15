# 第 7 章 跨领域评测指标：传统 ML / 推荐 / CV / NLP / RL

> **一句话结论**：同一个"好"字，在分类、回归、排序、推荐、CV、NLP、RL 里含义完全不同；岗位要求的成熟度不是背公式，而是**看到任务就能判断该用哪族指标、这个指标会不会骗人、报告里有没有隐瞒关键条件**。

---

> 本章对应岗位 JD 的「了解常见 ML 指标（分类 / 回归 / 排序、推荐 / CV / NLP / RL 等）」。目标是**能正确使用术语、能判断指标选得对不对**，公式不推导、调参不涉及。

## 7.1 通用 ML 指标：三大族

### 分类

| 指标 | 一句话含义 | 关键提醒 |
|---|---|---|
| Accuracy | 预测正确样本占比 | 类别不平衡时会严重误导 |
| Precision / Recall | 预测为正里对的比例 / 真实为正里被找回的比例 | 两者此消彼长，取决于你更怕 FP 还是 FN |
| F1 | Precision 与 Recall 的调和平均 | 单值折中，但会掩盖极端偏科 |
| ROC-AUC | 排序意义上"正样本得分高于负样本"的概率 | 不平衡时仍可能虚高；AUC=0.5 等价随机 |
| PR-AUC / AP | Precision-Recall 曲线下面积 | 不平衡、且更关心正类时优先用 |

最经典的"指标骗人"案例来自 Google 的教程：在 99:1 的不平衡数据里，**全预测成负类也能拿到 99% accuracy**，但此时 Recall=0，系统毫无价值。根本原因是：accuracy 默认把两类错误当成了同等代价。

> 来源：[Precision and Recall（Google ML Crash Course）](https://developers.google.com/machine-learning/crash-course/classification/precision-and-recall) — ✅
> 来源：[Imbalanced Datasets（Google ML Crash Course）](https://developers.google.com/machine-learning/crash-course/overfitting/imbalanced-datasets) — ✅
> 来源：[ROC and AUC（Google ML Crash Course）](https://developers.google.com/machine-learning/crash-course/classification/roc-and-auc) — ✅
> 来源：[scikit-learn: Metrics and scoring](https://scikit-learn.org/stable/modules/model_evaluation.html)、[ROC-AUC](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html)、[Average Precision / PR-AUC](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html) — ✅

**术语成熟度**：Precision/Recall/F1 依赖一个**判定阈值**，默认 0.5 并不总是合理——报告指标时不说阈值，结论就不可复现。

> 来源：[Thresholding（Google ML Crash Course）](https://developers.google.com/machine-learning/crash-course/classification/thresholding) — ✅

### 回归

| 指标 | 一句话含义 | 关键提醒 |
|---|---|---|
| MSE / RMSE | 平方误差的均值 / 其平方根 | 对离群点敏感；RMSE 与目标同量纲 |
| MAE | 绝对误差均值 | 对离群点更稳健，等价于拟合中位数 |
| R² | 相对"均值基线"解释了多少方差 | 可为负；随自变量增加单调不减，需配合 adjusted R² |
| MAPE | 绝对百分比误差均值 | y≈0 时爆炸，且对低估与高估惩罚不对称 |

选型口诀：**MSE ↔ 均值、MAE ↔ 中位数**；报告 MAPE 前先确认没有接近 0 的真值。

> 来源：[MSE](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_squared_error.html)、[R²](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.r2_score.html)、[MAPE](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_absolute_percentage_error.html)（均 scikit-learn 官方） — ✅

### 排序 / 检索

| 指标 | 关心什么 | 常见误用 |
|---|---|---|
| P@K | 前 K 个里相关结果占比 | 不报告 K 值等于没报 |
| Recall@K | 前 K 个覆盖了多少相关结果 | web-scale 下总量太大，Recall 常无意义 |
| MAP | 多个查询上 AP 的平均 | 需要明确的"相关"定义 |
| MRR | 第一个相关结果的排名倒数 | 只看首个命中，忽略其余 |
| NDCG | 含位置折损的 graded relevance | 依赖相关性分级与截断 K |

**排序不能只看 accuracy**：顺序错了但集合对，accuracy 可能满分，体验却是灾难。

> 来源：[NDCG（scikit-learn）](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.ndcg_score.html)、[DCG/NDCG 概念](https://en.wikipedia.org/wiki/Discounted_cumulative_gain) — ✅
> 来源：[Evaluation measures (information retrieval)](https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval))、[Mean reciprocal rank](https://en.wikipedia.org/wiki/Mean_reciprocal_rank)、[Learning to rank](https://en.wikipedia.org/wiki/Learning_to_rank) — ✅
> 来源：[Introduction to Information Retrieval, Ch.8（Stanford）](https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html) — ✅

## 7.2 推荐系统：三类指标 + 离线-在线落差

推荐评测通常分三层，**不能互相替代**：

1. **离线准确率族**：Recall@K、Hit Rate、NDCG、MAP——衡量"能不能排对"。
2. **超准确率族（beyond-accuracy）**：Coverage、Diversity、Novelty——衡量"列表够不够丰富、新不新"，它们是**列表级**而非用户级指标，和准确率不能直接互换。工程上常在排序之后做后处理来优化。
3. **在线业务指标**：CTR、CVR、停留时长、GMV——衡量"用户到底买不买账"。

> 来源：[Deep Learning based Recommender System: A Survey](https://arxiv.org/abs/1707.07435) — ✅
> 来源：[Beyond-accuracy 目标（2025–2026）](https://arxiv.org/abs/2511.10492) — ✅
> 来源：[TensorFlow Recommenders（FactorizedTopK / Hit Rate）](https://github.com/tensorflow/recommenders) — ✅
> 来源：[Wide & Deep（Google Play 在线转化实验）](https://arxiv.org/abs/1606.07792) — ✅

**离线-在线落差**是推荐评测最贵的坑：离线指标（NDCG/Recall@K）只是**代理指标**，线上（CTR/CVR）才是业务真相。"离线涨点、线上不涨"是常态，常见原因是数据分布偏差、曝光/位置偏差、反馈闭环、以及代理指标本身选错。

## 7.3 计算机视觉

### 检测 / 分割

| 指标 | 含义 |
|---|---|
| IoU | 预测框与真实框的交并比，检测的"对不齐"门槛 |
| AP | 单个类别、单一 IoU 阈值下 PR 曲线面积 |
| AP50 / AP75 | 固定 IoU=0.50 / 0.75 的 AP |
| mAP（COCO 口径） | 对 10 个 IoU 阈值（0.50:0.05:0.95）取平均的 AP |

**AP ≠ mAP**：在 COCO 语境里，"mAP"就是对多阈值取平均的 AP，双方常被混用。**AP50 通常远高于跨阈值平均**，只报 AP50 会显得虚高，必须注明阈值口径。分割用 mask IoU，与 box IoU 不是一回事。

> 来源：[COCO Detection Evaluation](https://cocodataset.org/#detection-eval)、[COCO API](https://github.com/cocodataset/cocoapi) — ✅

### 图像生成

| 指标 | 类型 | 方向 |
|---|---|---|
| PSNR / SSIM | 有参考、逐像素/结构 | 偏保真度，常与人类感知不符 |
| FID | 分布级、无参考 | 越低越好，比 IS 更能反映分布相似度 |
| IS | 分布级、无参考 | 越高越好，但易被刷 |
| CLIPScore | 语义级、可无参考 | 与人类判断相关性高于 CIDEr/SPICE；需背景知识的场景较弱 |

> 来源：[FID 原始论文](https://arxiv.org/abs/1706.08500)、[IS / Improved GAN](https://arxiv.org/abs/1606.03498)、[CLIP](https://arxiv.org/abs/2103.00020)、[CLIPScore](https://arxiv.org/abs/2104.08718)、[SSIM（scikit-image 官方示例）](https://scikit-image.org/docs/stable/auto_examples/transform/plot_ssim.html) — ✅

### 分类

ImageNet 长期用 **Top-1 / Top-5 accuracy** 作为协议；但 **ILSVRC 挑战在 2017 年后已停办**，如今更强调 ImageNet-ReaL、ImageNet-V2 以及鲁棒性 / 多模态评测，别再把"ILSVRC 榜单"当成现役战场。

> 来源：[ImageNet](https://www.image-net.org/)、[ILSVRC 论文（Russakovsky et al.）](https://arxiv.org/abs/1409.0575) — ✅

## 7.4 NLP：从 n-gram 到 LLM-as-Judge

**传统生成指标**（基于 n-gram 重叠，**无法衡量语义、事实性、指令遵循**）：

| 指标 | 特点 |
|---|---|
| BLEU | n-gram 精确率 + 长度惩罚；对分词与多参考高度敏感 |
| ROUGE | 面向摘要，基于召回（ROUGE-N/L） |
| METEOR | 引入同义词 / 词干匹配 |
| chrF | 字符 n-gram F 值，对形态丰富语言友好 |

**学习型语义指标**：BERTScore（上下文嵌入相似度）、BLEURT（学习型评估器）——都需要参考文本，并带领域 / 模型偏置。

> ⚠️ **易错点**：BLEURT 的正确 arXiv 编号是 **[2004.04696](https://arxiv.org/abs/2004.04696)**，常被误引为 2005.01535（后者实为无关论文）。

> 来源：[BLEU](https://aclanthology.org/P02-1040/)、[ROUGE](https://aclanthology.org/W04-1013/)、[METEOR](https://aclanthology.org/W05-0909/)、[chrF](https://aclanthology.org/W15-3049/)、[BERTScore](https://arxiv.org/abs/1904.09675)、[BLEURT](https://arxiv.org/abs/2004.04696) — ✅

**综合基准**：GLUE / SuperGLUE 是自然语言理解的多任务基准（SuperGLUE 正因"GLUE 已被超越"才推出）；SQuAD 用 EM 与 F1，并给出 Human Performance 基线，其 2.0 版本专门考验"该弃答时弃答"。

> 来源：[GLUE](https://arxiv.org/abs/1804.07461)、[SuperGLUE](https://arxiv.org/abs/1905.00537)、[SQuAD 榜单](https://rajpurkar.github.io/SQuAD-explorer/)、[SQuAD 2.0](https://arxiv.org/abs/1806.03822) — ✅

**为何 LLM 时代转向 LLM-as-Judge**：开放生成答案不唯一，n-gram 指标既惩罚合理同义改写、又奖励空洞重叠。MT-Bench / Chatbot Arena 证明强 LLM 裁判与人类偏好一致率可 **>80%**，与人类标注者间一致率相当；但必须警惕位置偏差、冗长偏差、自我增强偏差（校准详见第 2、4、13、15 章）。

> 来源：[Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena](https://arxiv.org/abs/2306.05685) — ✅

## 7.5 强化学习：评测口径与细节指向

RL 的"好"没有固定标签，常用四个维度：

- **Return（累计回报）**：注意区分 finite-horizon 无折扣与 infinite-horizon 折扣两种口径，**return ≠ reward**。
- **Sample efficiency / sample complexity**：达到同一性能需要多少交互样本，是算法横向对比的关键维度。
- **Success rate**：任务型 / 具身场景最直观的成败口径。
- **Regret**：主要在 bandit 语境，衡量相对最优策略的累积遗憾。

RL 评测最大的坑是**不可复现**：《Deep RL that Matters》专门指出结果方差大、需报告显著性、标准化报告流程——这对测开视角做 RL 评测尤其相关。（RL / RLHF / 调优术语见**附录 D**）。

> 来源：[Sutton & Barto, Reinforcement Learning 2nd ed.](http://incompleteideas.net/book/the-book-2nd.html)、[OpenAI Spinning Up: RL Intro](https://spinningup.openai.com/en/latest/spinningup/rl_intro.html)、[Gymnasium（env 接口）](https://gymnasium.farama.org/)、[PPO（sample complexity）](https://arxiv.org/abs/1707.06347)、[Deep RL that Matters](https://arxiv.org/abs/1709.06560) — ✅

## 7.6 指标"选得对不对"检查清单

拿到评测结论，按下面六问过一遍，能挡掉大部分"指标选错"的 bug：

1. **是否匹配任务？** 分类别用回归指标，排序别只看 accuracy，生成别只报 BLEU。
2. **是否报告了 K / 阈值？** P@K、Recall@K、Precision 都必须带 K 值或阈值。
3. **不平衡时是否换了口径？** 高风险正类场景用 PR-AUC / F1，并同时看 Recall。
4. **是否只报有利指标？** 只报 AP50、只报 Top-1、只报 accuracy 都是选择性报告。
5. **离线是否验证了线上？** 离线指标是代理，最终须由在线实验或监控确认。
6. **是否说明了随机性？** RL、生成等高方差任务应报告多 seed 与显著性。

> 离线 vs 在线、代理指标的关系，源头见：[Evaluation measures (information retrieval)](https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval))、[Trustworthy Online Controlled Experiments](https://experimentguide.com/) — ✅

---

## 本章要点

- 分类指标先问两件事：数据是否不平衡、阈值取多少；不平衡时 accuracy 会骗人，改用 PR-AUC / F1 / Recall。
- 回归选型口诀：MSE↔均值、MAE↔中位数；MAPE 在 y≈0 附近会爆炸。
- 排序 / 推荐指标必须带 K，推荐还要分离线准确率、超准确率、在线业务指标三层，警惕离线-在线落差。
- CV 里 **AP ≠ mAP**、AP50 会虚高、ILSVRC 已停办；生成指标分保真（PSNR/SSIM）、分布（FID/IS）、语义（CLIPScore）三类。
- NLP 传统指标只测字面重叠，LLM 时代转向 LLM-as-Judge；**BLEURT 正确编号是 2004.04696**，勿引 2005.01535。
- RL 评测看 return / sample efficiency / success rate / regret，且必须报告方差与显著性（细节见附录 D）。
- 六问检查清单：匹配任务、报告 K/阈值、不平衡换口径、不选择性报告、离线验证线上、说明随机性。

## 来源

- [scikit-learn: Metrics and scoring](https://scikit-learn.org/stable/modules/model_evaluation.html) — 访问 2026-09-15 — ✅ — 指标总览与选择原则
- [scikit-learn: roc_auc_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html) — 访问 2026-09-15 — ✅ — ROC-AUC
- [scikit-learn: average_precision_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html) — 访问 2026-09-15 — ✅ — PR-AUC / AP
- [Google ML Crash Course: Precision and Recall](https://developers.google.com/machine-learning/crash-course/classification/precision-and-recall) — 访问 2026-09-15 — ✅ — 不平衡反例
- [Google ML Crash Course: ROC and AUC](https://developers.google.com/machine-learning/crash-course/classification/roc-and-auc) — 访问 2026-09-15 — ✅ — AUC 直觉
- [Google ML Crash Course: Imbalanced Datasets](https://developers.google.com/machine-learning/crash-course/overfitting/imbalanced-datasets) — 访问 2026-09-15 — ✅ — 类别不平衡
- [Google ML Crash Course: Thresholding](https://developers.google.com/machine-learning/crash-course/classification/thresholding) — 访问 2026-09-15 — ✅ — 阈值
- [scikit-learn: mean_squared_error](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_squared_error.html) — 访问 2026-09-15 — ✅ — MSE
- [scikit-learn: r2_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.r2_score.html) — 访问 2026-09-15 — ✅ — R²
- [scikit-learn: mean_absolute_percentage_error](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_absolute_percentage_error.html) — 访问 2026-09-15 — ✅ — MAPE
- [scikit-learn: ndcg_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.ndcg_score.html) — 访问 2026-09-15 — ✅ — NDCG
- [Wikipedia: Discounted cumulative gain](https://en.wikipedia.org/wiki/Discounted_cumulative_gain) — 访问 2026-09-15 — ✅ — DCG/NDCG 概念
- [Wikipedia: Evaluation measures (information retrieval)](https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval)) — 访问 2026-09-15 — ✅ — 在线/离线指标
- [Wikipedia: Mean reciprocal rank](https://en.wikipedia.org/wiki/Mean_reciprocal_rank) — 访问 2026-09-15 — ✅ — MRR
- [Wikipedia: Learning to rank](https://en.wikipedia.org/wiki/Learning_to_rank) — 访问 2026-09-15 — ✅ — 排序范式
- [IIR Book: Evaluation of ranked retrieval results](https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html) — 访问 2026-09-15 — ✅ — P@K / MAP 教材
- [Deep Learning based Recommender System: A Survey](https://arxiv.org/abs/1707.07435) — 访问 2026-09-15 — ✅ — 推荐离线指标
- [TensorFlow Recommenders](https://github.com/tensorflow/recommenders) — 访问 2026-09-15 — ✅ — Hit Rate / FactorizedTopK
- [Beyond-accuracy 目标（arXiv 2511.10492）](https://arxiv.org/abs/2511.10492) — 访问 2026-09-15 — ✅ — Coverage/Diversity/Novelty
- [Wide & Deep](https://arxiv.org/abs/1606.07792) — 访问 2026-09-15 — ✅ — 在线转化实验
- [COCO Detection Evaluation](https://cocodataset.org/#detection-eval) — 访问 2026-09-15 — ✅ — AP/AP50/AP75/mAP
- [COCO API](https://github.com/cocodataset/cocoapi) — 访问 2026-09-15 — ✅ — 官方评估代码
- [FID](https://arxiv.org/abs/1706.08500) — 访问 2026-09-15 — ✅ — 生成分布指标
- [Inception Score / Improved GAN](https://arxiv.org/abs/1606.03498) — 访问 2026-09-15 — ✅ — IS
- [CLIP](https://arxiv.org/abs/2103.00020) — 访问 2026-09-15 — ✅ — CLIP 底座
- [CLIPScore](https://arxiv.org/abs/2104.08718) — 访问 2026-09-15 — ✅ — 语义相似度
- [scikit-image: SSIM](https://scikit-image.org/docs/stable/auto_examples/transform/plot_ssim.html) — 访问 2026-09-15 — ✅ — SSIM 与 MSE 对比
- [ImageNet](https://www.image-net.org/) — 访问 2026-09-15 — ✅ — 数据集主页
- [ILSVRC 论文](https://arxiv.org/abs/1409.0575) — 访问 2026-09-15 — ✅ — Top-1/Top-5 协议、2017 停办
- [BLEU](https://aclanthology.org/P02-1040/) — 访问 2026-09-15 — ✅ — n-gram 精确率
- [ROUGE](https://aclanthology.org/W04-1013/) — 访问 2026-09-15 — ✅ — 摘要召回指标
- [METEOR](https://aclanthology.org/W05-0909/) — 访问 2026-09-15 — ✅ — 同义/词干匹配
- [chrF](https://aclanthology.org/W15-3049/) — 访问 2026-09-15 — ✅ — 字符 n-gram F 值
- [BERTScore](https://arxiv.org/abs/1904.09675) — 访问 2026-09-15 — ✅ — 上下文嵌入相似度
- [BLEURT](https://arxiv.org/abs/2004.04696) — 访问 2026-09-15 — ✅ — 学习型评估器（非 2005.01535）
- [GLUE](https://arxiv.org/abs/1804.07461) — 访问 2026-09-15 — ✅ — NLU 多任务基准
- [SuperGLUE](https://arxiv.org/abs/1905.00537) — 访问 2026-09-15 — ✅ — GLUE 后继
- [SQuAD Explorer](https://rajpurkar.github.io/SQuAD-explorer/) — 访问 2026-09-15 — ✅ — EM / F1 榜单
- [SQuAD 2.0](https://arxiv.org/abs/1806.03822) — 访问 2026-09-15 — ✅ — 弃答能力
- [Judging LLM-as-a-Judge (MT-Bench / Chatbot Arena)](https://arxiv.org/abs/2306.05685) — 访问 2026-09-15 — ✅ — LLM 裁判与偏差
- [Sutton & Barto: Reinforcement Learning, 2nd ed.](http://incompleteideas.net/book/the-book-2nd.html) — 访问 2026-09-15 — ✅ — RL 教科书
- [OpenAI Spinning Up: RL Intro](https://spinningup.openai.com/en/latest/spinningup/rl_intro.html) — 访问 2026-09-15 — ✅ — return 等术语
- [Gymnasium](https://gymnasium.farama.org/) — 访问 2026-09-15 — ✅ — env 标准接口
- [PPO](https://arxiv.org/abs/1707.06347) — 访问 2026-09-15 — ✅ — sample complexity
- [Deep RL that Matters](https://arxiv.org/abs/1709.06560) — 访问 2026-09-15 — ✅ — RL 可复现性与报告规范
- [Trustworthy Online Controlled Experiments](https://experimentguide.com/) — 访问 2026-09-15 — ✅ — 离线信号需在线验证
