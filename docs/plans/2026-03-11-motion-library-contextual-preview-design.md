# Motion Library Contextual Preview Design

**Goal:** Motion Library의 각 preset이 실제 사용 맥락에 맞는 고유 프리뷰를 가지도록 재설계하고, 상단 분류 UI를 라벨이 모두 보이는 iOS-style category rail로 교체한다.

**Problem:** 현재 Motion Library는 taxonomy와 메타데이터는 분리되어 있지만, 상세 프리뷰는 하나의 공통 카드에 `scale`, `offset`, `opacity`만 적용한다. 결과적으로 같은 category 안의 preset들이 거의 동일한 샘플 모션처럼 보이고, `Sheet Present`, `Toggle State Morph`, `Swipe Commit`처럼 서로 다른 interaction intent가 프리뷰에서 구분되지 않는다. 또한 상단 category UI는 `segmented` Picker를 사용해 라벨이 줄임 처리되고, 분류 간 구분도 약하다.

**Decision:** 프리뷰는 `preset.id` 기반의 contextual scene renderer로 전환한다. 각 preset은 자신의 `surface`와 `applePattern`에 맞는 mini scene을 가지며, `duration`, `delay`, `easing`, `intensity`는 해당 scene의 tuning 값으로만 동작한다. 상단 category 선택 UI는 카메라 모드 selector와 유사한 horizontal rail로 교체해 모든 라벨이 잘리지 않고 표시되게 한다.

## Design Principles

- 모션은 강약 차이보다 interaction intent 차이가 먼저 보여야 한다.
- 프리뷰는 실제 앱 화면의 축약판이어야 하며 추상 카드 데모에 머무르면 안 된다.
- 같은 category여도 scene이 다를 수 있다.
- tuning control은 모션 종류를 바꾸지 않고, 같은 모션의 성격만 미세 조정해야 한다.
- category selector는 필터 UI이며 top-level tab이 아니므로 scrollable rail이 더 적합하다.

## Preview Architecture

프리뷰는 두 층으로 나눈다.

1. `PreviewSceneSurface`
- `sheet`
- `navigation`
- `tab`
- `listRow`
- `toggle`
- `card`
- `fullScreen`

2. `PreviewSceneChoreography`
- 각 surface 안에서 preset마다 다른 motion sequence를 정의한다.
- 예: 같은 `sheet` surface라도 `Sheet Present`와 `Sheet Dismiss`는 방향, 시작 상태, 정착 방식이 다르다.

상세 프리뷰는 `MotionPreviewView` 안에서 다음 흐름으로 렌더한다.

- preset -> scene surface 선택
- preset.id -> choreography 선택
- tuning values 적용
- replay 시 scene state reset 후 sequence 실행

## Preset-to-Scene Mapping

### Enter
- `Content Fade In`
  - Surface: `fullScreen`
  - Scene: 빈 콘텐츠 영역에 title/body/card가 순차적으로 나타남
  - Motion: opacity 중심, 약한 y-offset
- `Card Rise In`
  - Surface: `card`
  - Scene: 대시보드 카드 1장이 아래에서 떠오르며 정착
  - Motion: spring settle
- `Sheet Present`
  - Surface: `sheet`
  - Scene: dimmed background 위로 bottom sheet가 올라옴
  - Motion: bottom transition + opacity

### Navigate
- `Large Title Collapse`
  - Surface: `navigation`
  - Scene: large title header가 inline title로 수렴하고 list가 위로 스크롤된 상태로 정착
  - Motion: title scale/position transition + content offset
- `Push Transition`
  - Surface: `navigation`
  - Scene: 현재 화면이 왼쪽으로 밀리고 다음 detail 화면이 오른쪽에서 들어옴
  - Motion: dual-layer horizontal transition
- `Tab Switch Emphasis`
  - Surface: `tab`
  - Scene: 하단 tab item 선택 상태가 이동하고 active content panel이 교체됨
  - Motion: selected pill 이동 + active panel fade/slide

