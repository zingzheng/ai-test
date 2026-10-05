# AI Test · 内部完整版目录

> 内部版 = 公开版 + 「项目需求说明书」+ 「附录 E 测评岗位能力地图」。
> 构建：`./serve.sh build-internal` → 输出 `_book-internal/`（**不对外发布**）。

* [项目需求说明书（内部）](docs/REQUIREMENTS.md)

## 第一部分 · 基础知识

* [1. 导论：为什么测评是 AI 工程的第一性问题](docs/notes/part1-basics/01-intro.md)
* [2. 评测方法论全景：自动 / 人工 / A-B / LLM-as-Judge](docs/notes/part1-basics/02-methodology.md)
* [3. 模型级测评：经典基准与"基准生命周期"](docs/notes/part1-basics/03-model-level.md)
* [4. 主观评测与 LLM-as-Judge](docs/notes/part1-basics/04-subjective-judge.md)
* [5. 应用级测评（上）：RAG 怎么测](docs/notes/part1-basics/05-rag.md)
* [6. 应用级测评（下）：Agent 怎么测](docs/notes/part1-basics/06-agent.md)
* [7. 跨领域评测指标：传统 ML / 推荐 / CV / NLP / RL](docs/notes/part1-basics/07-cross-domain.md)
* [8. 安全与合规速览](docs/notes/part1-basics/08-safety-compliance.md)

## 第二部分 · 企业落地

* [9. 工具链与可观测性](docs/notes/part2-enterprise/09-tooling.md)
* [10. 大厂方法论拆解](docs/notes/part2-enterprise/10-vendor-methods.md)
* [11. 数据集工程：从生产 trace 到评测集](docs/notes/part2-enterprise/11-dataset.md)
* [12. 持续评测：把 eval 接进 CI/CD](docs/notes/part2-enterprise/12-cicd.md)
* [13. 端到端落地蓝图](docs/notes/part2-enterprise/13-blueprint.md)

## 第三部分 · 行业前沿

* [14. 可复现性危机](docs/notes/part3-frontier/14-reproducibility.md)
* [15. Judge 的偏差、分辨率与自动化](docs/notes/part3-frontier/15-judge-bias.md)
* [16. 2026 变动地图与开放问题](docs/notes/part3-frontier/16-frontier-map.md)

## 附录

* [A. 术语表](docs/notes/appendix/A-glossary.md)
* [B. 权威来源总清单](SOURCES.md)
* [C. 时效地图](docs/notes/appendix/C-freshness-map.md)
* [D. 模型训练与调优速览](docs/notes/appendix/D-training.md)
* [E. 测评岗位能力地图（内部）](docs/notes/appendix/E-career-map.md)
* [F. 测评面筋：AI Agent 面试真题与答案](docs/notes/appendix/F-agent-interview.md)
