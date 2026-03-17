# Library Media-First Cards Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make the Apple design library feel more visual by increasing thumbnail and preview prominence in home cards and detail screens.

**Architecture:** Keep the current semantic-token and native-navigation structure, but rebalance existing SwiftUI views so thumbnails and preview heroes occupy more vertical space than metadata. Use tests to lock in the new sizing and structure before implementation.

**Tech Stack:** SwiftUI, ExpoModulesCore, node:test, xcodebuild

---

### Task 1: Lock in media-first card expectations

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that home cards use a taller full-width thumbnail, retain compact text, and keep the favorite affordance at least 44x44.

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
Expected: FAIL until the larger media-first layout is implemented.

**Step 3: Write minimal implementation**

Update the home card layout and any related detail hero sizing so the new assertions become true.

**Step 4: Run test to verify it passes**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
Expected: PASS

### Task 2: Increase visual emphasis in SwiftUI views

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`

**Step 1: Write the failing test**

Extend tests to assert that the detail preview shell uses a larger frame and the helper hint is visually secondary.

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
Expected: FAIL until the preview hero sizing and hierarchy are updated.

**Step 3: Write minimal implementation**

Increase the home thumbnail height and detail preview height, reduce non-essential helper copy prominence, and keep the remaining metadata below the preview.

**Step 4: Run test to verify it passes**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
Expected: PASS

### Task 3: Verify the integrated build

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`

**Step 1: Run the targeted test suite**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs`
Expected: PASS

**Step 2: Run a fresh simulator build**

Run: `xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build`
Expected: exit code 0
