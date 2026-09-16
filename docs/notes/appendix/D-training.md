# 附录 D · 模型训练与调优速览

> **一句话结论**：训练与调优侧的知识对测评岗是"够用即可"——不必会推导公式或调参，只要**听得懂 agent / policy / reward、认得出 RLHF 是"谁在评、评什么"、知道 SFT 与 PEFT 各改了什么、调优后该用哪些基准做回归**，就能读懂模型团队交上来的训练日志，并判断评测该如何衔接。

---

> 本附录覆盖大模型训练 / 调优的基本概念。成熟度 =「了解即可、能正确使用术语」：不推导公式、不教调参。RL 指标在 [第 7 章](../part1-basics/07-cross-domain.md) §7.5 已有铺垫，这里补齐术语与流程全貌。

## D.1 RL 术语速查

| 术语 | 一句话含义 | 关键提醒 |
|---|---|---|
| agent（智能体） | 做决策、采取动作的一方 | 在 RLHF 里，被训练的 LLM 就是 agent |
| environment（环境） | agent 之外、对其动作给出反馈的部分 | 标准接口是 `reset()` / `step()`；`step()` 返回五元组 observation、reward、terminated、truncated、info |
| policy（策略，π） | 从状态到动作的映射（或动作分布） | RLHF 优化的就是这个策略 |
| reward（奖励） | 每一步环境的即时标量反馈 | 它是**信号**，不是目标本身 |
| episode（回合） | 从开始到终止的一次完整交互 | 回合制任务才有明确边界 |
| return（回报） | 一个回合内奖励的累计 | **return ≠ reward**，见 D.9 |
| discount factor（折扣因子，γ） | 给未来奖励打的折扣，γ∈[0,1] | 决定"多看重远期"；区分有限视界无折扣与无限视界折扣两种口径 |