### Emphasize
- `Selection Pulse`
  - Surface: `listRow`
  - Scene: 선택된 row가 짧게 pulse 후 selected state 유지
  - Motion: scale pulse + highlight wash
- `Primary CTA Bounce`
  - Surface: `toolbar`
  - Scene: CTA button이 짧게 탄성 반응하며 시선을 끔
  - Motion: button scale/bounce only

### Confirm
- `Toggle State Morph`
  - Surface: `toggle`
  - Scene: switch thumb가 이동하고 tint/background가 on state로 변함
  - Motion: thumb move + color morph

### Manipulate
- `Swipe Commit`
  - Surface: `listRow`
  - Scene: row가 좌측으로 밀리고 action 확정 후 committed state badge가 나타남
  - Motion: drag translation + settle + confirmation marker
- `Drag Lift`
  - Surface: `card`
  - Scene: 카드가 살짝 떠오르며 shadow가 깊어지고 주변 카드와 분리됨
  - Motion: lift, scale, shadow, subtle z-axis feel

### Dismiss
- `Sheet Dismiss`
  - Surface: `sheet`
  - Scene: 올라와 있던 sheet가 아래로 내려가며 배경 dim도 제거됨
  - Motion: reverse sheet transition

## Parameter Rules

- `duration`: sequence 전체 속도를 조절하되 단계 수는 바꾸지 않는다.
- `delay`: replay 시작 전 대기만 조절한다.
- `easing`: 같은 choreography의 timing curve만 조절한다.
- `intensity`: distance, overshoot, emphasis amount를 조절하되 scene semantics는 유지한다.

예를 들어 `Toggle State Morph`는 intensity가 바뀌어도 항상 toggle thumb 이동이어야 하며, 카드가 튀어 오르는 식으로 바뀌면 안 된다.

## Category Rail Design

상단 category selector는 다음 규칙으로 교체한다.

- `ScrollView(.horizontal, showsIndicators: false)` 기반
- 모든 라벨 full text 표시, 줄임 금지
- 선택 항목은 center-weighted emphasis 적용
- 탭 간 최소 44pt hit target 유지
- 선택 시 rail이 해당 항목을 가시 영역 중앙 근처로 스크롤
- 카메라 mode selector처럼 좌우 스와이프로 숨겨진 라벨이 자연스럽게 드러남

각 item은 다음 시각 구성을 가진다.

- 기본: secondary text
- 선택: primary text + subtle capsule/pill background
- 비선택: 배경 없음, 충분한 간격 유지

## Home Card Changes

카드 자체는 목록 성격을 유지하되 preview-like 오해를 줄인다.

- 카드에는 실제 scene 재현을 넣지 않는다.
- 카드에는 `name`, `summary`, `applePattern`, `surface`, `duration/intensity`만 유지한다.
- 실제 모션 차이는 상세 프리뷰에서 보여준다.

## Accessibility and HIG Notes

- category rail은 custom layout이므로 명시적 accessibility label/selected state를 제공해야 한다.
- 상세 프리뷰 section header는 기존처럼 header trait 유지
- rail item과 replay button은 44x44pt 이상 확보
- navigation-style scenes는 실제 UINavigationBar를 복제하지 않더라도 hierarchy는 명확히 유지

## Non-goals

- Apple 시스템 모션을 private API 수준으로 복제하지 않는다.
- 홈 카드 목록에 모든 프리뷰를 인라인 autoplay로 넣지 않는다.
- taxonomy 자체를 다시 바꾸지 않는다.

## Success Criteria

- 서로 다른 preset이 상세 프리뷰에서 명확히 다른 scene으로 보인다.
- 같은 category 안에서도 모션 intent 차이를 설명 없이 구분할 수 있다.
- 상단 category 라벨이 줄임 없이 모두 읽힌다.
- rail을 좌우로 움직일 때 숨겨진 category가 자연스럽게 드러난다.
- tuning control을 바꿔도 preset의 의미가 변하지 않는다.
