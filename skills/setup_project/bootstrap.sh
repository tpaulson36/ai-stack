#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh
# ~/Documents/bootstrap.sh
#
# Full environment rebuild for any new Mac.
# Run once after syncing ~/Documents/ to a new machine.
#
# Usage:
#   chmod +x ~/Documents/bootstrap.sh
#   ~/Documents/bootstrap.sh
#
# Safe to re-run — all steps are idempotent (skips already-installed tools).
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ── Helpers ───────────────────────────────────────────────────────────────────
header()  { echo -e "\n${BOLD}${BLUE}▶ $1${NC}"; }
success() { echo -e "  ${GREEN}✓${NC} $1"; }
skip()    { echo -e "  ${YELLOW}↷${NC} $1 (already installed)"; }
info()    { echo -e "  ${BLUE}→${NC} $1"; }
warn()    { echo -e "  ${RED}⚠${NC} $1"; }

DOCS="$HOME/Documents"

echo -e "${BOLD}"
echo "╔══════════════════════════════════════════╗"
echo "║        Documents Bootstrap Script        ║"
echo "║   Rebuilds full AI dev environment       ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# =============================================================================
# STEP 1 — System Prerequisites
# =============================================================================
header "System Prerequisites"

# Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "  Press any key once the installer finishes, then re-run this script."
  read -n 1
  exit 0
else
  skip "Xcode Command Line Tools"
fi

# Homebrew
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew installed"
else
  skip "Homebrew"
fi

# Node.js (via nvm)
if ! command -v nvm &>/dev/null && [[ ! -d "$HOME/.nvm" ]]; then
  info "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts
  success "nvm + Node.js LTS installed"
else
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  skip "nvm"
fi

# pnpm
if ! command -v pnpm &>/dev/null; then
  info "Installing pnpm..."
  npm install -g pnpm
  success "pnpm installed"
else
  skip "pnpm"
fi

# Python (via pyenv)
if ! command -v pyenv &>/dev/null; then
  info "Installing pyenv..."
  brew install pyenv
  pyenv install 3.12.0 --skip-existing
  pyenv global 3.12.0
  success "pyenv + Python 3.12 installed"
else
  skip "pyenv"
fi

# pip
if ! command -v pip3 &>/dev/null; then
  info "Installing pip..."
  python3 -m ensurepip --upgrade
  success "pip installed"
else
  skip "pip"
fi

# Git
if ! command -v git &>/dev/null; then
  brew install git
  success "git installed"
else
  skip "git"
fi

# GitHub CLI
if ! command -v gh &>/dev/null; then
  info "Installing GitHub CLI..."
  brew install gh
  success "gh installed"
else
  skip "gh"
fi

# Docker (optional — for Zep and other containerized tools)
if ! command -v docker &>/dev/null; then
  warn "Docker not found. Install Docker Desktop manually: https://www.docker.com/products/docker-desktop"
  warn "Required for: any containerized MCP servers"
else
  skip "Docker"
fi

# =============================================================================
# STEP 2 — Global CLI Tools
# =============================================================================
header "Global CLI Tools"

# vercel
if ! command -v vercel &>/dev/null; then
  info "Installing vercel CLI..."
  npm install -g vercel
  success "vercel installed"
else
  skip "vercel"
fi

# astro
if ! command -v astro &>/dev/null; then
  info "Installing astro CLI..."
  npm install -g astro
  success "astro installed"
else
  skip "astro"
fi

# GSD (Get Shit Done)
if ! command -v get-shit-done-cc &>/dev/null; then
  info "Installing get-shit-done-cc globally..."
  npm install -g get-shit-done-cc
  success "get-shit-done-cc installed"
else
  skip "get-shit-done-cc"
fi

# shadcn — runs via npx, no global install needed
info "shadcn runs via: npx shadcn@latest — no global install needed"

# =============================================================================
# STEP 3 — CLIs (~/Documents/CLIs/)
# =============================================================================
header "CLIs (~/Documents/CLIs/)"

CLI_DIR="$DOCS/CLIs"

