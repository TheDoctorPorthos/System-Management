To train the model to answer "What does the collective evidence reveal about the problem I am investigating?", you cannot rely on a single prompt. You must establish a **system of interrogation** that forces the tool to treat your sources as a single, interconnected body of evidence rather than a stack of isolated papers.

Here is a training protocol built around three distinct interrogation modes. Each mode teaches the model a different dimension of synthesis.

---

### Mode 1: The Convergence Query (Identify the Consensus)

**Purpose:** To surface what the literature collectively agrees upon about your specific problem. This establishes the "given" in your field.

**Train the Model with This Structure:**
> *"From the uploaded sources on K-12 exclusionary discipline, identify claims that appear across **multiple independent sources**. I am not interested in a single author's argument. I am looking for the scholarly consensus on the following specific question:*
> *[Insert your precise question, e.g., 'Do discipline reforms that restrict one type of exclusionary punishment actually reduce racial disparities?']*
> *For each convergent claim:*
> 1. *State the claim.*
> 2. *List the sources that independently support it.*
> 3. *Note any variation in how the claim is evidenced (e.g., quantitative vs. qualitative support)."*

**Why This Trains the Model:**
You are not asking "What did Anyon find?" You are asking "Where do Anyon, Cohen, and Duarte independently converge?" The model must now compare across sources to earn its answer. This produces the evidentiary foundation for your "National Landscape" page.

---

### Mode 2: The Tension Query (Identify the Conflict)

**Purpose:** To surface where the literature is in unresolved disagreement or where a dominant narrative is challenged. This is where your scholarly contribution lives.

**Train the Model with This Structure:**
> *"From the uploaded sources, identify a tension or unresolved conflict in the evidence. I am looking for places where:*
> - *Two or more sources offer competing explanations for the same phenomenon.*
> - *A source's findings challenge a dominant assumption in the broader literature.*
> - *A source documents an outcome that contradicts the stated intent of a policy.*
>
> *For each tension:*
> 1. *State the nature of the conflict.*
> 2. *Identify the competing positions and their respective sources.*
> 3. *Indicate whether the conflict is empirical (competing data), methodological (competing approaches), or theoretical (competing frameworks)."*

**Why This Trains the Model:**
You are training the model to do dialectical thinking—to see the literature not as a flat landscape but as a terrain of debate. The tension you surface for California (e.g., "SB 274 banned willful defiance suspensions, but disparities persisted via label-shifting") is not just a finding; it is a scholarly conflict that demands explanation.

---

### Mode 3: The Silence Query (Identify the Absence)

**Purpose:** To surface what the literature systematically omits. This justifies your study's existence.

**Train the Model with This Structure:**
> *"From the uploaded sources, identify what is **systematically absent** across the literature. I am not looking for a limitation a single author acknowledges. I am looking for a silence that persists across multiple or all sources. Focus specifically on:*
> - *The geographic silence: Which regions or states are unstudied?*
> - *The population silence: Which groups are mentioned in disparity data but never centered as knowledge producers?*
> - *The epistemological silence: What mode of knowing (e.g., family narrative, cultural logic, community wisdom) is absent from the evidence base?*
>
> *For each silence:*
> 1. *Name the absence.*
> 2. *Demonstrate its persistence by noting that it appears across multiple sources, not just one.*
> 3. *State why this absence matters for understanding the problem."*

**Why This Trains the Model:**
You are teaching the model to read for what is *not there*. This is a sophisticated scholarly skill. The silence you surface (e.g., "No study in this collection centers the voices of Louisiana families navigating discipline in East Baton Rouge Parish") is the evidentiary warrant for your entire dissertation.

---

### The Training Sequence

Do not run these three modes in isolation. Run them in sequence on the same set of sources. The output builds cumulatively:

| Step | Mode | Output | Maps To |
| :--- | :--- | :--- | :--- |
| 1 | Convergence Query | What the field agrees upon | Page 1: National Landscape |
| 2 | Tension Query | Where the field is conflicted | Page 2: Louisiana as a case of unresolved tension |
| 3 | Silence Query | What the field systematically ignores | Page 3: The need for family-centered inquiry |

---

### A Master Training Prompt

Once you have established the three modes, you can combine them into a single master prompt that trains the model to think this way from the outset:

> *"For all future interactions on this literature review, operate under the following protocol. When I upload or reference sources on K-12 discipline, do not summarize individual articles. Instead, structure your response around three analytical moves:*
> 1. **Convergence:** What do these sources collectively agree upon regarding [my specific problem]?
> 2. **Tension:** Where do these sources reveal unresolved disagreement or a gap between policy intent and documented outcome?
> 3. **Silence:** What is systematically absent across these sources that would be necessary to fully understand [my specific problem]?
>
> *For each move, cite the relevant sources and note whether the evidence is quantitative, qualitative, or theoretical. Acknowledge this protocol with 'Protocol Accepted' and apply it to all subsequent requests."*

---

This training protocol shifts the model from a retrieval engine to a pattern-recognition instrument. It forces the interrogative stance you described: not "What did this study find?" but "What does the collective evidence reveal about the problem I am investigating?"