# Detailed Workflows Reference

This file contains step-by-step workflows for the job application agent.

## Table of Contents
- [Workflow 1: Full Application](#workflow-1-full-application)
- [Workflow 2: Search and Batch Apply](#workflow-2-search-and-batch-apply)
- [Workflow 3: Outreach Only](#workflow-3-outreach-only)
- [Workflow 4: Status Report](#workflow-4-status-report)
- [Recruiter Outreach Details](#recruiter-outreach-details)
- [Platform-Specific Instructions](#platform-specific-instructions)

---

## Workflow 1: Full Application

**Trigger**: `/apply-job <url>`

### Phase 1: Extract & Score

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
   - Salary (if listed)

3. Score job fit (0-10 each):
   - Technical Fit: (matching skills / required skills) * 10
   - Level Match: Entry=10, Mid=7, Senior=3 for new grads
   - Location: Remote=10, Preferred city=8, Relocation=5
   - Mission: AI/Tech=10, Other=5

4. Calculate average score
   - >= 5.0: AUTO-PROCEED
   - < 5.0: Notify user, wait for confirmation
```

### Phase 2: Prepare Materials

**IMPORTANT:** Follow [formatting_rules.md](../../resume/formatting_rules.md) exactly for resume tailoring!

```
1. Read profile from ~/job-applier-agent/data/profile.json

2. Tailor resume (CRITICAL - follow formatting_rules.md):
   a. Copy master Python script (create_resume.py)
   b. Analyze JD and extract:
      - Required technologies (Python, React, etc.)
      - Nice-to-have technologies
      - Scale/performance language ("billions", "high-traffic")
      - Domain keywords (AI, data pipelines, etc.)
   c. Modify CONTENT ONLY in the copied script:
      - Reword bullets to match JD terminology
      - Bold technologies that match JD exactly
      - Reorder skills section (JD technologies first)
      - Reorder projects (most relevant first)
      - Add power words matching JD focus:
        * Scale: "high-traffic", "thousands of requests"
        * Performance: "sub-second", "reduced latency"
        * Data: "data pipelines", "real-time"
        * AI: "AI-powered", "LLMs", "ML models"
   d. NEVER modify: functions, margins, fonts, spacing
   e. Save script to ~/job-applier-agent/applications/<Company>/
   f. Generate DOCX: python create_<company>_resume.py

3. Generate cover letter:
   - Read ~/job-applier-agent/templates/cover_letter.md
   - WebFetch company website for context
   - Fill template with:
     - Company name, role
     - Why THIS company (specific reason)
     - Relevant project from your experience
   - Save to ~/job-applier-agent/applications/<Company>/cover_letter.txt
```

### Phase 3: Submit Application

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

4. Submit application (AUTO-PROCEED)

5. Take confirmation screenshot
   - Save to ~/job-applier-agent/screenshots/<company>_<date>.png
```

### Phase 4: Track & Outreach

```
1. Update ~/job-applier-agent/data/applications.json:
   - Add new application entry
   - Update stats

2. Execute recruiter outreach (see below)
```

---

## Workflow 2: Search and Batch Apply

**Trigger**: `/apply-job search <query>`

```
1. Search for jobs:
   - WebSearch: "<query> jobs 2026"
   - WebSearch: "<query> new grad"
   - WebSearch: "<query> entry level"

2. Collect job URLs from results

3. For each URL, quick score:
   - Navigate, extract basic info
   - Calculate fit score
   - Store in list

4. Rank by fit score, display to user:

   Found 15 matching jobs:
   1. [9.2] Software Engineer @ Google - Remote
   2. [8.5] AI Intern @ OpenAI - SF
   3. [7.8] Backend Dev @ Stripe - NYC
   ...

5. AUTO-PROCEED with top 10 (or user-specified number)

6. For each selected job:
   - Run full Workflow 1
   - Continue even if one fails
   - Track all results

7. Report summary at end
```

---

## Workflow 3: Outreach Only

**Trigger**: `/apply-job outreach <url>`

Run ONLY the outreach portion for an already-applied job:

```
1. Extract company name from URL
2. Find recruiters (see below)
3. Discover emails
4. Send cold emails
5. Send LinkedIn connections
6. Track in applications.json
```

---

## Workflow 4: Status Report

**Trigger**: `/apply-job status`

```
Read ~/job-applier-agent/data/applications.json

Display:

=== Job Application Status ===

Total Applications: 47
├── Applied: 42
├── Interviewed: 3
├── Rejected: 2
└── Offers: 0

Outreach Stats:
├── Emails Sent: 28
├── LinkedIn Connections: 45
└── Response Rate: 12%

Recent Applications:
1. [Jan 27] Software Engineer @ Epic - Applied + 2 emails
2. [Jan 27] Co-op @ Klaviyo - Applied + 3 emails
3. [Jan 26] Developer @ Google - Interviewed

Average Fit Score: 7.2
```

---

## Recruiter Outreach Details

### ⚠️ ORDER IS CRITICAL: Email FIRST, LinkedIn SECOND

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
4. Send (AUTO-PROCEED)
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
5. Answer screening questions:
   - Use profile.json.application_defaults
   - Work authorization: profile.json.work_authorization
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

## Gmail Automation

### Composing Email

```javascript
// Click compose
await page.locator('[aria-label="Compose"]').click();

// Fill To field (click and type)
await page.locator('[name="to"]').click();
await page.keyboard.type('email@company.com');
await page.keyboard.press('Tab');

// Fill Subject
await page.locator('[name="subjectbox"]').click();
await page.keyboard.type('Subject line here');
await page.keyboard.press('Tab');

// Fill Body (click Message Body, then type)
await page.locator('[aria-label="Message Body"]').click();
await page.keyboard.type('Email body here');

// Send (Ctrl+Enter or click Send)
await page.keyboard.press('Control+Enter');
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

---

**Line Count**: ~300 (under 500 for reference file)
