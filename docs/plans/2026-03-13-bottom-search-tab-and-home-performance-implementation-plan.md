# Bottom Search Tab And Home Performance Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Move search from the home header into the bottom tab area as a right-aligned destination and reduce scroll jank on the home library screen.

**Architecture:** Keep the existing three root destinations on the left side of the tab bar, introduce a dedicated search destination reachable from a bottom accessory on iOS 26+, and remove the duplicated home search field. Reduce home scroll compositing cost by introducing a lighter liquid panel style for scrolling cards and by simplifying the chrome around the segmented picker.

**Tech Stack:** SwiftUI, UIKit hosting, ExpoModulesCore, Node file-based regression tests, xcodebuild

---

### Task 1: Document the new shell structure

**Files:**
- Create: `docs/plans/2026-03-13-bottom-search-tab-and-home-performance-design.md`
- Create: `docs/plans/2026-03-13-bottom-search-tab-and-home-performance-implementation-plan.md`

**Step 1: Write the design doc**

Describe the search relocation, tab-bar accessory approach, and the performance rationale for lighter home chrome.

**Step 2: Write the implementation plan**

List exact files, tests, and verification commands for the UI restructure and performance cleanup.

### Task 2: Add failing tests for the new search structure

**Files:**
- Modify: `scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that:
- the home screen no longer contains `TextField("패턴 또는 구성요소 검색"`
- the root tab shell contains `tabViewBottomAccessory`
- the root tab shell contains `RootTab.search` or equivalent dedicated search destination structure

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: FAIL because the top search field still exists and bottom search accessory is missing.

**Step 3: Commit**

After implementation and green verification, include the updated test file in the next commit.

### Task 3: Add failing tests for lighter home cards

**Files:**
- Modify: `scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that:
- `AppleDesignTopicCard` uses a lighter panel variant instead of the heavy default panel
- the segmented picker is no longer wrapped in the same heavy panel treatment used by cards

**Step 2: Run test to verify it fails**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: FAIL because cards still use the heavy panel and segmented is still wrapped.

### Task 4: Implement the new search destination

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: Remove home-header search state and filtering**

Delete the `query` state and top search field from `AppleDesignLibraryHomeScreen`. Keep filtering only by selected library kind on the home screen.

**Step 2: Add a dedicated search screen**

Create a search-focused screen that owns its own query state, searches across all topics, and presents empty/result states with the same library visuals.

**Step 3: Extend root tab state**

Add a search tab state and wire the root shell to display the search destination.

**Step 4: Add bottom accessory search affordance**

On iOS 26+, use `tabViewBottomAccessory` to present a right-aligned search affordance that switches selection to the search destination.

### Task 5: Implement the home performance cleanup

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: Introduce a lighter liquid panel modifier**

Add a second panel variant with reduced shadow, reduced tint overlay, and lower compositing cost for scrolling cards.

**Step 2: Move topic cards to the lighter panel**

Update `AppleDesignTopicCard` to use the lighter panel variant.

**Step 3: Simplify top chrome**

Keep the segmented picker native and remove the extra heavy glass wrapper around it. Keep surrounding spacing and hierarchy readable.

### Task 6: Verify

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Modify: `scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Run targeted tests**

Run: `node --test scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

Expected: PASS

**Step 2: Run broader library regression tests**

Run: `node --test scripts/__tests__/motionContextualPreviewFiles.test.cjs scripts/__tests__/liquidGlassLibraryFiles.test.cjs scripts/__tests__/gridOverlayPresentationFiles.test.cjs`

Expected: PASS

**Step 3: Run iOS simulator build**

Run: `xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build`

Expected: exit code 0

**Step 4: Run device/release build**

Run: `xcodebuild -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Release -destination generic/platform=iOS build`

Expected: `** BUILD SUCCEEDED **`
