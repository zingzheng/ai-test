# 附录 E · 测评岗位能力地图

> **一句话结论**：这份附录把一份真实测评岗位 JD 拆成关键词，逐条映射到本笔记章节，并配一份按主题分组的面试准备清单——它的用途是「导航 + 面试」，不是新增知识。

本附录由一份真实测评岗位 JD 触发。JD 原文是：「了解常见评测方法论（自动评测、人工评测、A/B Test、LLM-as-a-Judge 等），有评测模型训练经验者优先；推荐/CV/NLP/RL 相关工作经验，有大模型调优应用、评测经历者优先；扎实的机器学习基础，能够熟练应用常用的机器学习模型解决实际业务问题，有主流深度学习模型（CV/NLP/推荐/RL 等）实践落地经验优先。」下面把它拆解、映射并转成面试题。

---

## E.1 原始 JD 能力清单（逐条拆关键词）

**条 1 · 评测方法论**
- 关键词：自动评测 / 人工评测 / A/B Test / LLM-as-Judge
- 隐含要求：知道四种方法各自能回答什么问题、代价多大、什么时候会骗人。

**条 2 · 评测模型训练经验（优先项）**
- 关键词：评测模型训练 → judge 校准、Critique Shadowing、precision/recall 对齐、reward model 评测。
- 隐含要求：不只是「用」judge，还知道怎么训 / 校准一个可信的评判器。

**条 3 · 推荐 / CV / NLP / RL 经验**
- 关键词：四类领域的评测口径与代表指标。
- 隐含要求：能跨域对话，看到任务就知道该用哪族指标。

**条 4 · 大模型调优应用、评测经历（优先项）**
- 关键词：大模型调优（SFT / PEFT / LoRA）、调优后如何评测、RLHF 链路。
- 隐含要求：理解训练侧概念在测评里的位置（了解即可，见附录 D）。

**条 5 · 扎实的机器学习基础 + 常用模型解决业务问题**
- 关键词：分类 / 回归 / 排序指标、类别不平衡、阈值、代理指标。
- 隐含要求：能判断「指标选得对不对」，而不是背公式。

**条 6 · 主流深度学习模型实践落地（优先项）**
- 关键词：离线指标 ↔ 在线业务指标的落差、离线-在线衔接。
- 隐含要求：有「离线涨点不等于线上变好」的实战自觉。

---

## E.2 能力地图（JD 关键词 → 章节落点）

| JD 关键词 | 含义 | 对应章节（相对链接） | 掌握到什么程度 |
|---|---|---|---|
| 自动评测 | 断言 / 指标计算，CI 挡退化 | [第 2 章](../part1-basics/02-methodology.md) §2.2 | 会用、知道盲区在开放生成 |
| 人工评测 | 众包 / 专家标注，建黄金标准 | [第 2 章](../part1-basics/02-methodology.md) §2.3 | 懂成本、一致性、标注者偏差 |
| A/B Test | 在线随机实验，最终裁判 | [第 2 章](../part1-basics/02-methodology.md) §2.4 | 记住样本量、SRM、p 值、多重比较、CUPED |
| LLM-as-Judge | 用模型当裁判打分 | [第 2 章](../part1-basics/02-methodology.md) §2.5、[第 4 章](../part1-basics/04-subjective-judge.md)、[第 15 章](../part3-frontier/15-judge-bias.md) | 知道何时用、偏差清单、如何校准 |
| 评测模型训练 | 训 / 校准评判器 | [第 13 章](../part2-enterprise/13-blueprint.md) §13.2 | 会报 precision/recall，懂 criteria drift |
| 推荐 | 离线准确率 + 超准确率 + 在线 | [第 7 章](../part1-basics/07-cross-domain.md) §7.2 | 能分层说明、警惕离线-在线落差 |
| CV | 检测 / 生成 / 分类指标 | [第 7 章](../part1-basics/07-cross-domain.md) §7.3 | 懂 AP≠mAP、FID 方向、ILSVRC 已停办 |
| NLP | n-gram 到学习型指标 | [第 7 章](../part1-basics/07-cross-domain.md) §7.4 | 知道 BLEU/ROUGE 局限、BLEURT 编号 |
| RL | return / sample efficiency 等 | [第 7 章](../part1-basics/07-cross-domain.md) §7.5、[附录 D](D-training.md) | 懂口径与不可复现性 |
| 大模型调优 / LoRA | SFT→RM→PPO、PEFT 谱系 | [附录 D](D-training.md) | 了解即可，不教调参 |
| reward hacking | 奖励被钻空子 | [附录 D](D-training.md) | 能解释定义与 overoptimization |
| ML 基础 / 指标 | 分类 / 回归 / 排序 | [第 7 章](../part1-basics/07-cross-domain.md) §7.1、§7.6 | 能判断指标选得对不对 |
| 模型级基准 | MMLU / 污染 / 饱和 | [第 3 章](../part1-basics/03-model-level.md) | 会读榜单、知道基准有生命周期 |
| RAG 测评 | 检索错还是生成错 | [第 5 章](../part1-basics/05-rag.md) | 会用 RAG Triad / RAGAS 定位故障 |
| Agent 测评 | 不止成功率 | [第 6 章](../part1-basics/06-agent.md) | 会看轨迹、工具、成本、pass^k |
| 数据集工程 | trace → 评测集 | [第 11 章](../part2-enterprise/11-dataset.md) | 会建 golden set / holdout |
| CI 持续评测 | 回归门禁 | [第 12 章](../part2-enterprise/12-cicd.md) | 会设计逐用例 baseline gate |
| 落地流程 | 端到端闭环 | [第 13 章](../part2-enterprise/13-blueprint.md) | 能讲清 30–50 例起步的五步循环 |
| 可复现性 | 噪声、成本、榜单失真 | [第 14 章](../part3-frontier/14-reproducibility.md) | 知道 <3pp 差异应存疑 |
| 安全合规 | 红队 / OWASP / 法规 | [第 8 章](../part1-basics/08-safety-compliance.md) | 能把风险变成测试用例 |

