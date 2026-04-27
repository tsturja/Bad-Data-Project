# 🚫 The Bad Data Project — Regional Cost of Living Analysis

> A graduate-level data analytics project that follows the full **CRISP-DM** pipeline in **R** — and ends with the most important deliverable a data analyst can produce: the recommendation **not to deploy**.

![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r&logoColor=white)
![Methodology](https://img.shields.io/badge/Methodology-CRISP--DM-2E7D32)
![Course](https://img.shields.io/badge/Course-ANLC%20754-7B1FA2)
![Status](https://img.shields.io/badge/Verdict-Do%20Not%20Deploy-D32F2F)
![Grade](https://img.shields.io/badge/Grade-A-success)

---

## 🧭 Why This Project Is Called "The Bad Data Project"

Most portfolio projects show off a model that works. **This one is different.**

I built the entire analytical pipeline — cleaning, feature engineering, visualization, correlation, regression — by the book. The models came out statistically significant. The R² values were respectable. The charts told a story. By every "looks good" metric, I had a successful project.

**And then I refused to deploy it.**

The dataset itself was untrustworthy: duplicate country-year records, wildly inconsistent income figures (Australia's average monthly income swung from \$1,121 to \$7,481 between 2001 and 2002 with no explanation), and uneven coverage across regions. No amount of clever modeling fixes that — and pretending otherwise would have been the wrong call.

**This project is in my portfolio because of that decision, not despite it.** Recognizing when data isn't fit for purpose, and saying so clearly, is one of the most valuable things a data analyst can do. It earned the project an **A** in graduate coursework and, more importantly, taught me a lesson no clean dataset could.

---

## 🎓 Academic Context

| | |
|---|---|
| **Course** | ANLC 754 — Fundamental Modeling Methods |
| **Program** | M.S. in Business Analytics |
| **Institution** | Mercy University, School of Business |
| **Submitted** | May 5, 2025 |
| **Author** | Tanmoy Saha Turja |

---

## 🧪 Methodology — CRISP-DM

The project followed the six-phase **Cross-Industry Standard Process for Data Mining** framework end-to-end:

```
   ┌─────────────────────┐      ┌─────────────────────┐
   │ 1. Business         │ ───▶ │ 2. Data             │
   │    Understanding    │      │    Understanding    │
   └─────────────────────┘      └──────────┬──────────┘
                                           │
   ┌─────────────────────┐      ┌──────────▼──────────┐
   │ 4. Modeling         │ ◀─── │ 3. Data             │
   │                     │      │    Preparation      │
   └──────────┬──────────┘      └─────────────────────┘
              │
   ┌──────────▼──────────┐      ┌─────────────────────┐
   │ 5. Evaluation       │ ───▶ │ 6. Deployment       │
   │                     │      │    (declined ⚠️)    │
   └─────────────────────┘      └─────────────────────┘
```

The deployment phase was deliberately halted after evaluation surfaced data integrity concerns serious enough to invalidate real-world use of the model.

---

## ❓ Business Questions

The analysis was structured around four practical, regional-level questions:

1. Which regions offer the **highest disposable income** after accounting for living costs and taxes?
2. Are some regions **disproportionately affected by housing costs**?
3. Which regions provide **better savings opportunities** based on income and expenses?
4. Are **high housing costs linked** to higher healthcare and education costs?

---

## 📊 The Dataset

- **Source:** [Regional Cost of Living Analysis — Kaggle](https://www.kaggle.com/datasets/heidarmirhajisadati/regional-cost-of-living-analysis)
- **Records:** 499 country-year observations
- **Variables:** Country, Year, Region, Average Monthly Income, Cost of Living, Tax Rate, Savings %, and percentage-of-income breakdowns for Housing, Healthcare, Education, and Transportation.

### 🚨 What Went Wrong With the Data

| Problem | What It Looked Like in the Data |
|---|---|
| **Duplicate records** | Multiple rows for the same Country–Year combination (e.g., Australia 2000 had 4 entries; Russia 2014 had 3). |
| **Implausible income volatility** | Australia's average monthly income jumped between roughly \$1,100 and \$7,500 across consecutive years — economically impossible at a country level. |
| **Uneven coverage** | Some countries had decades of observations; others had a single year. Regional comparisons would have been silently biased toward over-represented countries. |
| **No data dictionary** | No documentation explaining how the figures were collected, defined, or sourced. |

These aren't small issues. They are structural problems that **no amount of cleaning can fully repair** — they can only be partially mitigated.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **R** | Core language for the entire pipeline |
| **tidyverse / dplyr** | Data wrangling, grouping, aggregation |
| **ggplot2 / ggthemes / scales** | Visualization (regional bar charts, time series, dot plots) |
| **corrplot** | Correlation matrix visualization for cost relationships |
| **lm()** | Linear regression for housing → healthcare and housing → education models |
| **tm / wordcloud / RColorBrewer** | Word cloud for the closing presentation slide |

---

## 📁 Repository Structure

```
.
├── data/
│   └── Cost_of_Living_and_Income_Extended.csv   # Raw dataset (Kaggle)
├── scripts/
│   └── ProjectScript_Tanmoy.R                   # Full CRISP-DM pipeline in R
├── reports/
│   ├── Project_Report_Tanmoy.pdf                # Full written report
│   └── Final_Project_Presentation_Tanmoy.pptx   # Final presentation deck
└── README.md
```

> Adjust the folder paths above to match your repo if you push the files flat.

---

## 🔬 Analytical Workflow

**1. Data Preparation.** Percentage-based fields (housing, healthcare, education, transportation, tax) were converted into actual dollar amounts using `Average_Monthly_Income × Percentage / 100`. Records were grouped by `Region`, `Country`, and `Year`, and numeric fields were averaged to absorb duplicate entries.

**2. Diagnostic Visualization.** A time-series plot of Australia's average monthly income revealed the volatility problem clearly enough to justify abandoning country-level analysis in favor of **regional aggregation** — a deliberate trade-off that smoothed the noise but masked within-region variation.

**3. Modeling.** Three derived metrics drove the analysis:
- `Disposable_Income = Average_Monthly_Income − (Cost_of_Living + Tax_Amount)`
- `Housing_Burden % = Housing_Cost_Amount / Average_Monthly_Income × 100`
- `Savings_Opportunity % = Disposable_Income / Average_Monthly_Income × 100`

**4. Cost-Linkage Analysis.** A correlation matrix and two linear regression models (`Healthcare ~ Housing` and `Education ~ Housing`) tested whether housing costs co-move with other essential expenses.

---

## 📈 What the Models Said *(read with caution)*

> ⚠️ **Important context:** Every finding below is reported as it came out of the analysis. Because of the data quality problems described above, these results should be treated as illustrative of the *method*, not as reliable conclusions about the real world.

| Question | Result |
|---|---|
| **Disposable Income** | All six regions showed **negative** average disposable income. South America performed best (–\$242.7); Europe worst (–\$594.3). |
| **Housing Burden** | Roughly one-third of income across every region. South America: 36.2%, North America & Europe: 35.9%, Africa: 34.2%. |
| **Savings Opportunity** | All regions negative. North America least bad (–24.1%); Oceania worst (–47.5%). |
| **Housing ↔ Healthcare** | Correlation **r = 0.74**. Linear model: \$1 ↑ housing ⇒ \$0.27 ↑ healthcare. **R² = 0.548**, p < 0.001. |
| **Housing ↔ Education** | Correlation **r = 0.66**. Linear model: \$1 ↑ housing ⇒ \$0.19 ↑ education. **R² = 0.442**, p < 0.001. |

---

## 🛑 The Deployment Decision

The evaluation phase produced a clear verdict: **do not deploy**.

The reasoning, in plain terms:

- **Statistical significance is not the same as truth.** The models passed every standard test, but they were trained on inconsistent inputs. A p-value cannot rescue bad data.
- **Regional averaging hides bias.** Smoothing out country-level volatility helped the math, but it also let countries with more observations dominate their region's mean.
- **Real decisions need traceable data.** A policy or business recommendation built on an undocumented Kaggle file isn't a recommendation — it's a guess wearing a suit.

So instead of forcing a deployment, the project ends with an honest evaluation and a set of recommendations for what *would* make this analysis trustworthy in the future.

---

## 💡 What I Took Away From This Project

- **Data quality is a first-class deliverable.** A pretty chart on top of bad data is worse than no chart at all — it manufactures false confidence.
- **CRISP-DM isn't ceremonial.** The Evaluation phase exists precisely so analysts have a structured place to push back before deployment. Skipping it is how bad models reach production.
- **R is excellent for this kind of investigative work.** `dplyr` for grouping, `ggplot2` for diagnostic plotting, and `lm()` / `corrplot` for relationship modeling were enough to take the analysis from raw CSV to defensible verdict.
- **Saying "no" requires evidence.** Refusing to deploy isn't a vibe — it's a position you have to support with diagnostic plots, summary statistics, and clearly stated assumptions. That's what got this project an A.

---

## 🚀 How to Run

**Prerequisites:** R (≥ 4.0), RStudio recommended.

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/<your-repo>.git
   cd <your-repo>
   ```

2. **Install required packages** (first run only)
   ```r
   install.packages(c("tidyverse", "ggplot2", "readr", "dplyr",
                      "ggthemes", "scales", "lubridate", "corrplot",
                      "tm", "wordcloud", "RColorBrewer"))
   ```

3. **Update the data path** at the top of `ProjectScript_Tanmoy.R` to point to wherever you placed `Cost_of_Living_and_Income_Extended.csv` on your machine.

4. **Run the script** in RStudio section by section, or from the R console:
   ```r
   source("ProjectScript_Tanmoy.R")
   ```

---

## 🔮 What Would Make This Analysis Deployable

If this project were repeated with a better dataset, the same pipeline could produce genuinely useful results. The conditions:

- **Verified, well-documented sources** — government statistics, World Bank, OECD, or IMF — instead of an undocumented Kaggle aggregation.
- **Balanced coverage** so no region is over- or under-represented in regional averages.
- **Clear definitions** for "average monthly income" and each cost category (gross vs. net, urban vs. national, PPP-adjusted, etc.).
- **Outlier detection and smoothing** for time-series irregularities at the country level.
- **Train / test split** so regression models can be evaluated on unseen data instead of in-sample fit only.
- **Multivariable models** including transportation, tax burden, and demographic controls — not just housing as a single predictor.

---

## 📑 Project Artifacts

- 📄 **Full Report:** `Project_Report_Tanmoy.pdf` — the complete write-up with all figures and reasoning.
- 🎞️ **Presentation:** `Final_Project_Presentation_Tanmoy.pptx` — the slide deck used to defend the project.
- 💻 **R Script:** `ProjectScript_Tanmoy.R` — the full CRISP-DM pipeline.

---

## 👤 Author

**Tanmoy Saha Turja**
M.S. in Business Analytics — Mercy University

If this project's framing was useful to you, or you'd like to discuss data quality and analytical honesty in real-world settings, feel free to reach out or open an issue.

---

## 📜 License

Released under the MIT License — feel free to use, adapt, or build on this work with attribution.

---

## 🙏 Acknowledgments

- Dataset by [Heidar Mirhajisadati](https://www.kaggle.com/heidarmirhajisadati) on Kaggle.
- Mercy University School of Business and the ANLC 754 instructional team.
- The R community for the open-source tooling that made every step of this analysis possible.
