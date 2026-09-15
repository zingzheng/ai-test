# 调研报告 07 · 强化学习（RL）评测 + 大模型训练/调优概念

> 调研日期：2026-09-15　方法：webfetch 逐条实测
> 目标读者：测试开发工程师 · 成熟度 =「了解术语、能正确使用」，不推导公式、不教调参

---

## 一、RL 基础与评测

### 1.1 核心概念

| 概念 | 权威来源 | 说明 |
|---|---|---|
| 全套术语与形式化定义 | ✅ http://incompleteideas.net/book/the-book-2nd.html（Sutton & Barto, 2nd ed. MIT Press） | 领域标准教科书，官方免费 PDF；第 3 章 MDP、第 2 章 bandit/regret |
| 快速入门（agent/environment/policy/reward/return/discount/价值函数） | ✅ https://spinningup.openai.com/en/latest/spinningup/rl_intro.html | OpenAI Spinning Up，面向工程实践者，避免数学推导 |
| environment 标准接口（reset/step） | ✅ https://gymnasium.farama.org/ | Farama 维护的 Gym 官方继任者；`observation, reward, terminated, truncated, info` |

### 1.2 RL 评测指标

| 指标 | 权威来源 | 说明 |
|---|---|---|
| return / discounted return / 期望回报 | Spinning Up（同上）+ Sutton & Barto | 区分 finite-horizon undiscounted return 与 infinite-horizon discounted return |
| regret / 探索-利用 | Sutton & Barto 第 2 章 | regret 主要在 bandit 语境 |
| sample efficiency / sample complexity | ✅ https://arxiv.org/abs/1707.06347（PPO） | 摘要以 sample complexity 作算法对比维度 |
| RL 评测的可复现性与报告规范 | ✅ https://arxiv.org/abs/1709.06560（Deep RL that Matters, AAAI 2018） | 专门讨论结果不可复现、需显著性指标与标准化报告——**对测开视角做 RL 评测高度相关** |

### 1.3 经典算法了解

| 算法 | 权威来源 | 说明 |
|---|---|---|
| Q-learning（原始 1992） | ⚠️ https://doi.org/10.1007/BF00992698（Springer 反爬，未验证）；替代 ✅ https://en.wikipedia.org/wiki/Q-learning | value-based；learning rate / discount factor / Bellman update |
| policy gradient（NIPS 1999） | ✅ https://papers.nips.cc/paper/1999/hash/464d828b85b0bed98e80ade0a5c43b0f-Abstract.html | REINFORCE → actor-critic 一脉 |
| PPO | ✅ https://arxiv.org/abs/1707.06347 | RLHF 实际使用的算法 |
| DQN | ✅ https://arxiv.org/abs/1312.5602 | Mnih et al., NIPS 2013 Workshop |

---

## 二、人类反馈对齐（RLHF 及其后继）

### 2.1 RLHF 三阶段（SFT → reward model → PPO）

| 主题 | 权威来源 | 说明 |
|---|---|---|
| InstructGPT 原论文 | ✅ https://arxiv.org/abs/2203.02155 | SFT → RM → PPO；1.3B 输出胜过 175B GPT-3 |
| RLHF 通俗系统讲解 | ✅ https://huggingface.co/blog/rlhf | 三阶段、KL penalty、RM 训练 |
| Anthropic HH-RLHF 论文 | ✅ https://arxiv.org/abs/2204.05862 | 含 RLHF 鲁棒性、reward 与 √KL 的线性关系 |
| HH-RLHF 数据集 | ✅ https://huggingface.co/datasets/Anthropic/hh-rlhf | chosen/rejected 偏好对样例 |
| 早期关键工作（reward model 泛化评测） | ✅ https://arxiv.org/abs/2009.01325 | human preference 训练的 RM 可泛化；按人评优于 ROUGE |

### 2.2 DPO / Constitutional AI

| 主题 | 权威来源 | 说明 |
|---|---|---|
| DPO | ✅ https://arxiv.org/abs/2305.18290 | 用分类损失直接解最优策略，免去显式 RM + RL 采样 |
| Constitutional AI / RLAIF | ✅ https://arxiv.org/abs/2212.08073 ／ ✅ https://www.anthropic.com/research/constitutional-ai-harmlessness-from-ai-feedback | "谁在评"从人类转向 AI |

### 2.3 reward model 训练/评测；reward hacking

| 主题 | 权威来源 | 说明 |
|---|---|---|
| RM 训练与评测指标（工程实现） | ✅ https://huggingface.co/docs/trl/main/en/reward_trainer | Bradley-Terry 偏好损失；记录 accuracy（chosen>rejected 比例）、margin、mean_reward |
| reward hacking 形式化定义 | ✅ https://arxiv.org/abs/2209.13085 | proxy reward 与 true reward 的"不可 hack"条件 |
| reward overoptimization 缩放律 | ✅ https://arxiv.org/abs/2210.10760 | 过度优化 proxy reward 反损真实表现 |

