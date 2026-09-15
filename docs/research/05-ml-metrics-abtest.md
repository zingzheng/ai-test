# 调研报告 05 · 传统 ML 指标 + A/B Test 方法论

> 调研日期：2026-09-15　方法：webfetch 逐条实测（非记忆）
> 图例：✅ = HTTP 200 且内容相符；⚠️ = 可访问但未解析；❌ = 未能验证

---

## 一、分类指标

| 概念 | 来源 | 备注 |
|---|---|---|
| 指标总览与选择原则、多分类 average(macro/micro/weighted) | ✅ https://scikit-learn.org/stable/modules/model_evaluation.html | 官方权威总入口；"先定预测目标/决策，再选一致的评分函数" |
| 混淆矩阵定义（TP/FP/FN/TN、normalize） | ✅ https://scikit-learn.org/stable/modules/generated/sklearn.metrics.confusion_matrix.html | 行=真实、列=预测 |
| ROC-AUC 定义、ovr/ovo、Gini=2AUC−1 | ✅ https://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html | AUC 的排序含义与不平衡敏感性 |
| PR-AUC / Average Precision（非插值） | ✅ https://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html | 与梯形插值 AUC 的差异 |
| Precision/Recall/FPR/Accuracy 直觉、不平衡为何误导 | ✅ https://developers.google.com/machine-learning/crash-course/classification/precision-and-recall | Google ML Crash Course；"99% 全预测负类仍得 99% accuracy"反例 |
| ROC 与 AUC 直觉、不平衡时用 PR | ✅ https://developers.google.com/machine-learning/crash-course/classification/roc-and-auc | AUC=0.5 等价随机 |
| 阈值与混淆矩阵、为何 0.5 不总合理 | ✅ https://developers.google.com/machine-learning/crash-course/classification/thresholding | 连接"指标随阈值变化" |
| 类别不平衡处理、accuracy 是坏指标 | ✅ https://developers.google.com/machine-learning/crash-course/overfitting/imbalanced-datasets | 不平衡专题 |
| Precision/Recall/F-measure 数学 | ✅ https://en.wikipedia.org/wiki/Precision_and_recall | 概念性权威 |
| 混淆矩阵（多类/多标签）、不平衡失效示例 | ✅ https://en.wikipedia.org/wiki/Confusion_matrix | 95/5 数据示例 |
| ROC 曲线、AUC 概率解释与批评 | ✅ https://en.wikipedia.org/wiki/Receiver_operating_characteristic | "AUC 高但 precision 低"的批评 |
| PR 曲线实操、AP=∑(R_n−R_{n−1})P_n | ✅ https://scikit-learn.org/stable/auto_examples/model_selection/plot_precision_recall.html | 教学配图 |

## 二、回归指标

| 概念 | 来源 | 备注 |
|---|---|---|
| MSE 定义与 multioutput | ✅ https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_squared_error.html | 官方 API |
| R² 定义、可为负、常数预测=0 | ✅ https://scikit-learn.org/stable/modules/generated/sklearn.metrics.r2_score.html | R² 与平方误差同序 |
| MAPE、wMAPE、对 y≈0 爆炸、不对称惩罚 | ✅ https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_absolute_percentage_error.html | "贴近 0 时值任意大" |
| 回归指标选择（MSE↔mean、MAE↔median、pinball↔quantile） | ✅ https://scikit-learn.org/stable/modules/model_evaluation.html | "which scoring function"表 |
| MSE 定义、MSE=Var+Bias² | ✅ https://en.wikipedia.org/wiki/Mean_squared_error | 概念性权威 |
| RMSE/RMSD 定义、对离群点敏感、NRMSD | ✅ https://en.wikipedia.org/wiki/Root_mean_square_deviation | 对比 MSE 的量纲意义 |
| R² 详解、随变量增加单调不减、adjusted R² | ✅ https://en.wikipedia.org/wiki/Coefficient_of_determination | 补充 sklearn 未强调的 caveats |
| MAPE 缺点与替代 | ✅ https://en.wikipedia.org/wiki/Mean_absolute_percentage_error | 偏向下偏预测 |

## 三、排序 / 检索指标

| 概念 | 来源 | 备注 |
|---|---|---|
| NDCG 定义、graded relevance、k 截断 | ✅ https://scikit-learn.org/stable/modules/generated/sklearn.metrics.ndcg_score.html | 含 Järvelin & Kekäläinen 参考 |
| DCG/nDCG 推导、IDCG、局限 | ✅ https://en.wikipedia.org/wiki/Discounted_cumulative_gain | 为何需要归一化 |
| IR 评测总览：Online vs Offline、P/R/F、AP、P@k、MAP、DCG | ✅ https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval) | web-scale 下 recall 无意义 |
| MRR 定义与例子 | ✅ https://en.wikipedia.org/wiki/Mean_reciprocal_rank | 仅看首个相关结果 |
| Learning to Rank 指标与三种范式 | ✅ https://en.wikipedia.org/wiki/Learning_to_rank | 排序为何不能只看 accuracy |
| 教材：ranked retrieval 评测、11-point AP、MAP、P@k | ✅ https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html | Manning《IIR》第 8 章 |

