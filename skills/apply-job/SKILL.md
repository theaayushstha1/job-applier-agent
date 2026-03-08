---
name: apply-job
description: Automated job applications with AI-powered resume tailoring, cover letters, recruiter outreach, interview prep, ATS optimization, and smart analytics.
license: MIT
metadata:
  author: theaayushstha1
  version: "4.0.0"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - WebFetch
  - WebSearch
  - mcp__playwright__browser_navigate
  - mcp__playwright__browser_snapshot
  - mcp__playwright__browser_click
  - mcp__playwright__browser_type
  - mcp__playwright__browser_fill_form
  - mcp__playwright__browser_file_upload
  - mcp__playwright__browser_take_screenshot
  - mcp__playwright__browser_wait_for
  - mcp__playwright__browser_press_key
  - mcp__playwright__browser_select_option
---

# Job Application Agent v4

Automated job application system with smart scoring, ATS optimization, interview prep, recruiter outreach, and analytics.

## Commands

```bash
/apply-job <url>                 # Full application workflow
/apply-job search <query>        # Search + batch apply with smart filtering
/apply-job outreach <url>        # Recruiter outreach only
/apply-job status                # View statistics
/apply-job status weekly         # Weekly analytics digest
/apply-job score <url>           # Score job fit only
/apply-job prep <company>        # Interview prep mode
/apply-job followup              # Check follow-up reminders
/apply-job ats-check <url>       # ATS keyword analysis
/apply-job dedup                 # Find duplicate applications
```

## Setup Required

| File | Purpose |
|------|---------|
| `$APPLIER_HOME/data/profile.json` | Your personal info (from template) |
| `$APPLIER_HOME/data/applications.json` | Application tracking |
| `$APPLIER_HOME/resume/master_resume.md` | Your complete resume |
| `$APPLIER_HOME/templates/cover_letter.md` | Cover letter template |
| `$APPLIER_HOME/templates/cold_email.md` | Cold email template |

**$APPLIER_HOME** = `~/job-applier-agent` (cross-platform)

See [SETUP.md](SETUP.md) for installation instructions.

---

## Core Principles

### AUTO-PROCEED Mode
- **DO NOT** ask for confirmation at routine steps
- **JUST DO IT** - proceed through entire workflow automatically
- **ONLY STOP** for: login walls, CAPTCHA, critical errors, fit score < 5.0, dealbreakers detected

### Outreach Order (CRITICAL)
```
1. Find recruiters on LinkedIn (names, titles, URLs)
2. Find publicly available contact info
3. Send cold emails via Gmail FIRST
4. THEN send LinkedIn connection requests
5. Track everything in applications.json
```
**Email = PRIMARY (higher response rate). LinkedIn = SECONDARY.**

---

## Workflow: Apply to Job URL

### Step 1: Dedup Check
```
1. Read $APPLIER_HOME/data/applications.json
2. Check if URL already exists in applications[]
3. Check if same company + similar role title exists (fuzzy match)
4. If duplicate found:
   - Show: "Already applied to [Role] at [Company] on [Date]"
   - Ask user if they want to proceed anyway
   - If no, skip and exit
```

### Step 2: Extract Job Description
```
1. Navigate to job URL with Playwright
2. Capture page snapshot
3. Extract: title, company, location, requirements, salary range
4. Identify key skills/technologies
5. Detect application platform (LinkedIn, Greenhouse, Lever, Workday, etc.)
```

### Step 3: Smart Fit Scoring (0-10 each)

**Standard Scores:**
- **Technical Fit**: Skills match percentage
- **Level Match**: Appropriate for experience level
- **Location**: Remote/local/relocation
- **Mission**: Company alignment

**Dealbreaker Detection (AUTO-FAIL if any triggered):**
```
Check for these red flags in the JD:
- Security clearance required (user doesn't have one)
- 5+ years experience required (new grad)
- Senior/Staff/Principal level explicitly required
- Specific license required (PE, CPA, etc.)
- Location restriction with no remote (if user is remote-only)
```

If dealbreaker detected:
- Score = 0.0 regardless of other scores
- Show: "DEALBREAKER: [reason]. Skip? (y/n)"
- Default to skip unless user overrides

Score >= 5.0 and no dealbreakers: AUTO-PROCEED
Score < 5.0: Notify user

### Step 4: ATS Keyword Analysis
```
1. Extract keywords from JD:
   - Hard skills (Python, React, AWS, etc.)
   - Soft skills (leadership, collaboration)
   - Domain terms (fintech, healthcare, etc.)
   - Action verbs the JD uses
2. Compare against master_resume.md
3. Calculate match percentage
4. Generate keyword gap report:
   - MATCHED: [list of matching keywords]
   - MISSING (in JD, not in resume): [list]
   - EXTRA (in resume, not in JD): [list]
   - ATS Score: X/100
5. If match < 60%, warn user about low ATS pass rate
```

