# Apple HIG Reference Identity Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make the home screen read as a focused Apple HIG reference browser with clearer identity, real-context thumbnails, and usage-context metadata.

**Architecture:** Keep the existing SwiftUI library shell, semantic tokens, and single-column card layout. Update only the home identity copy, topic metadata model, and thumbnail renderers so the home screen becomes more concrete without destabilizing detail screens and search behavior.

**Tech Stack:** SwiftUI, Expo UI bridge module, Node test runner, xcodebuild simulator build

---

### Task 1: Add failing tests for reference identity and context metadata

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift`

**Step 1: Write the failing test**

Add assertions that expect:
- Home supporting copy to mention HIG reference purpose
- Home section label to use concrete language like `실제 화면 패턴`
- Cards to render a context line instead of `sectionTitle • name`
- Topic data to expose a `usageContext` field

**Step 2: Run test to verify it fails**

Run:

```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs
```

Expected: FAIL because current source still relies on section/name metadata and lacks `usageContext`.

**Step 3: Write minimal implementation**

Add `usageContext` to the topic model and seed values for existing topics. Update the home view copy and card metadata binding to use it.

**Step 4: Run test to verify it passes**

Run the same command and confirm the new expectations are green.

**Step 5: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift
git commit -m "feat: clarify HIG reference identity"
```

### Task 2: Make thumbnails read like real iOS contexts

**Files:**
- Modify: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that expect specific scene structures for thumbnail cases, for example:
- Search thumbnail includes a search field plus result rows
- Modal thumbnail includes parent surface plus raised sheet
- Toggle thumbnail uses a settings-row pattern
- Page thumbnail includes cards and page dots

**Step 2: Run test to verify it fails**

Run:

```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs
```

Expected: FAIL because current thumbnail scenes are still too generic.

**Step 3: Write minimal implementation**

Refine the `AppleDesignTopicThumbnail` scene builders so they depict more literal iOS contexts while preserving the new edge-to-edge hero structure.

**Step 4: Run test to verify it passes**

Run the same test command and confirm the thumbnail assertions pass.

**Step 5: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs
git commit -m "feat: add context-first library thumbnails"
```

### Task 3: Run regression verification and simulator build

**Files:**
- Verify only

**Step 1: Run regression tests**

```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/liquidGlassLibraryFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/gridOverlayPresentationFiles.test.cjs
```

Expected: PASS with zero failures.

**Step 2: Run simulator build**

```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build
```

Expected: exit code `0`.

**Step 3: Reinstall and launch in simulator**

```bash
xcrun simctl install booted /Users/im_018/Library/Developer/Xcode/DerivedData/SMPMVP-enxxdbidyaceyoaypsoublhtongz/Build/Products/Debug-iphonesimulator/SMPMVP.app
xcrun simctl launch booted com.smp.mvp
```

Expected: latest app launches successfully.

**Step 4: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-17-hig-reference-identity-design.md /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-17-hig-reference-identity-implementation-plan.md
git commit -m "docs: plan HIG reference identity refinement"
```
