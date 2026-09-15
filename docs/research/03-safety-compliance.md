# 调研报告 03 · 安全测评、红队与合规治理

> 调研日期：2026-09-15　方法：全部条目 webfetch 实际访问
> 图例：✅ 已成功读取；⚠️ 可达但内容未解析（PDF/JS 应用）；❌ 本次未能访问（不保证 URL 失效）
> 法规状态截至 **2026-09**。

---

## 一、安全与红队

### 1. JailbreakBench ✅
- 统一的 jailbreak **鲁棒性基准**：100 条危害行为数据集 **JBB-Behaviors**（源自 AdvBench/TDC/HarmBench）、攻击 artifact 仓库、标准化评测框架与排行榜；另补 100 条 benign 行为衡量**过度拒答**。
- 来源：官网 ✅ https://jailbreakbench.github.io/ ／ 论文 ✅ https://arxiv.org/abs/2404.01318（NeurIPS 2024 D&B）

### 2. HarmBench ✅
- 自动化红队的**标准化评测框架**，系统对比 18 种红队方法与 33 个目标模型/防御，提出高效对抗训练法（R2D2 系）。
- 来源：论文 ✅ https://arxiv.org/abs/2402.04249 ／ 代码 ✅ https://github.com/centerforaisafety/HarmBench ／ 官网 ⚠️ https://www.harmbench.org/（JS 单页）
- 分类器：`cais/HarmBench-Llama-2-13b-cls`

### 3. AdvBench ✅
- 危害行为/危害字符串数据集，源自 *Universal and Transferable Adversarial Attacks（GCG）*，是大量后续基准（JBB、HarmBench）数据来源。
- 来源：✅ https://github.com/llm-attacks/llm-attacks（`data/advbench/harmful_behaviors.csv`）／ GCG 论文 https://arxiv.org/abs/2307.15043

### 4. Anthropic Red-teaming 论文 ✅
- 早期系统化红队研究，覆盖 2.7B/13B/52B 四类模型；开放 **38,961 条红队攻击**数据集，强调方法透明与统计不确定性。
- 来源：✅ https://arxiv.org/abs/2209.07858

### 5. NVIDIA Garak ✅
- 开源 **LLM 漏洞扫描器**（Generative AI Red-teaming & Assessment Kit），号称 LLM 界的 nmap/Metasploit；含 probes（promptinject、dan、encoding、gcg、leakreplay、realtoxicityprompts、xss 等）+ detectors + generators + harness。
- 来源：仓库 ✅ https://github.com/NVIDIA/garak ／ 论文 ✅ https://arxiv.org/abs/2406.11036 ／ 文档 https://docs.garak.ai/ 、https://garak.readthedocs.io/
- 备注：`pip install -U garak` 即可，适合动手 Lab。

### 6. Microsoft PyRIT（⚠️ 已迁移）
- 面向生成式 AI 的 **Python 风险识别/红队框架**。
- 来源：**现行主仓库** ✅ https://github.com/microsoft/PyRIT ／ 旧仓库 ✅ https://github.com/Azure/PyRIT（**2026-03-27 归档只读**）／ 官网 https://microsoft.github.io/PyRIT/
- 备注：**写教程用 `microsoft/PyRIT`，`Azure/PyRIT` 已过时。**

### 7. OWASP Top 10 for LLM Applications（⚠️ 已换版）
- **2026 版已发布（2026-08-03，以官方发布页日期为准）**，风险排序与范围更新，并映射 NIST / MITRE ATLAS / CWE / OWASP Agentic Top10。
- 2026 现行清单：1 Prompt Injection；2 Sensitive Information Disclosure；3 Excessive Agency；4 Supply Chain；5 Data and Model Poisoning；6 Unbounded Consumption；7 Misinformation；8 Hidden Context Exposure；9 Vector and Embedding Weaknesses；10 Improper Output Handling
- 来源：2026 发布页 ✅ https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/ ／ 规范源 ✅ https://github.com/GenAI-Security-Project/GenAI-LLM-Top10 ／ 旧入口（2023 v1.1 存档）✅ https://owasp.org/www-project-top-10-for-large-language-model-applications/
- 备注：旧版 v1.1 与 2026 版**不同**，务必标版本号。

