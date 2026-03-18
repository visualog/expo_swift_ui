# HIG Hierarchy Mirroring Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rebuild the library information architecture so `Patterns` and `Components` mirror the official Apple HIG hierarchy while exposing unimplemented items as `준비 중`.

**Architecture:** Extend the existing `AppleDesignTopic` catalog into a hierarchical reference model with status metadata, then refactor library/search/favorites/detail navigation so patterns render as official leaf items and components render as official group-first navigation. Preserve existing rich previews for implemented items and add lightweight placeholders for planned items.

**Tech Stack:** SwiftUI, Expo Modules Core, Node test runner, xcodebuild

---

### Task 1: Add hierarchy and status models to the catalog

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions for:
- `AppleReferenceStatus`
- component group metadata
- official `Components` group labels
- planned/implemented status fields

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
Expected: FAIL because hierarchy/status model is not present yet.

**Step 3: Write minimal implementation**

Add the status enum and hierarchical metadata fields. Populate sample data with:
- official `Patterns` leaves
- official `Components` groups
- status values for implemented and planned items

**Step 4: Run test to verify it passes**

Run the same test command and confirm the hierarchy assertions pass.

### Task 2: Refactor library home to mirror official HIG navigation

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that:
- `Patterns` renders official leaf list
- `Components` renders official group list
- group cards/navigation exist
- planned items expose a `준비 중` state

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
Expected: FAIL because the current screen still uses flat lists.

**Step 3: Write minimal implementation**

Refactor the home screen to:
- render pattern leaves directly
- render component groups first
- push into a component-group list screen
- preserve current implemented-topic card style where possible

**Step 4: Run test to verify it passes**

Run the same test command and confirm the library structure assertions pass.

### Task 3: Add planned-state cards and detail behavior

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions for:
- `준비 중` badge/state copy
- detail fallback for planned items
- no interactive preview requirement for planned items

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs`
Expected: FAIL because planned-state UI does not exist yet.

**Step 3: Write minimal implementation**

Add:
- planned-state group/item cards
- planned-state detail panel
- conditional preview rendering for implemented items only

**Step 4: Run test to verify it passes**

Run the same test command and confirm the planned-state assertions pass.

### Task 4: Update search and favorites for the new hierarchy

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that search can surface:
- pattern leaves
- component groups
- component leaves

Also assert favorites remain leaf-topic-only.

**Step 2: Run test to verify it fails**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
Expected: FAIL because the current search/favorites logic only understands the flat model.

**Step 3: Write minimal implementation**

Update search indexing and favorites filtering to reflect the new hierarchy while keeping favorites limited to leaf topics.

**Step 4: Run test to verify it passes**

Run the same test command and confirm search/favorites assertions pass.

### Task 5: Verify builds after hierarchy refactor

**Files:**
- No new files

**Step 1: Run focused tests**

Run: `node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs`
Expected: PASS

**Step 2: Run simulator build**

Run: `xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build`
Expected: exit code 0
