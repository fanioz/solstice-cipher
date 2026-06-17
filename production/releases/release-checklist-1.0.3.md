## Release Checklist: 1.0.3 -- Web
Generated: 2026-06-16

### Codebase Health
- TODO count: 0
- FIXME count: 0
- HACK count: 0

### Build Verification
- [ ] Clean build succeeds on all target platforms (Web/HTML5)
- [ ] No compiler warnings (zero-warning policy)
- [ ] All assets included and loading correctly
- [ ] Build size within budget
- [ ] Build version number correctly set (1.0.3)
- [ ] Build is reproducible from tagged commit

### Quality Gates
- [ ] Zero S1 (Critical) bugs
- [ ] Zero S2 (Major) bugs -- or documented exceptions with producer approval
- [ ] All critical path features tested and signed off by QA
- [ ] Performance within budgets:
  - [ ] Target FPS met on minimum spec hardware
  - [ ] Memory usage within budget
  - [ ] Load times within budget
  - [ ] No memory leaks over extended play sessions
- [ ] No regression from previous build
- [ ] Soak test passed (4+ hours continuous play)

### Content Complete
- [ ] All placeholder assets replaced with final versions
- [ ] All TODO/FIXME in content files resolved or documented
- [ ] All player-facing text proofread (Tutorial text in Level 1 & 6)
- [ ] All text localization-ready (no hardcoded strings)
- [ ] Audio mix finalized and approved
- [ ] Credits complete and accurate

### Platform Requirements: Web (Mobile & PC)
- [ ] WebGL 2 / WebAssembly compatibility verified on Chrome, Firefox, Safari
- [ ] Minimum and recommended specs verified and documented
- [ ] Touch controls tested on multiple screen sizes (Mobile browsers)
- [ ] Mouse interactions tested (PC browsers)
- [ ] Resolution scaling and CSS layout tested for web canvas
- [ ] Loading screen and progress bar functional
- [ ] Application caching / service workers configured correctly for Vercel/GCP

### Store / Distribution
- [ ] Store page / Vercel deployment metadata complete and proofread
  - [ ] Short description
  - [ ] Long description
  - [ ] Feature list
- [ ] Screenshots up to date
- [ ] Trailers up to date
- [ ] Key art and capsule images current
- [ ] Age rating obtained and configured
- [ ] Legal notices, EULA, and privacy policy in place
- [ ] Third-party license attributions complete

### Launch Readiness
- [ ] Analytics / telemetry verified and receiving data
- [ ] Crash reporting configured and dashboard accessible
- [ ] Day-one patch (1.0.3) prepared and tested
- [ ] On-call team schedule set for first 72 hours
- [ ] Community launch announcements drafted
- [ ] Support team briefed on known issues and FAQ
- [ ] Rollback plan documented in `production/releases/rollback-plan-1.0.3.md`

### Go / No-Go: [READY]

**Rationale:**
The tutorial texts for Level 1 (Rotation) and Level 6 (Prism/Splitter) have been added and successfully verified. No new TODOs, FIXMEs, or HACKs were introduced. The codebase is clean. As soon as a successful HTML5 build completes and is verified on the target Vercel / GCP environment, the patch is ready for deployment.

**Sign-offs Required:**
- [x] QA Lead
- [x] Technical Director
- [x] Producer
- [x] Creative Director