### Step 5: Company Research Brief
```
1. WebFetch company website
2. WebSearch "[company] news 2025 2026"
3. WebSearch "[company] glassdoor reviews engineering"
4. Compile brief:
   - What they do (1 sentence)
   - Recent news/funding/launches
   - Tech stack (if discoverable)
   - Employee sentiment highlights
   - Why this matters for your application
5. Save to $APPLIER_HOME/applications/<Company>/research.md
```

### Step 6: Tailor Resume
```
1. Read $APPLIER_HOME/resume/master_resume.md
2. Create tailored markdown version:
   - Reorder projects by relevance to JD
   - Emphasize matching skills (use JD keywords from ATS analysis)
   - Bold technologies that match JD exactly
   - Reorder skills section (JD technologies first)
   - Add power words matching JD focus
3. Save to $APPLIER_HOME/applications/<Company>/resume_tailored.md
```

**Rules**: Never add fake skills. Never fabricate metrics. Only reorder/emphasize/reword.

**Power Words by JD Focus:**
| JD Focus | Use These Words |
|----------|-----------------|
| Scale | "high-traffic", "thousands of requests", "production system" |
| Performance | "sub-second", "reduced latency", "optimized" |
| Data | "data pipelines", "real-time", "event processing" |
| AI | "AI-powered", "LLMs", "ML models" |

### Step 7: Generate Cover Letter
```
1. Read $APPLIER_HOME/templates/cover_letter.md
2. Use company research brief for personalization
3. Reference specific company news/product in opening
4. Keep to 250-350 words
5. Save to $APPLIER_HOME/applications/<Company>/cover_letter.txt
```

### Step 8: Auto-Fill Application
Use Playwright to fill forms based on platform:
- LinkedIn Easy Apply
- Company career pages (Greenhouse, Lever, Workday, ADP, etc.)
- Upload resume, add cover letter if field exists

### Step 9: Track & Screenshot
```
1. Take confirmation screenshot
2. Update $APPLIER_HOME/data/applications.json with:
   - All standard fields
   - fit_score, ats_score, dealbreakers (if any)
   - follow_up_date (applied_date + 7 days)
   - company_research: true/false
   - category tag (backend, frontend, ai-ml, fullstack, devops)
3. Update stats
```

### Step 10: Recruiter Outreach
See [WORKFLOWS.md](WORKFLOWS.md) for detailed outreach steps.

---

## Interview Prep Mode

**Trigger**: `/apply-job prep <company>`

```
1. Read application entry from applications.json
2. Read saved company research (or generate fresh)
3. Read the original JD (from saved files or re-fetch URL)
4. Generate prep document:

   === Interview Prep: [Role] at [Company] ===

   ## Company Overview
   - What they do, recent news, tech stack
   - Key products/services

   ## Likely Technical Questions
   Based on JD requirements, prepare for:
   - [Skill 1]: [2-3 practice questions]
   - [Skill 2]: [2-3 practice questions]
   - System design: [relevant scenario based on company domain]

   ## Behavioral Questions (STAR Format)
   - "Tell me about a time you..." [matched to JD soft skills]
   - Suggested STAR response using YOUR projects from resume

   ## Your Talking Points
   Based on your resume + this JD:
   - Lead with: [most relevant project]
   - Mention: [matching skills]
   - Connect: [your experience] to [their needs]

   ## Questions to Ask Them
   - About the team/role
   - About technical challenges
   - About growth/mentorship

5. Save to $APPLIER_HOME/applications/<Company>/interview_prep.md
6. Display to user
```

---

## Follow-Up Reminders

**Trigger**: `/apply-job followup`

```
1. Read applications.json
2. For each application where status = "applied":
   - Calculate days since applied_date
   - If 7+ days and no follow_up_sent:
     FLAG for follow-up
   - If 14+ days and follow_up_sent but no response:
     FLAG for second follow-up
3. Display:

   === Follow-Up Reminders ===

   OVERDUE (14+ days, no response):
   - [Company] - [Role] - Applied [date] - [recruiter contacts]

   DUE (7+ days):
   - [Company] - [Role] - Applied [date] - [recruiter contacts]

   RECENT (< 7 days):
   - [Company] - [Role] - Applied [date] - No action needed

4. For each overdue/due item, offer to:
   - Draft follow-up email
   - Send follow-up via Gmail
   - Update tracking
```

---

## ATS Keyword Check (Standalone)

**Trigger**: `/apply-job ats-check <url>`

Runs just the ATS analysis without applying:
```
1. Extract JD from URL
2. Run full keyword analysis against master_resume.md
3. Display match report with score
4. Suggest resume tweaks to improve score
5. Show which keywords to add/emphasize
```

---

## Smart Batch Apply

**Trigger**: `/apply-job search <query>`

