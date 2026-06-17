# Adoption Plan

> **Generated**: 2026-06-09
> **Project phase**: Systems Design
> **Engine**: Godot 4 (4.x)
> **Template version**: v1.0+

Work through these steps in order. Check off each item as you complete it.
Re-run `/adopt` anytime to check remaining gaps.

---

## Step 1: Fix Blocking Gaps

*(No blocking gaps detected)*

---

## Step 2: Fix High-Priority Gaps

### 2a. Missing Control Manifest
The master rulesheet that guides stories and code formatting is missing.
**Fix**: Run `/create-control-manifest`
**Time**: 30 min
- [ ] `docs/architecture/control-manifest.md` created

---

## Step 3: Bootstrap Infrastructure

### 3a. Register existing requirements (creates tr-registry.yaml)
Run `/architecture-review` — even if ADRs already exist, this run bootstraps
the TR registry from your existing GDDs and ADRs.
*(Note: tr-registry.yaml already exists, but this updates it.)*
**Time**: 1 session (review can be long for large codebases)
- [ ] tr-registry.yaml updated

### 3b. Create control manifest
Run `/create-control-manifest`
**Time**: 30 min
- [ ] docs/architecture/control-manifest.md created

### 3c. Create sprint tracking file
Run `/sprint-plan update`
**Time**: 5 min (if sprint plan already exists as markdown)
- [ ] production/sprint-status.yaml created

### 3d. Set authoritative project stage
Run `/gate-check Systems Design`
*(Note: stage.txt already exists, but gate-check validates readiness)*
**Time**: 5 min
- [ ] production/stage.txt validated

---

## Step 4: Medium-Priority Gaps

### 4a. Missing Architecture Traceability Matrix
No persistent matrix mapping requirements to ADRs.
**Fix**: Run `/architecture-review` to generate it.
**Time**: 15 min
- [ ] `docs/architecture/architecture-traceability.md` created

### 4b. Performance Budgets Unconfigured
Technical preferences has `[TO BE CONFIGURED]` for performance budgets.
**Fix**: Manually edit `.claude/docs/technical-preferences.md` or set during architectural planning.
**Time**: 10 min
- [ ] Performance budgets configured

---

## Step 5: Optional Improvements

### 5a. Missing Manifest Version Stamp
Cannot track staleness without a manifest.
**Fix**: Resolved when `/create-control-manifest` is run.
**Time**: 0 min
- [ ] Manifest version stamp exists

---

## What to Expect from Existing Stories

Existing stories continue to work with all template skills. New format checks
(TR-ID validation, manifest version staleness) auto-pass when the fields are
absent — so nothing breaks. They won't benefit from staleness tracking until
regenerated. Do not regenerate stories that are in progress or done.

---

## Re-run

Run `/adopt` again after completing Step 3 to verify all blocking and high gaps
are resolved. The new run will reflect the current state of the project.
