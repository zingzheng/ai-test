# 权威来源总索引

> 本文件是 `ai-test` 项目的**唯一来源真相源（Single Source of Truth for References）**。
> 每条 URL 的验证状态与访问日期见 `docs/research/`。
> 图例：✅ 实测可访问且内容吻合　⚠️ 可访问但未解析　❌ 本次无法访问（不代表永久失效）
> 首次整理：2026-09-15

---

## A. 基础概念与综述

| 主题 | 来源 | 状态 |
|---|---|---|
| LLM 测评总览（what/where/how） | https://arxiv.org/abs/2307.03109 | ✅ |
| LLM-based Agents 评测综述（方法总纲） | https://arxiv.org/abs/2503.16416 | ✅ |
| LLM-as-a-Judge 综述 | https://arxiv.org/abs/2411.15594 | ✅ |
| 数据污染综述 | https://arxiv.org/abs/2502.14425 | ✅ |
| perplexity | https://en.wikipedia.org/wiki/Perplexity | ✅ |
| few-shot / zero-shot（GPT-3） | https://arxiv.org/abs/2005.14165 | ✅ |
| pass@k（Codex/HumanEval） | https://arxiv.org/abs/2107.03374 | ✅ |
| 数据污染检测（TS-Guessing） | https://arxiv.org/abs/2311.09783 | ✅ |

## B. 模型级基准（论文）

| 基准 | 来源 | 状态 |
|---|---|---|
| MMLU | https://arxiv.org/abs/2009.03300 | ✅ |
| MMLU-Pro | https://arxiv.org/abs/2406.01574 | ✅ |
| BIG-bench | https://arxiv.org/abs/2206.04615 ／ https://github.com/google/BIG-bench | ✅ |
| HellaSwag | https://arxiv.org/abs/1905.07830 | ✅ |
| GSM8K | https://arxiv.org/abs/2110.14168 | ✅ |
| HUMAN-Eval | https://arxiv.org/abs/2107.03374 | ✅ |
| MATH | https://arxiv.org/abs/2103.03874 | ✅ |

## C. 评测框架与平台

| 平台 | 来源 | 状态 |
|---|---|---|
| Stanford HELM | https://arxiv.org/abs/2211.09110 ／ https://crfm.stanford.edu/helm/ ／ https://github.com/stanford-crfm/helm | ✅/⚠️ |
| EleutherAI lm-evaluation-harness | https://github.com/EleutherAI/lm-evaluation-harness | ✅ |
| OpenCompass（司南） | https://github.com/open-compass/opencompass ／ https://rank.opencompass.org.cn/ ／ https://opencompass.org.cn/ | ✅/⚠️ |
| HF Open LLM Leaderboard | https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard | ✅（已终止） |

## D. 主观评测 / LLM-as-Judge

| 主题 | 来源 | 状态 |
|---|---|---|
| Chatbot Arena（论文） | https://arxiv.org/abs/2403.04132 | ✅ |
| Arena AI（原 LMArena 官网） | https://lmarena.ai/ | ✅ |
| MT-Bench / LLM-as-a-Judge | https://arxiv.org/abs/2306.05685 | ✅ |
| G-Eval | https://arxiv.org/abs/2303.16634 | ✅ |
| Leaderboard Illusion | https://arxiv.org/abs/2504.20879 | ✅ |

## E. 中文基准

| 基准 | 来源 | 状态 |
|---|---|---|
| C-Eval | https://arxiv.org/abs/2305.08322 ／ https://github.com/hkust-nlp/ceval | ✅ |
| CMMLU | https://arxiv.org/abs/2306.09212 ／ https://github.com/haonan-li/CMMLU | ✅ |
| SuperCLUE | https://github.com/CLUEbenchmark/SuperCLUE ／ https://www.superclueai.com/ | ✅/⚠️ |
| FlagEval | https://github.com/FlagOpen/FlagEval ／ https://flageval.baai.ac.cn/ | ✅/⚠️ |

## F. RAG 测评

