# Resume Formatting Rules - EXACT SPECIFICATIONS

> **CRITICAL:** When tailoring resumes, COPY the master Python script and ONLY modify content.
> NEVER change the formatting structure, functions, or layout code.

---

## Master Template Location

**ALWAYS USE THIS AS BASE:** `$APPLIER_HOME/resume/create_resume.py`

When creating a tailored resume:
1. Copy the entire script
2. Only modify the TEXT CONTENT (bullets, skills order, keywords)
3. NEVER change the functions or formatting code

---

## Core Functions (DO NOT MODIFY)

### 1. add_hyperlink() Function
```python
def add_hyperlink(paragraph, text, url):
    """Add a hyperlink to a paragraph."""
    part = paragraph.part
    r_id = part.relate_to(url, 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink', is_external=True)

    hyperlink = OxmlElement('w:hyperlink')
    hyperlink.set(qn('r:id'), r_id)

    new_run = OxmlElement('w:r')
    rPr = OxmlElement('w:rPr')

    color = OxmlElement('w:color')
    color.set(qn('w:val'), '0563C1')  # Blue color
    rPr.append(color)

    u = OxmlElement('w:u')
    u.set(qn('w:val'), 'single')  # Underline
    rPr.append(u)

    sz = OxmlElement('w:sz')
    sz.set(qn('w:val'), '21')  # 10.5pt font size (21 half-points)
    rPr.append(sz)

    new_run.append(rPr)
    t = OxmlElement('w:t')
    t.text = text
    new_run.append(t)
    hyperlink.append(new_run)
    paragraph._p.append(hyperlink)
    return hyperlink
```

### 2. add_bottom_border() Function
```python
def add_bottom_border(paragraph):
    """Add a bottom border line to a paragraph."""
    pPr = paragraph._p.get_or_add_pPr()
    pBdr = OxmlElement('w:pBdr')
    bottom = OxmlElement('w:bottom')
    bottom.set(qn('w:val'), 'single')
    bottom.set(qn('w:sz'), '6')  # Border thickness
    bottom.set(qn('w:space'), '1')
    bottom.set(qn('w:color'), '000000')  # Black
    pBdr.append(bottom)
    pPr.append(pBdr)
```

### 3. set_tab_stops() Function
```python
def set_tab_stops(paragraph, positions=None):
    """Set tab stops - right aligned."""
    if positions is None:
        positions = [(7.5, 'right')]  # 7.5 inches, right-aligned

    pPr = paragraph._p.get_or_add_pPr()
    tabs = OxmlElement('w:tabs')
    for pos, align in positions:
        tab = OxmlElement('w:tab')
        tab.set(qn('w:val'), align)
        tab.set(qn('w:pos'), str(int(pos * 1440)))  # CRITICAL: multiply by 1440
        tabs.append(tab)
    pPr.append(tabs)
```

---

## Document Layout

| Property | Value |
|----------|-------|
| Page Size | Letter (8.5" x 11") |
| Top Margin | 0.5" |
| Bottom Margin | 0.5" |
| Left Margin | 0.5" |
| Right Margin | 0.5" |
| Font Family | Calibri |
| Line Spacing | Single (1.0) |

---

## Text Sizes (EXACT VALUES)

| Element | Size | Weight | Style | Font Name |
|---------|------|--------|-------|-----------|
| Name | 18pt | Bold | Normal | Calibri |
| Contact info | 10.5pt | Normal | Normal | Calibri |
| Section headers | 11pt | Bold | UPPERCASE | Calibri |
| Company names | 10.5pt | Bold | Normal | Calibri |
| Locations | 10.5pt | Bold | Normal | Calibri |
| Role titles | 10.5pt | Normal | Italic | Calibri |
| Dates | 10.5pt | Normal | Italic | Calibri |
| Bullet text | 10.5pt | Normal | Normal | Calibri |
| Skills text | 10.5pt | Normal | Normal | Calibri |

---

## Section Header Format (EXACT)

```python
edu_header = doc.add_paragraph()
run = edu_header.add_run("EDUCATION")  # ALL CAPS
run.bold = True
run.font.size = Pt(11)
run.font.name = 'Calibri'
add_bottom_border(edu_header)  # Horizontal line underneath
edu_header.paragraph_format.space_after = Pt(3)
edu_header.paragraph_format.space_before = Pt(6)
```

