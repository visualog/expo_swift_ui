# Motion Library Native-First Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** iOS Liquid Glass 기반 Motion Library MVP를 SwiftUI 네이티브 중심으로 구현해, 모션 탐색/미리보기/즐겨찾기 저장의 최소 가치 루프를 완성한다.

**Architecture:** `ExpoShortcutsHomeView.swift`를 Motion Library 구조로 리팩터링한다. 핵심 화면은 SwiftUI(`NavigationStack`, `TabView`, `sheet`, `segmented Picker`)에서 처리하고, RN/JS는 호스팅과 fallback UI만 담당한다. 데이터는 초기 MVP에서 iOS 로컬 샘플 + `UserDefaults`를 사용한다.

**Tech Stack:** Expo 55, React Native 0.83, SwiftUI, Expo Modules, iOS Simulator, UserDefaults

---

### Task 1: Baseline Verification (RED)

**Files:**
- Modify: 없음 (검증만)

**Step 1: 현재 baseline 빌드 확인**

Run:
```bash
cd /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp
npm run ios -- -d 40C94D7D-D35C-47D5-8656-B9224FEBA48F
```
Expected: `Build Succeeded`

**Step 2: 현재 UI baseline 캡처**
- 라이트/다크 각각 스크린샷 1장씩 저장
- 목적: 이후 회귀 비교 기준 확보

**Step 3: Commit (옵션)**
```bash
git add -A
git commit -m "chore: capture baseline before motion library refactor"
```

---

### Task 2: Motion Preset Domain Model 도입

**Files:**
- Create: `modules/expo-swiftui-card/ios/MotionPreset.swift`
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: failing condition 정의 (RED)**
- 현재 코드에 `ShortcutFolderItem`, `ShortcutSuggestionItem` 하드코딩 존재
- 목표: MotionPreset 기반으로 교체

**Step 2: 모델 생성**

```swift
import Foundation

struct MotionPreset: Identifiable, Hashable {
  let id: String
  let name: String
  let category: MotionCategory
  let tags: [String]
  let duration: Double
  let delay: Double
  let easing: MotionEasing
  let intensity: MotionIntensity
}

enum MotionCategory: String, CaseIterable, Identifiable {
  case entrance, emphasis, exit, gesture
  var id: String { rawValue }
  var title: String {
    switch self {
    case .entrance: return "Entrance"
    case .emphasis: return "Emphasis"
    case .exit: return "Exit"
    case .gesture: return "Gesture"
    }
  }
}

enum MotionEasing: String, CaseIterable {
  case smooth, spring, easeInOut, bouncy
}

enum MotionIntensity: String, CaseIterable {
  case soft, normal, expressive
}
```

**Step 3: 샘플 데이터 추가**
- 최소 20개 프리셋 배열을 Swift 파일 내 static source로 제공

**Step 4: verify (GREEN)**
Run:
```bash
xcodebuild -workspace ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' build
```
Expected: `** BUILD SUCCEEDED **`

**Step 5: Commit**
```bash
git add modules/expo-swiftui-card/ios/MotionPreset.swift modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift
git commit -m "feat: add motion preset domain model and sample data"
```

---

### Task 3: 탭 IA를 Motion Library로 전환

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: failing condition 정의 (RED)**
- 현재 탭: `단축어/자동화/갤러리`
- 목표 탭: `라이브러리/즐겨찾기/설정`

**Step 2: 탭 enum/label 교체**
- `RootTab`와 `TabView` 라벨을 Motion Library IA로 변경

**Step 3: 각 탭 placeholder 명확화**
- `즐겨찾기` 탭은 빈 상태 + 목록 영역 틀만 먼저 구현
- `설정` 탭은 모션 강도 기본값 토글 자리만 확보

**Step 4: verify (GREEN)**
Run:
```bash
npm run ios -- -d 40C94D7D-D35C-47D5-8656-B9224FEBA48F
```
Expected: 앱 실행 후 탭 라벨이 새 IA로 표시

**Step 5: Commit**
```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift
git commit -m "feat: switch root IA to library favorites settings tabs"
```

---

### Task 4: Library Home (카테고리 + 검색 + 카드)

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: failing condition 정의 (RED)**
- 현재 화면은 Shortcuts 정보 중심(내 단축어/추천 단축어)
- 목표는 Motion preset catalog 중심

**Step 2: 검색 상태 추가**
```swift
@State private var query: String = ""
@State private var selectedCategory: MotionCategory = .entrance
```

**Step 3: 필터링 computed property 추가**
```swift
private var filteredPresets: [MotionPreset] {
  presets.filter { preset in
    preset.category == selectedCategory &&
    (query.isEmpty || preset.name.localizedCaseInsensitiveContains(query) ||
     preset.tags.contains(where: { $0.localizedCaseInsensitiveContains(query) }))
  }
}
```