| 工具/概念 | 来源 | 状态 |
|---|---|---|
| RAGAS（论文） | https://arxiv.org/abs/2309.15217 | ✅ |
| RAGAS（指标文档） | https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/ | ✅ |
| RAGAS · Faithfulness | https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/faithfulness/ | ✅ |
| RAGAS · Answer Relevancy | https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/answer_relevance/ | ✅ |
| RAGAS · Context Precision | https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_precision/ | ✅ |
| RAGAS · Context Recall | https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/context_recall/ | ✅ |
| TruLens RAG Triad | https://www.trulens.org/getting_started/core_concepts/rag_triad/ | ✅ |
| TruLens（仓库） | https://github.com/truera/trulens | ✅ |
| ARES（论文） | https://arxiv.org/abs/2311.09476 | ✅ |
| ARES（仓库） | https://github.com/stanford-futuredata/ARES | ✅ |
| DeepEval | https://github.com/confident-ai/deepeval ／ https://docs.confident-ai.com/docs/metrics-introduction | ✅ |
| BEIR | https://arxiv.org/abs/2104.08663 ／ https://github.com/UKPLab/beir | ✅ |

## G. Agent 测评基准

| 基准 | 来源 | 状态 |
|---|---|---|
| AgentBench | https://arxiv.org/abs/2308.03688 ／ https://github.com/THUDM/AgentBench | ✅ |
| SWE-bench | https://arxiv.org/abs/2310.06770 ／ https://swebench.com/ ／ https://github.com/SWE-bench/SWE-bench | ✅ |
| SWE-bench Verified | https://www.swebench.com/verified.html ／ https://openai.com/index/introducing-swe-bench-verified/ | ✅ |
| WebArena | https://arxiv.org/abs/2307.13854 ／ https://webarena.dev/ | ✅ |
| GAIA | https://arxiv.org/abs/2311.12983 ／ https://huggingface.co/spaces/gaia-benchmark/leaderboard | ✅ |
| τ-bench（论文） | https://arxiv.org/abs/2406.12045 | ✅ |
| τ²-bench（论文） | https://arxiv.org/abs/2506.07982 | ✅ |
| τ³-bench（现役仓库） | https://github.com/sierra-research/tau2-bench ／ https://taubench.com | ✅ |
| OSWorld | https://arxiv.org/abs/2404.07972 ／ https://os-world.github.io/ | ✅ |
| AgentBoard | https://arxiv.org/abs/2401.13178 ／ https://github.com/hkust-nlp/AgentBoard | ✅ |
| HAL | https://arxiv.org/abs/2510.11977 ／ https://hal.cs.princeton.edu/ | ✅ |
| MLE-bench | https://arxiv.org/abs/2410.07095 ／ https://github.com/openai/mle-bench | ✅ |

## H. 安全 / 红队 / 伦理

| 主题 | 来源 | 状态 |
|---|---|---|
| JailbreakBench | https://jailbreakbench.github.io/ ／ https://arxiv.org/abs/2404.01318 | ✅ |
| HarmBench | https://arxiv.org/abs/2402.04249 ／ https://github.com/centerforaisafety/HarmBench | ✅ |
| AdvBench | https://github.com/llm-attacks/llm-attacks | ✅ |
| GCG（对抗攻击原论文） | https://arxiv.org/abs/2307.15043 | ✅（源自 research/03） |
| Anthropic Red-teaming | https://arxiv.org/abs/2209.07858 | ✅ |
| NVIDIA Garak | https://github.com/NVIDIA/garak ／ https://arxiv.org/abs/2406.11036 | ✅ |
| Microsoft PyRIT | https://github.com/microsoft/PyRIT | ✅ |
| OWASP LLM Top 10 2026 | https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/ ／ https://github.com/GenAI-Security-Project/GenAI-LLM-Top10 | ✅ |
| ToxiGen | https://arxiv.org/abs/2203.09509 | ✅ |
| RealToxicityPrompts | https://arxiv.org/abs/2009.11462 | ✅ |

## I. 标准 / 治理 / 合规

| 主题 | 来源 | 状态 |
|---|---|---|
| NIST AI RMF | https://www.nist.gov/itl/ai-risk-management-framework | ✅ |
| NIST AI RMF 1.0 PDF | https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf | ✅ |
| TC260 治理框架 3.0（新闻页） | https://www.tc260.org.cn/tc260/xwdt1/202609/d513a007d04347f58e483fabaefb34b8.shtml | ✅ |
| NIST GenAI Profile（AI 600-1） | https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf | ⚠️ |
| ISO/IEC 42001 | https://www.iso.org/standard/42001 | ❌（403） |
| ISO/IEC 23894 | https://www.iso.org/standard/77304.html | ❌（403） |
| EU AI Act（欧委会） | https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai | ✅ |
| EU AI Act 时间线 | https://artificialintelligenceact.eu/implementation-timeline/ | ✅ |
| MLCommons / AILuminate | https://mlcommons.org/benchmarks/ ／ https://mlcommons.org/ailuminate/ | ✅ |
| TC260 / GB/T 45654-2025 | https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A | ✅ |
| TC260 官网（治理框架 3.0 等） | https://www.tc260.org.cn/ | ✅ |
| 生成式 AI 服务管理暂行办法 | https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm | ✅ |
| AI 生成合成内容标识办法 | https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm | ✅ |
| 信通院 CAICT | https://www.caict.ac.cn/ | ❌（412） |
| 电子标准院 CESI | https://www.cesi.cn/ | ❌（JS 挑战） |

