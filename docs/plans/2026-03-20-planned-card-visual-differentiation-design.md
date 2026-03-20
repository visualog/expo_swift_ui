# Planned Card Visual Differentiation Design

**Goal**

`준비 중` HIG 항목이 구현된 항목과 한눈에 구분되도록 카드 hero를 더 단순한 placeholder surface로 바꾼다.

**Context**

현재 홈, 그룹, 검색 화면에서 `planned` 항목은 텍스트와 배지로는 구분되지만, hero 썸네일이 구현된 항목과 비슷한 시각 언어를 써서 먼저 훑을 때 차이가 약하다. 사용자 입장에서는 “이미 볼 수 있는 데모”와 “구조만 준비된 항목”이 빠르게 구분되어야 한다.

**Decision**

- 구현된 항목은 기존처럼 맥락형 hero 썸네일을 유지한다.
- `planned` 항목은 공용 placeholder hero를 사용한다.
- placeholder hero는 실제 앱 장면을 흉내 내지 않고, 아이콘 + `준비 중` 레이블 + 중립적인 skeleton 조합으로 구성한다.
- 카드 본문 텍스트 구조는 유지해서 정보 구조는 바꾸지 않는다.

**Why**

- 홈과 검색은 빠른 스캔이 우선이라 hero만 보고도 상태 차이를 읽을 수 있어야 한다.
- `planned` 항목을 지나치게 실감 나게 만들면 구현 범위를 오해하게 된다.
- 텍스트를 더 늘리지 않고도 상태 차이를 강화할 수 있다.

**Affected UI**

- 라이브러리 홈의 `AppleDesignTopicCard`
- 구성요소 그룹 화면의 `AppleDesignTopicCard`
- 검색 결과의 `AppleDesignTopicCard`

**Non-goals**

- 상세 화면의 `planned` fallback 문구 변경
- HIG 계층 구조 변경
- `implemented/planned` 카운트 규칙 변경
