# 调研报告 06 · 跨领域评测指标（推荐 / CV / NLP）

> 调研日期：2026-09-15　方法：webfetch 逐条实测

---

## 一、推荐系统评测

### 1.1 离线指标

| 概念 | 权威来源 | 备注 |
|---|---|---|
| 检索/排序类离线指标（Recall@K、Hit Rate、NDCG、MAP） | ✅ https://arxiv.org/abs/1707.07435 | 《Deep Learning based Recommender System: A Survey》，ACM Computing Surveys；系统梳理模型与评测口径 |
| Hit Rate / Recall@K 工程实现（FactorizedTopK） | ✅ https://github.com/tensorflow/recommenders | TF Recommenders 官方仓库；全候选集排序命中率 |
| Coverage / Diversity / Novelty 等"超准确率"目标 | ✅ https://arxiv.org/abs/2511.10492（2025-11，2026-01 修订） | 明确需优化 accuracy 之外的多样性/新颖性，通常在排序阶段后处理 |

**术语提醒**
- P@K / Recall@K 依赖"相关"定义（隐式反馈常把交互当相关），K 取值显著改变结论。
- MAP、NDCG 是排序质量指标（NDCG 含位置折损）；Hit Rate 是"是否命中至少一个"的二值指标，常等价当 Recall@K。
- Coverage/Diversity/Novelty 是**列表级、非用户级**指标，不能与准确率直接互换。

### 1.2 在线指标与"离线-在线落差"

| 概念 | 权威来源 | 备注 |
|---|---|---|
| 在线 A/B 评测（转化/获取量） | ✅ https://arxiv.org/abs/1606.07792 | Google《Wide & Deep》；Google Play 在线实验，转化的经典工业案例 |

**术语提醒**
- CTR/CVR/停留时长/GMV 是业务在线指标；NDCG/Recall@K 是离线代理指标。
- "离线涨点、线上不涨"是常态，常见原因：数据分布偏差、曝光/位置偏差、反馈闭环、指标代理选错。

---

## 二、计算机视觉（CV）

### 2.1 检测 / 分割

| 概念 | 权威来源 | 备注 |
|---|---|---|
| COCO 检测评测协议（AP、AP50、AP75、mAP） | ✅ https://cocodataset.org/#detection-eval | COCO 官方 Evaluation 页 |
| COCO 官方评估代码（pycocotools） | ✅ https://github.com/cocodataset/cocoapi | "COCO mAP" 的出处 |

**术语提醒**
- AP ≠ mAP：COCO 语境的 "mAP" 就是对 10 个 IoU 阈值（0.50:0.05:0.95）取平均的 AP。
- **AP50 / AP75** 是固定 IoU 阈值的 AP，通常远高于跨阈值平均，只给 AP50 会显虚高，必须注明。
- 分割用 mask IoU，与 box IoU 不同。

### 2.2 图像生成

| 概念 | 权威来源 | 备注 |
|---|---|---|
| FID 原始论文 | ✅ https://arxiv.org/abs/1706.08500 | Heusel et al. 2017；FID 比 IS 更能反映分布相似度 |
| IS（Inception Score） | ✅ https://arxiv.org/abs/1606.03498 | Salimans et al.；Improved Techniques for Training GANs |
| CLIP 原论文 | ✅ https://arxiv.org/abs/2103.00020 | Radford et al. 2021；CLIP score 系列的底座 |
| CLIPScore | ✅ https://arxiv.org/abs/2104.08718 | Hessel et al., EMNLP 2021；与人类判断相关性高于 CIDEr/SPICE |
| SSIM（与 MSE 对比） | ✅ https://scikit-image.org/docs/stable/auto_examples/transform/plot_ssim.html | scikit-image 官方示例；引 Wang et al. 2004 |

**术语提醒**
- PSNR/SSIM：有参考、逐像素/结构，偏保真度，常与人类感知不符。
- FID/IS：分布级、无参考；FID 越低越好，IS 越高越好（IS 易被刷）。
- CLIP score：语义级、可无参考；需背景知识的场景较弱（CLIPScore 论文自述）。

### 2.3 分类