## J. 企业工具链 / 可观测性

| 工具 | 来源 | 状态 |
|---|---|---|
| LangSmith | https://docs.langchain.com/langsmith/evaluation | ✅ |
| Langfuse | https://langfuse.com/docs/evaluation/overview | ✅ |
| Arize Phoenix | https://arize.com/docs/phoenix | ✅ |
| W&B Weave | https://weave-docs.wandb.ai/ | ✅ |
| Braintrust | https://www.braintrust.dev/docs | ✅ |
| PromptLayer | https://docs.promptlayer.com/introduction | ✅ |
| Humanloop（退场） | https://humanloop.com/ | ✅ |
| OTel GenAI semconv | https://github.com/open-telemetry/semantic-conventions-genai | ✅ |
| OpenInference | https://github.com/Arize-ai/openinference | ✅ |
| promptfoo | https://www.promptfoo.dev/docs/intro/ | ✅ |
| Langfuse CI/CD | https://langfuse.com/docs/evaluation/experiments/experiments-ci-cd | ✅ |

## K. 大厂方法论

| 厂商 | 来源 | 状态 |
|---|---|---|
| OpenAI Evals 指南 | https://platform.openai.com/docs/guides/evals | ✅（2026-11-30 关停） |
| OpenAI Evals Cookbook | https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals | ✅ |
| OpenAI Evals 仓库 | https://github.com/openai/evals | ✅ |
| Anthropic《Demystifying evals for AI agents》 | https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents | ✅ |
| Anthropic 基础设施噪声 | https://www.anthropic.com/engineering/infrastructure-noise | ✅ |
| Google（Gemini Enterprise Agent Platform） | https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/evaluation-overview | ✅ |
| Microsoft Azure AI Foundry Evaluation SDK | https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/develop/evaluate-sdk | ✅ |

## L. 行业实践博客

| 作者/文章 | 来源 | 状态 |
|---|---|---|
| Hamel Husain《Your AI Product Needs Evals》 | https://hamel.dev/blog/posts/evals/ | ✅ |
| Hamel Husain《LLM-as-a-Judge 完整指南》 | https://hamel.dev/blog/posts/llm-judge/ | ✅ |
| Eugene Yan《Evaluating LLM-Evaluators》 | https://eugeneyan.com/writing/llm-evaluators/ | ✅ |
| Eugene Yan《Task-Specific LLM Evals》 | https://eugeneyan.com/writing/evals/ | ✅ |

## M. 前沿（2025–2026）

| 主题 | 来源 | 状态 |
|---|---|---|
| AI Agents That Matter（成本/可复现性） | https://arxiv.org/abs/2407.01502 | ✅ |
| Agent-as-Judge | https://arxiv.org/abs/2410.10934 | ✅ |
| Agentic Benchmark Checklist（ABC） | https://arxiv.org/abs/2507.02825 | ✅ |
| 去偏即测量干预（judge 分辨率） | https://arxiv.org/abs/2609.12439 | ✅（已被 EMNLP 2026 接收） |

## N. 传统 ML 指标

