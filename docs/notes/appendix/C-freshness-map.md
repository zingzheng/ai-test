# 附录 C · 时效地图

> 本表集中记录"已停更 / 已换代 / 已更名 / 已关停 / 已生效"的事实，避免引用过时信息；**最后核对日期 2026-09-15**。
>
> 说明：日期栏中的「截至 2026-09」表示原始素材未给出精确日期，仅确认该变动在核对日已经发生。全部 URL 均取自 [SOURCES.md](../../../SOURCES.md) 与 `docs/research/`，未新增任何未记录来源。

| 类型 | 主体 | 变动 | 日期 | 来源 |
|---|---|---|---|---|
| 榜单终止 | HF Open LLM Leaderboard | 开源模型榜单**已终止**，Space 讨论区置顶公告「end of the Open LLM Leaderboard」 | 截至 2026-09 | [Space](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard) |
| 维护模式 | Stanford HELM | 进入**维护模式**、不再扩展；旗舰榜单为 HELM Capabilities / Safety / VHELM | 2026-06-01 | [官网](https://crfm.stanford.edu/helm/) ／ [论文](https://arxiv.org/abs/2211.09110) |
| 仓库归档 | BIG-bench | 仓库**归档只读、不再演进**（450 作者 / 204 任务的历史基准） | 2026-04-17 | [GitHub](https://github.com/google/BIG-bench) ／ [论文](https://arxiv.org/abs/2206.04615) |
| 仓库归档 | HAL（Holistic Agent Leaderboard）harness | **归档、停止接收提交、榜单暂停更新**，团队转向 agent reliability | 2026-07-01 | [GitHub](https://github.com/princeton-pli/hal-harness) ／ [官网](https://hal.cs.princeton.edu/) |
| 品牌更名 | LMSYS Chatbot Arena / LMArena → **Arena AI** | 品牌更名；官网标题为「Arena AI: The Official AI Ranking & LLM Leaderboard」 | 截至 2026-09 | [官网](https://lmarena.ai/) ／ [论文](https://arxiv.org/abs/2403.04132) |
| 基准换代 | tau-bench → **τ²/τ³-bench** | 原 `sierra-research/tau-bench` 仓库**已废弃**；现役为 τ²（Dual-Control）→ **τ³**（当前版；2026-07 v1.0.1 修复 banking_knowledge 评分，旧结果不可比） | 截至 2026-09 | [现役仓库](https://github.com/sierra-research/tau2-bench) ／ [实时榜](https://taubench.com) ／ [τ² 论文](https://arxiv.org/abs/2506.07982) |
| 基准换代 | MMLU → **MMLU-Pro** | MMLU 被认为**饱和 / 区分度低**，由 MMLU-Pro 取代（选项 4→10、加入推理题） | 截至 2026-09 | [MMLU-Pro](https://arxiv.org/abs/2406.01574) ／ [MMLU](https://arxiv.org/abs/2009.03300) |
| 组织迁移 | SWE-bench | 仓库由 `princeton-nlp/SWE-bench` 迁至 **`SWE-bench` 组织** | 截至 2026-09 | [GitHub](https://github.com/SWE-bench/SWE-bench) ／ [官网](https://swebench.com/) |
| 组织迁移 | Microsoft PyRIT | 主仓库由 `Azure/PyRIT` 迁至 **`microsoft/PyRIT`**；旧仓库归档只读（教程勿再用 `Azure/` 路径） | 2026-03-27（旧仓库归档） | [新仓库](https://github.com/microsoft/PyRIT) ／ [旧仓库](https://github.com/Azure/PyRIT) |
| 组织迁移 | OTel GenAI Semantic Conventions | 自 2025 起从主 semconv **拆分为独立仓库** | 2025 起 | [独立仓库](https://github.com/open-telemetry/semantic-conventions-genai) |
| 版本更新 | OWASP Top 10 for LLM Applications | **2026 版**发布，风险排序与范围更新（与 2023 v1.1 不同，须标注版本号） | 2026-08-04 | [2026 发布页](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) ／ [规范源](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10) |
| 版本更新 | TC260《人工智能安全治理框架》 | 升级至 **3.0**，于国家网络安全宣传周发布 | 2026-09-14 | [新闻页](https://www.tc260.org.cn/tc260/xwdt1/202609/d513a007d04347f58e483fabaefb34b8.shtml) ／ [官网](https://www.tc260.org.cn/) |
| 平台关停 | OpenAI Evals 平台 | 正在弃用：**2026-10-31 转只读、2026-11-30 关停**，官方建议改用 Datasets | 2026-10-31 / 2026-11-30 | [平台指南](https://platform.openai.com/docs/guides/evals) ／ [Cookbook](https://cookbook.openai.com/examples/evaluation/getting_started_with_openai_evals) |
| 平台退场 | Humanloop | 团队加入 Anthropic，平台**正在 sunset**（首页公告） | 截至 2026-09 | [首页](https://humanloop.com/) |
| 平台迁移 | Google Vertex AI 评测文档 | 品牌迁移为 **Gemini Enterprise Agent Platform**，原 Vertex AI 域名 301 重定向 | 截至 2026-09 | [新文档](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/evaluation-overview) |
| 标准落地 | GB/T 45654-2025 | 生成式 AI 服务安全国家推荐标准，**2025-11-01 实施**（发布 2025-04-25），现行 | 2025-11-01 | [国标官方页](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A) |
| 法规生效 | EU AI Act | **2026-08-02 全面适用**；高风险系统义务与治理 / 执法同步落地 | 2026-08-02 | [欧委会](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) ／ [时间线](https://artificialintelligenceact.eu/implementation-timeline/) |
| 法规生效 | EU AI Act · AI Omnibus | 简化修法**2026-07-27 生效**，高风险时间线后延：Annex III → **2027-12-02**、Annex I → **2028-08-02** | 2026-07-27 | [时间线](https://artificialintelligenceact.eu/implementation-timeline/) ／ [欧委会](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) |
| 法规生效 | EU AI Act · 新增禁止类别 | 新增第 9 类禁止（未经同意的色情 / CSAM），**2026-12-02 适用** | 2026-12-02 | [时间线](https://artificialintelligenceact.eu/implementation-timeline/) |
| 赛事停办 | ImageNet ILSVRC | **2017 年后停办**（Top-1 / Top-5 协议仍惯用，评测转向 ImageNet-ReaL / V2 与鲁棒性） | 2017 后 | [官方挑战页](https://www.image-net.org/challenges/LSVRC/) ／ [ILSVRC 论文](https://arxiv.org/abs/1409.0575) |
| 测试集公开 | C-Eval | **2025-07-27 公开完整测试集**（此前为私有以防污染） | 2025-07-27 | [GitHub](https://github.com/hkust-nlp/ceval) |

## 维护说明

- 每次更新笔记（新增或修改任意章节）时，**先核对本表**，确认所引用的基准、平台、仓库、标准、法规未发生更名、换代、停更或迁移。
- 发现新变动时，在本表**新增条目并在「日期」栏标注发现日期**；已解除的变动（如恢复维护、重新上线）应更新或删除对应行，不得留存错误信息。
- 正文口径须与本表一致：统一称「Arena AI」而非「LMArena」；使用 `microsoft/PyRIT` 而非 `Azure/PyRIT`；标注 OWASP 版本号；τ-bench 首次出现须注明「原 τ-bench 已废弃」，主名用 **τ³-bench**。
- 来源仅限 [SOURCES.md](../../../SOURCES.md) 与 `docs/research/` 中已记录并验证过的 URL，**禁止编造**；新增来源须先按 README §5.3 的四要素格式补入来源总表，再在本表引用。
