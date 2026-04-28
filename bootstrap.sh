#!/usr/bin/env bash
# =============================================================================
# ai-stack/bootstrap.sh
#
# Sets up the full AI development stack on any Mac.
# No personal info, no secrets — safe to share publicly.
#
# Usage:
#   git clone https://github.com/YOUR_USERNAME/ai-stack.git ~/ai-stack
#   ~/ai-stack/bootstrap.sh
#
# Safe to re-run — all steps are idempotent.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

header()  { echo -e "\n${BOLD}${BLUE}▶ $1${NC}"; }
success() { echo -e "  ${GREEN}✓${NC} $1"; }
skip()    { echo -e "  ${YELLOW}↷${NC} $1 (already installed)"; }
info()    { echo -e "  ${BLUE}→${NC} $1"; }
warn()    { echo -e "  ${RED}⚠${NC} $1"; }

DOCS="$HOME/Documents"

echo -e "${BOLD}"
echo "╔══════════════════════════════════════════╗"
echo "║         AI Stack Bootstrap               ║"
echo "║   Full AI dev environment setup          ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# =============================================================================
# STEP 1 — System Prerequisites
# =============================================================================
header "System Prerequisites"

if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "  Press any key once the installer finishes, then re-run this script."
  read -n 1; exit 0
else
  skip "Xcode Command Line Tools"
fi

if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  success "Homebrew installed"
else
  skip "Homebrew"
fi

if [[ ! -d "$HOME/.nvm" ]]; then
  info "Installing nvm + Node.js LTS..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts && nvm use --lts
  success "nvm + Node.js LTS installed"
else
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  skip "nvm"
fi

if ! command -v pnpm &>/dev/null; then
  npm install -g pnpm && success "pnpm installed"
else
  skip "pnpm"
fi

if ! command -v pyenv &>/dev/null; then
  brew install pyenv
  pyenv install 3.12.0 --skip-existing
  pyenv global 3.12.0
  success "pyenv + Python 3.12 installed"
else
  skip "pyenv"
fi

if ! command -v pip3 &>/dev/null; then
  python3 -m ensurepip --upgrade && success "pip installed"
else
  skip "pip"
fi

if ! command -v gh &>/dev/null; then
  brew install gh && success "gh installed"
else
  skip "gh"
fi

if ! command -v docker &>/dev/null; then
  warn "Docker not found — install Docker Desktop manually: https://www.docker.com/products/docker-desktop"
else
  skip "Docker"
fi

# =============================================================================
# STEP 2 — Global CLI Tools
# =============================================================================
header "Global CLI Tools"

for pkg in vercel astro get-shit-done-cc; do
  if ! command -v "$pkg" &>/dev/null; then
    info "Installing $pkg..."
    npm install -g "$pkg" && success "$pkg installed"
  else
    skip "$pkg"
  fi
done

if ! command -v claude &>/dev/null; then
  info "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code && success "Claude Code installed"
else
  skip "Claude Code"
fi

if ! command -v nlm &>/dev/null; then
  info "Installing NotebookLM CLI..."
  npm install -g notebooklm-mcp && success "nlm installed"
else
  skip "nlm"
fi

# =============================================================================
# STEP 3 — CLIs (~/Documents/CLIs/)
# =============================================================================
header "CLIs (~/Documents/CLIs/)"

CLI_DIR="$DOCS/CLIs"

clone_cli() {
  local folder="$1" repo="$2"
  local dest="$CLI_DIR/$folder/$(basename "$repo" .git)"
  if [[ ! -d "$dest/.git" ]]; then
    mkdir -p "$CLI_DIR/$folder"
    if git clone --depth=1 "https://github.com/$repo.git" "$dest" 2>/dev/null; then
      success "$folder cloned"
    else
      warn "$folder — repo not found: $repo (skipping)"
    fi
  else
    skip "$folder"
  fi
}

clone_cli "Gemini_CLI"          "google-gemini/gemini-cli"
clone_cli "PlayWright_CLI"      "microsoft/playwright"

# =============================================================================
# STEP 4 — MCP Servers (~/Documents/MCPs/)
# =============================================================================
header "MCP Servers (~/Documents/MCPs/)"

MCP_DIR="$DOCS/MCPs"