| 主题 | 来源 | 状态 |
|---|---|---|
| 指标总览与选择原则 | https://scikit-learn.org/stable/modules/model_evaluation.html | ✅ |
| 混淆矩阵 | https://scikit-learn.org/stable/modules/generated/sklearn.metrics.confusion_matrix.html | ✅ |
| ROC-AUC | https://scikit-learn.org/stable/modules/generated/sklearn.metrics.roc_auc_score.html | ✅ |
| PR-AUC / Average Precision | https://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html | ✅ |
| Precision/Recall（Google 教程） | https://developers.google.com/machine-learning/crash-course/classification/precision-and-recall | ✅ |
| ROC 与 AUC（Google 教程） | https://developers.google.com/machine-learning/crash-course/classification/roc-and-auc | ✅ |
| 类别不平衡（Google 教程） | https://developers.google.com/machine-learning/crash-course/overfitting/imbalanced-datasets | ✅ |
| MSE | https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_squared_error.html | ✅ |
| R² | https://scikit-learn.org/stable/modules/generated/sklearn.metrics.r2_score.html | ✅ |
| MAPE | https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_absolute_percentage_error.html | ✅ |
| NDCG | https://scikit-learn.org/stable/modules/generated/sklearn.metrics.ndcg_score.html | ✅ |
| DCG/NDCG 概念 | https://en.wikipedia.org/wiki/Discounted_cumulative_gain | ✅ |
| IR 评测总览（在线/离线） | https://en.wikipedia.org/wiki/Evaluation_measures_(information_retrieval) | ✅ |
| MRR | https://en.wikipedia.org/wiki/Mean_reciprocal_rank | ✅ |
| Learning to Rank | https://en.wikipedia.org/wiki/Learning_to_rank | ✅ |
| 教材：ranked retrieval 评测 | https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html | ✅ |
| Precision and Recall（概念页） | https://en.wikipedia.org/wiki/Precision_and_recall | ✅ |
| 阈值与混淆矩阵（Google 教程） | https://developers.google.com/machine-learning/crash-course/classification/thresholding | ✅ |

## O. A/B Test（在线实验）

| 主题 | 来源 | 状态 |
|---|---|---|
| A/B 专著官方站（Kohavi et al. 2020） | https://experimentguide.com/ | ✅ |
| CUPED 原始论文（WSDM 2013） | https://www.exp-platform.com/Documents/2013-02-CUPED-ImprovingSensitivityOfControlledExperiments.pdf | ✅ |
| 受控实验实践综述 | https://www.exp-platform.com/Documents/GuideControlledExperiments.pdf | ✅ |
| SRM 诊断（Microsoft, KDD 2019） | https://www.microsoft.com/en-us/research/publication/diagnosing-sample-ratio-mismatch-in-online-controlled-experiments-a-taxonomy-and-rules-of-thumb-for-practitioners/ | ✅ |
| Delta method（比率型指标方差） | https://arxiv.org/abs/1803.06336 | ✅ |
| A/B 测试总览 | https://en.wikipedia.org/wiki/A/B_testing | ✅ |
| 假设检验 | https://en.wikipedia.org/wiki/Statistical_hypothesis_test | ✅ |
| p 值 | https://en.wikipedia.org/wiki/P-value | ✅ |
| 统计功效 | https://en.wikipedia.org/wiki/Statistical_power | ✅ |
| 样本量估算 | https://en.wikipedia.org/wiki/Sample_size_determination | ✅ |
| 置信区间 | https://en.wikipedia.org/wiki/Confidence_interval | ✅ |
| 多重比较 | https://en.wikipedia.org/wiki/Multiple_comparisons_problem | ✅ |
| 新奇效应 | https://en.wikipedia.org/wiki/Novelty_effect | ✅ |
| 网络效应 | https://en.wikipedia.org/wiki/Network_effect | ✅ |
| 随机对照试验 | https://en.wikipedia.org/wiki/Randomized_controlled_trial | ✅ |

## P. 推荐 / CV / NLP 指标

