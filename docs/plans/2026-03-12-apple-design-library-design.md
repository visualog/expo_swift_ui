# Apple Design Library Design

**Goal:** 기존 모션 라이브러리를 `애플 디자인 라이브러리`로 재구성하고, Apple Human Interface Guidelines의 `패턴`과 `구성요소` 정보를 내부 참고용 iOS 브라우저 형태로 미러링한다.

**Problem:** 현재 라이브러리는 `MotionPreset` 중심의 taxonomy와 파라미터 UI에 최적화되어 있다. 사용자가 원하는 것은 모션 preset 브라우저가 아니라, Apple HIG의 구조를 따라가며 패턴과 구성요소를 빠르게 탐색하고 각 항목의 맥락을 실제 iOS mini scene으로 확인할 수 있는 reference 라이브러리다.

**Decision:** 앱의 핵심 도메인을 `AppleDesignTopic`으로 바꾼다. 최상위 라이브러리 분류는 `패턴 / 구성요소` 두 개로 두고, 각 분류 아래에 Apple HIG 페이지 단위의 하위 라이브러리 topic을 정적 카탈로그로 배치한다. 홈은 topic 브라우저, 상세는 HIG 요약 + 공식 링크 + SwiftUI 참고 + contextual preview로 재구성한다.

## Approaches Considered

### 1. 이름만 변경하고 기존 motion preset 구조 유지
- 장점: 구현량이 가장 적다.
- 단점: HIG 미러 구조가 되지 않고, `duration`, `easing`, `intensity` 같은 모션 전용 메타데이터가 계속 남아 도메인 의미를 흐린다.

### 2. HIG 루트 브라우저를 새로 만들고 기존 motion 코드는 대부분 폐기
- 장점: 정보구조가 명확하고 이후 확장이 쉽다.
- 단점: 화면, 데이터 모델, 프리뷰 계약을 함께 교체해야 한다.

### 3. 별도 웹뷰 기반 HIG 미러 앱으로 전환
- 장점: 원문을 가장 직접적으로 볼 수 있다.
- 단점: 내부 reference 도구로서 요약/프리뷰 가치가 낮고, 현재 SwiftUI 기반 라이브러리와 잘 맞지 않는다.

**Recommended:** 2번. 내부 참고용 도구로서 가장 목적 적합하다.

## Information Architecture

### Top-level destinations
- `라이브러리`
- `즐겨찾기`
- `설정`

탭바는 계속 최상위 목적지 전환에만 사용한다.

### Library screen structure
- 헤더: `애플 디자인 라이브러리`
- 검색 필드: topic title, HIG section, tags 검색
- 상단 segmented picker: `패턴`, `구성요소`
- 본문: 선택된 라이브러리 분류에 속한 topic 목록

### Topic detail structure
- contextual preview
- HIG 요약
- 사용 맥락과 핵심 포인트
- SwiftUI 구현 힌트
- 공식 HIG 링크
- 관련 키워드

## Domain Model

정적 샘플 데이터는 아래 구조를 가진다.

- `AppleLibraryKind`
  - `patterns`
  - `components`
- `PreviewKind`
  - `launch`
  - `loading`
  - `search`
  - `onboarding`
  - `modal`
  - `share`
  - `menu`
  - `button`
  - `collection`
  - `list`
  - `picker`
  - `pageControl`
  - `progress`
  - `segmentedControl`
  - `textField`
  - `toggle`
- `AppleDesignTopic`
  - `id`
  - `name`
  - `koreanTitle`
  - `summary`
  - `libraryKind`
  - `sectionTitle`
  - `tags`
  - `icon`
  - `tintHex`
  - `higUrl`
  - `higPathTitle`
  - `platformNotes`
  - `swiftUIReference`
  - `previewKind`
  - `keyPoints`
  - `isSystemDemo`