---

## 二、国际标准 / 治理框架

### 8. NIST AI RMF ✅
- 自愿性 AI 风险管理框架，四大功能 **Govern / Map / Measure / Manage**。
- 来源：主页 ✅ https://www.nist.gov/itl/ai-risk-management-framework ／ AI RMF 1.0 PDF https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf ／ Playbook ✅ https://www.nist.gov/itl/ai-risk-management-framework/nist-ai-rmf-playbook
- **2026-09 状态**：AI RMF 1.0（2023-01-26）**正在修订**；2026-04-07 发布「关键基础设施可信 AI Profile」概念说明。

### 9. NIST Generative AI Profile（NIST.AI.600-1）
- 生成式 AI 的**独有风险画像 + 建议行动**，AI RMF 的横向 Profile。
- 来源：PDF ⚠️ https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf（2024-07-26 发布）／ DOI https://doi.org/10.6028/NIST.AI.600-1

### 10. ISO/IEC 42001 ❌（未验证）
- **AI 管理体系（AIMS）** 国际标准，可认证（类似 ISO 27001）。
- 期望来源（本次 **403 反爬**，未能验证）：https://www.iso.org/standard/42001 ／ https://www.iso.org/obp/ui/en/#iso:std:iso-iec:42001:ed-1:v1:en
- 备注：**勿据本报告断言其内容/版本**，需浏览器核实。

### 11. ISO/IEC 23894 ❌（未验证）
- AI **风险管理指南**（与 ISO 31000 对齐），偏指南性、非认证标准。
- 期望来源（**403**）：https://www.iso.org/standard/77304.html

### 12. EU AI Act ✅
- 全球首部综合性 AI 法规（Regulation (EU) 2024/1689），**风险分级**（不可接受/高风险/透明度/最小风险），对 GPAI 设透明度+版权+系统性风险义务。
- 来源：欧盟委员会官方页 ✅ https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai ／ 官方时间线（第三方 FLI 整理）✅ https://artificialintelligenceact.eu/implementation-timeline/ ／ 法规原文 EUR-Lex https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32024R1689（本次直取返回空，建议浏览器打开）
- **截至 2026-09 状态（关键）**：
  - 2024-08-01 生效；**2026-08-02 全面适用**。
  - 禁止性做法 + AI 素养：2025-02-02 起；**GPAI 义务 + 治理：2025-08-02 起**。
  - 透明度规则：2026-08 起。
  - **AI Omnibus（简化修法）2026-07-27 生效**：高风险系统时间线推迟——Annex III 敏感领域改为 **2027-12-02**；Annex I 产品嵌入式改为 **2028-08-02**。
  - 新增禁止第 9 类（未经同意的色情 / CSAM）：**2026-12-02** 适用。
  - 治理与执法：2026-08-02 起 AI Office + 成员国主管机关执法。

