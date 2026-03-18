# Apple HIG Hierarchy Mirroring Design

## Goal

`Apple HIG 레퍼런스` 앱의 정보구조를 Apple Human Interface Guidelines의 실제 `Patterns / Components` 계층과 맞춘다. 현재처럼 큰 분류만 닮은 flat list가 아니라, 공식 탐색 구조를 그대로 드러내고, 구현되지 않은 항목도 `준비 중` 상태로 명시해 레퍼런스 신뢰도를 높인다.

## Problem

현재 앱은 다음 점에서 공식 HIG와 어긋난다.

- `Patterns`는 실제 HIG처럼 개별 패턴 항목 리스트여야 하는데, 지금은 구현된 일부 항목만 flat card list로 보인다.
- `Components`는 실제 HIG처럼 `Content`, `Layout and organization`, `Menus and actions`, `Navigation and search`, `Presentation`, `Selection and input`, `Status`, `System experiences` 그룹을 먼저 보여줘야 하는데, 지금은 그룹 없이 flat card list다.
- 구현되지 않은 항목이 보이지 않아서 “공식 HIG를 기준으로 어디까지 커버하는지”가 불명확하다.

## Product Direction

앱은 “일부 주제를 멋지게 보여주는 데모”보다 “공식 HIG를 실제 화면 맥락으로 훑는 내부 레퍼런스”에 더 가깝게 간다. 그래서 첫 기준은 시각 스타일이 아니라 정보구조 정합성이다.

핵심 원칙:

- 상위 탐색은 `패턴 / 구성요소` 유지
- 하위 탐색은 공식 HIG 계층을 그대로 반영
- 구현 여부는 숨기지 않고 상태로 드러냄
- 구현된 항목만 rich preview 제공
- 준비 중 항목도 HIG 링크와 기본 설명은 제공

## Information Architecture

### Top Level

- `패턴`
- `구성요소`

### Patterns

`패턴` 탭은 공식 HIG의 개별 패턴 항목을 그대로 노출한다.

예시:

- `Charting data`
- `Collaboration and sharing`
- `Drag and drop`
- `Entering data`
- `Feedback`
- `File management`
- `Going full screen`
- `Launching`
- `Live-viewing apps`
- `Loading`
- `Managing accounts`
- `Managing notifications`
- `Modality`
- `Multitasking`
- `Offering help`
- `Onboarding`
- `Playing audio`
- `Playing haptics`
- `Playing video`
- `Printing`
- `Ratings and reviews`
- `Searching`
- `Settings`
- `Undo and redo`
- `Workouts`

표시 규칙:

- 구현됨: hero thumbnail + usage context + 상세 preview
- 준비 중: status badge + HIG 링크 + 짧은 설명

### Components

`구성요소` 탭은 먼저 공식 그룹 목록을 보여준다.

- `Content`
- `Layout and organization`
- `Menus and actions`
- `Navigation and search`
- `Presentation`
- `Selection and input`
- `Status`
- `System experiences`

각 그룹을 탭하면 해당 그룹 내부의 컴포넌트 항목 목록으로 들어간다.

표시 규칙:

- 그룹 화면: 카드 또는 list row로 그룹 소개
- 하위 항목 화면: 각 컴포넌트 항목을 `implemented / planned` 상태와 함께 노출

## Data Model

현재 `AppleDesignTopic` 단일 배열만으로는 공식 계층을 표현하기 어렵다. 구조를 아래처럼 확장한다.

- `AppleLibraryKind`
  - `patterns`
  - `components`
- `AppleReferenceStatus`
  - `implemented`
  - `planned`
- `AppleReferenceGroup`
  - `id`
  - `libraryKind`
  - `name`
  - `koreanTitle`
  - `summary`
  - `items`
- `AppleDesignTopic`
  - 기존 필드 유지
  - `status`
  - `groupID` 또는 `componentGroup`

핵심은:

- `Patterns`는 group 없이 leaf topic list
- `Components`는 group → topic 2단 구조

## Screen Behavior

### Home / Library

#### Patterns tab

- 공식 패턴 항목 전체 목록 노출
- 구현된 항목은 지금의 media-first hero card 유지
- 준비 중 항목은 same-size card를 유지하되 썸네일 대신 더 단순한 placeholder representation 사용

#### Components tab

- flat topic list 대신 그룹 목록 노출
- 그룹 카드는 title + summary + count + chevron
- 그룹 탭 시 하위 항목 전용 화면으로 push

### Detail

#### Implemented topic

- 현재 상세 구조 유지
- preview / key points / SwiftUI reference / official HIG link

#### Planned topic

- preview 생략 또는 compact placeholder
- `준비 중` badge 노출
- 공식 HIG 링크
- 간단한 scope note

### Search

검색은 새 계층을 가로질러 동작한다.

- 패턴 leaf
- 구성요소 그룹
- 구성요소 leaf

결과 row/card는 각 항목의 타입을 분명히 보여줘야 한다.

예:

- `패턴`
- `구성요소 그룹`
- `구성요소 항목`

## Visual Semantics

현재 media-first card 톤은 유지하되, 상태가 다른 항목을 명확히 구분한다.

### Implemented

- hero thumbnail
- stronger contrast
- selectable 상세 진입

### Planned

- placeholder panel
- `준비 중` badge
- thumbnail은 축약 표현
- visual weight는 조금 낮춤

### Component groups

- thumbnail보다 구조적 카드
- 그룹명 + 설명 + 항목 수 + chevron

즉, “실제 화면 preview가 있는 leaf”와 “아직 브라우징용 구조 노드”가 시각적으로 섞이지 않게 한다.

## Navigation

탐색 구조는 다음처럼 정리한다.

- `패턴`
  - leaf directly selectable
- `구성요소`
  - group list
  - group detail list
  - topic detail

이 구조는 native navigation push를 우선 사용한다.

## Favorites

즐겨찾기는 `implemented`와 `planned` 둘 다 저장 가능하게 둘 수 있다. 다만 초기 구현은 아래를 권장한다.

- leaf topic만 즐겨찾기 가능
- group은 즐겨찾기 대상에서 제외

이렇게 하면 즐겨찾기의 의미가 유지된다.

## Trade-offs

### Option 1: 공식 계층 정확 미러링 + 준비 중 노출

장점:

- HIG 기준과 가장 정합적
- 레퍼런스 신뢰도 높음
- 커버리지 갭이 명확함

단점:

- 준비 중 항목이 많아질 수 있음

### Option 2: 구현된 항목만 노출

장점:

- 완성도 높아 보임

단점:

- 공식 HIG 대비 구조 왜곡
- 레퍼런스 역할 약화

추천은 Option 1이다. 내부 참고용 도구라는 목적과 가장 잘 맞는다.

## Success Criteria

- `패턴` 탭이 공식 HIG 패턴 leaf 목록과 같은 방향으로 보인다
- `구성요소` 탭이 공식 HIG 그룹 목록을 먼저 보여준다
- 구현되지 않은 항목도 `준비 중` 상태로 드러난다
- 검색이 새 계층을 반영한다
- 기존 구현 preview는 유지되되 구조적 위치만 바뀐다
