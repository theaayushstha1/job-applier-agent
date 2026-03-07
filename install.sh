#!/bin/bash
# Job Application Agent - Installer
# Works on macOS, Linux, and Windows (Git Bash/WSL)

set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/theaayushstha1/job-applier-agent/main"

echo "Installing Job Application Agent..."

# Create directories
mkdir -p ~/job-applier-agent/{data,resume,templates,applications,screenshots}
mkdir -p ~/.claude/skills/apply-job

# Download skill files (verify HTTP status)
echo "Downloading skill files..."
for file in SKILL.md WORKFLOWS.md SETUP.md profile-template.json; do
  http_code=$(curl -fsSL -w "%{http_code}" -o ~/.claude/skills/apply-job/"$file" "$REPO_URL/skills/apply-job/$file")
  if [ "$http_code" -ne 200 ]; then
    echo "ERROR: Failed to download $file (HTTP $http_code)"
    exit 1
  fi
done

# Download templates
echo "Setting up templates..."
for file in cover_letter.md cold_email.md; do
  http_code=$(curl -fsSL -w "%{http_code}" -o ~/job-applier-agent/templates/"$file" "$REPO_URL/templates/$file")
  if [ "$http_code" -ne 200 ]; then
    echo "ERROR: Failed to download $file (HTTP $http_code)"
    exit 1
  fi
done

# Create profile from template (don't overwrite existing)
if [ ! -f ~/job-applier-agent/data/profile.json ]; then
    cp ~/.claude/skills/apply-job/profile-template.json ~/job-applier-agent/data/profile.json
fi

# Create empty applications tracker (don't overwrite existing)
if [ ! -f ~/job-applier-agent/data/applications.json ]; then
    echo '{"applications":[],"stats":{"total":0,"applied":0,"interviewed":0,"emailsSent":0,"connectionsSent":0}}' > ~/job-applier-agent/data/applications.json
fi

# Create placeholder resume (don't overwrite existing)
if [ ! -f ~/job-applier-agent/resume/master_resume.md ]; then
    printf "# Your Resume\n\nAdd your full resume content here for tailoring.\n" > ~/job-applier-agent/resume/master_resume.md
fi

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "   1. Edit your profile: nano ~/job-applier-agent/data/profile.json"
echo "   2. Add your resume:   cp ~/Downloads/resume.pdf ~/job-applier-agent/resume/"
echo "   3. Start Claude:      claude"
echo "   4. Apply to jobs:     /apply-job <job-url>"
echo ""
