# Cold Email Template

## Subject Line
Referral Request - [Role] Application | [School] [Major] Senior

## Body

Hi [First Name],

I just applied for the [Role] position at [Company] and wanted to reach out directly.

I'm a [Major] senior at [School] ([GPA] GPA) graduating [Graduation]. I built [Project Name], [brief description with metrics].

[1-2 sentences about why THIS company/role excites you - be specific]

I'd really appreciate it if you could take a look at my application or put in a referral. Happy to chat anytime.

Thanks for your time!

[Your Name]
[Your Website]
[Your Phone]

---

## Template Variables

| Variable | Source |
|----------|--------|
| `[First Name]` | Hiring manager's first name (from LinkedIn) |
| `[Role]` | Job title |
| `[Company]` | Company name |
| `[Major]` | profile.json → education.major |
| `[School]` | profile.json → education.school |
| `[GPA]` | profile.json → education.gpa |
| `[Graduation]` | profile.json → education.graduation |
| `[Project Name]` | profile.json → flagship_project.name |
| `[Your Name]` | profile.json → personal.name |
| `[Your Website]` | profile.json → links.website |
| `[Your Phone]` | profile.json → personal.phone |

## Rules

1. **Keep under 150 words** - Recruiters are busy
2. **Personalize the company line** - Show you did research
3. **Always include contact info** - Website and phone
4. **Professional but friendly** - Not too formal
5. **One clear ask** - Referral or application review