clone_cli() {
  local folder="$1"
  local repo="$2"
  local dest="$CLI_DIR/$folder/$(basename "$repo" .git)"
  if [[ ! -d "$dest/.git" ]]; then
    info "Cloning $repo into CLIs/$folder/..."
    mkdir -p "$CLI_DIR/$folder"
    git clone --depth=1 "https://github.com/$repo.git" "$dest"
    success "$folder cloned"
  else
    skip "$folder"
  fi
}

clone_cli "Gemini_CLI" "google-gemini/gemini-cli"
clone_cli "GoogleWorkspace_CLI" "googleworkspace/google-workspace-mcp"
clone_cli "PlayWright_CLI" "microsoft/playwright"

# PlayWright_CLI — install dependencies if present
PLAYWRIGHT_DIR="$CLI_DIR/PlayWright_CLI"
if [[ -d "$PLAYWRIGHT_DIR" ]] && [[ -f "$PLAYWRIGHT_DIR/package.json" ]]; then
  info "Installing PlayWright_CLI dependencies..."
  (cd "$PLAYWRIGHT_DIR" && npm install)
  success "PlayWright_CLI dependencies installed"
fi

# =============================================================================
# STEP 4 — MCP Servers (~/Documents/MCPs/)
# =============================================================================
header "MCP Servers (~/Documents/MCPs/)"

MCP_DIR="$DOCS/MCPs"

clone_mcp() {
  local folder="$1"
  local repo="$2"
  local dest="$MCP_DIR/$folder/$(basename "$repo" .git)"
  if [[ ! -d "$dest/.git" ]]; then
    info "Cloning $repo..."
    mkdir -p "$MCP_DIR/$folder"
    git clone --depth=1 "https://github.com/$repo.git" "$dest"
    success "$folder MCP cloned"
  else
    skip "$folder MCP"
  fi
}

# Blender MCP (clones directly into Blender_MCP/ — no subfolder)
BLENDER_MCP_DEST="$MCP_DIR/Blender_MCP"
if [[ ! -d "$BLENDER_MCP_DEST/.git" ]]; then
  info "Cloning Blender MCP..."
  git clone --depth=1 https://github.com/ahujasid/blender-mcp.git "$BLENDER_MCP_DEST"
  success "Blender MCP cloned"
  if [[ -f "$BLENDER_MCP_DEST/pyproject.toml" ]] || [[ -f "$BLENDER_MCP_DEST/requirements.txt" ]]; then
    info "Installing Blender MCP Python dependencies..."
    pip3 install -e "$BLENDER_MCP_DEST" 2>/dev/null || pip3 install -r "$BLENDER_MCP_DEST/requirements.txt" 2>/dev/null || true
  fi
else
  skip "Blender MCP"
fi

# Unreal Engine MCP (clones directly into Unreal_Engine_MCP/ — no subfolder)
UNREAL_MCP_DEST="$MCP_DIR/Unreal_Engine_MCP"
if [[ ! -d "$UNREAL_MCP_DEST/.git" ]]; then
  info "Cloning Unreal Engine MCP..."
  git clone --depth=1 https://github.com/flopperam/unreal-engine-mcp.git "$UNREAL_MCP_DEST"
  success "Unreal Engine MCP cloned"
else
  skip "Unreal Engine MCP"
fi

# Google Workspace MCP
clone_mcp "GoogleWorkspace_MCP" "googleworkspace/mcp-google-workspace"

# NotebookLM MCP
clone_mcp "NotebookLM_MCP" "buxuku/notebooklm-mcp"

# Puppeteer MCP
clone_mcp "Pupeteer_MCP" "modelcontextprotocol/servers"

# Remotion MCP
clone_mcp "Remotion_MCP" "remotion-dev/remotion"

# Chatterbox TTS
clone_mcp "Chatterbox" "resemble-ai/chatterbox"

# GSD MCP
clone_mcp "Get_Shit_Done_MCP" "gsd-build/get-shit-done-mcp"

# Adobe Premiere Pro MCP
clone_mcp "Premiere_Pro" "adobe/adobe-mcp"

# Stitch MCP
clone_mcp "Stitch_MCP" "stitchfix/mcp-server"

# ADB MCP (Android Debug Bridge)
clone_mcp "adb-mcp" "jlowin/adb-mcp"