## 四、A/B Test

| 概念 | 来源 | 备注 |
|---|---|---|
| A/B 测试专著官方站（Kohavi, Tang, Xu 2020, Cambridge） | ✅ https://experimentguide.com/ | 领域"圣经"；OEC、陷阱、方差缩减 |
| CUPED 原始论文（Deng/Xu/Kohavi/Walker, WSDM 2013） | ✅ https://www.exp-platform.com/Documents/2013-02-CUPED-ImprovingSensitivityOfControlledExperiments.pdf | 方差缩减经典 |
| 受控实验实践综述（Kohavi et al.） | ✅ https://www.exp-platform.com/Documents/GuideControlledExperiments.pdf | 互联网 A/B 经典实践 |
| SRM 分类与诊断规则（Fabijan et al., KDD 2019） | ✅ https://www.microsoft.com/en-us/research/publication/diagnosing-sample-ratio-mismatch-in-online-controlled-experiments-a-taxonomy-and-rules-of-thumb-for-practitioners/ | SRM 是数据质量"发烧症状" |
| 比率型指标的 Delta method 方差/推断 | ✅ https://arxiv.org/abs/1803.06336 | 重尾指标方差估计 |
| A/B 测试总览、常见检验、CUPED、挑战 | ✅ https://en.wikipedia.org/wiki/A/B_testing | 覆盖 SRM/CUPED/网络效应 |
| 假设检验 H0/H1、Type I/II、α、power、p 值 | ✅ https://en.wikipedia.org/wiki/Statistical_hypothesis_test | 概念性权威 |
| p 值定义、ASA 声明、误用 | ✅ https://en.wikipedia.org/wiki/P-value | "p 值不是什么" |
| 统计功效、1−β、Lehr 经验法则 | ✅ https://en.wikipedia.org/wiki/Statistical_power | 80% power / α=0.05 惯例 |
| 样本量估算 | ✅ https://en.wikipedia.org/wiki/Sample_size_determination | 比例/均值、公式与表 |
| 置信区间、反复抽样解释、常见误解 | ✅ https://en.wikipedia.org/wiki/Confidence_interval | "两 CI 重叠≠不显著" |
| 多重比较、FWER、Bonferroni/BH | ✅ https://en.wikipedia.org/wiki/Multiple_comparisons_problem | 多重比较陷阱 |
| 新奇效应 | ✅ https://en.wikipedia.org/wiki/Novelty_effect | 短期效应陷阱 |
| 网络效应 | ✅ https://en.wikipedia.org/wiki/Network_effect | 网络效应陷阱 |
| 随机对照试验方法论 | ✅ https://en.wikipedia.org/wiki/Randomized_controlled_trial | A/B 理论根基 |

## 五、离线评测 vs 在线实验

| 概念 | 来源 | 备注 |
|---|---|---|
| Online measures vs Offline metrics 并列对比 | ✅ https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval) | 在线指标用于 A/B、离线指标用于静态集 |
| OEC、离线与在线指标关系 | ✅ https://experimentguide.com/ | 离线信号需在线验证 |
| 离线集评测对真实用户的局限 | ✅ https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html | 教材层面 |

---

## 六、建议章节小节划分

```
1. 为什么"指标选错"是最贵的 bug
2. 分类指标：混淆矩阵 / P-R-F1 / ROC-AUC vs PR-AUC / 不平衡
3. 回归指标：MSE/RMSE/MAE / R² / MAPE 陷阱
4. 排序与检索指标：P@K / Recall@K / MAP / MRR / NDCG
5. 在线实验（A/B Test）：假设检验 / p 值 / 功效与样本量 / 置信区间 / CUPED / 常见陷阱
6. 离线评测与在线实验的关系：离线涨 ≠ 线上涨；工作流
```

## 七、未验证 / 存疑项

- ❌ exp-platform.com 上多个老 PDF 链接 404（含 DiagnosingSampleRatioMismatch、TopChallenges 等）
- ❌ Netflix Tech Blog（403 反爬）、ACM 相关页（403）
- ❌ `https://en.wikipedia.org/wiki/Interleaving_(information_retrieval)` 404
- ⚠️ `https://arxiv.org/abs/1203.0690` 内容无关，已剔除
- ⚠️ SRM 逐条规则需另找开放全文；Top Challenges Summit 论文建议用 DOI 获取
- ⚠️ Wikipedia 的新奇/网络效应偏通识，工程化表述建议以 experimentguide.com + CUPED/SRM 论文为主
