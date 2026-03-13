# Motion Library Contextual Preview Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Motion Library preset별로 실제 화면 맥락이 드러나는 고유 프리뷰를 구현하고, 상단 category UI를 줄임 없는 horizontal rail로 교체한다.

**Architecture:** `MotionPreviewView.swift`를 category-based shared card animation에서 preset-specific scene renderer로 재구성한다. 상세 프리뷰는 `surface` 기반 mini scene과 `preset.id` 기반 choreography를 결합한다. 홈 화면은 `segmented` Picker를 제거하고 `ScrollViewReader` 기반 category rail을 도입한다.

**Tech Stack:** SwiftUI, Expo Modules, xcodebuild, Node test runner, iOS Simulator

---

### Task 1: Lock the desired behavior with failing tests

**Files:**
- Create: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`
- Test: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

```javascript
test('preview view uses preset-specific scenes instead of category-only transforms', () => {
  const preview = read('modules/expo-swiftui-card/ios/MotionPreviewView.swift');
  assert.match(preview, /switch preset\.id/);
  assert.match(preview, /sheetScene|navigationScene|tabScene|toggleScene|listRowScene|cardScene/);
  assert.doesNotMatch(preview, /switch preset\.libraryCategory \{/);
});

test('home screen uses a horizontal category rail instead of segmented picker', () => {
  const home = read('modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift');
  assert.match(home, /ScrollViewReader/);
  assert.match(home, /ScrollView\(\.horizontal/);
  assert.doesNotMatch(home, /\.pickerStyle\(\.segmented\)/);
});
```

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: FAIL because the current preview still switches on `preset.libraryCategory` and the home screen still uses `.pickerStyle(.segmented)`.

**Step 3: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "test: add regression coverage for contextual motion previews"
```

---

### Task 2: Introduce a reusable category rail component

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**
- Reuse the second test from Task 1.

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs --test-name-pattern "horizontal category rail"
```
Expected: FAIL because `Picker(...).pickerStyle(.segmented)` is still present.

**Step 3: Write minimal implementation**

Add a custom rail in `ExpoShortcutsHomeView.swift`:

```swift
private struct MotionCategoryRail: View {
  let categories: [LibraryCategory]
  @Binding var selection: LibraryCategory

  var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(categories) { category in
            Button(category.title) {
              selection = category
              withAnimation(.easeInOut(duration: 0.2)) {
                proxy.scrollTo(category.id, anchor: .center)
              }
            }
            .id(category.id)
          }
        }
      }
    }
  }
}
```

Replace the segmented picker call site with `MotionCategoryRail`.

**Step 4: Run test to verify it passes**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs --test-name-pattern "horizontal category rail"
```
Expected: PASS

**Step 5: Build verify**

Run:
```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=916279A6-8D7F-49CB-A50F-606EF59CE581' ONLY_ACTIVE_ARCH=YES build
```
Expected: `BUILD SUCCEEDED`

**Step 6: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "feat: replace segmented category picker with motion rail"
```

---

### Task 3: Refactor preview state away from category-only transforms

**Files:**
- Modify: `modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- Test: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**
- Reuse the first test from Task 1.

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs --test-name-pattern "preset-specific scenes"
```
Expected: FAIL because `MotionPreviewView.swift` still relies on category-level `scaleValue`, `xOffset`, `yOffset`, `alphaValue`.

**Step 3: Write minimal implementation**

Restructure `MotionPreviewView.swift` into:

```swift
@State private var phase: PreviewPhase = .rest

private enum PreviewPhase {
  case rest
  case active
  case settled
}