# wifi_RuView
clone_mcp "wifi_RuView" "ruview/wifi-mcp"

# filesystem, memory, fetch — run via npx, no clone needed
info "filesystem/memory/fetch MCPs run via npx — no install needed"
info "github MCP runs via npx @modelcontextprotocol/server-github — no install needed"

# Firecrawl MCP (lives at ~/Documents/Firecrawl_MCP/ — not inside MCPs/)
FIRECRAWL_MCP_DEST="$DOCS/Firecrawl_MCP/firecrawl-mcp-server"
if [[ ! -d "$FIRECRAWL_MCP_DEST/.git" ]]; then
  info "Cloning Firecrawl MCP..."
  mkdir -p "$DOCS/Firecrawl_MCP"
  git clone --depth=1 https://github.com/firecrawl/firecrawl-mcp-server.git "$FIRECRAWL_MCP_DEST"
  success "Firecrawl MCP cloned"
  if [[ -f "$FIRECRAWL_MCP_DEST/package.json" ]]; then
    info "Installing Firecrawl MCP dependencies..."
    (cd "$FIRECRAWL_MCP_DEST" && npm install)
    success "Firecrawl MCP dependencies installed"
  fi
else
  skip "Firecrawl MCP"
fi

# =============================================================================
# STEP 5 — Plugin Repos (~/Documents/Plugins/)
# =============================================================================
header "Plugin Repos (~/Documents/Plugins/)"

PLUGINS_DIR="$DOCS/Plugins"

clone_plugin() {
  local category="$1"
  local folder="$2"
  local repo="$3"
  local dest="$PLUGINS_DIR/$category/$folder/$(basename "$repo" .git)"
  if [[ ! -d "$dest/.git" ]]; then
    info "Cloning $repo..."
    mkdir -p "$PLUGINS_DIR/$category/$folder"
    git clone --depth=1 "https://github.com/$repo.git" "$dest"
    success "$category/$folder/$(basename "$repo") cloned"
  else
    skip "$category/$folder/$(basename "$repo")"
  fi
}

# Website_Building
clone_plugin "Website_Building" "Astro_Web_Builder" "withastro/astro"
clone_plugin "Website_Building" "Astro_Web_Builder" "withastro/starlight"
clone_plugin "Website_Building" "LLMS_Txt" "answerdotai/llms-txt"
clone_plugin "Website_Building" "LLMS_Txt" "matfantinel/astro-llms-txt"
clone_plugin "Website_Building" "Mastra_TypeScript" "mastra-ai/mastra"
clone_plugin "Website_Building" "SchemaOrg" "google/schema-dts"
clone_plugin "Website_Building" "SchemaOrg" "garmeeh/next-seo"
clone_plugin "Website_Building" "SchemaOrg" "jonasmerlin/astro-seo"
clone_plugin "Website_Building" "Tailwind_CSS" "tailwindlabs/tailwindcss"
clone_plugin "Website_Building" "Tailwind_CSS" "tailwindlabs/headlessui"
clone_plugin "Website_Building" "Tailwind_CSS" "tailwindlabs/heroicons"
clone_plugin "Website_Building" "Tailwind_CSS" "shadcn-ui/ui"
clone_plugin "Website_Building" "Tailwind_CSS" "saadeghi/daisyui"

# Agents
# God Mode 3 — Advanced Claude Code power-user interface
GODMOD_DEST="$PLUGINS_DIR/God_Mode_3"
if [[ ! -d "$GODMOD_DEST/.git" ]]; then
  info "Cloning God Mode 3..."
  git clone --depth=1 https://github.com/elder-plinius/G0DM0D3.git "$GODMOD_DEST"
  success "God Mode 3 cloned"
  if [[ -f "$GODMOD_DEST/package.json" ]]; then
    info "Installing God Mode 3 dependencies..."
    (cd "$GODMOD_DEST" && npm install)
    success "God Mode 3 dependencies installed"
  fi
else
  skip "God Mode 3"
fi