### 13. MLCommons Benchmarks / AILuminate ✅
- 性能侧 **MLPerf**（Training/Inference/Storage）；安全侧 **AILuminate**（12 类危害的通用聊天 GenAI 安全基准；含 Safety、Jailbreak、Agentic、Multimodal 工作流；英文/法文/**中文** T2T）。
- 来源：基准总览 ✅ https://mlcommons.org/benchmarks/ ／ AILuminate ✅ https://mlcommons.org/ailuminate/

---

## 三、中国本土测评生态与合规

### 14. TC260《生成式人工智能服务安全基本要求》✅（已升为国标 GB/T 45654-2025）
- 我国首个面向生成式 AI 服务的**安全国家推荐标准**，是《生成式人工智能服务管理暂行办法》的核心配套技术基线。
- 来源：国标官方页 ✅ https://openstd.samr.gov.cn/bzgk/std/newGbInfo?hcno=F67D3F376E0A0A0FF5317FB36B32A30A
- **状态**：**GB/T 45654-2025 发布日 2025-04-25，实施日 2025-11-01，现行**（官网口径）。二手文章"2025-06-30 发布"与官网不一致，以官网为准。

### 15. TC260 其他最新文件（2026-09 新动态）
- 《人工智能安全治理框架 3.0》：**2026-09-14** 国家网络安全宣传周发布。新闻页 ✅ https://www.tc260.org.cn/tc260/xwdt1/202609/d513a007d04347f58e483fabaefb34b8.shtml
- 《人工智能应用安全指引 总则》等 4 项实践指南：**2026-09-15** 发布。主页 ✅ https://www.tc260.org.cn/

### 16. 大模型备案与安全评估要求（CAC）✅
- 面向公众提供生成式 AI 服务须遵守；具有舆论属性/社会动员能力的服务须**安全评估 + 算法备案**。
- 来源：《生成式人工智能服务管理暂行办法》（2023-08-15 施行）✅ https://www.cac.gov.cn/2023-07/13/c_1690898327029107.htm ／《人工智能生成合成内容标识办法》（**2025-09-01 施行**）✅ https://www.cac.gov.cn/2025-03/14/c_1743654684782215.htm

### 17. 中国信通院（CAICT）/ 中国电子技术标准化研究院（CESI）❌（未验证）
- CAICT「方升」大模型评测体系、CESI 标准研制与测评认证。
- 期望来源（**本次被反爬拦截**）：https://www.caict.ac.cn/（HTTP 412）／ https://www.cesi.cn/（JS 挑战）
- 备注：**勿据本报告引用具体评测结论**。

---

## 四、评测的伦理与偏差

### 18. ToxiGen ✅
- 大规模机器生成的**隐性/对抗性仇恨言论**数据集（约 27.4 万条，覆盖 13 个少数群体）。
- 来源：✅ https://arxiv.org/abs/2203.09509 ／ 代码 https://github.com/microsoft/TOXIGEN

### 19. RealToxicityPrompts ✅
- 10 万条自然句级 prompt + 毒性分数，衡量**无害 prompt 也会诱发酵性退化**（neural toxic degeneration）。
- 来源：✅ https://arxiv.org/abs/2009.11462

---

## 五、章节大纲建议（安全与合规）

```
第 0 章 导论：为什么 accuracy/perplexity 不够
第 1 章 红队与越狱的攻击面
  - Jailbreak vs Prompt Injection vs 数据投毒
  - GCG（AdvBench）、Persona Modulation、AutoDAN/PAIR/TAP
  - 动手：garak 扫一个模型；PyRIT 编排一次红队
第 2 章 评测基准与方法学
  - HarmBench / JailbreakBench / AdvBench
  - LLM-as-judge、classifier-as-judge 的可靠性与偏差
  - 可复现性危机；MLCommons AILuminate（含中文 T2T）
第 3 章 毒性、偏见与伦理
  - ToxiGen / RealToxicityPrompts；过度拒答 vs 漏放
第 4 章 应用安全视角
  - OWASP LLM Top 10 2026（与 2023 v1.1 对照）
  - Agentic 新风险；"安全问题 → 缓解措施"映射表
第 5 章 国际治理与标准
  - NIST AI RMF + GenAI Profile；ISO/IEC 42001 / 23894；EU AI Act 新时间线
第 6 章 中国本土合规与测评
  -《暂行办法》→ GB/T 45654-2025；备案/安全评估/内容标识；TC260 治理框架 3.0
第 7 章 动手 Lab 合集
第 8 章 争议与前沿
```

---

## 六、未验证 / 存疑项

- ISO/IEC 42001、ISO/IEC 23894（iso.org 全站 403）
- CAICT、CESI 官网（412 / JS 挑战）
- EU AI Act 的 EUR-Lex 法规原文页（返回空，建议浏览器打开）
- NIST GenAI Profile PDF（可下载但正文未解析）