> 来源：[Sutton & Barto, Reinforcement Learning 2nd ed.](http://incompleteideas.net/book/the-book-2nd.html)、[OpenAI Spinning Up: RL Intro](https://spinningup.openai.com/en/latest/spinningup/rl_intro.html)、[Gymnasium](https://gymnasium.farama.org/) — ✅

## D.2 RL 评测指标与报告陷阱

RL 的"好"没有固定标签，工程上常用四个口径：

| 指标 | 衡量什么 | 适用场景 |
|---|---|---|
| Return | 策略的累计回报 | 通用性能口径，须注明是否折扣 |
| Sample efficiency / sample complexity | 达到同一性能需要多少交互样本 | 算法横向对比（如 PPO 论文用它做卖点） |
| Success rate | 任务成败比例 | 任务型 / 具身场景最直观 |
| Regret | 相对最优策略的累积遗憾 | 主要在 bandit 语境 |

**报告陷阱**：RL 结果方差极大、对随机种子高度敏感，单次跑分几乎不可复现。《Deep RL that Matters》因此主张报告多种子、给出显著性，并标准化评测流程——只报最好一次的结果是典型的选择性报告。

> 来源：[PPO](https://arxiv.org/abs/1707.06347)、[Deep RL that Matters](https://arxiv.org/abs/1709.06560) — ✅

## D.3 经典算法一页纸

| 算法 | 一句话 | 原论文 |
|---|---|---|
| Q-learning | value-based 的经典方法，用 Bellman 更新逼近动作价值 | 原始 Springer 页反爬、无法稳定验证，此处以 [Wikipedia 词条](https://en.wikipedia.org/wiki/Q-learning) 代替 |
| policy gradient | 直接对策略参数求梯度，REINFORCE → actor-critic 一脉 | [NIPS 1999](https://papers.nips.cc/paper/1999/hash/464d828b85b0bed98e80ade0a5c43b0f-Abstract.html) |
| DQN | 用深度网络表示 Q 函数，开启深度 RL | [Mnih et al. 2013](https://arxiv.org/abs/1312.5602) |
| PPO | 近端策略优化，简单稳定、RLHF 实际使用的算法 | [Schulman et al. 2017](https://arxiv.org/abs/1707.06347) |

> 成熟度提醒：会认名字、知道所属派系（value-based / policy-based）即可，不必会实现。

## D.4 RLHF 三阶段：SFT → reward model → PPO

InstructGPT 把对齐拆成三步：

1. **SFT（监督微调）**：用人工写好的示范，在 (prompt, completion) 上做 token 级交叉熵。**谁在评**：无，直接模仿人。
2. **Reward model（奖励模型）**：让人对同一 prompt 的多个输出做偏好排序，训练一个打分器。**谁在评**：人类标注者；**评什么**：哪条回复更好。
3. **PPO**：以 RM 的分数为 reward 优化策略。**谁在评**：RM（它代理人类偏好）。

其中 **KL penalty** 很关键：它约束新策略不要偏离 SFT 参考策略太远，既防止利用 RM 漏洞刷分（reward hacking），也保住语言能力。InstructGPT 的结论是 1.3B 模型的输出可胜过 175B GPT-3。

> 来源：[InstructGPT](https://arxiv.org/abs/2203.02155)、[HF RLHF 博客](https://huggingface.co/blog/rlhf) — ✅
> 补充：[Anthropic HH-RLHF](https://arxiv.org/abs/2204.05862) 讨论了 RLHF 鲁棒性与 reward 和 √KL 的线性关系；偏好对样例见 [HH-RLHF 数据集](https://huggingface.co/datasets/Anthropic/hh-rlhf)；早期关键工作见 [Stiennon et al. 2020](https://arxiv.org/abs/2009.01325)。

## D.5 后继路线：DPO 与 Constitutional AI / RLAIF

- **DPO（Direct Preference Optimization）**：用分类损失直接解出最优策略，免去显式 RM 与 RL 采样，训练更简单。见 [2305.18290](https://arxiv.org/abs/2305.18290)。
- **Constitutional AI / RLAIF**：把"谁在评"从人类换成 AI——先让模型按一套原则自我批评与修订，再用 AI 反馈作为 reward。见 [2212.08073](https://arxiv.org/abs/2212.08073) 与 [Anthropic 官方介绍](https://www.anthropic.com/research/constitutional-ai-harmlessness-from-ai-feedback)。

对测评的意义：评的主体从"人类偏好"扩展到"AI 判官"，因此又回到 LLM-as-Judge 的偏差与校准问题（见第 2、4、15 章）。

## D.6 reward model 的评测

HF TRL 的 Reward Trainer 在实践中记录三类指标：

| 指标 | 含义 |
|---|---|
| accuracy | chosen 得分高于 rejected 的比例（偏好对正确率） |
| margin | chosen 与 rejected 的分差 |
| mean_reward | reward 的均值水平 |

两个绕不开的失败模式：

- **Reward hacking**：proxy reward（代理奖励）被刷高，却偏离 true reward（真实目标）。
- **Reward overoptimization**：过度优化 proxy reward，超过某点后真实表现反而下降，呈缩放律。

> 来源：[HF TRL Reward Trainer](https://huggingface.co/docs/trl/main/en/reward_trainer)、[reward hacking](https://arxiv.org/abs/2209.13085)、[reward overoptimization](https://arxiv.org/abs/2210.10760) — ✅

## D.7 调优谱系：预训练 → SFT → PEFT

- **预训练（pretraining）**：从头在大规模语料上学，得到底座模型。
- **SFT（supervised fine-tuning）**：在 (prompt, completion) 上最小化 token 级交叉熵，教模型听指令。
- **PEFT（parameter-efficient fine-tuning）**：只训练极少量参数，性能接近全量微调，显存与部署成本更低。

| 方法 | 一句话 | 原论文 / 文档 |
|---|---|---|
| Prompt-based（含 Prompt Tuning） | 只优化 soft prompt 向量，冻结 LM | [Prompt Tuning](https://arxiv.org/abs/2104.08691) |
| Prefix Tuning | 给每层优化连续 prefix 向量，约 0.1% 参数 | [Prefix Tuning](https://arxiv.org/abs/2101.00190) |
| Adapter | 在层间插入小模块，约 3.6% 参数接近全量微调 | [Adapter](https://arxiv.org/abs/1902.00751) |
| LoRA | 冻结原权重、只学低秩矩阵，可训练参数降约 1 万倍且无额外推理延迟 | [LoRA](https://arxiv.org/abs/2106.09685) |
| QLoRA | 4-bit NF4 + 双量化 + paged optimizer，进一步压低显存 | [QLoRA](https://arxiv.org/abs/2305.14314) |

> 来源：[PEFT 总览](https://huggingface.co/docs/peft/index)、[PEFT 方法分类](https://huggingface.co/docs/peft/main/en/methods/overview)、[PEFT 快速上手](https://huggingface.co/docs/peft/quicktour)（其中 LoRA 示例配置的可训练参数占比低至约 0.04%） — ✅
>
> 注意：上表 Adapter 的 3.6% 出自 Houlsby 等人 2019 年的原始论文口径；PEFT 文档里的 0.04% 是**某个 LoRA 配置**的示例值，两者不是同一方法，不要混用。

## D.8 调优之后怎么评

调优最怕**能力退化**，所以要用稳定的回归基准对比前后：

- **MMLU**：多任务知识基准，是"调优后能力是否退化"的常用回归口径。
- **HELM**：整体评测方法论，覆盖 accuracy / calibration / robustness / fairness / bias / toxicity / efficiency 七个维度——提醒评测不止看准确率。
- **工程抓手**：EleutherAI 的 `lm-evaluation-harness` 支持 `peft=<adapter>` 直接评测 LoRA，无需先合并权重；它也是 HF Open LLM Leaderboard 的后端。SFT 阶段另可看 loss / entropy / mean_token_accuracy。

> 来源：[lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness)、[MMLU](https://arxiv.org/abs/2009.03300)、[HELM](https://arxiv.org/abs/2211.09110)、[HF TRL SFT Trainer](https://huggingface.co/docs/trl/main/en/sft_trainer) — ✅

## D.9 术语中英对照与常见误用

| 中文 | 英文 | 常见误用 |
|---|---|---|
| 预训练 | pretraining | 误当微调的同义词；预训练没有任务标签 |
| 微调 | fine-tuning | 误称一切训练；SFT/PEFT 都是微调的子类 |
| 奖励 | reward | 误当 return；reward 是单步信号 |
| 回报 | return | 误当 reward；return 是累计值 |
| 策略 | policy | 误当模型权重；策略是"状态→动作"的映射 |
| 回合 | episode | 误用于非回合制任务 |
| 采样效率 | sample efficiency | 只看最终分数，忽略耗了多少交互 |
| 奖励建模 | reward modeling | 误以为能直接解决对齐；它只是代理指标 |

> 一句话记忆：**return 是累计、reward 是单步；fine-tuning 是在预训练权重上继续学，不是从头学；SFT 是模仿、RLHF 是偏好优化、PEFT 是省参数。**

---

## 来源

- [Sutton & Barto, Reinforcement Learning 2nd ed.](http://incompleteideas.net/book/the-book-2nd.html) — 访问 2026-09-15 — ✅ — RL 术语与 MDP 教科书
- [OpenAI Spinning Up: RL Intro](https://spinningup.openai.com/en/latest/spinningup/rl_intro.html) — 访问 2026-09-15 — ✅ — agent/policy/return/discount
- [Gymnasium](https://gymnasium.farama.org/) — 访问 2026-09-15 — ✅ — environment 标准接口
- [PPO](https://arxiv.org/abs/1707.06347) — 访问 2026-09-15 — ✅ — 算法与 sample complexity
- [Deep RL that Matters](https://arxiv.org/abs/1709.06560) — 访问 2026-09-15 — ✅ — 方差与报告规范
- [Wikipedia: Q-learning](https://en.wikipedia.org/wiki/Q-learning) — 访问 2026-09-15 — ✅ — Q-learning（原 Springer DOI 反爬，未验证）
- [policy gradient（NIPS 1999）](https://papers.nips.cc/paper/1999/hash/464d828b85b0bed98e80ade0a5c43b0f-Abstract.html) — 访问 2026-09-15 — ✅ — REINFORCE 一脉
- [DQN](https://arxiv.org/abs/1312.5602) — 访问 2026-09-15 — ✅ — 深度 RL 起点
- [InstructGPT](https://arxiv.org/abs/2203.02155) — 访问 2026-09-15 — ✅ — RLHF 三阶段
- [HF RLHF 博客](https://huggingface.co/blog/rlhf) — 访问 2026-09-15 — ✅ — 三阶段与 KL penalty
- [Anthropic HH-RLHF](https://arxiv.org/abs/2204.05862) — 访问 2026-09-15 — ✅ — RLHF 鲁棒性
- [HH-RLHF 数据集](https://huggingface.co/datasets/Anthropic/hh-rlhf) — 访问 2026-09-15 — ✅ — 偏好对样例
- [Stiennon et al. 2020](https://arxiv.org/abs/2009.01325) — 访问 2026-09-15 — ✅ — RM 泛化与偏好评测
- [DPO](https://arxiv.org/abs/2305.18290) — 访问 2026-09-15 — ✅ — 免 RL 的偏好优化
- [Constitutional AI](https://arxiv.org/abs/2212.08073) — 访问 2026-09-15 — ✅ — RLAIF
- [Anthropic: Constitutional AI](https://www.anthropic.com/research/constitutional-ai-harmlessness-from-ai-feedback) — 访问 2026-09-15 — ✅ — 官方介绍
- [HF TRL Reward Trainer](https://huggingface.co/docs/trl/main/en/reward_trainer) — 访问 2026-09-15 — ✅ — accuracy/margin/mean_reward
- [reward hacking](https://arxiv.org/abs/2209.13085) — 访问 2026-09-15 — ✅ — proxy/true reward
- [reward overoptimization](https://arxiv.org/abs/2210.10760) — 访问 2026-09-15 — ✅ — 缩放律
- [PEFT 总览](https://huggingface.co/docs/peft/index) — 访问 2026-09-15 — ✅ — 少量参数微调
- [PEFT 方法分类](https://huggingface.co/docs/peft/main/en/methods/overview) — 访问 2026-09-15 — ✅ — 选型
- [PEFT 快速上手](https://huggingface.co/docs/peft/quicktour) — 访问 2026-09-15 — ✅ — LoRA 配置
- [LoRA](https://arxiv.org/abs/2106.09685) — 访问 2026-09-15 — ✅ — 低秩适配
- [QLoRA](https://arxiv.org/abs/2305.14314) — 访问 2026-09-15 — ✅ — 4-bit 量化微调
- [Adapter](https://arxiv.org/abs/1902.00751) — 访问 2026-09-15 — ✅ — 层间小模块
- [Prefix Tuning](https://arxiv.org/abs/2101.00190) — 访问 2026-09-15 — ✅ — 连续 prefix
- [Prompt Tuning](https://arxiv.org/abs/2104.08691) — 访问 2026-09-15 — ✅ — soft prompt
- [lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness) — 访问 2026-09-15 — ✅ — `peft=<adapter>` 评 LoRA
- [MMLU](https://arxiv.org/abs/2009.03300) — 访问 2026-09-15 — ✅ — 多任务知识回归
- [HELM](https://arxiv.org/abs/2211.09110) — 访问 2026-09-15 — ✅ — 七维评测方法论
- [HF TRL SFT Trainer](https://huggingface.co/docs/trl/main/en/sft_trainer) — 访问 2026-09-15 — ✅ — SFT 与 loss/entropy 指标