이 구조는 기존 `MotionPreset`의 `duration`, `delay`, `easing`, `intensity`를 제거하고, HIG reference 브라우징에 필요한 메타데이터로 치환한다.

## Mirrored Topic Set

### 패턴
- Launching
- Loading
- Menus
- Modality
- Onboarding
- Searching
- File management
- Collaboration and sharing
- Notifications
- Writing

### 구성요소
- Buttons
- Collections
- Color wells
- Icons
- Images
- Labels
- Lists and tables
- Page controls
- Pickers
- Progress indicators
- Segmented controls
- Text fields
- Toggles

이 토픽들은 Apple HIG의 현재 페이지 단위를 기준으로 한 정적 카탈로그다. 각각 공식 HIG URL을 가진다.

## Preview Strategy

프리뷰는 더 이상 공통 카드 애니메이션이 아니다. 각 topic은 자신의 정보 의미에 맞는 mini scene을 가진다.

- `Launching`: launch screen에서 첫 콘텐츠로 넘어가는 scene
- `Loading`: skeleton/progress overlay scene
- `Searching`: search field focus와 결과 list scene
- `Modality`: dimmed backdrop 위 sheet scene
- `Onboarding`: paging card scene
- `Menus`: long-press menu scene
- `Buttons`: primary/secondary action scene
- `Collections`: card grid selection scene
- `Lists and tables`: inset grouped rows scene
- `Page controls`: paging dots와 current page scene
- `Pickers`: wheel/menu style selection scene
- `Progress indicators`: linear/circular progress scene
- `Segmented controls`: native segmented selection scene
- `Text fields`: form entry focus scene
- `Toggles`: on/off settings row scene

프리뷰는 semantic fidelity가 우선이며, 과장된 motion demo가 아니라 실제 사용 맥락을 보여준다.

## UI Decisions

### 상단 분류 컨트롤
- public native를 유지하기 위해 `Picker(...).pickerStyle(.segmented)`를 사용한다.
- 라벨은 `패턴`, `구성요소` 두 개만 노출하므로 길이 문제를 없앤다.

### 목록 레이아웃
- topic 카드에는 icon, title, section title, summary, HIG path title을 표시한다.
- 동일 레벨 항목은 같은 카드 토큰을 사용한다.
- 카드 tap으로 상세 sheet를 연다.

### 상세 화면
- preview는 상단 hero 영역으로 배치한다.
- `핵심 포인트`, `SwiftUI 참고`, `공식 가이드`를 각각 semantic section으로 나눈다.
- 공식 링크는 Safari 열기용 `Link`를 사용한다.

## Favorites and Settings

즐겨찾기는 topic ID 기준으로 저장한다. 기존 store는 ID 문자열 저장 구조라 재사용 가능하다.

설정은 `레이아웃 그리드 표시`를 유지하고, 기존 `모션 기본값` 섹션은 제거한다. 대신 reference library 성격에 맞게 간단한 표시 설정만 남긴다.

## Accessibility and HIG Notes

- segmented control은 두 peer library kinds만 전환한다.
- 카드와 toolbar action은 44x44pt 이상 target을 유지한다.
- 상세의 각 section title은 header trait를 유지한다.
- ScrollView를 쓰더라도 section semantics를 텍스트와 header trait로 명시한다.

## Non-goals

- Apple HIG 원문 전체를 오프라인 복제하지 않는다.
- 웹뷰로 공식 페이지를 그대로 내장하지 않는다.
- private API 수준의 시스템 UI 복제를 시도하지 않는다.

## Success Criteria

- 홈 화면에서 `패턴 / 구성요소` 두 분류를 전환하며 HIG topic을 탐색할 수 있다.
- 각 topic 카드와 상세에서 Apple HIG reference라는 성격이 분명하게 드러난다.
- 상세 프리뷰가 각 topic의 사용 맥락을 서로 다르게 보여준다.
- 기존 motion-specific vocabulary가 UI와 데이터 모델에서 제거된다.