# Oh My Claude Code — Claude Code enhancement framework
OMCC_DEST="$PLUGINS_DIR/Oh_My_Claude_Code"
if [[ ! -d "$OMCC_DEST/.git" ]]; then
  info "Cloning Oh My Claude Code..."
  git clone --depth=1 https://github.com/Yeachan-Heo/oh-my-claudecode.git "$OMCC_DEST"
  success "Oh My Claude Code cloned"
  if [[ -f "$OMCC_DEST/package.json" ]]; then
    info "Installing Oh My Claude Code dependencies..."
    (cd "$OMCC_DEST" && npm install)
    success "Oh My Claude Code dependencies installed"
  fi
else
  skip "Oh My Claude Code"
fi

# The Agency — 60+ specialized AI agents + NEXUS orchestration
AGENCY_DEST="$PLUGINS_DIR/Agency_Agents"
if [[ ! -d "$AGENCY_DEST/.git" ]]; then
  info "Cloning The Agency (agency-agents)..."
  git clone --depth=1 https://github.com/msitarzewski/agency-agents.git "$AGENCY_DEST"
  success "Agency Agents cloned"
  info "To install agents into Claude Code: cp -r $AGENCY_DEST/* ~/.claude/agents/"
else
  skip "Agency Agents"
fi

clone_plugin "Agents" "PaperClip" "PaperClipAGI/paperclip"

# claude-mem (top-level in Plugins)
CLAUDE_MEM_DEST="$PLUGINS_DIR/claude-mem"
if [[ ! -d "$CLAUDE_MEM_DEST/.git" ]]; then
  info "Cloning claude-mem..."
  git clone --depth=1 https://github.com/badboysm890/claude-mem.git "$CLAUDE_MEM_DEST"
  success "claude-mem cloned"
else
  skip "claude-mem"
fi

# CLI_Build
clone_plugin "CLI_Build" "CLI-Anything" "guypeer8/cli-anything"

# General
GSD_DEST="$PLUGINS_DIR/General/GSD/get-shit-done"
if [[ ! -d "$GSD_DEST/.git" ]]; then
  info "Cloning GSD..."
  mkdir -p "$PLUGINS_DIR/General/GSD"
  git clone --depth=1 https://github.com/gsd-build/get-shit-done.git "$GSD_DEST"
  success "GSD cloned"
else
  skip "GSD"
fi

SP_DEST="$PLUGINS_DIR/General/SuperPowers/superpowers"
if [[ ! -d "$SP_DEST/.git" ]]; then
  info "Cloning SuperPowers..."
  mkdir -p "$PLUGINS_DIR/General/SuperPowers"
  git clone --depth=1 https://github.com/superpowers-ai/superpowers.git "$SP_DEST"
  success "SuperPowers cloned"
else
  skip "SuperPowers"
fi

# =============================================================================
# STEP 6 — Memory Tools (~/Documents/Plugins/Memory/)
# =============================================================================
header "Memory Tools (~/Documents/Plugins/Memory/)"

MEM_DIR="$PLUGINS_DIR/Memory"

# mem0
MEM0_DEST="$MEM_DIR/mem0/mem0"
if [[ ! -d "$MEM0_DEST/.git" ]]; then
  info "Cloning mem0..."
  mkdir -p "$MEM_DIR/mem0"
  git clone --depth=1 https://github.com/mem0ai/mem0.git "$MEM0_DEST"
  success "mem0 cloned"
else
  skip "mem0"
fi

if ! python3 -c "import mem0" &>/dev/null; then
  info "Installing mem0ai Python package..."
  pip3 install mem0ai
  success "mem0ai installed"
else
  skip "mem0ai (Python)"
fi

# Letta (MemGPT)
LETTA_DEST="$MEM_DIR/MemGPT/MemGPT"
if [[ ! -d "$LETTA_DEST/.git" ]]; then
  info "Cloning Letta (MemGPT)..."
  mkdir -p "$MEM_DIR/MemGPT"
  git clone --depth=1 https://github.com/cpacker/MemGPT.git "$LETTA_DEST"
  success "Letta cloned"
else
  skip "Letta (MemGPT)"
fi

if ! command -v letta &>/dev/null; then
  info "Installing letta Python package..."
  pip3 install letta
  success "letta installed"
else
  skip "letta (Python)"
fi

