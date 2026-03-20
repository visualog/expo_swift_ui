# Planned Card Visual Differentiation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make `planned` HIG topic cards visually distinct from implemented cards by replacing contextual heroes with a placeholder hero treatment.

**Architecture:** Keep the current `AppleDesignTopicCard` structure and status copy, but branch inside `AppleDesignTopicThumbnail` so `planned` topics render a dedicated placeholder hero. Preserve existing detail fallback and hierarchy behavior.

**Tech Stack:** SwiftUI, Expo UI module, Node test runner, xcodebuild

---

### Task 1: Add a failing test for planned-card hero behavior

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that:
- `AppleDesignTopicThumbnail` branches on `topic.status == .planned`
- the planned branch contains explicit `Text("준비 중")`
- the planned branch uses a named placeholder hero helper instead of contextual thumbnail helpers

**Step 2: Run test to verify it fails**

Run:

```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs
```

Expected: FAIL because the planned thumbnail branch does not exist yet.

### Task 2: Implement the minimal planned placeholder hero

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: Add a dedicated placeholder hero helper**

Create a `plannedThumbnail` view inside `AppleDesignTopicThumbnail` that uses:
- topic icon
- `준비 중` label
- neutral skeleton lines
- existing semantic colors and topic tint

**Step 2: Branch thumbnail rendering**

Return the placeholder hero when `topic.status == .planned`; otherwise keep the existing contextual thumbnail switch.

**Step 3: Keep body structure unchanged**

Do not change card metadata, group cards, or detail fallback in this task.

### Task 3: Verify tests and build

**Files:**
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs`

**Step 1: Run targeted tests**

```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs
```

Expected: PASS with zero failures.

**Step 2: Run simulator build**

```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build
```

Expected: exit code `0`