| 主题 | 来源 | 状态 |
|---|---|---|
| 深度学习推荐系统综述 | https://arxiv.org/abs/1707.07435 | ✅ |
| TF Recommenders | https://github.com/tensorflow/recommenders | ✅ |
| 超准确率目标（2025–2026） | https://arxiv.org/abs/2511.10492 | ✅ |
| Wide & Deep（在线指标案例） | https://arxiv.org/abs/1606.07792 | ✅ |
| COCO 检测评测协议 | https://cocodataset.org/#detection-eval | ✅ |
| COCO API | https://github.com/cocodataset/cocoapi | ✅ |
| FID（arXiv 1706.08500） | https://arxiv.org/abs/1706.08500 | ✅ |
| IS（arXiv 1606.03498） | https://arxiv.org/abs/1606.03498 | ✅ |
| CLIP（arXiv 2103.00020） | https://arxiv.org/abs/2103.00020 | ✅ |
| CLIPScore（arXiv 2104.08718） | https://arxiv.org/abs/2104.08718 | ✅ |
| SSIM（scikit-image） | https://scikit-image.org/docs/stable/auto_examples/transform/plot_ssim.html | ✅ |
| ImageNet | https://www.image-net.org/ | ✅ |
| ILSVRC 官方挑战页 | https://www.image-net.org/challenges/LSVRC/ | ✅ |
| ILSVRC 论文 | https://arxiv.org/abs/1409.0575 | ✅ |
| BLEU（Papineni 2002） | https://aclanthology.org/P02-1040/ | ✅ |
| ROUGE（Lin 2004） | https://aclanthology.org/W04-1013/ | ✅ |
| METEOR | https://aclanthology.org/W05-0909/ | ✅ |
| chrF | https://aclanthology.org/W15-3049/ | ✅ |
| BERTScore | https://arxiv.org/abs/1904.09675 | ✅ |
| BLEURT | https://arxiv.org/abs/2004.04696 | ✅ |
| GLUE 论文 | https://arxiv.org/abs/1804.07461 | ✅ |
| SuperGLUE 论文 | https://arxiv.org/abs/1905.00537 | ✅ |
| SQuAD | https://rajpurkar.github.io/SQuAD-explorer/ | ✅ |
| SQuAD 2.0 论文 | https://arxiv.org/abs/1806.03822 | ✅ |

## Q. RL / RLHF / 大模型调优

| 主题 | 来源 | 状态 |
|---|---|---|
| Sutton & Barto（RL 教科书） | http://incompleteideas.net/book/the-book-2nd.html | ✅ |
| OpenAI Spinning Up（RL 术语） | https://spinningup.openai.com/en/latest/spinningup/rl_intro.html | ✅ |
| Gymnasium | https://gymnasium.farama.org/ | ✅ |
| PPO | https://arxiv.org/abs/1707.06347 | ✅ |
| Deep RL that Matters | https://arxiv.org/abs/1709.06560 | ✅ |
| policy gradient（NIPS 1999） | https://papers.nips.cc/paper/1999/hash/464d828b85b0bed98e80ade0a5c43b0f-Abstract.html | ✅ |
| DQN | https://arxiv.org/abs/1312.5602 | ✅ |
| InstructGPT（RLHF 三阶段） | https://arxiv.org/abs/2203.02155 | ✅ |
| HF RLHF 博客 | https://huggingface.co/blog/rlhf | ✅ |
| Anthropic HH-RLHF | https://arxiv.org/abs/2204.05862 | ✅ |
| HH-RLHF 数据集 | https://huggingface.co/datasets/Anthropic/hh-rlhf | ✅ |
| 摘要 RLHF（Stiennon 2020） | https://arxiv.org/abs/2009.01325 | ✅ |
| DPO | https://arxiv.org/abs/2305.18290 | ✅ |
| Constitutional AI | https://arxiv.org/abs/2212.08073 | ✅ |
| Anthropic CAI 官方介绍 | https://www.anthropic.com/research/constitutional-ai-harmlessness-from-ai-feedback | ✅ |
| Q-learning（概念页） | https://en.wikipedia.org/wiki/Q-learning | ✅ |
| reward model 训练（HF TRL） | https://huggingface.co/docs/trl/main/en/reward_trainer | ✅ |
| reward hacking 定义 | https://arxiv.org/abs/2209.13085 | ✅ |
| reward overoptimization 缩放律 | https://arxiv.org/abs/2210.10760 | ✅ |
| SFT Trainer（HF TRL） | https://huggingface.co/docs/trl/main/en/sft_trainer | ✅ |
| PEFT 总览 | https://huggingface.co/docs/peft/index | ✅ |
| PEFT 方法分类 | https://huggingface.co/docs/peft/main/en/methods/overview | ✅ |
| PEFT 快速上手 | https://huggingface.co/docs/peft/quicktour | ✅ |
| LoRA | https://arxiv.org/abs/2106.09685 | ✅ |
| QLoRA | https://arxiv.org/abs/2305.14314 | ✅ |
| Adapter | https://arxiv.org/abs/1902.00751 | ✅ |
| Prefix Tuning | https://arxiv.org/abs/2101.00190 | ✅ |
| Prompt Tuning | https://arxiv.org/abs/2104.08691 | ✅ |

> ⚠️ 未验证项：Q-learning 原始 Springer 页（DOI 10.1007/BF00992698，反爬）；BLEURT 常被误引为 arXiv 2005.01535（实为 2004.04696）。
