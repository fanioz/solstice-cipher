# Rollback Plan -- Solstice Cipher v1.0.2

This document outlines the rollback procedure for version v1.0.2 of Solstice Cipher, reverting back to the previous stable release v1.0.1 on the Web/HTML5 target platform.

## 1. Rollback Procedure (Web/HTML5)
To revert the active build from v1.0.2 to v1.0.1 on the hosting platform (e.g., GitHub Pages, Itch.io, or custom static hosting):

### Git Reversion
1. **Locate the Stable Version Tag**: Verify that the previous release tag `v1.0.1` exists:
   ```bash
   git fetch --tags
   git checkout tags/v1.0.1
   ```
2. **Re-build HTML5 Artifacts**:
   - If deployment is automated via a deployment branch (e.g., `gh-pages`):
     - Ensure the build is re-generated from the clean `v1.0.1` codebase using Godot's headless CLI:
       ```bash
       godot --headless --export-release "Web" build/web/index.html
       ```
3. **Deploy to Hosting Branch**:
   - Push the generated HTML5 artifacts to the deployment branch:
     - For Git-based hosting (GitHub Pages):
       ```bash
       npx gh-pages -d build/web
       ```
     - For direct branch tracking: force-push the v1.0.1 build commit to the tracking branch:
       ```bash
       git push origin <v1.0.1-commit-hash>:<deployment-branch> --force
       ```
   - For Itch.io deployment (using Butler):
     ```bash
     butler push build/web/ fanioz/solstice-cipher:web-html5 --target v1.0.1
     ```

## 2. Platform-Specific Rollback Constraints
*   **CDN & Browser Caching**:
    *   *Constraint*: Web browsers cache the game's `.js`, `.wasm`, and `.pck` files aggressively. Even after deploying the v1.0.1 rollback build, players who have the game tab open or recently loaded it will continue to run the buggy v1.0.2 version.
    *   *Mitigation*: Trigger a CDN cache purge (if using Cloudflare or similar). Ensure that cache control headers on the hosting server are set to `no-cache` or `max-age=0` for the HTML/loader files, and require a hard refresh (Ctrl+F5 / Cmd+Shift+R) in public communications.
*   **Save State / LocalStorage Compatibility**:
    *   *Constraint*: If v1.0.2 introduced changes to the local save game schema (`user://save.dat` or browser LocalStorage / IndexedDB), reverting to v1.0.1 could cause crashes or parse errors if v1.0.1 does not support the new schema.
    *   *Mitigation*: Verify the save-state compatibility between v1.0.2 and v1.0.1. If v1.0.2 migrated the save structure, the rollback must include a fallback mechanism, or players must be informed that progress made during the brief v1.0.2 window might be lost.

## 3. Roles and Responsibilities
*   **Incident Commander / Trigger Decision**:
    *   *Role*: Creative Director (User) or Producer.
    *   *Responsibility*: Approves the decision to trigger the rollback based on severity criteria (e.g., S1-Critical crash rate >5% or blocker bug prevents gameplay).
*   **Deployment Execution**:
    *   *Role*: Release Manager (DevOps / Lead Programmer).
    *   *Responsibility*: Performs the Git revert, re-builds the v1.0.1 package, redeploys the files to the web hosting, and verifies the deployment status.
*   **Validation**:
    *   *Role*: QA Lead.
    *   *Responsibility*: Performs a sanity/smoke check on the rolled-back deployment to ensure the game loads, runs v1.0.1, and save states Hydrate successfully.
*   **Communication**:
    *   *Role*: Community Manager.
    *   *Responsibility*: Drafts and posts player-facing announcements across Discord, Itch.io, and other social channels.

## 4. Player Communication Plan
If a rollback is initiated, transparent and timely communication is required to prevent negative player sentiment.

### Initial Acknowledgment
> 📢 **Attention Players:**
> We are aware of critical issues affecting stability in our latest patch (v1.0.2). Our team is actively investigating. If you are experiencing crashes or freezing, please hang tight as we work on a fix.

### Rollback Announcement
> ⚠️ **Update on v1.0.2 Patch Reversion:**
> To ensure a stable experience while we address compatibility and stability issues in today's update, we have temporarily rolled the game build back to **v1.0.1**.
>
> **What this means for you:**
> - The game will run on version v1.0.1.
> - **Action Required**: You may need to perform a hard refresh (Ctrl+F5 on Windows, Cmd+Shift+R on Mac) or clear your browser cache to ensure the rollback takes effect.
> - **Saves**: Your main progress from v1.0.1 remains safe. Any progress made during the brief window of v1.0.2 should remain intact, but if you experience issues loading, please reach out in our support channel.
>
> We apologize for the inconvenience and thank you for your patience as we prepare a hotfix!

### Resolution Announcement
> ✅ **Solstice Cipher v1.0.2 is Now Live!**
> The stability issues from the previous v1.0.2 update have been resolved, and the update is now successfully redeployed.
> Thank you again for your patience and support! Let us know if you run into any further issues in our bug-reporting channel.
