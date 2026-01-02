# Current Issue - PDF Processor Plugin

## Problem
The `/pdf-processor:preprocess` skill is checking for `pdftk-java` command instead of `pdftk` command.

## Symptom
When running the skill, it executes:
```bash
which pdftk-java ocrmypdf tesseract
```

But it should execute:
```bash
which pdftk ocrmypdf tesseract
```

## Root Cause
The cached plugin at `/Users/yostos/.claude/plugins/cache/yostos-marketplace/pdf-processor/1.0.0/` is using an old version of the skill file, even though the source file at `plugins/pdf-processor/skills/preprocess.md` has been updated.

## What Was Done
Updated `plugins/pdf-processor/skills/preprocess.md` (lines 13-18) to explicitly state:
- CRITICAL: Run this EXACT command: `which pdftk ocrmypdf tesseract`
- You MUST check for `pdftk` command (the brew package is called pdftk-java, but the command itself is `pdftk`)

## What Needs to Be Done
1. Either update the cached plugin version
2. Or reinstall the plugin to pick up the new skill file

## Current Status
- `pdftk` is already installed at `/opt/homebrew/bin/pdftk`
- `ocrmypdf` is installed at `/opt/homebrew/bin/ocrmypdf`
- `tesseract` is installed at `/opt/homebrew/bin/tesseract`

All required tools are available. The skill just needs to check for the correct command name.

## Solution After Restart
After restarting Claude Code, either:
1. Update the cached skill file directly
2. Bump the plugin version and reinstall
3. Clear the plugin cache and reinstall