| 概念 | 权威来源 | 备注 |
|---|---|---|
| ImageNet 官方站 | ✅ https://www.image-net.org/ | 数据集主页 |
| ILSVRC 官方挑战页 | ✅ https://www.image-net.org/challenges/LSVRC/ | 2010–2017 挑战 |
| ILSVRC 论文（Top-1/Top-5 协议） | ✅ https://arxiv.org/abs/1409.0575 | Russakovsky et al., IJCV 2015 |

**2026 状态**：ILSVRC **2017 年后已停办**；Top-1/Top-5 仍惯用，但更强调 ImageNet-ReaL、ImageNet-V2、鲁棒性/多模态评测。

---

## 三、自然语言处理（NLP）

### 3.1 传统文本生成指标

| 概念 | 权威来源 | 备注 |
|---|---|---|
| BLEU（Papineni 2002） | ✅ https://aclanthology.org/P02-1040/ | n-gram 精确率 + 长度惩罚；NAACL 2018 Test-of-Time |
| ROUGE（Lin 2004） | ✅ https://aclanthology.org/W04-1013/ | 面向摘要，ROUGE-N/L 基于召回 |
| METEOR（2005） | ✅ https://aclanthology.org/W05-0909/ | 引入同义/词干匹配 |
| chrF（2015） | ✅ https://aclanthology.org/W15-3049/ | 字符 n-gram F 值，对形态丰富语言友好 |
| BERTScore | ✅ https://arxiv.org/abs/1904.09675 | Zhang et al., ICLR 2020；上下文嵌入相似度 |
| BLEURT | ✅ https://arxiv.org/abs/2004.04696 | Sellam et al., ACL 2020；**注意不是 2005.01535** |

### 3.2 基准

| 基准 | 权威来源 | 备注 |
|---|---|---|
| GLUE 论文 | ✅ https://arxiv.org/abs/1804.07461 | Wang et al., ICLR 2019 |
| SuperGLUE 论文 | ✅ https://arxiv.org/abs/1905.00537 | Wang et al., NeurIPS 2019；"GLUE 已被超越"才推出 |
| SQuAD 官网/榜单 | ✅ https://rajpurkar.github.io/SQuAD-explorer/ | 指标为 EM 与 F1；含 Human Performance 基线 |
| SQuAD 2.0 论文 | ✅ https://arxiv.org/abs/1806.03822 | Rajpurkar et al., ACL 2018；考验"该弃答时弃答" |

### 3.3 传统指标为何在 LLM 时代不够用

| 概念 | 权威来源 | 备注 |
|---|---|---|
| LLM-as-a-Judge / MT-Bench / Chatbot Arena | ✅ https://arxiv.org/abs/2306.05685 | Zheng et al., NeurIPS 2023；强 LLM 裁判与人类一致性 >80%；位置/冗长/自我增强偏差 |

**术语提醒**
- BLEU/ROUGE/METEOR/chrF：n-gram 重叠，无法衡量语义、事实性、指令遵循；BLEU 对分词/多参考高度敏感。
- BERTScore/BLEURT：学习型，需参考文本、有领域/模型偏置。
- LLM 时代开放生成转向 **LLM-as-Judge + 人类偏好竞技场**，但要警惕裁判偏差。

---

## 四、建议章节小节划分

```
1. 评测指标总论：离线 / 在线 / 人类评估的分工；指标选型三问
2. 推荐系统：离线准确率族 / 超准确率族 / 在线指标 / 离线-在线落差
3. 计算机视觉：检测分割（IoU、AP、COCO）/ 生成（PSNR/SSIM/FID/IS/CLIPScore）/ 分类
4. 自然语言处理：传统指标 / 语义指标 / 综合基准 / LLM 时代的转向
5. 指标"选得对不对"的检查清单
```

## 五、未验证 / 存疑项

- ❌ `tensorflow.org/recommenders` 多次 Transport error → 改用 GitHub 仓库
- ❌ Netflix Tech Blog（403）、ACM《beyond-accuracy》综述（403）
- ⚠️ `arxiv.org/abs/2005.01535` 不是 BLEURT（实为 Lifelog Mining），BLEURT 正确编号 **2004.04696**
- ⚠️ GLUE/SuperGLUE 官网为 JS 单页，引用优先用论文
- ⚠️ YouTube 推荐论文（CTR/watch time）、NDCG 原始论文（ACM）本次未验证到稳定 URL
- ⚠️ 离线-在线一致性无单一权威页，建议引用多篇工业论文段落
