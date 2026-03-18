# Grid Alignment Across All Screens Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Align the library, search, favorites, settings, and detail screens to one shared 4-column rhythm so cards, headers, and panels sit on consistent horizontal and vertical grid lines.

**Architecture:** Introduce a small shared layout token set in the SwiftUI library shell and replace literal spacing values with those tokens across top-level screens and card/detail components. Lock the behavior with file-level tests that assert shared spacing tokens and screen-specific usage.

**Tech Stack:** SwiftUI, Expo Modules Core, Node test runner, xcodebuild

---

### Task 1: Define shared layout rhythm

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions for shared spacing tokens such as `cardGap`, `heroPadding`, `panelPadding`, and a detail section gap token.

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
Expected: FAIL because the new token names are not present yet.

**Step 3: Write minimal implementation**

Add the shared spacing tokens under `AppleDesignSemanticTokens.Spacing`.

**Step 4: Run test to verify it passes**

Run the same test command and confirm the new assertions pass.

### Task 2: Align top-level screens to the same grid

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that home, search, favorites, and settings screens use the shared spacing tokens for horizontal padding, section gaps, and list/card spacing.

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
Expected: FAIL because screens still use mixed literal values.

**Step 3: Write minimal implementation**

Replace literal paddings and stack spacings in the top-level screens with the shared tokens.

**Step 4: Run test to verify it passes**

Run the same test command and confirm the screen layout assertions pass.

### Task 3: Align cards, thumbnails, and detail panels

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that cards and detail sections use shared footer/panel padding, thumbnail hero padding, and preview spacing values.

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
Expected: FAIL because the card and preview code still use mixed literals.

**Step 3: Write minimal implementation**

Refactor thumbnail internals, card footer spacing, detail panel spacing, and preview padding to the shared rhythm.

**Step 4: Run test to verify it passes**

Run the same test command and confirm the new layout assertions pass.

### Task 4: Verify builds after layout alignment

**Files:**
- No new files

**Step 1: Run focused tests**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs`
Expected: PASS

**Step 2: Run simulator build**

Run: `xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build`
Expected: exit code 0