---

## Company/Organization Line Format (EXACT)

```python
company = doc.add_paragraph()
set_tab_stops(company)  # Sets right-aligned tab at 7.5"
r = company.add_run("Company Name")
r.bold = True
r.font.size = Pt(10.5)
r.font.name = 'Calibri'
company.add_run("\t")  # Tab character for right alignment
r = company.add_run("City, State")
r.bold = True
r.font.size = Pt(10.5)
r.font.name = 'Calibri'
company.paragraph_format.space_after = Pt(0)
```

---

## Role/Title Line Format - WITHOUT GitHub Link

```python
title = doc.add_paragraph()
set_tab_stops(title)
r = title.add_run("Job Title")
r.italic = True
r.font.size = Pt(10.5)
r.font.name = 'Calibri'
title.add_run("\t")
r = title.add_run("May 2024 – Aug 2024")
r.italic = True
r.font.size = Pt(10.5)
r.font.name = 'Calibri'
title.paragraph_format.space_after = Pt(0)
```

---

## Role/Title Line Format - WITH GitHub Link (EXACT SPACING)

```python
p_role = doc.add_paragraph()
set_tab_stops(p_role)
r = p_role.add_run("Lead Developer                    ")  # ~20 spaces after role
r.italic = True
r.font.size = Pt(10.5)
r.font.name = 'Calibri'
add_hyperlink(p_role, "[GitHub]", GITHUB_LINKS["project"])
p_role.add_run("                    \t")  # ~20 spaces before tab
r = p_role.add_run("2025")
r.italic = True
r.font.size = Pt(10.5)
r.font.name = 'Calibri'
p_role.paragraph_format.space_after = Pt(0)
```

**Spacing Rule:** Use exactly 20 spaces on each side of the [GitHub] link to center it visually.

---

## Bullet Points Format (EXACT)

```python
b = doc.add_paragraph(style='List Bullet')
b.add_run("Led a team of 4 in building a production ").font.size = Pt(10.5)
r = b.add_run("RAG")
r.bold = True
r.font.size = Pt(10.5)
b.add_run(" system using ").font.size = Pt(10.5)
r = b.add_run("Python")
r.bold = True
r.font.size = Pt(10.5)
b.paragraph_format.space_after = Pt(0)  # No space after (except last in section)
b.paragraph_format.left_indent = Inches(0.5)  # CRITICAL: 0.5 inch indent
```

---

## TAILORING PROCESS (CRITICAL - FOLLOW EVERY TIME)

### Step 1: Analyze the Job Description
Extract these from the JD:
- **Required technologies** (Python, React, MySQL, etc.)
- **Nice-to-have technologies**
- **Scale/performance language** ("billions of events", "petabyte scale", "high-traffic")
- **Methodology** (Agile, Scrum, etc.)
- **Domain** (AI, e-commerce, data pipelines, etc.)

### Step 2: Copy the Master Script
```
1. Copy $APPLIER_HOME/resume/create_resume.py entirely
2. Save as: $APPLIER_HOME/applications/[Company]/create_[company]_resume.py
3. ONLY modify the TEXT CONTENT inside the script
4. NEVER modify functions, margins, font sizes, or spacing
```

### Step 3: Tailor Content (What to Change)

#### A. Reword Bullet Points to Match JD Language
| If JD Says... | Change Bullets to Include... |
|---------------|------------------------------|
| "real-time data pipelines" | "real-time event processing", "data pipelines" |
| "high-traffic", "scale" | "high-traffic production system", "thousands of daily requests" |
| "performance" | "sub-second response times", "reduced latency by X%" |
| "billions of events" | "handles thousands of requests", "high-throughput" |
| "Agile/Scrum" | "shipped features in Agile sprints", "daily standups" |

#### B. Bold Technologies That Match JD
- If JD mentions "MySQL" → bold "MySQL" (not just "SQL")
- If JD mentions "Redis" → bold "Redis"
- If JD mentions "TypeScript" → bold "TypeScript"
- Bold their EXACT terminology

#### C. Reorder Skills Section
Put JD technologies FIRST in each category:
- If JD wants Python, TypeScript → "Programming: **Python**, **TypeScript**, JavaScript..."
- If JD wants MySQL, Redis → "Cloud & Databases: **AWS**, **MySQL**, **Redis**..."

#### D. Reorder Projects (Optional)
If a specific project matches better, move it up.

