# Detailed Workflows Reference

Step-by-step workflows for every command in the job application agent.

## Table of Contents
- [Workflow 1: Full Application](#workflow-1-full-application)
- [Workflow 2: Search and Batch Apply](#workflow-2-search-and-batch-apply)
- [Workflow 3: Outreach Only](#workflow-3-outreach-only)
- [Workflow 4: Status Report](#workflow-4-status-report)
- [Workflow 5: Interview Prep](#workflow-5-interview-prep)
- [Workflow 6: Follow-Up Reminders](#workflow-6-follow-up-reminders)
- [Workflow 7: ATS Keyword Check](#workflow-7-ats-keyword-check)
- [Workflow 8: Application Dedup](#workflow-8-application-dedup)
- [Workflow 9: Weekly Analytics](#workflow-9-weekly-analytics)
- [Recruiter Outreach Details](#recruiter-outreach-details)
- [Platform-Specific Instructions](#platform-specific-instructions)

---

## Workflow 1: Full Application

**Trigger**: `/apply-job <url>`

### Phase 1: Pre-Check

```
1. Read ~/job-applier-agent/data/applications.json

2. Dedup check:
   - Search applications[] for matching URL
   - Search for same company + similar role title
   - If found: show "Already applied to [Role] at [Company] on [Date]"
   - Ask user to confirm or skip

3. If duplicate and user says skip, exit cleanly
```

### Phase 2: Extract & Score

```
1. Navigate to job URL
   - mcp__playwright__browser_navigate(url)
   - mcp__playwright__browser_snapshot()

2. Extract job details:
   - Job title
   - Company name
   - Location (remote/onsite/hybrid)
   - Required skills
   - Nice-to-have skills
   - Responsibilities
   - Salary range (if listed)
   - Experience level required

3. Dealbreaker detection:
   - Check for: security clearance, 5+ years required,
     senior/staff/principal level, specific licenses,
     location restrictions incompatible with user preferences
   - If dealbreaker found:
     Score = 0.0
     Show: "DEALBREAKER: [reason]. Skip? (y/n)"
     Default to skip

4. Score job fit (0-10 each, skip if dealbreaker):
   - Technical Fit: (matching skills / required skills) * 10
   - Level Match: Entry=10, Mid=7, Senior=3 for new grads
   - Location: Remote=10, Preferred city=8, Relocation=5
   - Mission: AI/Tech=10, Other=5

5. Calculate average score
   - >= 5.0: Proceed to next phase
   - < 5.0: Notify user, wait for confirmation
```

### Phase 3: ATS Analysis

```
1. Extract all keywords from JD:
   - Hard skills: programming languages, frameworks, tools
   - Soft skills: communication, leadership, teamwork
   - Domain terms: fintech, healthcare, e-commerce
   - Action verbs: built, designed, scaled, optimized

2. Read ~/job-applier-agent/resume/master_resume.md

3. Compare keywords:
   - For each JD keyword, check if it appears in resume
   - Case-insensitive matching
   - Handle synonyms: "JS" = "JavaScript", "ML" = "Machine Learning"

4. Calculate ATS score:
   - (matched keywords / total JD keywords) * 100
   - Weight hard skills 2x vs soft skills

5. Generate report:
   ATS Score: 74/100
   MATCHED (18): Python, React, AWS, Docker, ...
   MISSING (6): Kubernetes, Terraform, Go, ...
   Recommendation: Consider emphasizing [missing skills you have]

6. If ATS score < 60, warn user
```

### Phase 4: Company Research

```
1. WebFetch company homepage
   - Extract: mission, products, team size clues

2. WebSearch "[company] news 2025 2026"
   - Find: funding rounds, product launches, acquisitions

3. WebSearch "[company] glassdoor reviews engineering"
   - Find: employee sentiment, culture highlights

4. Compile research brief:
   ## [Company] Research Brief
   **What they do**: [1 sentence]
   **Recent news**: [2-3 bullet points]
   **Tech stack**: [if discoverable]
   **Culture**: [Glassdoor highlights]
   **Why apply**: [connection to your skills/interests]

5. Save to ~/job-applier-agent/applications/<Company>/research.md
```

### Phase 5: Prepare Materials

```
1. Read profile from ~/job-applier-agent/data/profile.json

2. Tailor resume (markdown-based):
   a. Read master_resume.md
   b. Use ATS keyword analysis to guide changes:
      - Reword bullets to include matched JD keywords
      - Bold technologies that appear in JD
      - Reorder skills (JD technologies first)
      - Reorder projects (most relevant to JD first)
      - Add power words matching JD focus
   c. NEVER add skills you don't have
   d. NEVER fabricate metrics
   e. Save to ~/job-applier-agent/applications/<Company>/resume_tailored.md

3. Generate cover letter:
   - Read ~/job-applier-agent/templates/cover_letter.md
   - Use company research brief for personalization
   - Reference specific company news/product
   - Fill template with role, company, relevant project
   - Keep to 250-350 words
   - Save to ~/job-applier-agent/applications/<Company>/cover_letter.txt
```

### Phase 6: Submit Application

```
1. Identify platform type:
   - LinkedIn Easy Apply
   - Greenhouse
   - Lever
   - Workday
   - ADP
   - Custom company portal

2. Fill application form:
   - Use profile.json for all fields
   - Upload resume file
   - Paste cover letter if text field exists
   - Answer screening questions from profile.json defaults

3. Take pre-submit screenshot

4. Confirm with user, then submit application

5. Take confirmation screenshot
   - Save to ~/job-applier-agent/screenshots/<company>_<date>.png
```

### Phase 7: Track & Outreach

```
1. Categorize the role:
   - Analyze JD keywords to assign category:
     backend, frontend, ai-ml, fullstack, devops

2. Update ~/job-applier-agent/data/applications.json:
   - Add new application entry with all fields
   - Include: fit_score, ats_score, dealbreakers, category
   - Set follow_up_date = applied_date + 7 days
   - Set follow_up_sent = false
   - Set company_research = true
   - Update stats (total, applied, avgFitScore, avgAtsScore)

3. Execute recruiter outreach (see Recruiter Outreach Details)
```

---

## Workflow 2: Search and Batch Apply

**Trigger**: `/apply-job search <query>`

```
1. Search for jobs across sources:
   - WebSearch: "<query> jobs 2026"
   - WebSearch: "<query> new grad entry level"
   - WebSearch: "site:linkedin.com/jobs <query>"
   - WebSearch: "site:greenhouse.io <query>"

2. Collect job URLs from all results (deduplicate URLs)

3. Quick-score each URL:
   - Navigate, extract title + company + requirements
   - Run dealbreaker check first (fast fail)
   - If no dealbreaker, calculate fit score
   - Check against applications.json for duplicates

4. Filter and categorize:
   - PASS: score >= 5.0, no dealbreakers, not duplicate
   - FILTERED: reasons logged (duplicate, dealbreaker, low score)

5. Display filtered results:
   Found 18 jobs, 5 filtered:

   APPLYING TO (13):
   1. [9.2] Software Engineer @ Google - Remote
   2. [8.5] AI Engineer @ OpenAI - SF
   ...

   FILTERED OUT (5):
   - CompanyA: Already applied (Jan 15)
   - CompanyB: Requires security clearance
   - CompanyC: Fit score 3.2 (too low)

6. Proceed with qualifying jobs (user can specify count)

7. For each selected job:
   - Run full Workflow 1
   - Continue to next even if one fails
   - Log success/failure for each

8. Summary report at end:
   Batch Complete: 10/13 submitted
   - 10 applied successfully
   - 2 required login (skipped)
   - 1 form error (screenshot saved)
   Emails sent: 15 | Connections: 20
```

---

## Workflow 3: Outreach Only

**Trigger**: `/apply-job outreach <url>`

Run ONLY the outreach portion for an already-applied job:

```
1. Extract company name from URL
2. Check if application exists in applications.json
3. Find recruiters (see Recruiter Outreach Details)
4. Find publicly available contact info
5. Send cold emails
6. Send LinkedIn connections
7. Track in applications.json
```

---

## Workflow 4: Status Report

**Trigger**: `/apply-job status`

```
Read ~/job-applier-agent/data/applications.json

Display:

=== Job Application Status ===

Total Applications: 47
  Applied: 42
  Interviewed: 3
  Rejected: 2
  Offers: 0

Outreach Stats:
  Emails Sent: 28
  LinkedIn Connections: 45
  Response Rate: 12%

Scoring:
  Avg Fit Score: 7.2
  Avg ATS Score: 74/100

Recent Applications (last 5):
1. [Jan 27] Software Engineer @ Epic - Applied + 2 emails
2. [Jan 27] Co-op @ Klaviyo - Applied + 3 emails
3. [Jan 26] Developer @ Google - Interviewed
4. [Jan 25] AI Engineer @ OpenAI - Applied
5. [Jan 24] Backend Dev @ Stripe - Rejected

Follow-ups Due: 5 applications
```

---

## Workflow 5: Interview Prep

**Trigger**: `/apply-job prep <company>`

```
1. Search applications.json for matching company name
   - If not found: "No application found for [company]"
   - If found: load application entry

2. Load materials:
   - Read ~/job-applier-agent/applications/<Company>/research.md
   - If no research exists, generate fresh (Phase 4 from Workflow 1)
   - Read the saved JD or re-navigate to application URL

3. Read user's master_resume.md for project details

4. Generate interview prep document:

   === Interview Prep: [Role] at [Company] ===
   Generated: [date]

   ## Company Overview
   [From research brief: what they do, recent news, tech stack]

   ## Technical Questions to Expect
   Based on JD requirements:

   ### [Required Skill 1] (e.g., Python)
   - Explain the difference between [concept A] and [concept B]
   - How would you optimize [relevant scenario]?
   - Describe your experience with [skill] in a project

   ### [Required Skill 2] (e.g., React)
   - Walk me through your component architecture approach
   - How do you handle state management in large apps?
   - What testing strategies do you use?

   ### System Design
   Based on [company domain], you might be asked:
   - Design a [relevant system matching company product]
   - Consider: scalability, caching, database choice

   ## Behavioral Questions (STAR Format)
   Based on JD soft skills (leadership, collaboration, etc.):

   Q: "Tell me about a time you led a technical project"
   Suggested STAR:
   - Situation: [from your CS Navigator project]
   - Task: [what you needed to accomplish]
   - Action: [what you did, technologies used]
   - Result: [800+ students, department-wide adoption]

   Q: "Describe a challenging bug you debugged"
   Suggested STAR:
   - [mapped to relevant resume experience]

   ## Your Talking Points
   Lead with: [most relevant project to this role]
   Key skills to highlight: [matched skills from ATS analysis]
   Connection: "[Your X experience] directly maps to [their Y need]"

   ## Questions to Ask Them
   - "What does the first 90 days look like for this role?"
   - "What's the biggest technical challenge your team faces?"
   - "How does the team approach code reviews and knowledge sharing?"
   - "What does growth/mentorship look like for junior engineers?"
   - [1-2 company-specific questions based on research]

5. Save to ~/job-applier-agent/applications/<Company>/interview_prep.md
6. Display full document to user
```

---

## Workflow 6: Follow-Up Reminders

**Trigger**: `/apply-job followup`

```
1. Read ~/job-applier-agent/data/applications.json
2. Get today's date

3. For each application where status = "applied":
   - days_since = today - applied_date
   - Categorize:
     OVERDUE: days_since >= 14 AND (follow_up_sent = true OR no outreach contacts)
     DUE: days_since >= 7 AND follow_up_sent = false
     RECENT: days_since < 7

4. Display:

   === Follow-Up Reminders ===
   Date: [today]

   OVERDUE - Need second follow-up (3):
   1. [Company A] - [Role] - Applied 16 days ago
      Contacts: jane@company.com, linkedin.com/in/jane
   2. [Company B] - [Role] - Applied 21 days ago
      Contacts: No recruiter found
   3. ...

   DUE - Send first follow-up (5):
   1. [Company C] - [Role] - Applied 8 days ago
      Contacts: john@company.com
   2. ...

   RECENT - No action needed (4):
   1. [Company D] - [Role] - Applied 2 days ago

5. For DUE items with email contacts:
   - Draft follow-up email:
     Subject: "Following Up - [Role] Application | [Name]"
     Body: Brief, polite follow-up referencing original application
   - Offer to send via Gmail
   - If sent, update follow_up_sent = true in applications.json

6. For OVERDUE items:
   - Draft second follow-up (shorter, more direct)
   - Or suggest moving status to "no_response" after 30 days
```

---

## Workflow 7: ATS Keyword Check

**Trigger**: `/apply-job ats-check <url>`

```
1. Navigate to job URL with Playwright
2. Extract full job description text

3. Parse keywords into categories:
   HARD SKILLS: [Python, React, AWS, Docker, PostgreSQL, ...]
   SOFT SKILLS: [leadership, communication, teamwork, ...]
   DOMAIN: [fintech, SaaS, e-commerce, ...]
   VERBS: [built, designed, scaled, optimized, deployed, ...]

4. Read ~/job-applier-agent/resume/master_resume.md

5. Match analysis:
   - For each keyword, check presence in resume
   - Handle common synonyms:
     JS/JavaScript, ML/Machine Learning, DB/Database,
     AWS/Amazon Web Services, k8s/Kubernetes, etc.

6. Display report:

   === ATS Keyword Analysis ===
   Job: [Title] at [Company]
   ATS Score: 74/100

   MATCHED (18/25 hard skills):
   Python, React, JavaScript, TypeScript, FastAPI,
   PostgreSQL, Docker, AWS, Git, REST APIs, ...

   MISSING FROM RESUME (7):
   Kubernetes, Terraform, Go, GraphQL, Redis,
   Kafka, Datadog

   SKILLS YOU HAVE BUT JD DOESN'T MENTION (5):
   LangChain, Pinecone, OpenAI, Tailwind, Vite

   SOFT SKILLS MATCHED: 4/6
   Missing: "cross-functional", "stakeholder management"

   RECOMMENDATIONS:
   1. Add "Redis" to skills if you have experience with it
   2. Mention "Kubernetes" if you've used it (even basic kubectl)
   3. Reword "[bullet]" to include "cross-functional collaboration"
   4. Your ATS score is GOOD - most systems pass at 70+

7. Do NOT apply. Just display the analysis.
```

---

## Workflow 8: Application Dedup

**Trigger**: `/apply-job dedup`

```
1. Read ~/job-applier-agent/data/applications.json

2. Check for duplicates:

   a. Exact URL matches:
      - Group applications by URL
      - Flag any URL appearing 2+ times

   b. Fuzzy role match (same company):
      - Group by company name
      - Within each company, compare role titles
      - Flag if titles are similar:
        "Software Engineer" vs "Software Developer" = similar
        "Software Engineer" vs "Data Scientist" = different
      - Use word overlap: if 50%+ words match, flag as similar

   c. Recent re-applications:
      - Same company applied within 30 days = flag

3. Display:

   === Duplicate Application Check ===

   EXACT DUPLICATES (same URL): 0

   SIMILAR ROLES (same company, similar title): 2
   1. Stripe:
      - "Software Engineer" (applied Jan 15) [ID: stripe-0115-001]
      - "Software Developer" (applied Jan 22) [ID: stripe-0122-001]
      Recommendation: These are likely the same role

   2. Google:
      - "Backend Engineer" (applied Jan 10)
      - "Backend Developer" (applied Feb 5)
      Recommendation: 26 days apart, might be different postings

   CLEAN: 45 applications have no duplicates

4. For each flagged pair, ask user:
   - Keep both?
   - Remove the older one?
   - Remove the newer one?

5. Update applications.json if user chooses to remove
```

---

## Workflow 9: Weekly Analytics

**Trigger**: `/apply-job status weekly`

```
1. Read ~/job-applier-agent/data/applications.json
2. Get today's date, calculate 7-day window

3. Segment applications:
   - this_week: applied_date within last 7 days
   - all_time: all applications

4. Calculate metrics:
   - Applications this week vs last week (trend)
   - Response rate: (interviewed + offers) / total
   - Category breakdown: count by category field
   - Category response rates: responses per category
   - Outreach effectiveness: emails sent vs responses
   - Score distributions: fit score and ATS score averages

5. Generate recommendations based on data:
   - If AI/ML roles have highest response rate:
     "Focus on AI/ML roles - 3x higher response rate"
   - If avg ATS score < 70:
     "Your ATS scores are below 70 avg - run /apply-job ats-check more"
   - If follow-ups are overdue:
     "You have X follow-ups due - run /apply-job followup"
   - If no applications this week:
     "No applications this week. Try: /apply-job search [suggestion]"

6. Display:

   === Weekly Job Search Analytics ===
   Period: [date] to [date]

   This Week:
   - Applications: 12 (up from 8 last week)
   - Emails sent: 8
   - Connections sent: 12

   All Time:
   - Total: 47 | Applied: 42 | Interviewing: 3
   - Rejected: 2 | Offers: 0
   - Response Rate: 12%

   By Category:
   - AI/ML: 8 apps, 25% response rate
   - Backend: 15 apps, 10% response rate
   - Frontend: 10 apps, 5% response rate
   - Fullstack: 9 apps, 11% response rate
   - DevOps: 5 apps, 0% response rate

   Scores:
   - Avg Fit Score: 7.2/10
   - Avg ATS Score: 74/100

   Recommendations:
   1. AI/ML roles are performing best - apply to more
   2. 5 follow-ups are overdue
   3. Consider dropping DevOps roles (0% response)
```

---

## Recruiter Outreach Details

### Order: Email FIRST, LinkedIn SECOND

### Step 1: Find Recruiters on LinkedIn

```
1. Navigate to LinkedIn
2. Search: "<company> recruiter" or "<company> talent acquisition"
3. Find 3+ people with titles:
   - Technical Recruiter
   - Talent Acquisition
   - University Recruiter
   - Recruiting Coordinator
   - Engineering Manager (backup)
4. Extract for each:
   - Full name
   - Title
   - LinkedIn URL
```

### Step 2: Find Recruiter Contact Info

```
1. Check each recruiter's LinkedIn profile for public email/contact info
2. Check the company careers page for recruiter contact details
3. Look for the company's public contact or referral form
4. Only use publicly listed contact information
```

### Step 3: Send Cold Emails (PRIMARY)

```
1. Open Gmail: https://mail.google.com
2. Click Compose
3. Fill fields:
   - To: discovered email
   - Subject: "Referral Request - [Role] Application | [School] Senior"
   - Body: Use cold email template from profile
4. Confirm with user, then send
5. Track: email_sent=true, email_date=today
```

### Step 4: Send LinkedIn Connections (SECONDARY)

**Only after ALL emails are sent!**

```
1. Navigate to recruiter's LinkedIn profile
2. Click "More" button
3. Click "Connect"
4. Send WITHOUT note (faster, still effective)
5. Track: connection_sent=true
```

### Step 5: Update Tracking

```json
"outreach": [
  {
    "name": "Jane Doe",
    "title": "Technical Recruiter",
    "email": "jdoe@company.com",
    "linkedin": "linkedin.com/in/janedoe",
    "email_sent": true,
    "email_date": "2026-01-27",
    "connection_sent": true,
    "connection_date": "2026-01-27"
  }
]
```

---

## Platform-Specific Instructions

### LinkedIn Easy Apply
```
1. Click "Easy Apply" button
2. Modal appears with steps
3. Fill contact info from profile.json
4. Upload resume when prompted
5. Answer screening questions from profile.json.application_defaults
6. Review and submit
```

### Greenhouse
```
1. Usually embedded form on company site
2. Standard fields: name, email, phone, resume, cover letter
3. Often has custom questions
4. Look for "Submit Application" button
```

### Lever
```
1. Clean single-page form
2. Resume upload + basic info
3. Optional cover letter field
4. Custom questions at bottom
```

### Workday
```
1. Requires account creation (notify user)
2. Multi-step wizard
3. Extensive form fields
4. May auto-parse resume (verify accuracy)
```

### ADP
```
1. Multi-step application
2. Often has preliminary questions first
3. May have location/relocation questions
4. eSignature required at end
```

### Custom Company Portals
```
1. Use browser_snapshot to identify all fields
2. Map to profile.json data
3. Handle custom questions as best as possible
4. Screenshot before submit
```

---

## Follow-Up Email Template

```
Subject: Following Up - [Role] Application | [Name]

Hi [First Name],

I applied for the [Role] position at [Company] [X days] ago
and wanted to follow up on my application.

I remain very excited about [specific thing from company research].
My experience with [relevant project/skill] aligns well with what
your team is building.

Happy to share any additional information. Looking forward to
hearing from you.

Best,
[Name]
[Website]
[Phone]
```

---

## Error Recovery

| Situation | Recovery |
|-----------|----------|
| Login wall | Notify user, wait for "continue" |
| CAPTCHA | Notify user, wait for manual solve |
| Rate limited | Wait 60s, retry once, skip if blocked |
| Form field not found | Screenshot, ask user to identify |
| Email bounce | Log failure, continue with others |
| LinkedIn limit | Note in tracking, try again tomorrow |
| Duplicate found | Show previous app, ask to proceed |
| Dealbreaker | Show reason, default to skip |
| ATS score < 60 | Warn user, suggest improvements, still proceed |
