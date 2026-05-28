Here are four precision-engineered prompts designed specifically for **verbatim extraction**. Each forces the Gemini Scribe plug-in to return exact phrasing, key terminology, and direct quotes with page/section citations, minimizing paraphrase and maximizing usable textual evidence for your literature review.

---

### 🔹 1. Theoretical Anchor: The Reform Paradox
**Source:** `Understanding the Reform Paradox in K-12 Education (1).PDF`
```text
From this document, extract ONLY verbatim quotes and exact phrases that define the "reform paradox" and explain why K-12 disciplinary reforms consistently fail to close equity gaps. Provide exactly 3–4 excerpts. For each, format as:
- Quote: "[exact text]" (p. X)
- Author's Key Term(s): [list 1–3 precise terms or phrases used in the quote]
Do not paraphrase, summarize, or interpret. Prioritize the authors' original theoretical framing and national-scope claims.
```

---

### 🔹 2. Intersectionality & Statistical Reality
**Source:** Cruz et al. (2021)
```text
From Annamma, et al.(2020); Anyon, (2023); Cohen, (2023) extract ONLY verbatim quotes and exact phrasing that present the the reform paradox through the Intersectionality Theoretical Framework. Provide exactly 3–4 excerpts. For each, format as:
- Quote: "[exact text]" (p. X)
- Data Focus: [e.g., race/disability intersection, national trend, methodological critique]
Do not paraphrase or calculate new statistics. Return only the authors' original wording describing disparities, intersectional findings, or critiques of traditional data interpretation.
```

---

### 🔹 3. Policy Mechanisms & Jurisdictional Case Studies
**Source:** Kolluri & Tichavakunda (2023)
```text
From Kolluri & Tichavakunda (2023), extract ONLY verbatim quotes and exact phrases that explain how policy implementations in Texas, New York, and Puerto Rico have inadvertently sustained disciplinary inequities. Provide 1–2 quotes per jurisdiction. For each, format as:
- Jurisdiction: [TX/NY/PR]
- Quote: "[exact text]" (p. X)
- Policy Mechanism Named: [e.g., "crisis of belonging," "isolation via alternative education," "cultural dissonance"]
Do not paraphrase or synthesize across jurisdictions. Return only the authors' original analytical language describing policy failure in each context.
```

---

### 🔹 4. California Nuance: Reform Unintended Consequences
**Sources:** Welsh (2024) & Wang (2022)
```text
From Welsh (2024) and Wang (2022), extract ONLY verbatim quotes and exact phrasing that document how California's progressive suspension reforms (e.g., SB 274) led to "label-shifting" rather than equity. Provide exactly 3–4 excerpts across both sources. For each, format as:
- Source: [Author, Year]
- Quote: "[exact text]" (p. X)
- Phenomenon Described: [e.g., alternative categories, persistent disparities, post-reform administrative workarounds]
Do not paraphrase or merge findings. Return only the authors' original wording capturing how disparities morphed post-reform.
```

---

### 🔑 Master Verbatim Extraction Template (Reusable for Future Sections)
```text
From [Source Title/Author], extract ONLY verbatim quotes and exact phrasing related to [specific concept/theme]. Provide [number] excerpts. For each, format as:
- Quote: "[exact text]" (p. X or Section X)
- Key Term/Concept: [author's original terminology]
Do not paraphrase, summarize, or interpret. Prioritize direct authorial language that captures [specify focus: e.g., empirical claims, theoretical framing, policy mechanisms, methodological critiques].
```

---

### 💡 Plugin-Specific Tips for Accuracy:
1. **Explicit "NO PARAPHRASE" Directive:** AI document readers default to synthesis. The strict formatting rules and negative constraints above force verbatim output.
2. **Page/Section Verification:** Always cross-check 1–2 quotes against the original PDF. If the plugin misattributes a page, add `"(Verify page number against PDF before output)"` to your prompt.
3. **Chunk if Needed:** If the source exceeds typical RAG context windows, add `Focus only on pages [X–Y]` to target the most relevant sections.

Would you like these formatted as a ready-to-import prompt library (e.g., JSON or CSV) for batch processing in Gemini Scribe, or adjusted to match a specific journal's citation style (APA 7th, Chicago, etc.)?