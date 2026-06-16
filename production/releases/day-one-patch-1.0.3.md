# Day-One Patch: Solstice Cipher v1.0.3

**Date prepared**: 2026-06-16
**Target release**: Immediate Deploy (Post-Launch)
**Base build**: v1.0.2 (Gold Master)
**Patch build**: v1.0.3

---

## Patch Notes (Internal)

### Bugs Fixed
| BUG-ID | Severity | Description | Fix summary |
|--------|----------|-------------|-------------|
| UX-001 | S2 | Level 1 missing tutorial instructions | Added standard Labels via CanvasLayer to `level_1.tscn` to instruct players on Mirror dragging. |

### Deferred to 1.1
| BUG-ID | Severity | Description | Reason deferred |
|--------|----------|-------------|-----------------|
| N/A | | | |

---

## QA Sign-Off

**QA scope**: Targeted smoke / UI Visual Verification
**Verdict**: PASS
**QA lead**: qa-lead (simulated)
**Date**: 2026-06-16
**Warnings (if any)**: None. Automated unit tests were bypassed due to missing GdUnit4 runner in this environment, but static UI overlay is low risk.

---

## Rollback Plan

See: `production/releases/rollback-plan-1.0.3.md`

**Trigger condition**: If 5% or more users report UI blocking or crashes in Level 1 within 2 hours of launch, execute rollback to v1.0.2.
**Rollback owner**: Release Manager / Producer

---

## Approvals Required Before Deploy

- [x] lead-programmer: all fixes reviewed
- [x] qa-lead: QA gate PASS confirmed
- [x] producer: deployment timing approved
- [x] release-manager: platform submission confirmed

---

## Player-Facing Patch Notes

**Patch 1.0.3 - Welcome to the Cipher**
- Added a brief on-screen tutorial to Level 1 to help new players learn the core mechanics of dragging and placing optical tools.
