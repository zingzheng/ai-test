# 第 8 章 安全与合规速览

> **一句话结论**：安全合规不是"上线前补的文档"，而是一张由红队工具、应用风险清单、国际法规与本土标准共同织成的地图；测试开发不必成为法务，但要能一眼看出"哪个风险该用哪把尺子量"。

---

本章是**轻量速览**：不深入攻击算法或法条细节，只求建立一张"安全合规地图"。读到需要动手时，再去查对应来源。

## 8.1 红队与越狱：一页表

红队（red teaming）就是"自己先打自己"，用攻击视角找模型的安全漏洞。下面五个名字是本领域最常被引用的入口，定位各不相同。

| 名称 | 一句话定位 | 来源 |
|---|---|---|
| **JailbreakBench** | 统一的越狱鲁棒性基准：100 条危害行为的 JBB-Behaviors + 攻击 artifact + 排行榜，另补 100 条良性行为衡量**过度拒答** | [官网](https://jailbreakbench.github.io/)／[论文](https://arxiv.org/abs/2404.01318) |
| **HarmBench** | 自动化红队的标准化评测框架，系统对比 18 种红队方法与 33 个目标模型/防御 | [论文](https://arxiv.org/abs/2402.04249)／[代码](https://github.com/centerforaisafety/HarmBench) |
| **AdvBench** | 危害行为数据集，源自 GCG 对抗攻击论文，是后续众多基准的**数据源头** | [仓库](https://github.com/llm-attacks/llm-attacks)／[GCG 论文](https://arxiv.org/abs/2307.15043) |
| **Garak** | NVIDIA 开源的 LLM 漏洞扫描器，号称"LLM 界的 nmap"，`pip install` 即用 | [仓库](https://github.com/NVIDIA/garak)／[论文](https://arxiv.org/abs/2406.11036) |
| **PyRIT** | 微软的生成式 AI 风险识别/红队编排框架 | [现行主仓库](https://github.com/microsoft/PyRIT) |

> ⚠️ **版本提醒**：PyRIT 已从 `Azure/PyRIT` **迁移到** [`microsoft/PyRIT`](https://github.com/microsoft/PyRIT)，旧仓库（[Azure/PyRIT](https://github.com/Azure/PyRIT)）已于 2026-03-27 归档只读。写教程、抄链接时务必用前者。

## 8.2 应用安全风险清单：OWASP LLM Top 10（2026 版）

OWASP 的 LLM 应用风险清单是应用侧最通用的"体检表"。**2026 版已于 2026-08-03 发布**（以官方发布页日期为准），风险排序与范围都有更新：

1. Prompt Injection（提示注入）
2. Sensitive Information Disclosure（敏感信息泄露）
3. Excessive Agency（过度自主权）
4. Supply Chain（供应链）
5. Data and Model Poisoning（数据与模型投毒）
6. Unbounded Consumption（无节制消耗）
7. Misinformation（错误信息）
8. Hidden Context Exposure（隐藏上下文暴露）
9. Vector and Embedding Weaknesses（向量与嵌入弱点）
10. Improper Output Handling（输出处理不当）

> ⚠️ **不要混用版本**：清单里的条目与 [2023 v1.1 旧版](https://owasp.org/www-project-top-10-for-large-language-model-applications/) **不同**，引用时必须标注版本号。2026 版还把风险映射到了 NIST / MITRE ATLAS / CWE 等框架。
> 来源：[2026 发布页](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/)／[规范源仓库](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10)

## 8.3 国际标准与法规一句话版

- **NIST AI RMF**：美国自愿性 AI 风险管理框架，四大功能 **Govern / Map / Measure / Manage**。截至 2026-09 的 1.0 版正在修订。配套的[生成式 AI Profile（NIST.AI.600-1）](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf)给出生成式 AI 的独有风险画像。来源：[NIST AI RMF 主页](https://www.nist.gov/itl/ai-risk-management-framework)／[AI RMF 1.0 PDF](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf)。
- **EU AI Act**：全球首部综合性 AI 法规（Regulation (EU) 2024/1689），按风险分级（不可接受/高风险/透明度/最小风险）。**时间线已被 AI Omnibus 简化修法改写**——高风险系统的 Annex III 敏感领域推迟到 **2027-12-02**，Annex I 产品嵌入式推迟到 **2028-08-02**；新增禁止的第 9 类（未经同意的色情/CSAM）自 **2026-12-02** 适用。来源：[欧委会官方页](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)／[实施时间线](https://artificialintelligenceact.eu/implementation-timeline/)。
- **ISO/IEC 42001**（AI 管理体系）等 ISO 标准：本次因 iso.org 反爬**未能验证**，若要引用请以浏览器核实为准。

## 8.4 中国本土合规

- **GB/T 45654-2025**：《生成式人工智能服务安全基本要求》，我国首个面向生成式 AI 服务的安全国家推荐标准，是《暂行办法》的核心配套技术基线。**发布 2025-04-25，实施 2025-11-01，现行**。来源：[国标官方页](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A)。
- **TC260 治理框架 3.0**：《人工智能安全治理框架 3.0》于 **2026-09-14** 国家网络安全宣传周发布；同期发布《人工智能应用安全指引 总则》等 4 项实践指南。来源：[TC260 新闻页](https://www.tc260.org.cn/tc260/xwdt1/202609/d513a007d04347f58e483fabaefb34b8.shtml)／[TC260 官网](https://www.tc260.org.cn/)。
- **备案与内容标识**：面向公众提供生成式 AI 服务须遵守《生成式人工智能服务管理暂行办法》（2023-08-15 施行）；具有舆论属性/社会动员能力的服务须做**安全评估 + 算法备案**。AI 生成合成内容还须遵守《人工智能生成合成内容标识办法》（**2025-09-01 施行**）。来源：[暂行办法](https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm)／[内容标识办法](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm)。

## 8.5 测试开发为什么该关心

因为安全的每一环最终都要靠**测试**落地：越狱基准是测模型的，OWASP 清单是测应用的，法规与标准则定义了"通过"的底线。把红队用例纳入 CI、把风险清单变成测试用例、把合规要求变成上线检查项——这正是测试开发在安全治理里不可替代的位置。

---

## 本章要点

- 红队五件套：JailbreakBench（基准）、HarmBench（框架）、AdvBench（数据源）、Garak（扫描器）、PyRIT（编排，注意已迁到 `microsoft/PyRIT`）。
- OWASP LLM Top 10 **2026 版**与 2023 v1.1 不同，引用必须标版本。
- 国际：NIST AI RMF（自愿框架）+ EU AI Act（风险分级，时间线被 AI Omnibus 推迟）。
- 本土：GB/T 45654-2025 是技术基线，TC260 治理框架 3.0（2026-09-14）是最新动态，备案与内容标识是硬约束。
- 安全合规的落脚点是测试用例，这是测试开发的价值所在。

## 来源

- [JailbreakBench 官网](https://jailbreakbench.github.io/)／[论文](https://arxiv.org/abs/2404.01318) — 访问 2026-09-15 — ✅
- [HarmBench 论文](https://arxiv.org/abs/2402.04249)／[代码](https://github.com/centerforaisafety/HarmBench) — 访问 2026-09-15 — ✅
- [AdvBench 仓库](https://github.com/llm-attacks/llm-attacks)／[GCG 论文](https://arxiv.org/abs/2307.15043) — 访问 2026-09-15 — ✅
- [NVIDIA Garak](https://github.com/NVIDIA/garak)／[论文](https://arxiv.org/abs/2406.11036) — 访问 2026-09-15 — ✅
- [Microsoft PyRIT](https://github.com/microsoft/PyRIT)（迁移后）／[Azure/PyRIT（已归档）](https://github.com/Azure/PyRIT) — 访问 2026-09-15 — ✅
- [OWASP LLM Top 10 2026 发布页](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/)／[规范源](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10)／[2023 v1.1 旧入口](https://owasp.org/www-project-top-10-for-large-language-model-applications/) — 访问 2026-09-15 — ✅
- [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework)／[AI RMF 1.0](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf)／[GenAI Profile](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf) — 访问 2026-09-15 — ✅/⚠️
- [EU AI Act（欧委会）](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)／[实施时间线](https://artificialintelligenceact.eu/implementation-timeline/) — 访问 2026-09-15 — ✅
- [GB/T 45654-2025 国标页](https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A) — 访问 2026-09-15 — ✅
- [TC260 治理框架 3.0 新闻](https://www.tc260.org.cn/tc260/xwdt1/202609/d513a007d04347f58e483fabaefb34b8.shtml)／[TC260 官网](https://www.tc260.org.cn/) — 访问 2026-09-15 — ✅
- [生成式人工智能服务管理暂行办法](https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm)／[人工智能生成合成内容标识办法](https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm) — 访问 2026-09-15 — ✅
- ISO/IEC 42001、ISO/IEC 23894 — iso.org 本次反爬 403，**本次未能验证**
