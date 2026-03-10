# Shortcuts Screen HIG Review (2026-03-10)

## Scope
- Screen: `ExpoShortcutsHomeView.swift`
- Target: iOS + SwiftUI + Expo UI
- Rule set: `~/.codex/skills/apple-hig-swiftui/references/rules.yaml`

## Findings

### 1) Section heading level mismatch
- Decision: `내 단축어`와 `추천 단축어`를 동일한 섹션 레벨로 통일
- Rule IDs: `IA-LEVEL-001`, `SEM-SECTION-002`
- Why: 현재 두 영역은 sibling 섹션인데 타이포 토큰이 다름 (`34` vs `22`)
- Source URLs:
  - https://developer.apple.com/kr/design/human-interface-guidelines/
  - https://developer.apple.com/design/human-interface-guidelines/accessibility
- Implementation delta:
  - `내 단축어`, `추천 단축어` heading font를 동일 토큰으로 통일
  - custom layout 유지 시 두 heading 모두 접근성 header trait 부여

Code evidence:
- `내 단축어`: `.font(.system(size: 34, weight: .bold))`
- `추천 단축어`: `.font(.system(size: 22, weight: .bold))`

### 2) Light mode card separation is too weak
- Decision: 카드 표면과 배경의 시각적 분리를 강화
- Rule IDs: `CONTRAST-007`
- Why: 카드 배경(`secondarySystemBackground`)과 페이지 배경(`systemGroupedBackground`) 대비가 약해 라이트 모드에서 경계 인지가 어려움
- Source URLs:
  - https://developer.apple.com/design/tips/
  - https://developer.apple.com/design/human-interface-guidelines/accessibility
- Implementation delta:
  - 카드 surface를 `secondarySystemGroupedBackground` 또는 material 기반으로 재검토
  - 필요 시 1px stroke(`separator` 계열) 추가
  - 라이트/다크 각각 스크린샷 비교 검증 필수

Code evidence:
- 카드: `.background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(...))`
- 페이지: `.background(Color(uiColor: .systemGroupedBackground))`

### 3) Section semantics are visual-only in custom scroll layout
- Decision: Section semantics 보강
- Rule IDs: `SEM-SECTION-002`
- Why: 현재 `ScrollView + VStack` 구성으로 시스템 `Section` 시맨틱이 자동 제공되지 않음
- Source URLs:
  - https://developer.apple.com/design/human-interface-guidelines/accessibility
- Implementation delta:
  - 최소: 제목에 `.accessibilityAddTraits(.isHeader)` 부여
  - 대안: `List + Section` 전환(디자인 변화 수반)

## Priority
1. Heading level normalization (high)
2. Light mode contrast tuning (high)
3. Accessibility header semantics (medium)

## Ready-to-apply patch outline
1. Extract unified section title token (e.g. `sectionTitleFont`)
2. Apply token to both section headings
3. Add `.accessibilityAddTraits(.isHeader)` to both headings
4. Update folder card background token + subtle stroke
5. Verify in light/dark screenshots

## Implementation Status (2026-03-10)
- [x] Heading level normalization applied (`sectionHeadingFont` token shared)
- [x] Accessibility header traits applied to both section titles
- [x] Card surface contrast improved (`secondarySystemGroupedBackground` + subtle separator stroke)
- [x] Layout grid overlay default set to OFF
- [ ] Simulator light/dark screenshot re-validation pending
