# Solstice Cipher: v1.0.3 Day-One Patch Rollback Plan

## Overview
**Target Version:** v1.0.2 (Gold Master)
**Rollback Version:** v1.0.3 (Day-One Patch - Level 1 Tutorial)
**Supported Platforms:** GitHub Pages, Vercel Web Export

## 1. Rollback Execution Procedures

### Vercel Web Export
Vercel maintains immutable deployments, allowing for near-instantaneous rollbacks.
*   **Step 1:** Log into the Vercel Dashboard and navigate to the `solstice-cipher` project.
*   **Step 2:** Go to the **Deployments** tab.
*   **Step 3:** Locate the last successful deployment for `v1.0.2` (Gold Master).
*   **Step 4:** Click the vertical ellipsis (`...`) next to the deployment and select **Assign to Production Domain** (or **Revert to this deployment**).
*   **Step 5:** Confirm the action. The production URL will instantly point to the v1.0.2 build.

### GitHub Pages
GitHub Pages deployments depend on the branch and CI/CD setup.
*   **Step 1:** Open the terminal and ensure you are on the `main` deployment branch.
*   **Step 2:** Revert the merge commit or the specific commit that bumped the version to v1.0.3:
    ```bash
    git revert <commit-hash-of-v1.0.3-release>
    ```
*   **Step 3:** Push the reverted commit:
    ```bash
    git push origin main
    ```
*   **Step 4:** Navigate to the **Actions** tab in the GitHub repository to monitor the Pages deployment workflow.
*   **Step 5:** Wait for the workflow to complete (typically 2-3 minutes) to verify the build is live.

## 2. Platform-Specific Rollback Constraints

*   **Vercel Caching:** Vercel edge caching is cleared almost immediately upon reverting the deployment. However, active players might need to hard refresh (`Ctrl+F5` or `Cmd+Shift+R`) if their browser has heavily cached the WebGL/WASM web export assets.
*   **GitHub Pages CDN Delay:** GitHub's Fastly CDN can take up to 10 minutes to invalidate the cache across all global edge nodes. Some regions may continue to serve v1.0.3 temporarily, leading to a fragmented player base for a brief window.
*   **Save Data / LocalStorage Compatibility:** If the v1.0.3 tutorial modified the structure of the player's LocalStorage save state (e.g., adding a `tutorial_completed: true` flag), rolling back to v1.0.2 must not break the game. The v1.0.2 build must be able to gracefully ignore unknown save flags. If it cannot, players may experience black screens and will need instructions on how to clear their browser site data.

## 3. Roles and Responsibilities

*   **Decision Maker / Initiator:** The **Release Manager** (or Lead Producer) holds the sole authority to trigger the rollback based on severity thresholds (e.g., 5%+ crash rate, hard-locks in the new tutorial, critical memory leaks).
*   **Execution:** The **Release Manager** (or DevOps) performs the GitHub Git revert and Vercel dashboard actions.
*   **Verification:** **QA** is responsible for immediately testing the production URLs post-rollback to ensure v1.0.2 is live, the tutorial is gone, and previous save files load without errors.
*   **Player Communication:** The **Community Manager** is responsible for drafting and publishing all messaging across social channels (Discord, X/Twitter, etc.).

## 4. Player Communication Strategy

Communication must be transparent, prompt, and provide actionable steps for players.

*   **Immediate Acknowledgment (0-15 mins of issue detection):**
    > *"We're currently investigating reports of [Issue, e.g., freezing during the Level 1 tutorial] in the Solstice Cipher Day-One Patch. We are working on a fix ASAP."*
*   **Rollback Announcement (At time of rollback execution):**
    > *"To ensure everyone can keep playing smoothly, we are temporarily rolling back Solstice Cipher to v1.0.2 (our launch build) while we fix the bugs in the new Level 1 tutorial. No save data will be lost. Please hard refresh your browser (Ctrl+F5 or Cmd+Shift+R) if you experience any unusual behavior."*
*   **Resolution Follow-Up (Post-Rollback completion):**
    > *"The rollback to v1.0.2 is now fully complete across all platforms. We'll deploy the updated Level 1 tutorial in a hotfix later this week once it passes rigorous testing. Thank you for your patience!"*
