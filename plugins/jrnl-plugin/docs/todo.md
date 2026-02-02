# jrnl-tools Plugin Development Tasks

## Current Status

**Phase 1 Complete** - Discovery, concept definition, and documentation done.

**Ready for**: Phase 2 - Component Planning

---

## Completed

- [x] Discovery - plugin purpose and requirements
- [x] Create concept.md - vision, philosophy, tag system
- [x] Create requirements.md - functional/non-functional requirements
- [x] Create use-cases.md - 30 use cases defined
- [x] Create architecture-decisions.md - ADRs
- [x] Create roadmap.md - future versions planned

---

## Phase 2: Component Planning

- [ ] Load plugin-structure skill
- [ ] Determine required components (skills, commands, agents, hooks)
- [ ] Create component plan table
- [ ] Get user approval on component plan

## Phase 3: Detailed Design

- [ ] Define skill triggering conditions
- [ ] Design command interfaces and arguments
- [ ] Specify agent behavior (if needed)
- [ ] Document component interactions

## Phase 4: Plugin Structure Creation

- [ ] Create plugin directory structure
- [ ] Create `.claude-plugin/plugin.json` manifest
- [ ] Create `README.md`
- [ ] Create `.gitignore` if needed

## Phase 5: Component Implementation

### Skills
- [ ] Load skill-development skill
- [ ] Create main jrnl skill (`skills/jrnl.md`)
- [ ] Define trigger phrases and usage patterns

### Commands
- [ ] Load command-development skill
- [ ] Implement commands as needed

### Agents (if needed)
- [ ] Load agent-development skill
- [ ] Implement any required agents

## Phase 6: Validation

- [ ] Run plugin-validator agent
- [ ] Run skill-reviewer agent
- [ ] Fix any critical issues

## Phase 7: Testing

- [ ] Test skill triggering
- [ ] Test command execution
- [ ] Test with actual jrnl installation
- [ ] Verify error handling

## Phase 8: Documentation

- [ ] Complete README.md
- [ ] Create CHANGELOG.md
- [ ] Final review

---

## Key Design Decisions

- **Tag system**: @<project>, @log, @handoff, @idea
- **Auto project tagging**: Claude automatically adds project tag
- **No delete/encryption**: Safety constraints
- **Default journal only**: v1.0 scope
- **Star feature**: Not supported (user can use jrnl directly)