---

## E.3 面试高频问题清单

### A. 评测方法论（6 题）

1. 自动 / 人工 / A-B / LLM-as-Judge 怎么选？——「离线↔在线、便宜↔可信」两轴与漏斗工作流。[第 2 章](../part1-basics/02-methodology.md) §2.1、§2.6
2. A/B 的样本量怎么算？依赖哪些输入？——α、power、最小可检测效应，必须实验前算。[第 2 章](../part1-basics/02-methodology.md) §2.4
3. p 值最常见的误用是什么？——它不是「H0 为真的概率」；显著性 ≠ 效应大小。[第 2 章](../part1-basics/02-methodology.md) §2.4
4. SRM 是什么？为什么出现就该停？——样本比例失配，是数据质量发烧症状。[第 2 章](../part1-basics/02-methodology.md) §2.4
5. 同时看 20 个指标会怎样？CUPED 解决什么？——多重比较需校正；CUPED 用实验前协变量降方差。[第 2 章](../part1-basics/02-methodology.md) §2.4
6. LLM-judge 与人类一致性有多高？有哪些系统性偏差？——>80%，但位置 / 冗长 / 自我增强偏差。[第 4 章](../part1-basics/04-subjective-judge.md) §4.3、§4.5

### B. LLM 评测与基准（5 题）

7. MMLU 为什么被淘汰？替代是什么？——饱和、区分度低；MMLU-Pro。[第 3 章](../part1-basics/03-model-level.md) §3.2、§3.3
8. 数据污染怎么检测？——TS-Guessing 等；污染会让分数虚高。[第 3 章](../part1-basics/03-model-level.md) §3.3、[第 11 章](../part2-enterprise/11-dataset.md) §11.5
9. pass@k 与 pass^k 有什么区别？——「至少一个对」vs「k 次全对」，后者衡量可靠性。[第 3 章](../part1-basics/03-model-level.md) §3.2、[第 6 章](../part1-basics/06-agent.md) §6.3
10. 基准为什么会「死」？举 2026 变动例子。——饱和 / 污染 / 维护成本；BIG-bench 归档、HF 榜单终止。[第 3 章](../part1-basics/03-model-level.md) §3.3
11. 读到一份榜单该怎么判断信不信？——基础设施噪声、Leaderboard Illusion、ABC 清单。[第 14 章](../part3-frontier/14-reproducibility.md) §14.3–§14.5

### C. RAG / Agent（6 题）

