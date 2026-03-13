# Liquid Glass Apple Design Library Design

**Date:** 2026-03-13

## Goal

`애플 디자인 라이브러리` 전체 UI를 iOS 26 `Liquid Glass` 방향으로 재구성하고, 각 HIG 샘플을 실제 터치와 제스처에 반응하는 live demo로 바꾼다.

## Context

현재 앱은 `패턴 / 구성요소`를 기준으로 HIG topic을 탐색할 수 있고, 각 topic은 정적 preview scene과 상세 시트를 가진다. 구조 자체는 내부 reference 앱으로 적절하지만, 시각 언어는 아직 iOS 26 glass 계열과 거리가 있고 preview도 `다시 보기` 중심의 재생형 데모에 머물러 있다.

사용자 요구는 두 가지다.

1. 샘플을 iOS 26 liquid UI 방향으로 바꾼다.
2. 샘플이 실제 앱처럼 터치, 스와이프, 토글, 드래그 등에 반응해야 한다.

## Constraints

- 경로 기준은 반드시 main workspace다.
- 상위 구조는 계속 `패턴 / 구성요소` 분류를 유지한다.
- 분류 전환, 탭 전환, 시트는 native 구조를 유지한다.
- 커스텀 제어는 최소화하되, preview 장면은 실제 사용 맥락을 드러내야 한다.
- iOS 26 미만에서도 빌드 가능해야 하므로 fallback이 필요하다.
- layout grid overlay는 계속 최상위 window 레벨에 남아야 한다.

## Recommended Approach

전체 UI를 `Liquid Glass` 스타일 셸과 interactive preview system 두 층으로 나눈다.

### 1. Library Shell

- 홈, 즐겨찾기, 설정, 상세 시트의 주요 surface를 glass 계열로 올린다.
- 검색 필드, 카드, metadata block, code snippet block, empty state, segmented container를 glass panel 기반으로 정리한다.
- 하단 탭바는 native `TabView`를 유지하고, iOS 26 이상에서는 사용 가능한 탭 동작만 추가한다.
- 배경은 약한 다층 gradient와 highlight로 glass 표면이 분리되게 한다.
- text 대비는 유지하고, glass 위 텍스트는 항상 충분한 contrast를 확보한다.

### 2. Interactive Preview System

- `MotionPreviewView`는 더 이상 `animate` 한 변수로 전체를 재생하지 않는다.
- `PreviewKind`별로 실제 입력을 받는 mini scene을 제공한다.
- 각 scene은 HIG 항목에 맞는 interaction을 가진다.
  - `launch`: tap으로 launch shell에서 content shell로 전환
  - `loading`: tap으로 skeleton -> progress -> content reveal
  - `search`: tap/focus로 field 활성화와 result highlight
  - `modal`: tap/drag로 sheet present, dismiss
  - `menu`: tap 또는 long press로 menu reveal
  - `share`: tap으로 share panel 등장
  - `pageControl`: swipe로 page 전환
  - `picker` / `segmentedControl`: 실제 selection 변경
  - `textField`: focus/typing state 반영
  - `toggle`: 실제 on/off 전환
  - `list`: row tap 및 swipe affordance

### 3. Compatibility Layer

- iOS 26 이상에서는 glass API를 우선 사용한다.
- 그 미만에서는 `Material`, grouped background, separator stroke로 비슷한 위계를 제공한다.
- glass 전용 modifier는 helper로 감싸서 각 view가 직접 availability 분기를 반복하지 않게 한다.

## Alternatives Considered

### A. Preview only

프리뷰 캔버스만 glass와 interactive scene으로 바꾼다.

- 장점: 빠르다.
- 단점: “전체 라이브러리의 iOS 26화” 요구를 충족하지 못한다.

### B. Recommended: Shell + Preview

전체 chrome을 glass로 올리고, topic preview도 상호작용 가능한 live demo로 바꾼다.

- 장점: 요구사항과 가장 정확히 맞는다.
- 단점: 홈과 상세, preview renderer를 함께 수정해야 한다.

### C. Full visual restyle

모든 surface를 aggressively floating glass로 바꾼다.

- 장점: 시각적 임팩트가 크다.
- 단점: reference 앱 특성상 가독성과 정보 위계가 쉽게 무너진다.

## Information Architecture

- 탭바: `라이브러리 / 즐겨찾기 / 설정`
- 라이브러리 상단 분류: `패턴 / 구성요소`
- 상세 정보 계층:
  - interactive preview
  - title, summary, metadata
  - 핵심 포인트
  - SwiftUI 참고
  - 공식 가이드

같은 수준의 section header는 같은 token을 유지한다.

## Interaction Model

- 카드 tap: 상세 시트 열기
- star button: 즐겨찾기 toggle
- preview tap/drag/swipe: scene별 상태 전환
- replay button은 제거하거나 보조 action으로 축소한다. 기본 상호작용은 직접 조작이다.
- modal-style preview는 dismiss 경로가 항상 보장되어야 한다.

## Visual Language

- background: soft cool gradient + subtle bloom
- panel: glass fill + thin specular stroke
- accent: topic tint 유지
- corner radius: 기존 grouped card보다 조금 더 부드럽게
- shadow: heavy drop shadow 대신 얕은 depth separation
- controls: native shape와 spacing을 우선하고 glass는 표면 처리로만 사용

## Accessibility

- interactive target은 최소 44x44pt 유지
- custom preview도 VoiceOver에서 설명 가능한 label/value를 제공
- reduced transparency 환경에서도 card/panel 대비가 유지되도록 fallback stroke와 background separation 사용
- section header는 계속 header trait를 유지

## Testing Strategy

- 파일 레벨 테스트로 glass helper, interactive scene state, native tab/segmented 유지 여부를 확인
- Swift build로 availability 및 modifier 사용 오류 검증
- simulator manual check로
  - home shell
  - detail sheet
  - modal preview
  - page control preview
  - toggle preview
  를 확인

## Success Criteria

- 홈과 상세 모두에서 iOS 26 glass 계열 표면이 일관되게 보인다.
- 각 topic preview가 실제 입력에 반응한다.
- `패턴 / 구성요소` 정보구조와 native navigation은 유지된다.
- iOS build가 깨지지 않는다.
- grid overlay는 시트 위에서도 최상위에 남는다.