@ViewBuilder
private var previewScene: some View {
  switch preset.id {
  case "enter_content_fade_in":
    contentFadeInScene
  case "enter_sheet_present", "dismiss_sheet_dismiss":
    sheetScene
  case "navigate_push_transition":
    pushTransitionScene
  case "navigate_large_title_collapse":
    largeTitleCollapseScene
  case "navigate_tab_switch_emphasis":
    tabSwitchScene
  case "confirm_toggle_state_morph":
    toggleScene
  case "manipulate_swipe_commit":
    swipeCommitScene
  case "manipulate_drag_lift":
    dragLiftScene
  default:
    genericCardScene
  }
}
```

Keep `duration`, `delay`, `easing`, `intensity` as tuning inputs for the same scene.

**Step 4: Run test to verify it passes**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs --test-name-pattern "preset-specific scenes"
```
Expected: PASS

**Step 5: Build verify**

Run:
```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=916279A6-8D7F-49CB-A50F-606EF59CE581' ONLY_ACTIVE_ARCH=YES build
```
Expected: `BUILD SUCCEEDED`

**Step 6: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "feat: switch motion preview to preset-specific scenes"
```

---

### Task 4: Implement surface-accurate preview scenes

**Files:**
- Modify: `modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- Test: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

Extend the preview test with explicit scene coverage:

```javascript
assert.match(preview, /contentFadeInScene/);
assert.match(preview, /sheetScene/);
assert.match(preview, /pushTransitionScene/);
assert.match(preview, /largeTitleCollapseScene/);
assert.match(preview, /tabSwitchScene/);
assert.match(preview, /toggleScene/);
assert.match(preview, /swipeCommitScene/);
assert.match(preview, /dragLiftScene/);
```

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: FAIL until all scene functions exist.

**Step 3: Write minimal implementation**

Implement each scene as a dedicated `@ViewBuilder` block:

- `contentFadeInScene`: title/body/card stack with staggered reveal
- `sheetScene`: dimmed backdrop + bottom sheet
- `pushTransitionScene`: source and destination cards in a nav container
- `largeTitleCollapseScene`: large title + list content that collapses
- `tabSwitchScene`: bottom tab rail + active panel change
- `toggleScene`: real toggle-like control morph
- `swipeCommitScene`: list row drag and commit badge
- `dragLiftScene`: floating card with shadow/lift

**Step 4: Run test to verify it passes**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: PASS

**Step 5: Build verify**

Run:
```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=916279A6-8D7F-49CB-A50F-606EF59CE581' ONLY_ACTIVE_ARCH=YES build
```
Expected: `BUILD SUCCEEDED`

**Step 6: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "feat: add contextual preview scenes for motion presets"
```

---

### Task 5: Expand detail layout to support the larger scene

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `scripts/__tests__/motionTaxonomyFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions that the detail view still includes the taxonomy metadata and embeds `MotionPreviewView` as the top section.

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs
```
Expected: FAIL if the detail layout regresses while the preview canvas is expanded.

**Step 3: Write minimal implementation**

- Increase preview container prominence in `MotionPresetDetailSheet`
- Keep parameter controls below the scene
- Preserve metadata and snippet sections
- Ensure replay control remains visible without clipping

**Step 4: Run test to verify it passes**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs
```
Expected: PASS

**Step 5: Build verify**

Run:
```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=916279A6-8D7F-49CB-A50F-606EF59CE581' ONLY_ACTIVE_ARCH=YES build
```
Expected: `BUILD SUCCEEDED`

**Step 6: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs
git commit -m "feat: tune motion preset detail for contextual scenes"
```

---

### Task 6: Final verification and regression sweep

**Files:**
- Modify: 없음

**Step 1: Run targeted file tests**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: all tests PASS

**Step 2: Run simulator build**

Run:
```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=916279A6-8D7F-49CB-A50F-606EF59CE581' ONLY_ACTIVE_ARCH=YES build
```
Expected: `BUILD SUCCEEDED`

**Step 3: Manual QA**

- Confirm category rail shows full labels with no truncation
- Confirm hidden labels appear when horizontally scrolling
- Confirm `Sheet Present`, `Toggle State Morph`, `Swipe Commit`, `Push Transition` all look semantically different
- Confirm tuning controls do not change preset meaning

**Step 4: Commit**

```bash
git add -A
git commit -m "feat: add contextual motion previews and category rail"
```