### 2.4 RLHF 与模型评测的关系

- **谁在评**：人类标注者（InstructGPT preference ranking）、AI 反馈（RLAIF）、自动判官（GPT-4-as-judge）。
- **评什么**：偏好排序 → 训练 RM → 用 reward 作评测/优化信号，同时用人类/自动评估检验真实质量。
- 来源：InstructGPT §3–4、HF RLHF 博客、Constitutional AI 论文。

---

## 三、大模型调优概念

### 3.1 预训练 / SFT / PEFT

| 主题 | 权威来源 | 说明 |
|---|---|---|
| 预训练 → SFT 概念与工程 | ✅ https://huggingface.co/docs/trl/main/en/sft_trainer | SFT = 在 (prompt, completion) 上最小化 token 级交叉熵 |
| PEFT 总览 | ✅ https://huggingface.co/docs/peft/index | 只微调少量参数，性能接近全量微调 |
| PEFT 方法分类与选型 | ✅ https://huggingface.co/docs/peft/main/en/methods/overview | Prompt-based / Adapter / Layer tuning 的选型建议 |
| PEFT 上手 | ✅ https://huggingface.co/docs/peft/quicktour | LoRA 配置、保存、推理；adapter 仅 ~0.04% 可训练参数 |

### 3.2 代表 PEFT 方法原始论文

| 方法 | 权威来源 | 说明 |
|---|---|---|
| LoRA | ✅ https://arxiv.org/abs/2106.09685 | 冻结原权重 + 低秩矩阵；可训练参数降 1 万倍、无额外推理延迟 |
| QLoRA | ✅ https://arxiv.org/abs/2305.14314 | 4-bit NF4 + 双量化 + paged optimizer；也讨论 GPT-4 作廉价评测判官 |
| Adapter | ✅ https://arxiv.org/abs/1902.00751 | 仅加 3.6% 参数即接近全量微调 |
| Prefix Tuning | ✅ https://arxiv.org/abs/2101.00190 | 冻结 LM，优化连续 prefix 向量，0.1% 参数 |
| Prompt Tuning | ✅ https://arxiv.org/abs/2104.08691 | soft prompt；随规模增大逐渐追平全量微调 |

### 3.3 调优之后如何评测

| 主题 | 权威来源 | 说明 |
|---|---|---|
| 评测框架（支持 PEFT adapter） | ✅ https://github.com/EleutherAI/lm-evaluation-harness | `peft=<adapter>` 直接评测 LoRA；HF Open LLM Leaderboard 的后端；2025/12–2026/09 仍活跃 |
| 多任务知识基准 | ✅ https://arxiv.org/abs/2009.03300（MMLU） | "调优后能力是否退化"的常用回归基准 |
| 整体评测方法论 | ✅ https://arxiv.org/abs/2211.09110（HELM） | accuracy/calibration/robustness/fairness/bias/toxicity/efficiency 7 维 |
| SFT 后的评测指标 | ✅ https://huggingface.co/docs/trl/main/en/sft_trainer | loss、entropy、mean_token_accuracy |

---

## 四、建议附录小节划分

```
D. 模型训练与调优速览
  D.1 RL 术语速查：agent/environment/policy/reward/episode/return/discount
  D.2 RL 评测指标：return / sample efficiency / success rate / regret；方差陷阱
  D.3 经典算法一页纸：Q-learning / policy gradient / DQN / PPO
  D.4 RLHF 三阶段：SFT → RM → PPO（谁评、评什么、KL penalty）
  D.5 后继路线：DPO、Constitutional AI / RLAIF
  D.6 reward model 的评测：accuracy/margin/reward；reward hacking / overoptimization
  D.7 调优谱系：预训练 → SFT → PEFT（Prompt-based / Adapter / LoRA / QLoRA）
  D.8 调优后评测：MMLU / HELM 指标；lm-evaluation-harness + PEFT adapter
  D.9 术语中英对照与常见误用（return≠reward、fine-tuning≠pretraining）
```

## 五、未验证 / 存疑项

- ⚠️ Q-learning 原始 Springer 链接（DOI 10.1007/BF00992698）反爬未验证 → 用 Sutton & Barto + Wikipedia 替代
- ⚠️ PEFT `package_reference/overview` 路径已变更（v0.21.0 不存在）→ 用 `methods/overview` + `quicktour`
- ⚠️ TRL `ppo_trainer` 非 main 路径未验证；`main` 版 ✅ 可访问（含 objective/rlhf_reward、policy/approxkl_avg 等指标）
- ⚠️ 文档版本随年份漂移（2026 实测：PEFT v0.21.0、TRL v1.13.0）；长期维护建议固定版本号 URL
