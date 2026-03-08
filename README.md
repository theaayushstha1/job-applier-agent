# Job Application Agent

Automated job applications with Claude Code. Apply to jobs with personalized resumes, cover letters, recruiter outreach, ATS optimization, interview prep, and smart analytics.

## Install (One Command)

```bash
npx skills add theaayushstha1/job-applier-agent
```

## Setup

**1. Edit your profile:**
```bash
nano ~/job-applier-agent/data/profile.json
```

**2. Add your resume:**
```bash
cp ~/Downloads/YourResume.pdf ~/job-applier-agent/resume/MyResume.pdf
```

**3. Start applying:**
```bash
claude
/apply-job https://linkedin.com/jobs/view/123456
```

## Commands

| Command | What it does |
|---------|--------------|
| `/apply-job <url>` | Full application workflow with ATS analysis |
| `/apply-job search <query>` | Smart batch apply with dedup + dealbreaker filtering |
| `/apply-job outreach <url>` | Send recruiter emails + LinkedIn |
| `/apply-job status` | View your application stats |
| `/apply-job status weekly` | Weekly analytics with response rates by category |
| `/apply-job score <url>` | Score job fit without applying |
| `/apply-job prep <company>` | Interview prep with technical Qs, STAR answers, talking points |
| `/apply-job followup` | Check which applications need follow-up emails |
| `/apply-job ats-check <url>` | ATS keyword match analysis without applying |
| `/apply-job dedup` | Find and clean up duplicate applications |

## What It Does

**Core Application Flow:**
- Extracts job description from any URL
- Detects dealbreakers (clearance, senior level, 5+ years) before wasting your time
- Scores job fit (skills match, level, location, mission)
- Runs ATS keyword analysis (match score out of 100)
- Researches the company (news, Glassdoor, tech stack)
- Tailors your resume to match the JD
- Generates personalized cover letter using company research
- Auto-fills applications (LinkedIn, Greenhouse, Lever, Workday, ADP)
- Sends cold emails to recruiters (primary)
- Sends LinkedIn connection requests (secondary)
- Sets 7-day follow-up reminders
- Tracks everything in `applications.json`

**Interview Prep:**
- Generates technical questions based on the JD
- Writes STAR format behavioral answers using YOUR resume projects
- Creates talking points and questions to ask
- Saves prep docs per company

**Smart Analytics:**
- Weekly digest with response rates by role category
- Tracks which types of roles get the most callbacks
- Data-driven recommendations on where to focus
- Follow-up reminder system so nothing falls through the cracks

**Batch Apply Intelligence:**
- Auto-filters out jobs you already applied to
- Auto-skips dealbreaker jobs (clearance, senior level, etc.)
- Sorts by fit score, applies to best matches first

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- [Playwright MCP](https://www.npmjs.com/package/@anthropic/mcp-playwright) for browser automation

Add to `~/.claude/settings.json`:
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@anthropic/mcp-playwright"]
    }
  }
}
```

## Security and Privacy

- **No credentials stored**: The skill uses your existing browser sessions (Gmail, LinkedIn). No passwords or tokens are saved.
- **All data stays local**: Profile data, applications tracking, and generated files are stored on your machine only.
- **No external servers**: No data is sent to any third-party service. Emails go through your own Gmail account.
- **User confirmation required**: The skill confirms before submitting applications, sending emails, or sending LinkedIn requests.
- **Input sanitization**: Job descriptions are treated as untrusted input and used only for text comparison (keyword matching, scoring). No JD content is executed as code.
- **Public info only**: Recruiter contact discovery uses only publicly available information from LinkedIn profiles and company career pages.
- **No shell execution**: The skill does not use Bash or any shell execution tools. All operations use safe, scoped tool calls (file read/write, browser navigation).

## License

MIT
