# Semantic Apple Design Tokens Design

**Context**

현재 `애플 디자인 라이브러리`는 Apple HIG를 참조하는 앱이지만, 실제 화면 구현은 시맨틱 색상과 타입 스타일보다 고정값에 크게 의존하고 있습니다. 그 결과 다크 모드, 대비 변화, Dynamic Type 적응이 충분하지 않고, Apple 디자인 시스템을 설명하는 앱으로서도 설득력이 떨어집니다.

**Observed Issues**

- 배경과 패널이 `Color(red:...)`, `Color.white.opacity(...)`, `Color(hex: ...)` 중심으로 구성돼 Light/Dark 적응이 약합니다.
- 헤드라인, 본문, 캡션이 대부분 `.font(.system(size: ...))` 로 고정돼 Dynamic Type 스케일과 semantic hierarchy를 충분히 타지 않습니다.
- `topic.tintHex`가 accent 역할을 넘어서 표면색 구성에도 개입합니다.
- preview scene도 HIG topic reference임에도 semantic foreground/background가 아닌 임의 알파 조합이 많습니다.

**Decision**

공통 `AppleDesignSemanticTokens` 레이어를 도입하고, 라이브러리 화면군과 preview scene에 semantic color, text style, spacing role을 적용합니다.

**Principles**

- 색상은 가능한 한 system semantic color를 우선 사용합니다.
- glass direction은 유지하되, glass 위에 올라가는 content color는 semantic foreground를 사용합니다.
- typography는 point size 직접 지정 대신 SwiftUI semantic text style을 우선 사용합니다.
- spacing도 숫자 흩뿌리기 대신 role 기반 scale로 통일합니다.
- `topic.tintHex`는 accent와 topical emphasis에만 제한적으로 사용합니다.

**Scope**

- Home
- Search
- Favorites
- Settings
- Detail sheet
- MotionPreviewView

**Token Model**

- Color
  - app background: `systemBackground` / `secondarySystemBackground`
  - elevated panel fill fallback: `secondarySystemBackground`, `tertiarySystemBackground`, `systemFill`, `secondarySystemFill`
  - primary text: `label`
  - secondary text: `secondaryLabel`
  - tertiary/meta text: `tertiaryLabel`
  - separators/strokes: `separator`, `opaqueSeparator`
  - accent: topic tint or `.accentColor`
- Typography
  - screen title: `.largeTitle`
  - section title: `.title2` or `.title3`
  - card title: `.headline`
  - body: `.body`
  - meta/supporting: `.subheadline`, `.footnote`, `.caption`
  - monospace snippet: `.footnote` with monospaced design
- Spacing
  - page inset
  - section gap
  - card content gap
  - compact control padding

**Expected Outcome**

- Dark mode에서도 배경과 텍스트 대비가 자연스럽게 유지됩니다.
- 카드와 detail, preview가 system semantic hierarchy에 맞게 읽힙니다.
- Apple 디자인 reference 앱으로서 설명하는 내용과 구현 방식이 더 일치합니다.
