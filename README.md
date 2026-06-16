# Solution Agent

A Claude Code and Codex **plugin** for documenting projects and researching Confluence Solution Designs.

The repository is intentionally dual-use:

- `.claude-plugin/` contains the Claude Code manifest and marketplace metadata.
- `.codex-plugin/` contains the Codex plugin manifest.
- `.codex/agents/` contains Codex custom-agent TOML definitions for local/project-scoped subagent use.
- `skills/`, `agents/`, `hooks/`, and `templates/` stay shared where the host supports them.

## Installation

### Claude Code

```bash
# Add the marketplace (once)
/plugin marketplace add lpetersdorf/doc_agent

# Install the plugin
/plugin install solution-agent
```

### Codex

Codex discovers the plugin through `.codex-plugin/plugin.json`. During local development, install or link this repository through your Codex plugin workflow so the plugin root points at this checkout.

## Usage

### Claude CLI

Nach der Installation:

1. Wechsle in das zu dokumentierende Projektverzeichnis und öffne dort ein Terminal.
2. Starte Claude (`claude`).
3. Verwende in Claude den Skill, um den Projektordner zu dokumentieren:

```
/document-project
```

### Claude Cowork / Chat

Wenn du lieber **Cowork** oder den **Chat** nutzt, muss das Plugin zunächst in den
Einstellungen aktiviert werden:

1. Öffne **Einstellungen → Fähigkeiten → Skills**.
2. Über **Plugin erstellen** lässt sich ein Marketplace hinzufügen — füge den
   Marketplace `lpetersdorf/doc_agent` hinzu.
3. Aktiviere anschließend den **Solution Agent**.

Danach stehen die Skills des Plugins in Cowork und Chat zum Dokumentieren zur Verfügung.

### Codex

Nach der Installation stehen die Skills als Plugin-Skills unter `solution-agent` zur Verfügung:

```
/solution-agent:document-project
/solution-agent:document-status
/solution-agent:document-sync
```

Codex-Subagents sind anders definiert als Claude-Subagenten. Die Claude-Agenten liegen weiter unter `agents/*.md`; ihre Codex-Pendants liegen als TOML-Dateien unter `.codex/agents/*.toml` und können explizit gespawnt werden, z.B.:

```
Spawn the repo-analyzer subagent for this repository and summarize the result.
```

Hinweis: Nach aktueller Codex-Doku sind Custom Agents projekt- oder benutzerweit (`.codex/agents/` bzw. `~/.codex/agents/`) definiert. Plugin-Bundles listen Skills, Hooks, MCP, Apps und Assets, aber keine Agents als eigenes Plugin-Bundle-Feld. Für installierte Plugin-Workflows bleiben die Skills daher der stabile Einstiegspunkt.

### Pfade (PUSH / PULL)

Ohne Argument fragt der Skill, welchen Pfad du möchtest:

- **PUSH** — Analyse a local project or remote repo and publish documentation to Confluence
- **PULL** — Research existing Confluence Solution Design documents

You can also pass your request directly:

```
/document-project analysiere das Repo github.com/… und erstell eine Confluence-Seite
/document-project welche Solution Designs beschäftigen sich mit Databricks?
```

## What it does

| What you say | What runs |
|---|---|
| "Analysiere das Repo github.com/…" | `repo-analyzer` |
| "Was zeigt dieses Architekturbild?" | `diagram-analyzer` |
| "Erstell eine Confluence-Seite" | `confluence-publisher` |
| "Was steht im Solution Design zu X?" | `solution-researcher` |
| "Analysiere Repo und erstell Confluence-Doku" | `repo-analyzer` → `confluence-publisher` |
| "Vollständige Doku: Repo + Bilder + Confluence" | `repo-analyzer` + `diagram-analyzer` → `confluence-publisher` |

## Skills

| Skill | Zweck |
|---|---|
| `/document-project` | Orchestriert Analyse und Confluence-Dokumentation (PUSH) oder Confluence-Recherche (PULL) |
| `/document-status` | Zeigt vorhandene Analyse-Artefakte und die Dokumentations-Vorschau im aktuellen Verzeichnis |
| `/document-sync` | Aktualisiert eine bestehende Confluence-Seite mit der vorhandenen `dokumentation-preview.md` — ohne Duplikat zu erstellen |

## Sicherheit

Das Plugin bringt Sicherheits-Hooks mit, die automatisch greifen:

- Bash-Befehle und Read-Zugriffe auf Credential-Dateien (z. B. `.env`) werden blockiert.
- `git push` und destruktive Operationen werden in geklonten Analyse-Repos (`/tmp/repo-analyzer-*`)
  unterbunden — dein lokales Arbeitsverzeichnis bleibt davon unberührt.

Hinweis: Die vorhandenen Hooks sind aktuell Claude-Code-spezifisch (`${CLAUDE_PLUGIN_ROOT}` und Claude-Toolnamen). Codex-Plugins können grundsätzlich Hooks bündeln, aber diese Hook-Dateien müssten dafür auf Codex-Toolnamen und Codex-Plugin-Pfade angepasst werden.

## Requirements

- [Claude Code](https://claude.ai/code) installed
- Codex with plugin support, if you want to use the Codex manifest
- Atlassian MCP server connected (for Confluence publishing)

**Optional tools** (for analysing Office/PDF documents):
```bash
brew install pandoc poppler
```
Without these, `.docx`, `.pptx`, and `.pdf` files are skipped during document analysis. All other features work without them.

## This repository

This repo is the **Solution Agent plugin** for Claude Code and Codex — it holds the skills, Claude sub-agents, Codex custom-agent definitions, hooks, and templates.  
Claude Code and Codex load the supported shared components from the same checkout via their respective manifests and configuration files. See [CLAUDE.md](CLAUDE.md) for the maintainer guide.
