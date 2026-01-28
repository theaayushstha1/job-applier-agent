#!/bin/bash
# Job Application Agent - One-Line Installer
# Works on macOS, Linux, and Windows (Git Bash/WSL)

set -e

echo "🚀 Installing Job Application Agent..."

# Create directories
mkdir -p ~/job-applier-agent/{data,resume,templates,applications,screenshots}
mkdir -p ~/.claude/skills/apply-job

# Download skill files
echo "📥 Downloading skill files..."
curl -fsSL "https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main/skill/SKILL.md" -o ~/.claude/skills/apply-job/SKILL.md
curl -fsSL "https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main/skill/WORKFLOWS.md" -o ~/.claude/skills/apply-job/WORKFLOWS.md
curl -fsSL "https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main/skill/SETUP.md" -o ~/.claude/skills/apply-job/SETUP.md
curl -fsSL "https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main/skill/profile-template.json" -o ~/.claude/skills/apply-job/profile-template.json

# Download templates
echo "📝 Setting up templates..."
curl -fsSL "https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main/templates/cover_letter.md" -o ~/job-applier-agent/templates/cover_letter.md
curl -fsSL "https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main/templates/cold_email.md" -o ~/job-applier-agent/templates/cold_email.md

# Create profile from template
if [ ! -f ~/job-applier-agent/data/profile.json ]; then
    cp ~/.claude/skills/apply-job/profile-template.json ~/job-applier-agent/data/profile.json
fi

# Create empty applications tracker
if [ ! -f ~/job-applier-agent/data/applications.json ]; then
    echo '{"applications":[],"stats":{"total":0,"applied":0,"interviewed":0,"emailsSent":0,"connectionsSent":0}}' > ~/job-applier-agent/data/applications.json
fi

# Create placeholder resume
if [ ! -f ~/job-applier-agent/resume/master_resume.md ]; then
    echo "# Your Resume\n\nAdd your full resume content here for tailoring." > ~/job-applier-agent/resume/master_resume.md
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Edit your profile: nano ~/job-applier-agent/data/profile.json"
echo "   2. Add your resume:   cp ~/Downloads/resume.pdf ~/job-applier-agent/resume/"
echo "   3. Start Claude:      claude"
echo "   4. Apply to jobs:     /apply-job <job-url>"
echo ""
