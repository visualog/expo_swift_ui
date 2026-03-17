# Semantic Apple Design Tokens Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace hard-coded visual values in the Apple design library with semantic Apple design tokens for color, typography, and spacing.

**Architecture:** Add a shared semantic token layer in SwiftUI, then refactor the library shell and preview scenes to consume tokenized roles instead of raw hex values and fixed font sizes. Keep topic tint only as an accent signal, not as the base surface system.

**Tech Stack:** SwiftUI, UIKit semantic colors, ExpoModulesCore, Node file-based regression tests, xcodebuild

---

### Task 1: Document the token strategy

**Files:**
- Create: `docs/plans/2026-03-13-semantic-apple-design-tokens-design.md`
- Create: `docs/plans/2026-03-13-semantic-apple-design-tokens-implementation-plan.md`

**Step 1: Write the design doc**

Describe the current problems with hard-coded colors/fonts and the semantic token approach.

**Step 2: Write the implementation plan**

List exact files, tests, and verification commands for the token refactor.

### Task 2: Add failing tests for token adoption in the shell

**Files:**
- Modify: `scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that:
- a shared semantic token type exists in `ExpoShortcutsHomeView.swift`
- the library background no longer uses raw `Color(red:` values
- the home/detail/search shell uses semantic text styles instead of repeated `system(size:)` for key headings/body text

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: FAIL because the shell still uses hard-coded colors and font sizes.

### Task 3: Add failing tests for token adoption in previews

**Files:**
- Modify: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that:
- `MotionPreviewView.swift` defines or consumes semantic preview tokens
- preview shell and scene rows use semantic colors for foreground/background roles
- preview hint text no longer depends on a fixed `.system(size: 12, ...)` token

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/motionContextualPreviewFiles.test.cjs`

Expected: FAIL because preview scenes still contain many fixed font sizes and direct colors.

### Task 4: Implement semantic token layer for library screens

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: Add token types**

Introduce shared semantic color, typography, and spacing roles that wrap UIKit/SwiftUI semantic values.

**Step 2: Refactor background and panels**

Replace raw gradient/stroke/fill values with semantic background and panel tokens while keeping the liquid glass direction.

**Step 3: Refactor shell text hierarchy**

Move major titles, section titles, body copy, and metadata text to semantic text styles.

### Task 5: Implement semantic token adoption in previews

**Files:**
- Modify: `modules/expo-swiftui-card/ios/MotionPreviewView.swift`

**Step 1: Add preview token access**

Add semantic preview helpers for foreground, background, meta, stroke, and accent.

**Step 2: Refactor shared preview shell**

Replace direct white and raw size/color values with semantic roles.

**Step 3: Refactor repeated scene primitives**

Update common controls and labels in scenes to use semantic text styles and semantic fills.

### Task 6: Verify

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Modify: `modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- Modify: `scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
- Modify: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Run targeted tests**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs scripts/__tests__/motionContextualPreviewFiles.test.cjs`

Expected: PASS

**Step 2: Run broader regression tests**

Run: `node --test scripts/__tests__/gridOverlayPresentationFiles.test.cjs scripts/__tests__/liquidGlassLibraryFiles.test.cjs scripts/__tests__/motionContextualPreviewFiles.test.cjs`

Expected: PASS

**Step 3: Run iOS simulator build**

Run: `xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build`

Expected: exit code 0

**Step 4: Run device/release build**

Run: `xcodebuild -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Release -destination generic/platform=iOS build`

Expected: `** BUILD SUCCEEDED **`