# Zep
ZEP_DEST="$MEM_DIR/zep/zep"
if [[ ! -d "$ZEP_DEST/.git" ]]; then
  info "Cloning Zep..."
  mkdir -p "$MEM_DIR/zep"
  git clone --depth=1 https://github.com/getzep/zep.git "$ZEP_DEST"
  success "Zep cloned"
else
  skip "Zep"
fi

# =============================================================================
# STEP 6b — Claude Skills (~/Documents/Claude_Skills/)
# =============================================================================
header "Claude Skills (~/Documents/Claude_Skills/)"

CLAUDE_SKILLS_DIR="$DOCS/Claude_Skills"

# awesome-claude-skills (ComposioHQ)
AWESOME_SKILLS="$CLAUDE_SKILLS_DIR/awesome-claude-skills"
if [[ ! -d "$AWESOME_SKILLS/.git" ]]; then
  info "Cloning awesome-claude-skills..."
  mkdir -p "$CLAUDE_SKILLS_DIR"
  git clone --depth=1 https://github.com/ComposioHQ/awesome-claude-skills.git "$AWESOME_SKILLS"
  success "awesome-claude-skills cloned"
else
  skip "awesome-claude-skills"
fi

# composio Python package (required for connect-apps-plugin)
if ! python3 -c "import composio" &>/dev/null; then
  info "Installing composio Python package..."
  pip3 install composio
  success "composio installed"
else
  skip "composio (Python)"
fi

# =============================================================================
# STEP 7 — Claude Code
# =============================================================================
header "Claude Code"

if ! command -v claude &>/dev/null; then
  info "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
  success "Claude Code installed"
else
  skip "Claude Code"
fi

# Global CLAUDE.md
GLOBAL_CLAUDE="$HOME/.claude/CLAUDE.md"
if [[ ! -f "$GLOBAL_CLAUDE" ]]; then
  info "Creating global ~/.claude/CLAUDE.md from template..."
  mkdir -p "$HOME/.claude"
  cat > "$GLOBAL_CLAUDE" << 'EOF'
# Global CLAUDE.md
# See ~/Documents/Skills_Personal/setup_project/SKILL.md for full setup guide

## NEVER Rules
- NEVER read, write, or reference .env, .env.*, or *.secret files
- NEVER commit secrets or credentials to git
- NEVER run rm -rf without explicit confirmation
- NEVER push directly to main or master
- NEVER install packages without showing the command first
EOF
  success "~/.claude/CLAUDE.md created"
else
  skip "~/.claude/CLAUDE.md (already exists)"
fi

# =============================================================================
# STEP 8 — Shell Aliases
# =============================================================================
header "Shell Aliases"

ZSHRC="$HOME/.zshrc"
ALIAS_MARKER="# ── Documents Bootstrap Aliases ──"

if ! grep -q "$ALIAS_MARKER" "$ZSHRC" 2>/dev/null; then
  info "Adding aliases to ~/.zshrc..."
  cat >> "$ZSHRC" << 'EOF'

# ── Documents Bootstrap Aliases ──
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
  success "Aliases added to ~/.zshrc"
  info "Run: source ~/.zshrc"
else
  skip "~/.zshrc aliases (already present)"
fi

