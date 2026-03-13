# Liquid Glass Apple Design Library Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Convert the Apple Design Library UI to an iOS 26 Liquid Glass presentation and replace replay-only previews with live interactive demos.

**Architecture:** Keep the existing `AppleDesignTopic` catalog and native tab / segmented structure, then add a shared glass styling layer for shell surfaces and a stateful interactive scene system inside `MotionPreviewView`. Use availability-gated helpers so iOS 26 gets glass-specific behavior while older targets fall back to material-backed grouped surfaces.

**Tech Stack:** SwiftUI, UIKit hosting bridge, ExpoModulesCore, Node file-level regression tests, xcodebuild

---

### Task 1: Lock the shell restyle with failing regression tests

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
- Create: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that:
- `ExpoShortcutsHomeView.swift` contains a shared glass-style helper or modifier
- `AppleDesignLibraryHomeScreen`, `AppleDesignTopicCard`, `AppleDesignTopicDetailSheet`, and `SettingsScreen` use that helper
- the library still uses native `Picker(...).pickerStyle(.segmented)` and `TabView`
- the old replay-only affordance is no longer the primary interaction model

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: FAIL because the glass helper and interactive shell wiring do not exist yet.

**Step 3: Write minimal implementation support points**

Add only the smallest structural hooks needed so the test can target real symbols and usage sites.

**Step 4: Run test to verify it passes**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: PASS

**Step 5: Commit**

```bash
git add scripts/__tests__/liquidGlassLibraryFiles.test.cjs scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "test: lock liquid glass library shell structure"
```

### Task 2: Add shared Liquid Glass surface helpers

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Extend the test to require:
- a shared background helper for the library root
- a shared glass panel helper for cards and sheet blocks
- iOS 26 availability branching for glass-specific behavior

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: FAIL with missing helper names or missing usage.

**Step 3: Write minimal implementation**

Implement helper(s) inside `ExpoShortcutsHomeView.swift` such as:
- a soft gradient root background
- a reusable panel modifier for cards, search field, segmented container, metadata blocks, and empty states
- a fallback path for non-iOS-26 targets

Do not change preview interactivity yet.

**Step 4: Run test to verify it passes**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: PASS

**Step 5: Commit**

```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift scripts/__tests__/liquidGlassLibraryFiles.test.cjs
git commit -m "feat: add liquid glass shell surfaces"
```

### Task 3: Convert topic cards and detail sections to the new shell

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Require the card and detail sections to use the shared glass panel helper rather than plain grouped background fills.

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: FAIL

**Step 3: Write minimal implementation**

Apply the new helper to:
- `AppleDesignTopicCard`
- detail metadata sections
- code snippet block container
- favorites empty state
- settings form wrapper or surrounding shell

Keep touch targets at or above 44pt.

**Step 4: Run test to verify it passes**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: PASS

**Step 5: Commit**

```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift scripts/__tests__/liquidGlassLibraryFiles.test.cjs
git commit -m "feat: restyle library cards and sheets with glass panels"
```

### Task 4: Lock interactive preview behavior with failing tests

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`

**Step 1: Write the failing test**

Add assertions that `MotionPreviewView.swift` includes:
- explicit per-scene state beyond a single replay flag
- tap/drag/swipe/toggle gesture hooks
- native interactive controls for segmented, picker, page control, toggle, and text input scenes

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/motionContextualPreviewFiles.test.cjs`

Expected: FAIL because most scenes are still replay-based.

**Step 3: Write minimal implementation support points**

Introduce placeholder state and function names needed for each interactive scene path.

**Step 4: Run test to verify it passes**

Run: `node --test scripts/__tests__/motionContextualPreviewFiles.test.cjs`

Expected: PASS

**Step 5: Commit**

```bash
git add modules/expo-swiftui-card/ios/MotionPreviewView.swift scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "test: lock interactive preview scene structure"
```

### Task 5: Rebuild MotionPreviewView as a live demo surface

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

Tighten the test to check for concrete scene behavior hooks:
- drag state for modal/page scenes
- focus/input state for search/text field scenes
- selection state for segmented/picker/page control scenes
- direct toggle state for toggle scene

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/motionContextualPreviewFiles.test.cjs`

Expected: FAIL

**Step 3: Write minimal implementation**

Refactor `MotionPreviewView` to:
- replace replay-first flow with event-first interaction
- use live controls where possible
- keep a small reset helper only as a secondary action if needed
- apply glass-style preview chrome with fallback

**Step 4: Run test to verify it passes**

Run: `node --test scripts/__tests__/motionContextualPreviewFiles.test.cjs`

Expected: PASS

**Step 5: Commit**

```bash
git add modules/expo-swiftui-card/ios/MotionPreviewView.swift scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "feat: add live interactive liquid glass previews"
```

### Task 6: Verify grid overlay and shell coexistence

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs`
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: Write the failing test**

Add assertions that grid overlay presenter still exists and the shell restyle did not move grid rendering back into the SwiftUI tree.

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/gridOverlayPresentationFiles.test.cjs`

Expected: FAIL only if shell changes regressed overlay placement.

**Step 3: Write minimal implementation**

Keep the current window-level overlay intact while integrating any glass-related scene changes.

**Step 4: Run test to verify it passes**

Run: `node --test scripts/__tests__/gridOverlayPresentationFiles.test.cjs`

Expected: PASS

**Step 5: Commit**

```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift scripts/__tests__/gridOverlayPresentationFiles.test.cjs
git commit -m "test: preserve overlay window behavior with glass shell"
```

### Task 7: Run local verification

**Files:**
- Modify: none

**Step 1: Run targeted tests**

Run:

```bash
node --test \
  scripts/__tests__/motionTaxonomyFiles.test.cjs \
  scripts/__tests__/motionContextualPreviewFiles.test.cjs \
  scripts/__tests__/gridOverlayPresentationFiles.test.cjs \
  scripts/__tests__/liquidGlassLibraryFiles.test.cjs
```

Expected: PASS

**Step 2: Run iOS simulator build**

Run:

```bash
xcodebuild -quiet \
  -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace \
  -scheme SMPMVP \
  -configuration Debug \
  -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' \
  ONLY_ACTIVE_ARCH=YES \
  build
```

Expected: build succeeds

**Step 3: Run device/release build**

Run:

```bash
xcodebuild \
  -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace \
  -scheme SMPMVP \
  -configuration Release \
  -destination generic/platform=iOS \
  build
```

Expected: `** BUILD SUCCEEDED **`

**Step 4: Manual simulator verification**

Check:
- home shell uses glass surfaces
- detail sheet uses glass surfaces
- toggle/page control/modal demos react to touch
- segmented control remains native
- grid overlay remains above sheet

**Step 5: Commit**

```bash
git add .
git commit -m "feat: adopt liquid glass apple design library"
```
