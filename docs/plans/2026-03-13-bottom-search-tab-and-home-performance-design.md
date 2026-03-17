# Bottom Search Tab And Home Performance Design

**Context**

`애플 디자인 라이브러리`는 현재 홈 상단에 검색 필드를 두고, 하단에는 `라이브러리 / 즐겨찾기 / 설정` 탭만 제공합니다. 사용자는 검색을 하단 우측에 분리된 진입점으로 옮기길 원했고, 홈 스크롤이 끊기는 현상도 함께 개선하길 요청했습니다.

**Problem**

- 홈 상단 검색은 top-level destination이 아니라 화면 내부 필터라서, 하단 탭 구조와 역할이 겹칩니다.
- 현재 홈은 `ScrollView + LazyVGrid` 안의 카드마다 무거운 liquid-glass panel을 적용해 스크롤 중 합성 비용이 큽니다.
- 상단 segmented picker 자체는 native지만, 바깥 glass 래퍼까지 겹쳐 있어 home chrome이 과합니다.

**Options**

1. 상단 검색 유지 + 하단 검색 추가  
중복 진입점이 생겨 정보구조가 흐려집니다.

2. 하단에 검색을 별도 탭으로 분리  
검색을 top-level destination으로 승격할 수 있지만, 사용자가 원하는 `좌측 그룹 + 우측 단독 검색` 표현은 약할 수 있습니다.

3. 좌측은 기존 탭 그룹을 유지하고, 우측에는 public SwiftUI 하단 액세서리로 검색 진입점을 둔다  
시각 구조와 요구사항에 가장 가깝고, 상단 검색 제거로 역할도 분리됩니다.

**Decision**

3번으로 진행합니다.

- 상단 검색 필드는 제거합니다.
- 하단은 `라이브러리 / 즐겨찾기 / 설정` 3개를 유지합니다.
- iOS 26 이상에서는 `tabViewBottomAccessory`를 사용해 우측 단독 검색 진입점을 둡니다.
- 검색 자체는 별도 `검색` destination으로 구성하고, 하단 우측 액세서리에서 그 destination으로 이동합니다.
- iOS 26 미만에서는 일반 탭 구조 fallback을 유지합니다.
- 홈 카드와 상단 chrome은 glass 밀도를 낮춰 스크롤 성능을 개선합니다.

**UI Structure**

- 홈
  - 대제목
  - 설명 패널
  - native segmented picker
  - topic count
  - topic grid
- 하단
  - 좌측: `라이브러리 / 즐겨찾기 / 설정`
  - 우측: 검색 액세서리
- 검색 화면
  - 전용 검색 입력
  - 전체 topic 검색 결과
  - 빈 결과 상태

**Performance Direction**

- 스크롤되는 topic card는 heavy glass 패널 대신 더 가벼운 panel variant를 사용합니다.
- 상단 설명 패널과 segmented 주변은 여전히 liquid 방향을 유지하되, shadow와 tint overlay를 줄입니다.
- 배경 blur는 유지하되 카드까지 중첩되는 합성 비용을 최소화합니다.

**Testing**

- 파일 기반 테스트로 상단 검색 필드 제거 여부를 확인합니다.
- 파일 기반 테스트로 하단 검색 destination 및 `tabViewBottomAccessory` 사용을 확인합니다.
- 파일 기반 테스트로 topic card가 lighter panel variant를 사용하도록 바뀌었는지 확인합니다.