# =============================================================================
# DONE
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║         Bootstrap Complete! ✓            ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# MANUAL STEPS REQUIRED — Cannot be automated (need your credentials/input)
# Complete these IN ORDER after bootstrap finishes.
# =============================================================================
echo -e "${BOLD}${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${YELLOW}║   ⚠  MANUAL STEPS REQUIRED — Do these now, in order         ║${NC}"
echo -e "${BOLD}${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}── 1. SHELL ─────────────────────────────────────────────────────${NC}"
echo "  Why: activates nvm and pyenv paths added by this script"
echo "  $ source ~/.zshrc"
echo ""
echo -e "${BOLD}── 2. GITHUB CLI ────────────────────────────────────────────────${NC}"
echo "  Why: required for gh commands + Claude's GitHub MCP server (opens browser)"
echo "  $ gh auth login"
echo "  → Choose: GitHub.com → HTTPS → Login with a web browser"
echo ""
echo -e "${BOLD}── 3. VERCEL CLI ────────────────────────────────────────────────${NC}"
echo "  Why: required for vercel deploy commands (opens browser)"
echo "  $ vercel login"
echo ""
echo -e "${BOLD}── 4. GOOGLE WORKSPACE MCP ──────────────────────────────────────${NC}"
echo "  Why: Gmail/Calendar/Drive MCP needs Google Cloud OAuth credentials"
echo "  $ cd ~/Documents/MCPs/GoogleWorkspace_MCP/mcp-google-workspace"
echo "  $ npm install"
echo "  → Create OAuth app at: https://console.cloud.google.com/apis/credentials"
echo "  → Download credentials.json into this folder"
echo "  $ node dist/index.js auth   # or check README for exact auth command"
echo "  → Browser will open for Google login — generates token.json"
echo ""
echo -e "${BOLD}── 5. GOOGLE WORKSPACE CLI ──────────────────────────────────────${NC}"
echo "  Why: CLI uses separate credentials from the MCP above"
echo "  $ cd ~/Documents/CLIs/GoogleWorkspace_CLI/google-workspace-mcp"
echo "  $ npm install"
echo "  $ npm run auth              # opens browser for Google login"
echo ""
echo -e "${BOLD}── 6. GEMINI CLI ────────────────────────────────────────────────${NC}"
echo "  Why: needs npm deps installed + Google account auth on first run"
echo "  $ cd ~/Documents/CLIs/Gemini_CLI/gemini-cli"
echo "  $ npm install"
echo "  $ npm run build"
echo "  $ npx gemini                # first run opens browser for Google login"
echo ""
echo -e "${BOLD}── 7. NOTEBOOKLM MCP ────────────────────────────────────────────${NC}"
echo "  Why: MCP requires Google auth before Claude can use notebooklm tools"
echo "  $ nlm login"
echo "  → Opens browser for Google account login"
echo ""
echo -e "${BOLD}── 8. BLENDER MCP ───────────────────────────────────────────────${NC}"
echo "  Why: requires addon installed inside Blender (GUI steps — no terminal auth)"
echo "  Terminal: note the addon path:"
echo "  $ echo ~/Documents/MCPs/Blender_MCP/addon.py"
echo "  GUI steps in Blender:"
echo "    1. Edit → Preferences → Add-ons → Install from Disk"
echo "    2. Select: ~/Documents/MCPs/Blender_MCP/addon.py"
echo "    3. Enable the addon checkbox"
echo "    4. In the addon panel: click 'Start MCP Server'"
echo ""
echo -e "${BOLD}── 9. UNREAL ENGINE MCP ─────────────────────────────────────────${NC}"
echo "  Why: UE plugin must be copied per-project (not global)"
echo "  $ cp -r ~/Documents/MCPs/Unreal_Engine_MCP/UnrealMCP /path/to/YourProject/Plugins/"
echo "  GUI steps in Unreal:"
echo "    1. Edit → Plugins → search 'UnrealMCP' → Enable"
echo "    2. Restart Unreal when prompted"
echo ""
echo -e "${BOLD}── 10. FIRECRAWL MCP ────────────────────────────────────────────${NC}"
echo "  Why: web scraping requires a Firecrawl API key"
echo "  → Get free key at: https://www.firecrawl.dev (sign up → API Keys)"
echo "  $ cd ~/Documents/Firecrawl_MCP/firecrawl-mcp-server"
echo "  $ npm install"
echo "  Then add key to ~/.claude/settings.json:"
echo '  $ open ~/.claude/settings.json   # add under "env": { "FIRECRAWL_API_KEY": "YOUR_KEY" }'
echo ""
echo -e "${BOLD}── 11. COMPOSIO / CONNECT-APPS ──────────────────────────────────${NC}"
echo "  Why: 500+ app actions require a Composio API key + per-app OAuth"
echo "  → Get free key at: https://platform.composio.dev"
echo "  $ claude --plugin-dir ~/Documents/Claude_Skills/awesome-claude-skills/connect-apps-plugin"
echo "  Inside Claude: /connect-apps:setup   (paste API key when asked)"
echo "  → Connect individual apps (Gmail, Slack, etc.) at: https://platform.composio.dev"
echo ""
echo -e "${BOLD}── 12. API TOKENS → ~/.claude/settings.json ─────────────────────${NC}"
echo "  Why: secrets are never committed — must be entered manually on each machine"
echo '  $ open ~/.claude/settings.json'
echo '  Add under "env": {'
echo '    "VERCEL_TOKEN":      "get at vercel.com/account/tokens"'
echo '    "GITHUB_TOKEN":      "get at github.com/settings/tokens (repo + workflow scopes)"'
echo '    "SUPABASE_URL":      "get at supabase.com → project → Settings → API"'
echo '    "SUPABASE_ANON_KEY": "get at supabase.com → project → Settings → API"'
echo '    "FIRECRAWL_API_KEY": "get at firecrawl.dev → dashboard → API Keys"'
echo '  }'
echo ""
echo -e "${BOLD}── 13. AGENCY AGENTS (OPTIONAL) ─────────────────────────────────${NC}"
echo "  Why: agents must live in ~/.claude/agents/ to activate inside Claude Code"
echo "  $ mkdir -p ~/.claude/agents"
echo "  $ cp -r ~/Documents/Plugins/Agency_Agents/* ~/.claude/agents/"
echo "  Verify: ls ~/.claude/agents/  # should list engineering/, design/, etc."
echo ""
echo -e "${BOLD}── 14. MEMORY TOOLS / LETTA (OPTIONAL) ──────────────────────────${NC}"
echo "  Why: Letta requires a running server process before Claude can use it"
echo "  $ letta server"
echo "  → Runs on http://localhost:8283 — keep this terminal open while using memory"
echo ""
echo -e "${BOLD}── 15. PAPERCLIP (OPTIONAL) ─────────────────────────────────────${NC}"
echo "  Why: needs dependencies installed before use"
echo "  $ cd ~/Documents/Plugins/Agents/PaperClip/paperclip"
echo "  $ pnpm install"
echo "  $ pnpm build"
echo "  → Check README.md for any additional config or auth steps"
echo ""

