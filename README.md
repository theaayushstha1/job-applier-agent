# Job Application Agent

Automated job applications with Claude Code. Apply to 100+ jobs with personalized resumes, cover letters, and recruiter outreach.

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
| `/apply-job <url>` | Apply to a specific job |
| `/apply-job search <query>` | Search and batch apply |
| `/apply-job outreach <url>` | Send recruiter emails + LinkedIn |
| `/apply-job status` | View your application stats |
| `/apply-job score <url>` | Score job fit without applying |

## What It Does

- Extracts job description from any URL
- Scores job fit (skills match, level, location)
- Tailors your resume to match the JD
- Generates personalized cover letter
- Auto-fills applications (LinkedIn, Greenhouse, Lever, Workday)
- Sends cold emails to recruiters (primary)
- Sends LinkedIn connection requests (secondary)
- Tracks everything in `applications.json`

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

## Privacy

- All data stays local
- No external servers
- Emails sent from YOUR account

## License

MIT
