# Apple HIG Reference Library Agent Handoff

**Date:** 2026-03-18  
**Repo Root:** `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp`  
**Primary Xcode Workspace:** `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace`

---

## 1. Ground Rules

- Work only in this repository root: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp`
- Do not use the old `🤩 SMP` path.
- Xcode validation should always target:
  - `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace`
- Main branch has already been used for iOS device builds and is the active working branch for this thread.

---

## 2. What This App Is Now

The app has been reshaped from a motion-preset demo into an **Apple HIG reference library**.

Current intended product identity:

- Title: `Apple HIG 레퍼런스`
- Top-level library kinds:
  - `패턴`
  - `구성요소`
- Home cards are visual reference cards with large hero thumbnails
- Search is a dedicated bottom-tab destination
- Favorites and Settings remain separate top-level destinations
- UI is styled with semantic Apple system colors and liquid-glass-inspired surfaces

The user specifically wants the app to feel like a **real Apple HIG reference browser**, not a generic design gallery.

---

## 3. Major Work Completed So Far

### A. Motion taxonomy phase

Earlier work replaced the old motion taxonomy with:

- `Enter`
- `Emphasize`
- `Navigate`
- `Manipulate`
- `Confirm`
- `Dismiss`

This is now mostly historical context. The app has since evolved beyond a pure motion library, but the underlying refactor is still part of the code history.

Relevant historical commit:

- `ff2931a feat: adopt native motion taxonomy presets` (worktree branch reference from prior session)

### B. Hermes / prebuild / Xcode stability

The repo includes fixes so prebuild and pod regeneration do not regress Hermes/Xcode script behavior.

Important files:

- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/package.json`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/patchHermesPodspecEncoding.js`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/patchHermesPodspecEncoding.test.cjs`

This area was previously verified with:

- `npm run prebuild:ios`
- `npx pod-install ios`
- `xcodebuild ... Release ... generic/platform=iOS build`

### C. Apple design library pivot

The UI and data model were pivoted from “모션 라이브러리” to an Apple design/HIG reference library.

Core files involved:

- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

### D. Liquid glass + semantic token work

The current UI now uses:

- semantic system colors
- semantic typography
- shared layout spacing tokens
- liquid-glass style surfaces
- preview scenes that are interactive rather than replay-only

### E. Single-column visual reference cards

The home and search views no longer use a 2-column grid.  
Cards are now single-column visual reference cards with large thumbnails and compact text.

### F. HIG hierarchy mirroring work

The app no longer treats both tabs as flat card lists.

Implemented direction:

- `Patterns` behaves like a leaf-topic list
- `Components` first shows official HIG component groups
- some planned-but-not-yet-implemented items are intentionally visible as `준비 중`

This is only partially complete relative to the full official HIG structure, but the model and first-pass UI scaffolding are in place.

---

## 4. Key Files and Their Roles

### `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift`

Now acts as the **reference catalog model**, not just a motion preset file.

Important contents:

- `AppleDesignTopic`
- `AppleLibraryKind`
- `AppleReferenceStatus`
- `AppleComponentGroup`
- topic sample data for patterns/components
- `implemented` vs `planned` state
- usage-context strings used in cards

### `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`

Renders the interactive preview scene for a given HIG topic.

Important contents:

- preview shell styling
- per-topic preview kind switching
- live interaction state
- shared preview layout tokens

### `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

Main UI shell for the library.

Important contents:

- semantic color/spacing tokens
- grid overlay implementation
- liquid glass panel modifiers
- card layout
- detail sheet
- home/search/favorites/settings screens
- root tab view
- HIG hierarchy browsing logic

### Tests

- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs`

These are file-content regression tests and are the fastest guardrail for ongoing UI structure changes.

---

## 5. Current Uncommitted Working State

At the time of this handoff, the following files are modified and not yet committed:

- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`

And these planning docs are currently untracked:

- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-18-grid-alignment-all-screens-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-18-hig-hierarchy-mirroring-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-18-hig-hierarchy-mirroring-implementation-plan.md`

This handoff file is also new and uncommitted.

---

## 6. Most Recent Verified State

### Tests

Most recent passing command:

```bash
node --test \
  /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs \
  /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs \
  /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs
```

Result:

- `28/28 pass`

### Simulator build

Most recent passing command:

```bash
xcodebuild -quiet \
  -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace \
  -scheme SMPMVP \
  -configuration Debug \
  -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' \
  ONLY_ACTIVE_ARCH=YES \
  build
