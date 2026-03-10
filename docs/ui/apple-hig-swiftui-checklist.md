# Apple HIG SwiftUI UI Review Checklist

## Information Architecture
- [ ] sibling 섹션 제목은 동일 타이포 토큰을 사용한다.
- [ ] 제목 위계는 위치(위/아래)만으로 결정하지 않는다.
- [ ] 섹션 간 간격/리듬이 일관된다.

## Semantics & Accessibility
- [ ] 가능하면 `List + Section`을 사용한다.
- [ ] custom layout인 경우 섹션 제목에 header semantics를 추가한다.
- [ ] 주요 컨트롤은 VoiceOver에서 의미 단위로 탐색된다.

## Navigation
- [ ] 탭은 최상위 목적지 전환 용도로만 사용한다.
- [ ] 화면별 컨텍스트 액션은 nav/toolbar에 배치한다.

## Modality
- [ ] 모달은 집중이 필요한 인터럽션에만 사용한다.
- [ ] 모달마다 명확한 dismiss 경로가 있다.

## Touch Target
- [ ] 탭 가능한 요소는 최소 44x44pt를 만족한다.
- [ ] 아이콘만 있는 버튼도 탭 프레임 기준으로 검사한다.

## Visual Contrast
- [ ] 라이트 모드에서 카드와 배경이 구분된다.
- [ ] 다크 모드에서도 텍스트/액션 대비가 충분하다.
- [ ] 투명/블러 효과가 있어도 정보 위계가 유지된다.

## Screen QA Protocol
- [ ] 라이트 모드 전체 캡처 검토
- [ ] 다크 모드 전체 캡처 검토
- [ ] Dynamic Type(기본/확대) 검토
- [ ] 실제 기기/시뮬레이터에서 스크롤·탭 상호작용 확인

## Sources
- https://developer.apple.com/kr/design/human-interface-guidelines/
- https://developer.apple.com/design/human-interface-guidelines/accessibility
- https://developer.apple.com/design/human-interface-guidelines/tab-views
- https://developer.apple.com/design/human-interface-guidelines/modality
- https://developer.apple.com/design/tips/