clone_mcp() {
  local folder="$1" repo="$2"
  local dest="$MCP_DIR/$folder/$(basename "$repo" .git)"
  if [[ ! -d "$dest/.git" ]]; then
    mkdir -p "$MCP_DIR/$folder"
    if git clone --depth=1 "https://github.com/$repo.git" "$dest" 2>/dev/null; then
      success "$folder MCP cloned"
    else
      warn "$folder MCP — repo not found: $repo (skipping)"
    fi
  else
    skip "$folder MCP"
  fi
}

# Blender MCP (clones directly — no subfolder)
BLENDER_DEST="$MCP_DIR/Blender_MCP"
if [[ ! -d "$BLENDER_DEST/.git" ]]; then
  git clone --depth=1 https://github.com/ahujasid/blender-mcp.git "$BLENDER_DEST"
  success "Blender MCP cloned"
  pip3 install -e "$BLENDER_DEST" 2>/dev/null || true
else
  skip "Blender MCP"
fi

# Unreal Engine MCP
UNREAL_DEST="$MCP_DIR/Unreal_Engine_MCP"
if [[ ! -d "$UNREAL_DEST/.git" ]]; then
  git clone --depth=1 https://github.com/flopperam/unreal-engine-mcp.git "$UNREAL_DEST"
  success "Unreal Engine MCP cloned"
else
  skip "Unreal Engine MCP"
fi

# Firecrawl MCP
FIRECRAWL_DEST="$DOCS/Firecrawl_MCP/firecrawl-mcp-server"
if [[ ! -d "$FIRECRAWL_DEST/.git" ]]; then
  mkdir -p "$DOCS/Firecrawl_MCP"
  git clone --depth=1 https://github.com/firecrawl/firecrawl-mcp-server.git "$FIRECRAWL_DEST"
  [[ -f "$FIRECRAWL_DEST/package.json" ]] && (cd "$FIRECRAWL_DEST" && npm install)
  success "Firecrawl MCP cloned"
else
  skip "Firecrawl MCP"
fi

# GoogleWorkspace_MCP already installed as google_workspace_mcp
if [[ ! -d "$MCP_DIR/GoogleWorkspace_MCP/google_workspace_mcp/.git" ]] && [[ ! -d "$MCP_DIR/GoogleWorkspace_MCP/mcp-google-workspace/.git" ]]; then
  warn "GoogleWorkspace_MCP — not found, install manually"
else
  skip "GoogleWorkspace_MCP"
fi
clone_mcp "NotebookLM_MCP"      "buxuku/notebooklm-mcp"
clone_mcp "Pupeteer_MCP"        "modelcontextprotocol/servers"
clone_mcp "Remotion_MCP"        "remotion-dev/remotion"
clone_mcp "Chatterbox"          "resemble-ai/chatterbox"
clone_mcp "Get_Shit_Done_MCP"   "gsd-build/get-shit-done-mcp"
clone_mcp "Premiere_Pro"        "adobe/adobe-mcp"
clone_mcp "Stitch_MCP"          "stitchfix/mcp-server"
clone_mcp "adb-mcp"             "jlowin/adb-mcp"
clone_mcp "wifi_RuView"         "ruview/wifi-mcp"
clone_mcp "Perplexity_MCP"      "jsonallen/perplexity-mcp"

info "filesystem/memory/fetch/github MCPs run via npx — no install needed"

# =============================================================================
# STEP 5 — Plugin Repos (~/Documents/Plugins/)
# =============================================================================
header "Plugin Repos (~/Documents/Plugins/)"

PLUGINS_DIR="$DOCS/Plugins"

clone_plugin() {
  local category="$1" folder="$2" repo="$3"
  local dest="$PLUGINS_DIR/$category/$folder/$(basename "$repo" .git)"
  if [[ ! -d "$dest/.git" ]]; then
    mkdir -p "$PLUGINS_DIR/$category/$folder"
    if git clone --depth=1 "https://github.com/$repo.git" "$dest" 2>/dev/null; then
      success "$category/$folder cloned"
    else
      warn "$category/$folder — repo not found: $repo (skipping)"
    fi
  else
    skip "$category/$folder/$(basename "$repo")"
  fi
}

