# Native Motion Taxonomy Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 임의 데모 모션 프리셋을 iOS 네이티브 상호작용 기준의 Motion Library taxonomy로 교체한다.

**Architecture:** 기존 SwiftUI 기반 Motion Library 구조는 유지하고, `MotionPreset` schema와 샘플 데이터, 라이브러리/상세 UI copy를 함께 정리한다. 네트워크나 저장 구조는 건드리지 않고 로컬 샘플 데이터 계층만 교체한다.

**Tech Stack:** SwiftUI, Expo Modules, React Native host view, UserDefaults

---

### Task 1: Domain schema rename and extension

**Files:**
- Modify: `modules/expo-swiftui-card/ios/MotionPreset.swift`

**Step 1: Write the failing test**

현 프로젝트에는 Swift 테스트 타깃이 없으므로, 먼저 build failure 기준을 만든다.
- `MotionPreset`가 새로운 taxonomy 필드를 가지지 않아 UI copy 교체가 불가능한 상태를 RED로 본다.

**Step 2: Extend schema**

- `MotionCategory`를 `LibraryCategory`로 재정의하거나 의미를 변경한다.
- `applePattern`
- `swiftUIImplementation`
- `surface`
- `isDemoOnly`

를 `MotionPreset`에 추가한다.

**Step 3: Run build to verify**

Run:
```bash
cd /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp
xcodebuild -quiet -workspace ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' build
```
Expected: build succeeds

**Step 4: Commit**

```bash
git add modules/expo-swiftui-card/ios/MotionPreset.swift
git commit -m "refactor: redefine motion preset taxonomy schema"
```

### Task 2: Replace sample data with native-first preset set

**Files:**
- Modify: `modules/expo-swiftui-card/ios/MotionPreset.swift`

**Step 1: Replace sampleData**

- 기존 20개 임의 프리셋을 제거한다.
- 승인된 12개 프리셋으로 교체한다.
- 각 프리셋에 Apple pattern과 SwiftUI mapping 설명을 넣는다.

**Step 2: Normalize copy**

- 사용자 노출명은 인터랙션 결과 중심으로 작성한다.
- summary는 한국어 기준으로 한 줄 설명으로 통일한다.

**Step 3: Run build**

Run:
```bash
xcodebuild -quiet -workspace ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' build
```
Expected: build succeeds

**Step 4: Commit**

```bash
git add modules/expo-swiftui-card/ios/MotionPreset.swift
git commit -m "feat: replace demo presets with native motion taxonomy"
```

### Task 3: Update library category UI

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: Update segmented control**

- 기존 `Entrance/Emphasis/Exit/Gesture` 라벨을 새 taxonomy 기준으로 교체한다.
- 카드 필터가 새 카테고리 enum을 기준으로 동작하도록 수정한다.

**Step 2: Update list header copy**

- `프리셋` 헤더와 개수 표시는 유지한다.
- 카드 메타 정보는 easing/time 위주가 아니라 pattern intent 위주로 조정한다.

**Step 3: Run build**

Run:
```bash
xcodebuild -quiet -workspace ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' build
```
Expected: build succeeds

**Step 4: Commit**

```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift
git commit -m "feat: update motion library categories and list metadata"
```

### Task 4: Update detail sheet metadata

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Modify: `modules/expo-swiftui-card/ios/MotionPreviewView.swift`

**Step 1: Add detail metadata blocks**

- `Apple pattern`
- `SwiftUI mapping`
- `Surface`
- `Recommended duration`

를 상세 화면에 노출한다.

**Step 2: Relabel preview intent**

- 프리뷰는 데모임을 분명히 하되, 실제 UX 패턴 reference라는 의미를 유지한다.
- 필요하면 `Demo preview` 또는 유사 문구를 추가한다.

**Step 3: Run build**

Run:
```bash
xcodebuild -quiet -workspace ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' build
```
Expected: build succeeds

**Step 4: Commit**

```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift modules/expo-swiftui-card/ios/MotionPreviewView.swift
git commit -m "feat: add native motion metadata to detail sheet"
```

### Task 5: Documentation and verification

**Files:**
- Modify: `SWIFTUI_EXPO_SETUP.md`
- Create: `docs/ui/2026-03-11-native-motion-taxonomy.md`

**Step 1: Document taxonomy**

- 새 6개 카테고리
- 12개 초기 프리셋
- Apple pattern / SwiftUI mapping 원칙

을 문서화한다.

**Step 2: Visual verification**

Run:
```bash
npm run ios -- -d 40C94D7D-D35C-47D5-8656-B9224FEBA48F
```
Expected: 앱 실행 후 새 taxonomy와 프리셋 copy가 반영된다.

**Step 3: Commit**

```bash
git add SWIFTUI_EXPO_SETUP.md docs/ui/2026-03-11-native-motion-taxonomy.md
git commit -m "docs: add native motion taxonomy reference"
```
