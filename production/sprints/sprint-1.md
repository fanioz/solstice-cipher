# Sprint 1 — 2026-06-10 to 2026-06-24

## Sprint Goal
Establish the foundational gameplay systems by implementing the core optical beam propagation mechanics and the fundamental puzzle solving algorithm, allowing light to interact with simple mirrors and prisms.

## Capacity
- Total days: 10
- Buffer (20%): 2 days reserved for unplanned work
- Available: 8 days

## Tasks

### Must Have (Critical Path)
| ID | Task | Agent/Owner | Est. Days | Dependencies | Acceptance Criteria |
|----|------|-------------|-----------|-------------|-------------------|
| 1-1 | beam-mechanics 001: Core Propagation | lead-programmer | 1.5 | None | Mirrors reflect at 90°, snap to 15° |
| 1-2 | beam-mechanics 002: Beam Splitting | lead-programmer | 1.0 | 1-1 | Prisms split beam, one straight, one at 90° |
| 1-3 | puzzle-solver 001: Float Quantization | ai-programmer | 1.0 | None | Snap vectors to 0.001 precision |
| 1-4 | puzzle-solver 002: Radial A* Solver | ai-programmer | 2.5 | 1-1, 1-3 | Backwards pathing algorithm |

### Should Have
| ID | Task | Agent/Owner | Est. Days | Dependencies | Acceptance Criteria |
|----|------|-------------|-----------|-------------|-------------------|
| 1-5 | beam-mechanics 005: Diagonal Routing | lead-programmer | 1.0 | 1-1 | Benders deflect at 45° |
| 1-6 | beam-mechanics 004: Path Blocking | lead-programmer | 0.5 | 1-1 | Shades stop light |

## Carryover from Previous Sprint
*None — Initial Sprint*

## Risks
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Core Propagation bottleneck | High | High | Dedicate full focus to story 1-1 before attempting any other mechanics. |
| Float drift over multiple beam bounces | High | High | Implement strict 0.001 quantization early (puzzle-solver 001) before optical mechanics are tested. |

## Dependencies on External Factors
- Requires `godot-prompter` skills to be functioning.

## Definition of Done for this Sprint
- [ ] All Must Have tasks completed
- [ ] All tasks pass acceptance criteria
- [ ] QA plan exists (`production/qa/qa-plan-sprint-1.md`)
- [ ] All Logic/Integration stories have passing unit/integration tests
- [ ] Smoke check passed (`/smoke-check sprint`)
- [ ] QA sign-off report: APPROVED or APPROVED WITH CONDITIONS (`/team-qa sprint`)
- [ ] No S1 or S2 bugs in delivered features
- [ ] Design documents updated for any deviations
- [ ] Code reviewed and merged