12. RAG 答错了，怎么定位是检索错还是生成错？——拆开看检索与生成，用 RAG Triad 定位。[第 5 章](../part1-basics/05-rag.md) §5.2
13. RAGAS 四指标分别测什么？——Faithfulness / Answer Relevancy / Context Precision / Context Recall。[第 5 章](../part1-basics/05-rag.md) §5.3
14. Agent 评测为什么不只看成功率？——过程、工具调用、成本、延迟同样是一等指标。[第 6 章](../part1-basics/06-agent.md) §6.3
15. pass^k 为什么对 Agent 特别重要？——长程任务随机性大，单次跑分会掩盖不稳。[第 6 章](../part1-basics/06-agent.md) §6.3
16. 组件级评测和端到端评测何时用哪个？——组件级好归因、可回归；端到端反映真实交互。[第 5 章](../part1-basics/05-rag.md) §5.7、[第 6 章](../part1-basics/06-agent.md) §6.4
17. 轨迹评估 / progress rate 是什么？——把操作序列当评分对象，刻画过程增量。[第 6 章](../part1-basics/06-agent.md) §6.3

### D. 传统 ML 与领域指标（5 题）

18. 类别不平衡时 accuracy 为什么会骗人？——99:1 全预测负类也能拿 99%，但 Recall=0。[第 7 章](../part1-basics/07-cross-domain.md) §7.1
19. NDCG 与 accuracy 的区别是什么？——排序关心位置折损与分级相关性，顺序错则体验崩。[第 7 章](../part1-basics/07-cross-domain.md) §7.1
20. FID 怎么解读？——分布级、无参考、越低越好，别和逐像素指标混为一谈。[第 7 章](../part1-basics/07-cross-domain.md) §7.3
21. AP 和 mAP 是一回事吗？——COCO 语境下 mAP 是多阈值平均；只报 AP50 会虚高。[第 7 章](../part1-basics/07-cross-domain.md) §7.3
22. 推荐系统「离线涨、线上不涨」常见原因？——分布偏差、曝光/位置偏差、反馈闭环、代理指标选错。[第 7 章](../part1-basics/07-cross-domain.md) §7.2

### E. 训练与调优（3 题）

23. RLHF 的三个阶段是什么？——SFT → 奖励模型 → PPO。[附录 D](D-training.md)
24. reward hacking 是什么？——奖励被钻空子，随优化加剧（overoptimization）。[附录 D](D-training.md)
25. LoRA 是什么、为什么省资源？——低秩适配器，只训少量参数。[附录 D](D-training.md)

### F. 工程落地（4 题）

26. 怎么从 0 建评测集？——30–50 例真实 trace 起步 → 专家 pass/fail + critique。[第 13 章](../part2-enterprise/13-blueprint.md) §13.1、[第 11 章](../part2-enterprise/11-dataset.md)
27. CI 里怎么做回归门禁？——逐用例比对 baseline，抛 RegressionError，阈值留噪声余量。[第 12 章](../part2-enterprise/12-cicd.md) §12.3、§12.4
28. 离线涨分但线上不涨怎么办？——离线只是代理指标，须由在线 A/B 或监控裁决。[第 2 章](../part1-basics/02-methodology.md) §2.6、[第 12 章](../part2-enterprise/12-cicd.md) §12.5
29. 怎么让 judge 可信？——用专家标注报 precision/recall，Critique Shadowing 迭代校准。[第 13 章](../part2-enterprise/13-blueprint.md) §13.2

> 共 **29 道**，覆盖 JD 全部关键词。

---

## E.4 一句话备考建议

**别背公式，练「判断力」**：拿任何一个评测结论，问自己六件事——这个指标匹配任务吗？K 值/阈值汇报了吗？不平衡时换口径了吗？有没有选择性报告？离线验证过线上吗？随机性说清楚了吗？
（六问出自 [第 7 章](../part1-basics/07-cross-domain.md) §7.6。）

---

## 来源说明

- 本附录为**导航性内容**，知识点本身均来自本笔记正文与附录，未新增独立事实论断；章节落点链接均为仓库内相对路径。
- 涉及的外部权威来源，统一收口在 [SOURCES.md](../../../SOURCES.md) 与各章「来源」小节，主要包括：
    - 评测方法论：Hamel Husain《Your AI Product Needs Evals》、Anthropic《Demystifying evals for AI agents》、Kohavi《Trustworthy Online Controlled Experiments》。
    - A/B 与 SRM：CUPED（WSDM 2013）、Microsoft《Diagnosing Sample Ratio Mismatch》（KDD 2019）。
    - 模型级 / 污染：MMLU、MMLU-Pro、TS-Guessing、数据污染综述。
    - Judge：MT-Bench / Chatbot Arena（arXiv 2306.05685）。
    - Agent：τ³-bench、HAL、《AI Agents That Matter》。
    - 训练与调优：InstructGPT（RLHF 三阶段）、LoRA、reward overoptimization。
- JD 原文由用户提供，属需求输入，非外部引用。
- 最后更新：2026-09-15。
