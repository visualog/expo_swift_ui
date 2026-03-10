# Native Motion Taxonomy Design

**Goal:** Motion Library의 임시 데모 프리셋을 iOS 네이티브 UX 패턴과 SwiftUI 구현 가능성에 맞는 taxonomy로 재정의한다.

**Problem:** 현재 라이브러리의 모션 프리셋은 MVP 검증용 임의 샘플이다. 이름, 분류, 요약이 Apple 기본 앱에서 관찰되는 상호작용과 직접 연결되지 않고, SwiftUI 구현 기준과도 분리되어 있다.

**Decision:** 라이브러리의 1차 정보구조는 `사용자 상호작용 중심`으로 정의한다. 각 프리셋은 사용자에게는 UX 패턴명으로 노출하고, 내부적으로는 SwiftUI 구현 메타데이터를 가진다.

## Taxonomy

### Primary categories
- `Enter`
- `Emphasize`
- `Navigate`
- `Manipulate`
- `Confirm`
- `Dismiss`

### Secondary metadata
- `applePattern`: Apple 기본 앱/HIG에서 대응되는 패턴 이름
- `swiftUIImplementation`: SwiftUI animation or transition mapping
- `durationBand`: short / medium / long
- `intensityBand`: soft / normal / expressive
- `surface`: card / sheet / full screen / toolbar / tab / list row

## Initial preset set

1. `Content Fade In`
2. `Card Rise In`
3. `Sheet Present`
4. `Large Title Collapse`
5. `Push Transition`
6. `Tab Switch Emphasis`
7. `Selection Pulse`
8. `Primary CTA Bounce`
9. `Toggle State Morph`
10. `Swipe Commit`
11. `Drag Lift`
12. `Sheet Dismiss`

## Naming rules

- 사용자 노출명은 시각 효과명이 아니라 인터랙션 결과 중심으로 작성한다.
- `Fade`, `Bounce`, `Spring` 같은 구현 용어는 보조 설명 또는 내부 구현값으로 내린다.
- 한 프리셋은 한 개의 의도만 가져야 한다. 예를 들어 `Swipe Commit`은 `Manipulate`에만 속한다.

## UI implications

- 카테고리 segmented control은 기존 `Entrance/Emphasis/Exit/Gesture`를 대체한다.
- 카드에는 `프리셋명`, `짧은 설명`, `Apple pattern tag` 정도만 노출한다.
- 상세 화면에는 다음 필드를 표시한다:
- `Intent`
- `Apple pattern`
- `SwiftUI mapping`
- `recommended duration`
- `recommended intensity`

## Data model changes

현재 `MotionPreset`의 `category`, `easing`, `intensity` 중심 구조를 유지하되, 다음 필드가 추가되어야 한다.

- `libraryCategory`
- `applePattern`
- `swiftUIImplementation`
- `surface`
- `isDemoOnly`

기존 `MotionCategory`는 제거하거나 내부 전환용 enum으로 축소한다.

## Non-goals

- 실제 Apple 시스템 모션을 역공학해 픽셀 단위로 복제하지 않는다.
- iOS private API 또는 undocumented behavior는 사용하지 않는다.
- Android 공용 taxonomy까지 이번 단계에서 확장하지 않는다.

## Success criteria

- 현재 20개 임의 샘플이 12개 네이티브 기준 프리셋으로 정리된다.
- 라이브러리 목록/상세에서 프리셋의 의도가 이름만으로 이해된다.
- SwiftUI 구현 설명이 붙어 있어 개발 reference로도 쓸 수 있다.
- 이후 JSON 또는 원격 데이터로 분리해도 schema 변경이 최소화된다.