# God Mode 3
GODMOD_DEST="$PLUGINS_DIR/God_Mode_3"
if [[ ! -d "$GODMOD_DEST/.git" ]]; then
  git clone --depth=1 https://github.com/elder-plinius/G0DM0D3.git "$GODMOD_DEST"
  [[ -f "$GODMOD_DEST/package.json" ]] && (cd "$GODMOD_DEST" && npm install)
  success "God Mode 3 cloned"
else
  skip "God Mode 3"
fi

# Oh My Claude Code
OMCC_DEST="$PLUGINS_DIR/Oh_My_Claude_Code"
if [[ ! -d "$OMCC_DEST/.git" ]]; then
  git clone --depth=1 https://github.com/Yeachan-Heo/oh-my-claudecode.git "$OMCC_DEST"
  [[ -f "$OMCC_DEST/package.json" ]] && (cd "$OMCC_DEST" && npm install)
  success "Oh My Claude Code cloned"
else
  skip "Oh My Claude Code"
fi

# Agency Agents
AGENCY_DEST="$PLUGINS_DIR/Agency_Agents"
if [[ ! -d "$AGENCY_DEST/.git" ]]; then
  git clone --depth=1 https://github.com/msitarzewski/agency-agents.git "$AGENCY_DEST"
  info "To install agents: cp -r $AGENCY_DEST/* ~/.claude/agents/"
  success "Agency Agents cloned"
else
  skip "Agency Agents"
fi

clone_plugin "Agents"      "PaperClip"    "PaperClipAGI/paperclip"
clone_plugin "CLI_Build"   "CLI-Anything" "guypeer8/cli-anything"

# claude-mem
CLAUDE_MEM_DEST="$PLUGINS_DIR/claude-mem"
if [[ ! -d "$CLAUDE_MEM_DEST/.git" ]]; then
  git clone --depth=1 https://github.com/badboysm890/claude-mem.git "$CLAUDE_MEM_DEST"
  success "claude-mem cloned"
else
  skip "claude-mem"
fi

# GSD
GSD_DEST="$PLUGINS_DIR/General/GSD/get-shit-done"
if [[ ! -d "$GSD_DEST/.git" ]]; then
  mkdir -p "$PLUGINS_DIR/General/GSD"
  git clone --depth=1 https://github.com/gsd-build/get-shit-done.git "$GSD_DEST"
  success "GSD cloned"
else
  skip "GSD"
fi

# SuperPowers
SP_DEST="$PLUGINS_DIR/General/SuperPowers/superpowers"
if [[ ! -d "$SP_DEST/.git" ]]; then
  mkdir -p "$PLUGINS_DIR/General/SuperPowers"
  if git clone --depth=1 https://github.com/superpowers-ai/superpowers.git "$SP_DEST" 2>/dev/null; then
    success "SuperPowers cloned"
  else
    warn "SuperPowers — repo not found (skipping)"
  fi
else
  skip "SuperPowers"
fi

# Website Building
clone_plugin "Website_Building" "Astro_Web_Builder" "withastro/astro"
clone_plugin "Website_Building" "Astro_Web_Builder" "withastro/starlight"
clone_plugin "Website_Building" "LLMS_Txt"          "answerdotai/llms-txt"
clone_plugin "Website_Building" "Mastra_TypeScript"  "mastra-ai/mastra"
clone_plugin "Website_Building" "SchemaOrg"          "google/schema-dts"
clone_plugin "Website_Building" "Tailwind_CSS"       "tailwindlabs/tailwindcss"
clone_plugin "Website_Building" "Tailwind_CSS"       "shadcn-ui/ui"

# =============================================================================
# STEP 6 — Memory Tools
# =============================================================================
header "Memory Tools (~/Documents/Plugins/Memory/)"

MEM_DIR="$PLUGINS_DIR/Memory"

MEM0_DEST="$MEM_DIR/mem0/mem0"
if [[ ! -d "$MEM0_DEST/.git" ]]; then
  mkdir -p "$MEM_DIR/mem0"
  git clone --depth=1 https://github.com/mem0ai/mem0.git "$MEM0_DEST"
  pip3 install mem0ai 2>/dev/null || true
  success "mem0 cloned"
else
  skip "mem0"
fi

LETTA_DEST="$MEM_DIR/MemGPT/MemGPT"
if [[ ! -d "$LETTA_DEST/.git" ]]; then
  mkdir -p "$MEM_DIR/MemGPT"
  git clone --depth=1 https://github.com/cpacker/MemGPT.git "$LETTA_DEST"
  pip3 install letta 2>/dev/null || true
  success "Letta (MemGPT) cloned"
