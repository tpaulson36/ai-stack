# Backup & Sync Strategy
`~/Documents/sync.md`

How to move your entire AI dev environment to a new Mac in minutes.

---

## What Gets Backed Up vs Rebuilt

| What | Backup Method | Restore Method |
|------|--------------|----------------|
| READMEs, configs, scripts | Git repo or cloud sync | Already there after sync |
| Cloned plugin repos | **Not backed up** | `bootstrap.sh` re-clones |
| Installed CLIs (vercel, etc.) | **Not backed up** | `bootstrap.sh` reinstalls |
| MCP servers | **Not backed up** | `bootstrap.sh` rebuilds |
| Python/Node packages | **Not backed up** | `bootstrap.sh` reinstalls |
| Shell aliases | Tracked in `CLIs/*/aliases.sh` | `bootstrap.sh` re-sources |
| `~/.claude/CLAUDE.md` | Backed up separately (see below) | Copy on new machine |
| API tokens / secrets | **Never backed up** | Re-enter manually |

---

## Option A — Private Git Repo (Recommended)

The cleanest solution. Your `~/Documents/` folder becomes a private git repo.
The `.gitignore` already excludes all cloned repos and secrets — only your
READMEs, scripts, and configs are committed.

### First-time setup (this machine)

```bash
cd ~/Documents
git init
git add .
git commit -m "Initial Documents setup"

# Create a private repo on GitHub (CLI)
gh repo create documents-hub --private --source=. --push

# Or manually on github.com, then:
git remote add origin https://github.com/YOUR_USERNAME/documents-hub.git
git push -u origin main
```

### On a new machine

```bash
# 1. Clone your repo
git clone https://github.com/YOUR_USERNAME/documents-hub.git ~/Documents

# 2. Run bootstrap to rebuild everything else
chmod +x ~/Documents/bootstrap.sh
~/Documents/bootstrap.sh

# 3. Re-enter API tokens in .claude/settings.json
# 4. source ~/.zshrc
```

**That's it.** Two commands and you're fully operational.

### Keeping it updated

After adding a new README, tool, or config:
```bash
cd ~/Documents
git add .
git commit -m "Add SuperPowers agent commands"
git push
```

On your other machine:
```bash
cd ~/Documents
git pull
# If new tools were added, run bootstrap again — it skips already-installed items
~/Documents/bootstrap.sh
```

---

## Option B — iCloud Drive (Easiest, no git required)

Move `~/Documents/` to iCloud Drive so it auto-syncs across all your Macs.

### Setup

```bash
# macOS already syncs ~/Documents if iCloud Drive is on
# Enable: System Settings → Apple ID → iCloud → iCloud Drive → Desktop & Documents Folders
```

### On a new Mac

```bash
# 1. Sign in to iCloud — ~/Documents syncs automatically
# 2. Wait for sync to complete, then:
chmod +x ~/Documents/bootstrap.sh
~/Documents/bootstrap.sh
```

**Tradeoff:** iCloud syncs everything including large cloned repos (which the git
approach excludes via .gitignore). Expect a larger sync on first setup.
**Fix:** Add the Plugins folder to iCloud's excluded list, or use Option A instead.

---

## Option C — Dropbox / OneDrive

Same as iCloud but cross-platform (works on Windows too if needed).

```bash
# Move Documents to your Dropbox folder
mv ~/Documents ~/Dropbox/Documents
ln -s ~/Dropbox/Documents ~/Documents  # keep the ~/Documents path working
```

---

## Also Back Up: `~/.claude/`

Your global Claude config lives outside `~/Documents/` and needs separate backup.

```bash
# Add to your git repo as a separate folder, or just copy it
cp -r ~/.claude ~/Documents/claude-config/   # then commit this
```

What's in `~/.claude/`:
```
~/.claude/
├── CLAUDE.md          ← Your global preferences + NEVER rules
├── settings.json      ← Global tool permissions
└── projects/          ← Auto-memory per project (large, skip backup)
```

Add `claude-config/projects/` to `.gitignore` — the auto-memory folder gets large.

---

## Tokens & Secrets — Manual Step on Every New Machine

These are **never** synced or committed. Re-enter them after bootstrap:

| Token | Where to get it | Where to put it |
|-------|----------------|-----------------|
| `VERCEL_TOKEN` | vercel.com/account/tokens | `.claude/settings.json` → mcpServers.vercel.env |
| `GITHUB_TOKEN` | github.com/settings/tokens | `.claude/settings.json` → mcpServers.github.env |
| `SUPABASE_URL` | supabase.com project settings | `.claude/settings.json` → mcpServers.supabase.env |
| `SUPABASE_SERVICE_KEY` | supabase.com project settings | `.claude/settings.json` → mcpServers.supabase.env |
| Anthropic API key | console.anthropic.com | Claude Code handles this on first `claude` run |

**Never put tokens in `bootstrap.sh` or any committed file.**

---

## Quick Reference — New Machine Checklist

```
□ Clone documents-hub repo (or wait for iCloud sync)
□ chmod +x ~/Documents/bootstrap.sh
□ ~/Documents/bootstrap.sh
□ source ~/.zshrc
□ vercel login
□ gh auth login
□ letta server (start memory server)
□ Add tokens to .claude/settings.json
□ Verify: node --version && vercel --version && claude --version
```

---

## Keeping Bootstrap Fresh

When you add a new tool to your environment, add it to `bootstrap.sh`:

```bash
# Template for adding a new CLI
if ! command -v <tool> &>/dev/null; then
  info "Installing <tool>..."
  npm install -g <package>
  success "<tool> installed"
else
  skip "<tool>"
fi

# Template for adding a new plugin repo
clone_plugin "<FolderName>" "<org/repo>"
```

Then commit the updated `bootstrap.sh`:
```bash
cd ~/Documents
git add bootstrap.sh
git commit -m "Add <tool> to bootstrap"
git push
```
