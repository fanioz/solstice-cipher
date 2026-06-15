# Rollback Plan -- Day-One Patch v1.0.1

This document outlines the rollback procedure for the Solstice Cipher Day-One Patch (v1.0.1).

## Rollback Procedure
If the Day-One Patch introduces critical bugs or crash regressions, we will immediately revert to the Gold Master release build (v1.0.0).

### Platform Reversion
- **Android (Google Play Store)**:
  - Trigger a rollout reversion by promoting the previous v1.0.0 build to the production track, or submit a new build (v1.0.2) that contains the reverted code.
- **Web (GitHub Pages / Itch.io)**:
  - Force-push/redeploy the tag `v1.0.0-gold` or revert the commits back to the gold master commit.

### Rollback Constraints
- Google Play Store review times can take up to 24-48 hours. If a rollback is needed on Android, users may experience delayed reversion.
- For Web, redeployment takes less than 5 minutes.

### Ownership
- **Trigger Decision**: User (Creative Director)
- **Deployment Execution**: Antigravity (DevOps / Lead Programmer role)

### Player Communication
- If a rollback occurs, post a community message on the game store page / platform channels:
  - *"We have temporarily reverted the latest game update to address compatibility issues. Thank you for your patience."*
