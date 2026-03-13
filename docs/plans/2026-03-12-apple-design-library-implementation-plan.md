# Apple Design Library Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 기존 모션 라이브러리를 Apple HIG `패턴 / 구성요소` 구조를 미러링하는 `애플 디자인 라이브러리`로 재구성한다.

**Architecture:** 기존 `MotionPreset` 중심 모델을 `AppleLibraryKind`와 `AppleDesignTopic` 정적 카탈로그로 교체한다. 홈 화면은 segmented control로 `패턴 / 구성요소`를 전환하고, 카드 목록과 상세 sheet는 topic 메타데이터와 contextual preview를 보여준다. 프리뷰는 topic의 HIG 의미에 맞는 scene renderer로 재구성한다.

**Tech Stack:** SwiftUI, Expo Modules, Node test runner, xcodebuild, iOS Simulator

---

### Task 1: Lock the new library IA with failing tests

**Files:**
- Modify: `scripts/__tests__/motionTaxonomyFiles.test.cjs`
- Modify: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

```javascript
test('design data file defines Apple HIG library kinds and topics', () => {
  const source = read('modules/expo-swiftui-card/ios/MotionPreset.swift');
  assert.match(source, /enum AppleLibraryKind:/);
  assert.match(source, /struct AppleDesignTopic:/);
  assert.match(source, /static let sampleData: \[AppleDesignTopic\]/);
  assert.match(source, /case patterns/);
  assert.match(source, /case components/);
});

test('home view is branded as Apple Design Library with pattern\/component segmented control', () => {
  const source = read('modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift');
  assert.match(source, /Text\("애플 디자인 라이브러리"\)/);
  assert.match(source, /Picker\("라이브러리 분류", selection: \$selectedLibraryKind\)/);
  assert.match(source, /Text\(kind\.koreanTitle\)\.tag\(kind\)/);
});
```

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: FAIL because current code still defines `MotionPreset`, motion taxonomy enums, and `모션 라이브러리`.

**Step 3: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "test: add apple design library regression coverage"
```

---

### Task 2: Replace the motion data model with Apple HIG topics

**Files:**
- Modify: `modules/expo-swiftui-card/ios/MotionPreset.swift`
- Test: `scripts/__tests__/motionTaxonomyFiles.test.cjs`

**Step 1: Write the failing test**
- Reuse the first test from Task 1.

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs --test-name-pattern "Apple HIG library kinds"
```
Expected: FAIL because the file still contains `LibraryCategory`, `MotionSurface`, and `MotionPreset`.

**Step 3: Write minimal implementation**

Define the new catalog in `MotionPreset.swift`:

```swift
enum AppleLibraryKind: String, CaseIterable, Identifiable, Codable {
  case patterns
  case components
}

enum PreviewKind: String, Codable {
  case launch
  case loading
  case search
  case modal
  case button
  case list
  case pageControl
  case segmentedControl
  case textField
  case toggle
}

struct AppleDesignTopic: Identifiable, Hashable, Codable {
  let id: String
  let name: String
  let koreanTitle: String
  let summary: String
  let libraryKind: AppleLibraryKind
  let higUrl: String
  let previewKind: PreviewKind
  let keyPoints: [String]
}
```

Populate `sampleData` with the mirrored HIG topics for `패턴` and `구성요소`.

**Step 4: Run test to verify it passes**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs --test-name-pattern "Apple HIG library kinds"
```
Expected: PASS

**Step 5: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs
git commit -m "feat: replace motion preset catalog with apple design topics"
```

---

### Task 3: Rebuild the home, favorites, and settings screens around topics

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Test: `scripts/__tests__/motionTaxonomyFiles.test.cjs`

**Step 1: Write the failing test**

Add assertions for:

```javascript
assert.match(source, /Text\("애플 디자인 라이브러리"\)/);
assert.match(source, /Picker\("라이브러리 분류", selection: \$selectedLibraryKind\)/);
assert.match(source, /ForEach\(AppleLibraryKind\.allCases\)/);
assert.match(source, /AppleDesignTopic\.sampleData/);
assert.doesNotMatch(source, /MotionPreset/);
```

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs --test-name-pattern "Apple Design Library"
```
Expected: FAIL because the home view still uses `MotionPreset`, motion copy, and motion settings.

**Step 3: Write minimal implementation**

Rebuild the file around:

- `AppleDesignTopicCard`
- `AppleDesignTopicDetailSheet`
- `AppleDesignLibraryHomeScreen`
- `FavoritesScreen`
- `SettingsScreen`
- `AppleDesignLibraryRootTabView`

Remove motion-specific sections such as `Duration`, `Delay`, `Easing`, `Intensity`, and `모션 기본값`.

**Step 4: Run test to verify it passes**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs
```
Expected: PASS

**Step 5: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs
git commit -m "feat: rebuild apple design library screens"
```

---

### Task 4: Rework previews into HIG topic scenes

**Files:**
- Modify: `modules/expo-swiftui-card/ios/MotionPreviewView.swift`
- Test: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Write the failing test**

```javascript
test('preview view switches on preview kind and provides HIG scenes', () => {
  const source = read('modules/expo-swiftui-card/ios/MotionPreviewView.swift');
  assert.match(source, /switch topic\.previewKind/);
  assert.match(source, /launchScene/);
  assert.match(source, /loadingScene/);
  assert.match(source, /searchScene/);
  assert.match(source, /menuScene/);
  assert.match(source, /buttonScene/);
  assert.match(source, /pageControlScene/);
  assert.match(source, /segmentedControlScene/);
  assert.match(source, /textFieldScene/);
  assert.match(source, /toggleScene/);
  assert.doesNotMatch(source, /switch preset\.id/);
});
```

**Step 2: Run test to verify it fails**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: FAIL because the preview still routes motion presets by preset id.

**Step 3: Write minimal implementation**

Change `MotionPreviewView` to accept `topic: AppleDesignTopic` and render preview scenes by `PreviewKind`. Each scene should match the semantic role of the topic rather than motion parameters.

**Step 4: Run test to verify it passes**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: PASS

**Step 5: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "feat: replace motion previews with HIG topic scenes"
```

---

### Task 5: Verify the library end to end

**Files:**
- Modify: none
- Test: `scripts/__tests__/motionTaxonomyFiles.test.cjs`
- Test: `scripts/__tests__/motionContextualPreviewFiles.test.cjs`

**Step 1: Run the focused tests**

Run:
```bash
node --test /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
```
Expected: PASS

**Step 2: Run the simulator build**

Run:
```bash
xcodebuild -quiet -workspace /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,id=40C94D7D-D35C-47D5-8656-B9224FEBA48F' ONLY_ACTIVE_ARCH=YES build
```
Expected: `BUILD SUCCEEDED`

**Step 3: Commit**

```bash
git add /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-12-apple-design-library-design.md /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/docs/plans/2026-03-12-apple-design-library-implementation-plan.md /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionTaxonomyFiles.test.cjs /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/scripts/__tests__/motionContextualPreviewFiles.test.cjs
git commit -m "feat: introduce apple design library"
```
