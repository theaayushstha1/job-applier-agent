# Job Application Agent

🤖 Automated job applications with Claude Code. Apply to 100+ jobs with personalized resumes, cover letters, and recruiter outreach.

## Install

### Option 1: skills.sh (Recommended)
```bash
npx skills add theaayushstha1/job-applier-agent
```

### Option 2: Manual Install
```bash
curl -fsSL https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main/install.sh | bash
```

## Setup (2 Minutes)

### 1. Edit your profile
```bash
nano ~/job-applier-agent/data/profile.json
```
Fill in your name, email, phone, skills, education, etc.

### 2. Add your resume
```bash
cp ~/Downloads/YourResume.pdf ~/job-applier-agent/resume/MyResume.pdf
```

### 3. Start applying
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

1. **Extracts** job description from any URL
2. **Scores** job fit (skills match, level, location)
3. **Tailors** your resume to match the JD
4. **Generates** personalized cover letter
5. **Auto-fills** application forms (LinkedIn, Greenhouse, Lever, etc.)
6. **Sends emails** to recruiters (primary outreach)
7. **Sends LinkedIn** connection requests (secondary)
8. **Tracks** everything in `applications.json`

## Requirements

- [Claude Code](https://claude.ai/code) CLI installed
- [Playwright MCP](https://www.npmjs.com/package/@anthropic/mcp-playwright) for browser automation
- Gmail account (for sending emails)
- LinkedIn account (for recruiter search)

### Playwright MCP Setup

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

## File Structure

```
~/job-applier-agent/
├── data/
│   ├── profile.json        ← Your info (edit this!)
│   └── applications.json   ← Application tracking
├── resume/
│   └── MyResume.pdf        ← Your resume
├── templates/
│   ├── cover_letter.md     ← Cover letter template
│   └── cold_email.md       ← Email template
├── applications/           ← Generated files per company
└── screenshots/            ← Confirmation screenshots
```

## Privacy

- ✅ All data stays local on your machine
- ✅ `profile.json` contains your info (gitignored)
- ✅ Emails sent from YOUR Gmail account
- ✅ No external servers or tracking

## Tags

`claude-code` `job-search` `automation` `ai-agent` `linkedin` `resume` `cover-letter` `recruiter-outreach` `playwright` `mcp`

## License

MIT - Use it, modify it, share it.

---

**Made for the grind.** 💪