### Step 4: Add Power Words That Match JD
| JD Focus | Add These Words |
|----------|-----------------|
| Scale | "scalable", "high-traffic", "production system", "thousands of requests" |
| Performance | "optimized", "reduced latency", "sub-second", "high-throughput" |
| Data | "data pipelines", "event processing", "real-time", "analytics" |
| AI | "AI-powered", "intelligent", "ML models", "LLMs" |
| Reliability | "high availability", "99.9% uptime", "fault-tolerant" |

### Step 5: Verify Before Generating
- [ ] Used master script as base (not written from scratch!)
- [ ] All functions UNCHANGED
- [ ] Bullet content reworded to match JD language
- [ ] Technologies from JD are bolded
- [ ] Skills reordered to put JD technologies first
- [ ] Added scale/performance language if JD mentions it
- [ ] Formatting is IDENTICAL to original resume

---

## What to Modify (CONTENT ONLY):
1. **Bullet text** - Reword to use JD terminology
2. **Bold keywords** - Bold technologies that match the JD exactly
3. **Skills order** - Put most relevant skills first in each category
4. **Power words** - Add scale/performance language matching JD

## What NOT to Modify (NEVER TOUCH):
1. Function definitions (add_hyperlink, add_bottom_border, set_tab_stops)
2. Document margins (0.5" all sides)
3. Font sizes (18pt name, 11pt headers, 10.5pt body)
4. Tab stop positions (7.5" right-aligned)
5. Spacing values (Pt(0), Pt(3), Pt(6))
6. Border thickness ('sz', '6')
7. Contact line structure
8. Section order (Education, Experience, Projects, Activities, Skills)
9. ~20 spaces around GitHub links

---

## Required Sections (IN ORDER)

1. **EDUCATION**
2. **EXPERIENCE**
3. **PROJECTS**
4. **ACTIVITIES AND LEADERSHIP**
5. **SKILLS**

---

## Skills Section Categories (EXACT FORMAT)

```python
# Category label is bold, followed by items
s = doc.add_paragraph()
r = s.add_run("Programming: ")
r.bold = True
r.font.size = Pt(10.5)
r.font.name = 'Calibri'
# Then add skills (some bold for ATS)
r = s.add_run("Python")
r.bold = True
r.font.size = Pt(10.5)
s.add_run(", ").font.size = Pt(10.5)
# ... continue
s.paragraph_format.space_after = Pt(0)
```

### Categories:
1. **Programming:** Python, TypeScript, JavaScript, SQL, Java, R, HTML/CSS
2. **Frameworks & Tools:** React, FastAPI, Flask, Node.js, LangChain, PyTorch, Docker, Git
3. **Cloud & Databases:** AWS (EC2, S3, Lambda, RDS), MySQL, PostgreSQL, Redis, MongoDB, Pinecone, Google Cloud (Vertex AI)
4. **AI/ML:** LLMs, RAG Systems, AI Agents, OpenAI API, Google Gemini, Vector Databases, NLP
5. **Other:** REST APIs, CI/CD, Agile/Scrum, Unit Testing, OOP, Microservices

---

## ATS Optimization - Bold These Terms

### Always Bold:
- Python, JavaScript, TypeScript, SQL
- React, FastAPI, Flask, Node.js, LangChain
- PyTorch, TensorFlow
- Docker, Git
- AWS, Google Cloud, Vertex AI, Pinecone
- LLMs, RAG Systems, AI Agents, OpenAI API, Google Gemini, Vector Databases
- Metrics (800+, 40%, 20%, etc.)

### Bold When Matching JD:
- Any technology specifically mentioned in job description
- Exact terminology from JD (e.g., "MySQL" if they say MySQL, not just "SQL")

---

## Quick Checklist Before Generating

- [ ] Used master script as base template
- [ ] All functions unchanged (add_hyperlink, add_bottom_border, set_tab_stops)
- [ ] Tab stops use `* 1440` conversion
- [ ] Bottom border uses `'sz', '6'`
- [ ] Hyperlinks have font size element `'21'`
- [ ] Bullet indent is `Inches(0.5)`
- [ ] GitHub links have ~20 spaces on each side
- [ ] All sections present: EDUCATION, EXPERIENCE, PROJECTS, ACTIVITIES, SKILLS
- [ ] Contact line uses hyperlinks