else
  skip "Letta"
fi

# =============================================================================
# STEP 7 — Claude Skills
# =============================================================================
header "Claude Skills (~/Documents/Claude_Skills/)"

CLAUDE_SKILLS_DIR="$DOCS/Claude_Skills"
AWESOME_SKILLS="$CLAUDE_SKILLS_DIR/awesome-claude-skills"
if [[ ! -d "$AWESOME_SKILLS/.git" ]]; then
  mkdir -p "$CLAUDE_SKILLS_DIR"
  git clone --depth=1 https://github.com/ComposioHQ/awesome-claude-skills.git "$AWESOME_SKILLS"
  pip3 install composio 2>/dev/null || true
  success "awesome-claude-skills cloned"
else
  skip "awesome-claude-skills"
fi

# =============================================================================
# STEP 8 — n8n
# =============================================================================
header "n8n Workflow Automation"

N8N_DEST="$DOCS/n8n_github"
if [[ ! -d "$N8N_DEST" ]]; then
  mkdir -p "$N8N_DEST"
  warn "n8n: copy your docker-compose.yml into ~/Documents/n8n_github/ then run: docker-compose up -d"
else
  skip "n8n folder"
fi

# =============================================================================
# STEP 9 — Shell Aliases
# =============================================================================
header "Shell Aliases"

ZSHRC="$HOME/.zshrc"
ALIAS_MARKER="# ── AI Stack Bootstrap Aliases ──"

if ! grep -q "$ALIAS_MARKER" "$ZSHRC" 2>/dev/null; then
  cat >> "$ZSHRC" << 'EOF'

# ── AI Stack Bootstrap Aliases ──
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
  success "Aliases added to ~/.zshrc"
else
  skip "~/.zshrc aliases"
fi

# =============================================================================
# DONE
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║         AI Stack Ready! ✓                ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}${YELLOW}── MANUAL STEPS REQUIRED (in order) ───────────────────${NC}"
echo ""
echo "  [ ] 1.  source ~/.zshrc"
echo ""
echo "  [ ] 2.  gh auth login"
echo "          → GitHub CLI auth (opens browser)"
echo ""
echo "  [ ] 3.  vercel login"
echo "          → Vercel CLI auth (opens browser)"
echo ""
echo "  [ ] 4.  Google Workspace MCP OAuth:"
echo "          cd ~/Documents/MCPs/GoogleWorkspace_MCP/mcp-google-workspace"
echo "          npm install && node dist/index.js auth"
echo ""
echo "  [ ] 5.  Gemini CLI first run:"
echo "          cd ~/Documents/CLIs/Gemini_CLI/gemini-cli && npm install && npx gemini"
echo "          → Opens browser for Google login"
echo ""
echo "  [ ] 6.  NotebookLM auth:"
echo "          nlm login"
echo ""
echo "  [ ] 7.  Create your secrets file:"
echo "          cp ~/ai-stack/configs/.env.example ~/.claude/.env"
echo "          nano ~/.claude/.env   # fill in your API keys"
echo ""
echo "  [ ] 8.  Copy desktop MCP config for your machine:"
echo "          cp ~/ai-stack/configs/claude_desktop_config_travel.json \\"
echo "             ~/Library/Application\ Support/Claude/claude_desktop_config.json"
echo "          # or: _mini.json / _alien.json for other machines"
echo "          # Then fill in YOUR_* placeholders in the config"
echo ""
echo "  [ ] 9.  Install Agency Agents into Claude Code:"
echo "          cp -r ~/Documents/Plugins/Agency_Agents/* ~/.claude/agents/"
echo ""
echo "  [ ] 10. Restart Claude Desktop"
echo ""
echo -e "${BOLD}Verify:${NC}"
echo "  node --version && python3 --version && claude --version && gh --version"
echo ""
echo -e "${BOLD}Key paths:${NC}"
echo "  MCPs:    ~/Documents/MCPs/"
echo "  CLIs:    ~/Documents/CLIs/"
echo "  Plugins: ~/Documents/Plugins/"
echo "  Skills:  ~/Documents/Claude_Skills/"
echo "  Configs: ~/ai-stack/configs/"
echo ""