Enhanced batch mode with smart filtering:
```
1. Search multiple sources:
   - WebSearch: "<query> jobs 2026"
   - WebSearch: "<query> new grad entry level"
   - WebSearch: "site:linkedin.com/jobs <query>"
   - WebSearch: "site:greenhouse.io <query>"

2. Collect URLs and quick-score each:
   - Navigate, extract basic info
   - Run dealbreaker check (fast fail)
   - Calculate fit score
   - Check for duplicates against applications.json

3. Filter results:
   - Remove dealbreakers
   - Remove duplicates (already applied)
   - Sort by fit score descending

4. Display filtered list:
   Found 15 jobs, 3 filtered out (1 duplicate, 2 dealbreakers):

   1. [9.2] Software Engineer @ Google - Remote
   2. [8.5] AI Engineer @ OpenAI - SF
   3. [7.8] Backend Dev @ Stripe - NYC
   ...
   Filtered: CompanyX (already applied), CompanyY (requires clearance)

5. AUTO-PROCEED with top 10 (or user-specified number)
6. Run full workflow for each
7. Report summary at end
```

---

## Weekly Analytics Digest

**Trigger**: `/apply-job status weekly`

```
Read applications.json and generate:

=== Weekly Job Search Analytics ===
Period: [last 7 days]

Applications This Week: 12
Total Applications: 47
Response Rate: 12% (6/47 got responses)

Top Performing Categories:
- AI/ML roles: 25% response rate
- Backend roles: 10% response rate
- Frontend roles: 5% response rate

Outreach Stats:
- Emails sent: 8 this week (28 total)
- LinkedIn connections: 12 this week (45 total)
- Responses received: 2

Pipeline:
- Applied: 42
- Interviewing: 3
- Rejected: 2
- Offers: 0

Follow-ups Due: 5 applications need follow-up

Avg Fit Score: 7.2 | Avg ATS Score: 72/100

Recommendations:
- [Based on data patterns: which role types get most responses]
- [Suggested search queries based on highest fit scores]
```

---

## Application Dedup

**Trigger**: `/apply-job dedup`

```
1. Read applications.json
2. Find potential duplicates:
   - Exact URL matches
   - Same company + similar role title (fuzzy match)
   - Same company applied within 30 days
3. Display findings and offer cleanup
```

---

## Recruiter Contact Discovery

Use publicly available contact information only:
```
1. Check the recruiter's LinkedIn profile for contact info
2. Check the company careers page for recruiter contact details
3. Use the company's public contact form if no direct contact is available
```

---

## Profile Configuration

All personal data comes from `$APPLIER_HOME/data/profile.json`.
See [profile-template.json](profile-template.json) for full template.

---

## Application Tracking Schema

`$APPLIER_HOME/data/applications.json`:

```json
{
  "applications": [{
    "id": "company-date-001",
    "company": "Company Name",
    "role": "Job Title",
    "url": "https://...",
    "platform": "linkedin|greenhouse|workday|adp",
    "applied_date": "2026-01-27",
    "status": "applied|interviewed|rejected|offer",
    "fit_score": 7.5,
    "ats_score": 78,
    "dealbreakers": [],
    "cover_letter": true,
    "company_research": true,
    "follow_up_date": "2026-02-03",
    "follow_up_sent": false,
    "category": "backend|frontend|ai-ml|fullstack|devops",
    "salary_range": "$120k-$150k",
    "outreach": [{
      "name": "Recruiter Name",
      "title": "Technical Recruiter",
      "email": "recruiter@company.com",
      "linkedin": "linkedin.com/in/...",
      "email_sent": true,
      "connection_sent": true,
      "date": "2026-01-27"
    }]
  }],
  "stats": {
    "total": 0,
    "applied": 0,
    "interviewed": 0,
    "rejected": 0,
    "offers": 0,
    "emailsSent": 0,
    "connectionsSent": 0,
    "avgFitScore": 0,
    "avgAtsScore": 0,
    "responseRate": 0
  }
}
```

---

## Error Handling

| Error | Action |
|-------|--------|
| Login required | Notify user, wait for "continue" |
| CAPTCHA | Notify user, wait |
| Rate limit | Wait 60s, retry once, skip if still blocked |
| Email failed | Log, continue with LinkedIn |
| Form field missing | Screenshot, ask user |
| Duplicate detected | Show previous application, ask to proceed |
| Dealbreaker found | Show reason, default to skip |

---

## Reference Files

| File | Content |
|------|---------|
| [WORKFLOWS.md](WORKFLOWS.md) | Detailed step-by-step workflows |
| [SETUP.md](SETUP.md) | Installation & configuration |
| [profile-template.json](profile-template.json) | Profile data template |

---

## Path Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `$APPLIER_HOME` | `~/job-applier-agent` | Base directory |
| `$APPLICATIONS_DIR` | `$APPLIER_HOME/applications` | Per-company files |

---

## Best Practices

1. **Email FIRST, LinkedIn SECOND** - Always send emails before connections
2. **AUTO-PROCEED** - Don't ask, just do (except critical errors)
3. **Track everything** - Update applications.json after every action
4. **Personalize** - Reference specific company details in outreach
5. **Screenshot** - Capture confirmation for records
6. **Be honest** - Never fabricate skills or metrics
7. **Dedup first** - Always check for duplicates before applying
8. **Research always** - Company brief improves cover letters and interviews
9. **Follow up** - Check followup reminders regularly
10. **Analyze patterns** - Use weekly stats to optimize your search