**Step 4: UI 교체**
- 상단: 페이지 헤더 + 검색창 + 카테고리 segmented control
- 본문: 2열 카드 (`LazyVGrid`)로 프리셋 노출

**Step 5: verify (GREEN)**
- 검색 텍스트 입력 시 카드 개수 변동 확인
- 카테고리 전환 시 카드 필터 동작 확인

**Step 6: Commit**
```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift
git commit -m "feat: implement motion library home with category and search"
```

---

### Task 5: Motion Detail + Live Preview

**Files:**
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`
- Create: `modules/expo-swiftui-card/ios/MotionPreviewView.swift`

**Step 1: failing condition 정의 (RED)**
- 현재 카드 탭 시 상세/미리보기 없음

**Step 2: 상세 진입 상태 추가**
```swift
@State private var selectedPreset: MotionPreset?
```

**Step 3: 상세 시트 구현**
- `sheet(item: $selectedPreset)` 사용
- 프리뷰 영역 + 파라미터 슬라이더(duration, delay) + easing/intensity picker

**Step 4: 프리뷰 컴포넌트 분리**
- `MotionPreviewView`에 애니메이션 상태/재생 버튼 구성

**Step 5: verify (GREEN)**
- 카드 탭 시 시트 오픈
- 파라미터 변경 시 프리뷰 애니메이션 반영

**Step 6: Commit**
```bash
git add modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift modules/expo-swiftui-card/ios/MotionPreviewView.swift
git commit -m "feat: add motion detail sheet and live preview"
```

---

### Task 6: Favorites 저장/조회 (UserDefaults)

**Files:**
- Create: `modules/expo-swiftui-card/ios/FavoritesStore.swift`
- Modify: `modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift`

**Step 1: failing condition 정의 (RED)**
- 앱 재실행 시 즐겨찾기 유지되지 않음

**Step 2: Store 구현**
```swift
final class FavoritesStore: ObservableObject {
  @Published private(set) var favoriteIds: Set<String> = []
  private let key = "motion_favorite_ids"

  func load() { ... }
  func toggle(_ id: String) { ... }
  func isFavorite(_ id: String) -> Bool { favoriteIds.contains(id) }
}
```

**Step 3: 라이브러리/즐겨찾기 탭 연결**
- 카드에 즐겨찾기 토글 버튼
- 즐겨찾기 탭에서 favoriteIds 기반 목록 렌더

**Step 4: verify (GREEN)**
- 즐겨찾기 추가/제거 즉시 반영
- 앱 재실행 후 상태 유지

**Step 5: Commit**
```bash
git add modules/expo-swiftui-card/ios/FavoritesStore.swift modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift
git commit -m "feat: persist favorites with userdefaults"
```

---

### Task 7: HIG Gate + QA 문서 반영

**Files:**
- Modify: `docs/ui/apple-hig-swiftui-checklist.md`
- Modify: `docs/ui/2026-03-10-shortcuts-hig-review.md`
- Create: `docs/ui/2026-03-xx-motion-library-qa.md`

**Step 1: 체크리스트 실행 결과 기록**
- 헤더 위계, 44pt 타깃, 라이트/다크 대비, 탭 동작 검증

**Step 2: 회귀 스크린샷 첨부 규칙 추가**
- 라이트/다크 각 1장, 상세 시트 1장

**Step 3: verify (GREEN)**
- 문서에 Pass/Fail 근거가 남아 있는지 확인

**Step 4: Commit**
```bash
git add docs/ui
git commit -m "docs: add motion library qa evidence and hig gate results"
```

---

### Task 8: Final Verification + MVP Cut

**Files:**
- Modify: `docs/plans/2026-03-10-liquid-glass-motion-prd-and-mvp-plan.md` (상태 반영)

**Step 1: 통합 검증 명령 실행**
Run:
```bash
cd /Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp
npm run ios -- -d 40C94D7D-D35C-47D5-8656-B9224FEBA48F
xcodebuild -workspace ios/SMPMVP.xcworkspace -scheme SMPMVP -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' build
```
Expected: 둘 다 성공

**Step 2: MVP 포함/제외 최종 체크**
- 포함 기능 4개(F1~F4) 동작 확인
- 비목표 기능 미포함 확인

**Step 3: 최종 Commit**
```bash
git add -A
git commit -m "feat: deliver motion library native-first mvp"
```

---

## Execution Notes
- 네이티브 변경은 반드시 재빌드 필요(핫리로드만으로 불충분)
- 시뮬레이터에서 이전 빌드 캐시 혼선이 있으면 앱 uninstall 후 재설치
- UI 위계 판단은 `apple-hig-swiftui` 규칙셋 기준으로만 결정