echo -e "${BOLD}── 16. CLAUDE DESKTOP CONFIG ────────────────────────────────────${NC}"
echo "  Why: wires all MCP servers into Claude Desktop app"
echo "  A template config is stored in ~/Documents/claude-config/claude_desktop_config.json"
echo "  $ mkdir -p ~/Library/Application\ Support/Claude"
echo "  $ cp ~/Documents/claude-config/claude_desktop_config.json \\"
echo "       ~/Library/Application\ Support/Claude/claude_desktop_config.json"
echo "  Then open the file and replace all YOUR_* placeholders with real values:"
echo "    YOUR_FIRECRAWL_API_KEY   → firecrawl.dev dashboard"
echo "    YOUR_FLOPPERAM_API_KEY   → flopperam.com account"
echo "    YOUR_COMPOSIO_MCP_URL    → from /connect-apps:setup output"
echo "    YOUR_COMPOSIO_API_KEY    → platform.composio.dev"
echo "    REPLACE_WITH_YOUR_DEVICE_ID/NAME → pair Chrome extension first"
echo "  $ open ~/Library/Application\ Support/Claude/claude_desktop_config.json"
echo "  After saving: quit and relaunch Claude Desktop"
echo ""
echo -e "${BOLD}── VERIFY ALL INSTALLS ──────────────────────────────────────────${NC}"
echo "  node --version && pnpm --version && python3 --version"
echo "  vercel --version && gh --version && claude --version"
echo ""
echo -e "${BOLD}Key paths:${NC}"
echo "  MCPs:          ~/Documents/MCPs/  (Blender_MCP, Unreal_Engine_MCP, GoogleWorkspace, etc.)"
echo "  Firecrawl:     ~/Documents/Firecrawl_MCP/"
echo "  CLIs:          ~/Documents/CLIs/  (Gemini_CLI, GoogleWorkspace_CLI, PlayWright_CLI)"
echo "  Plugins:       ~/Documents/Plugins/"
echo "  Agency Agents: ~/Documents/Plugins/Agency_Agents/"
echo "  Skills:        ~/Documents/Skills_Personal/"
echo "  Claude Skills: ~/Documents/Claude_Skills/awesome-claude-skills/"
echo ""