```

Result:

- exit code `0`
- only existing Pod/Expo/Hermes warnings

### Real device / Release history

Real device signing was previously blocked because the selected development identity was invalid.  
That was resolved by creating a new valid Apple Development certificate in Xcode Accounts / Manage Certificates.

Release builds were previously verified successfully after that.

---

## 7. Recent Commits Already on Remote

Recent relevant commits on `origin/main`:

- `8394d10 feat: refine apple hig reference library`
- `96156f6 feat: build apple design library with liquid glass demos`
- `eb7812e chore: ignore local worktrees directory`
- `78f538a docs: add native motion taxonomy design and plan`
- `5b6882e docs: add HIG review and swiftui checklist`

Everything described in Section 5 is newer local work on top of `8394d10` and is not yet pushed.

---

## 8. Current UI Direction

### What is working well

- Product identity is clearer than before
- Home cards are much more visual than earlier text-heavy versions
- Search is separated into its own tab
- Favorites and Settings are stable
- Detail previews are interactive
- Semantic Apple system colors and typography are in place

### What is still in progress

- Exact HIG hierarchy mirroring is incomplete
- Some pattern topics and component leaves are still placeholders
- Some cards and detail layouts still need visual refinement against the grid
- The home/detail visual language is close, but not yet fully “Apple documentation-quality”

---

## 9. Latest User Feedback and Active Concern

The most recent active issue from the user was:

- some header titles appeared to intrude on margins
- some cards/panels did not visually fill the width inside the margin grid

A fix was just applied for this:

- a shared `AppleScreenHeader` was introduced
- custom content headers replaced native navigation titles in affected screens
- panels were forced to fill available width with consistent leading alignment

This was verified by tests and simulator build, but should still be visually checked in Simulator.

---

## 10. Operational Notes for Running the App

### Simulator

Known simulator device used most recently:

- `iPhone 17 Pro Max`
- simulator UDID used in builds:
  - `40C94D7D-D35C-47D5-8656-B9224FEBA48F`

### Metro / Dev Client

This app is typically run as an Expo Dev Client during local debugging.

If the app opens to:

- `No development servers found`

then Metro is not running or the dev-client URL was not reopened.

Typical recovery flow:

```bash
npm start -- --dev-client
```

Then reopen via dev-client URL, commonly:

```text
exp+smp-ios-mvp://expo-development-client/?url=http%3A%2F%2F127.0.0.1%3A8081
```

### Xcode

Always use:

- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace`

Do not use the `.xcodeproj`.

---

## 11. Important Planning Docs Created During This Thread

- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-11-motion-library-contextual-preview-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-11-motion-library-contextual-preview-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-12-apple-design-library-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-12-apple-design-library-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-13-liquid-glass-apple-design-library-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-13-liquid-glass-apple-design-library-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-13-bottom-search-tab-and-home-performance-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-13-bottom-search-tab-and-home-performance-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-13-semantic-apple-design-tokens-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-13-semantic-apple-design-tokens-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-17-library-media-first-cards-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-17-library-media-first-cards-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-17-hig-reference-identity-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-17-hig-reference-identity-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-18-grid-alignment-all-screens-implementation-plan.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-18-hig-hierarchy-mirroring-design.md`
- `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-18-hig-hierarchy-mirroring-implementation-plan.md`

These documents tell the story of the evolution from motion taxonomy work into a HIG reference browser.

---

## 12. User Preferences Captured During This Thread

- The user wants alignment with Apple HIG, not a generic custom design system
- The app title should convey clear identity
- Cards should be visual-first and easy to scan
- Metadata should focus on **usage context**, not abstract taxonomy
- The user prefers seeing official HIG hierarchy even when some items are not implemented yet
- Placeholder items should remain visible as `준비 중`
- Layout should obey the visible grid
- Thumbnails should feel closer to real iOS UI context than abstract placeholders
- Search should not appear in the top header of home; it belongs in the bottom tab shell

---

## 13. Suggested Next Steps for the Next Agent

### If the next task is visual refinement

1. Run the existing tests
2. Rebuild simulator debug
3. Open the app in Simulator with Metro running
4. Check:
   - home header margin alignment
   - full-width cards
   - detail panel inner alignment
   - component group screen visual rhythm

### If the next task is HIG structure completion

1. Continue expanding `AppleDesignTopic.sampleData`
2. Mirror more official `Patterns` leaves
3. Add more `Components` leaf items inside each official component group
4. Keep placeholder entries visible with `status == .planned`
5. Update tests in:
   - `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
   - `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`

### If the next task is commit/push cleanup

Before committing:

```bash
git -C /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp status --short
```

Then re-run:

```bash
node --test \
  /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs \
  /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs \
  /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs
```

and:

```bash
xcodebuild -quiet \
  -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace \
  -scheme SMPMVP \
  -configuration Debug \
  -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' \
  ONLY_ACTIVE_ARCH=YES \
  build
```

---

## 14. Short Handoff Summary

If a new agent reads only one paragraph, this is the one:

This repo is now an Apple HIG reference app built inside the Expo/SwiftUI iOS module shell. The major transformation from motion presets to a visual HIG browser is already done. The current local work is centered on (1) grid alignment across all screens and (2) mirroring official HIG hierarchy more honestly, including placeholder `준비 중` items. Tests are currently green (`28/28`), the simulator Debug build currently succeeds, and the next likely step is either visual verification in Simulator or continuing the hierarchy completion work before committing the latest local changes.
