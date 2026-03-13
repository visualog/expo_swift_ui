import Foundation

enum AppleLibraryKind: String, CaseIterable, Identifiable, Codable {
  case patterns
  case components

  var id: String { rawValue }

  var title: String {
    switch self {
    case .patterns: return "Patterns"
    case .components: return "Components"
    }
  }

  var koreanTitle: String {
    switch self {
    case .patterns: return "패턴"
    case .components: return "구성요소"
    }
  }
}

enum PreviewKind: String, CaseIterable, Codable {
  case launch
  case loading
  case search
  case onboarding
  case modal
  case share
  case menu
  case writing
  case button
  case collection
  case colorWell
  case icon
  case image
  case label
  case list
  case pageControl
  case picker
  case progress
  case segmentedControl
  case textField
  case toggle
}

struct AppleDesignTopic: Identifiable, Hashable, Codable {
  let id: String
  let name: String
  let koreanTitle: String
  let summary: String
  let libraryKind: AppleLibraryKind
  let sectionTitle: String
  let tags: [String]
  let icon: String
  let tintHex: String
  let higUrl: String
  let higPathTitle: String
  let platformNotes: String
  let swiftUIReference: String
  let previewKind: PreviewKind
  let keyPoints: [String]
  let isSystemDemo: Bool
}

extension AppleDesignTopic {
  static let sampleData: [AppleDesignTopic] = [
    AppleDesignTopic(
      id: "pattern_launching",
      name: "Launching",
      koreanTitle: "앱 실행",
      summary: "앱이 열리고 첫 화면으로 전환될 때 브랜드보다 실제 첫 작업으로 빠르게 연결하는 흐름입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["startup", "launch", "first-run"],
      icon: "sparkles.tv",
      tintHex: "#0A84FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/launching",
      higPathTitle: "Patterns • Launching",
      platformNotes: "실행 경험은 짧고 명확해야 하며 첫 콘텐츠로 빠르게 이어져야 합니다.",
      swiftUIReference: "ZStack + launch state transition into root content",
      previewKind: .launch,
      keyPoints: [
        "첫 화면으로 빠르게 진입해야 합니다.",
        "브랜드 노출보다 사용자가 시작할 작업을 우선합니다.",
        "정적인 스플래시보다 실제 콘텐츠 연결이 중요합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_loading",
      name: "Loading",
      koreanTitle: "로딩",
      summary: "콘텐츠가 준비되는 동안 진행 상태와 대기 맥락을 이해할 수 있게 만드는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["loading", "skeleton", "progress"],
      icon: "hourglass",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/loading",
      higPathTitle: "Patterns • Loading",
      platformNotes: "단순 spinner보다 가능한 한 실제 레이아웃을 유지하고 진행 상태를 드러내는 편이 좋습니다.",
      swiftUIReference: "ProgressView + redacted placeholders + task state",
      previewKind: .loading,
      keyPoints: [
        "로딩 중에도 레이아웃 맥락을 유지합니다.",
        "대기 시간이 길면 진행 상태를 구체적으로 보여줍니다.",
        "완료 후 실제 콘텐츠로 자연스럽게 전환합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_menus",
      name: "Menus",
      koreanTitle: "메뉴",
      summary: "보조 명령을 현재 화면 맥락 안에서 간결하게 노출하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["menu", "actions", "context"],
      icon: "ellipsis.circle",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/menus",
      higPathTitle: "Patterns • Menus",
      platformNotes: "맥락 메뉴는 현재 선택과 연관된 작업을 짧고 명확하게 노출해야 합니다.",
      swiftUIReference: "Menu + Button roles + context actions",
      previewKind: .menu,
      keyPoints: [
        "현재 맥락과 관련 있는 작업만 넣습니다.",
        "파괴적 작업은 역할과 구분을 명확히 합니다.",
        "주요 작업은 메뉴 안으로 숨기지 않습니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_modality",
      name: "Modality",
      koreanTitle: "모달리티",
      summary: "현재 작업 흐름을 잠시 분리해 집중이 필요한 내용을 다루는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["sheet", "modal", "focus"],
      icon: "square.bottomhalf.filled",
      tintHex: "#30B0C7",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/modality",
      higPathTitle: "Patterns • Modality",
      platformNotes: "모달은 명확한 완료 또는 취소 흐름이 있을 때만 사용해야 합니다.",
      swiftUIReference: ".sheet / .fullScreenCover with focused task flow",
      previewKind: .modal,
      keyPoints: [
        "반드시 별도의 집중 흐름이 필요한 경우에만 사용합니다.",
        "닫기 경로는 명확해야 합니다.",
        "모달 안에 또 다른 모달을 중첩하지 않습니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_onboarding",
      name: "Onboarding",
      koreanTitle: "온보딩",
      summary: "초기 학습과 권한, 핵심 가치 제안을 단계적으로 소개하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["intro", "education", "first-run"],
      icon: "rectangle.on.rectangle.angled",
      tintHex: "#FF9F0A",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/onboarding",
      higPathTitle: "Patterns • Onboarding",
      platformNotes: "온보딩은 짧게 유지하고 실제 사용으로 빠르게 이어져야 합니다.",
      swiftUIReference: "TabView with .page style + focused onboarding copy",
      previewKind: .onboarding,
      keyPoints: [
        "핵심 가치와 첫 행동을 중심으로 구성합니다.",
        "모든 기능 설명을 한 번에 밀어 넣지 않습니다.",
        "건너뛰기와 나중에 학습하기를 허용합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_searching",
      name: "Searching",
      koreanTitle: "검색",
      summary: "검색 필드, 최근 검색, 결과 목록이 하나의 흐름으로 이어지는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["search", "results", "query"],
      icon: "magnifyingglass",
      tintHex: "#0A84FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/searching",
      higPathTitle: "Patterns • Searching",
      platformNotes: "검색은 입력과 결과가 같은 흐름 안에서 빠르게 피드백되어야 합니다.",
      swiftUIReference: ".searchable + result sections + recent queries",
      previewKind: .search,
      keyPoints: [
        "입력 즉시 관련 결과를 보여줍니다.",
        "최근 검색과 추천은 검색을 돕는 정도로만 사용합니다.",
        "검색 상태와 기본 상태의 전환을 명확히 구분합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_file_management",
      name: "File management",
      koreanTitle: "파일 관리",
      summary: "문서와 파일을 브라우징, 정렬, 선택, 이동하는 흐름을 정리하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["files", "browser", "documents"],
      icon: "folder",
      tintHex: "#FFCC00",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/file-management",
      higPathTitle: "Patterns • File management",
      platformNotes: "파일 관리 화면은 계층, 현재 위치, 선택 상태를 명확히 보여줘야 합니다.",
      swiftUIReference: "NavigationSplitView + List selection + context actions",
      previewKind: .list,
      keyPoints: [
        "현재 위치와 계층을 이해하기 쉽게 보여줍니다.",
        "파일 작업은 선택 상태와 함께 제공해야 합니다.",
        "정렬과 보기 방식은 사용자가 제어할 수 있어야 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_collaboration_and_sharing",
      name: "Collaboration and sharing",
      koreanTitle: "협업 및 공유",
      summary: "콘텐츠를 다른 사람과 공유하거나 함께 작업하게 만드는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["share", "collaboration", "invite"],
      icon: "person.2.crop.square.stack",
      tintHex: "#30D158",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/collaboration-and-sharing",
      higPathTitle: "Patterns • Collaboration and sharing",
      platformNotes: "공유는 대상, 권한, 결과를 이해하기 쉬운 흐름으로 제공해야 합니다.",
      swiftUIReference: "ShareLink + share sheet + collaboration state row",
      previewKind: .share,
      keyPoints: [
        "대상과 권한을 분명하게 설명합니다.",
        "공유 전후 상태 변화를 보여줍니다.",
        "초대와 공개 공유를 혼동하지 않게 설계합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_notifications",
      name: "Notifications",
      koreanTitle: "알림",
      summary: "사용자에게 시의적절한 정보를 전달하고 다시 앱으로 연결하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["notification", "alerts", "updates"],
      icon: "bell.badge",
      tintHex: "#FF375F",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/notifications",
      higPathTitle: "Patterns • Notifications",
      platformNotes: "알림은 가치가 명확할 때만 보내고, 탭 후 목적지 연결이 자연스러워야 합니다.",
      swiftUIReference: "List rows + notification settings + destination deep link handling",
      previewKind: .list,
      keyPoints: [
        "알림은 시간과 맥락에 맞아야 합니다.",
        "내용은 한눈에 이해할 수 있어야 합니다.",
        "탭 이후 이동할 목적지가 분명해야 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_writing",
      name: "Writing",
      koreanTitle: "쓰기",
      summary: "텍스트를 작성, 편집, 검토하는 흐름에서 집중과 가독성을 유지하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      tags: ["writing", "editor", "input"],
      icon: "square.and.pencil",
      tintHex: "#BF5AF2",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/writing",
      higPathTitle: "Patterns • Writing",
      platformNotes: "쓰기 화면은 방해를 줄이고 입력 상태와 포커스를 분명하게 유지해야 합니다.",
      swiftUIReference: "TextEditor + toolbar formatting + focused field state",
      previewKind: .writing,
      keyPoints: [
        "입력 중에는 방해 요소를 줄입니다.",
        "편집 맥락과 서식 도구를 가깝게 둡니다.",
        "초안과 완료 상태를 분명하게 구분합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_buttons",
      name: "Buttons",
      koreanTitle: "버튼",
      summary: "명확한 액션을 표현하는 기본 조작 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["button", "action", "cta"],
      icon: "rectangle.portrait.and.arrow.right",
      tintHex: "#0A84FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/buttons",
      higPathTitle: "Components • Buttons",
      platformNotes: "버튼은 역할과 우선순위가 시각적으로 분명해야 합니다.",
      swiftUIReference: "Button + buttonStyle + controlSize + role",
      previewKind: .button,
      keyPoints: [
        "가장 중요한 액션만 시각적으로 강조합니다.",
        "버튼 제목은 동사를 중심으로 짧게 씁니다.",
        "역할이 다른 버튼은 스타일도 구분합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_collections",
      name: "Collections",
      koreanTitle: "컬렉션",
      summary: "카드나 썸네일 기반의 반복 콘텐츠를 브라우징하는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["grid", "cards", "browse"],
      icon: "square.grid.2x2",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/collections",
      higPathTitle: "Components • Collections",
      platformNotes: "컬렉션은 일관된 셀 구조와 예측 가능한 탐색 흐름이 중요합니다.",
      swiftUIReference: "LazyVGrid + card cell + selection state",
      previewKind: .collection,
      keyPoints: [
        "셀 구조를 일관되게 유지합니다.",
        "스크롤과 선택 상태를 쉽게 추적할 수 있어야 합니다.",
        "과도한 장식보다 콘텐츠 자체를 우선합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_color_wells",
      name: "Color wells",
      koreanTitle: "색상 선택기",
      summary: "현재 색을 보여주고 색상 변경을 시작하는 작은 조작 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["color", "picker", "well"],
      icon: "eyedropper.halffull",
      tintHex: "#FF9F0A",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/color-wells",
      higPathTitle: "Components • Color wells",
      platformNotes: "현재 선택된 색과 상호작용 가능성을 함께 드러내야 합니다.",
      swiftUIReference: "ColorPicker with visible selected swatch",
      previewKind: .colorWell,
      keyPoints: [
        "현재 색을 명확히 보여줍니다.",
        "색상 변경 동작은 예측 가능해야 합니다.",
        "작은 컨트롤이지만 충분한 hit target을 확보합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_icons",
      name: "Icons",
      koreanTitle: "아이콘",
      summary: "작은 시각 기호로 의미를 전달하는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["icon", "symbol", "sf-symbols"],
      icon: "app.badge",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/icons",
      higPathTitle: "Components • Icons",
      platformNotes: "아이콘은 텍스트를 완전히 대체하기보다 의미를 보조하는 역할에 적합합니다.",
      swiftUIReference: "Image(systemName:) + symbolRenderingMode + label pairing",
      previewKind: .icon,
      keyPoints: [
        "익숙한 의미를 가진 기호를 사용합니다.",
        "필요한 경우 레이블과 함께 제공합니다.",
        "장식용과 액션용 아이콘을 구분합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_images",
      name: "Images",
      koreanTitle: "이미지",
      summary: "썸네일, 히어로, 미디어 프리뷰 등 시각 콘텐츠를 보여주는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["image", "media", "thumbnail"],
      icon: "photo.on.rectangle",
      tintHex: "#30B0C7",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/images",
      higPathTitle: "Components • Images",
      platformNotes: "이미지는 레이아웃 안에서 목적과 계층이 분명해야 합니다.",
      swiftUIReference: "Image + AsyncImage + scaledToFill/crop management",
      previewKind: .image,
      keyPoints: [
        "이미지는 정보 구조를 보조해야 합니다.",
        "자르기와 비율 처리를 일관되게 유지합니다.",
        "장식 이미지와 콘텐츠 이미지를 구분합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_labels",
      name: "Labels",
      koreanTitle: "레이블",
      summary: "아이콘과 텍스트를 묶어 의미를 전달하는 조합형 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["label", "text", "icon+text"],
      icon: "tag",
      tintHex: "#8E8E93",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/labels",
      higPathTitle: "Components • Labels",
      platformNotes: "레이블은 텍스트 의미를 우선하고, 아이콘은 보조 정보로 동작해야 합니다.",
      swiftUIReference: "Label(title:icon:) with foreground hierarchy",
      previewKind: .label,
      keyPoints: [
        "텍스트가 핵심 의미를 전달해야 합니다.",
        "아이콘은 맥락을 빠르게 보조합니다.",
        "한 화면 안에서 레이블 구조를 일관되게 유지합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_lists_tables",
      name: "Lists and tables",
      koreanTitle: "리스트 및 테이블",
      summary: "행 기반 데이터와 설정 화면을 구성하는 핵심 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["list", "table", "rows"],
      icon: "list.bullet.rectangle",
      tintHex: "#30D158",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/lists-and-tables",
      higPathTitle: "Components • Lists and tables",
      platformNotes: "행 구조, 구분, 보조 정보, 액세서리 관계가 명확해야 합니다.",
      swiftUIReference: "List + Section + insetGrouped styling",
      previewKind: .list,
      keyPoints: [
        "행 정보의 계층을 명확히 보여줍니다.",
        "섹션과 보조 설명을 적절히 사용합니다.",
        "선택과 이동 affordance를 일관되게 유지합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_page_controls",
      name: "Page controls",
      koreanTitle: "페이지 컨트롤",
      summary: "여러 페이지 중 현재 위치를 점 형태로 알려주는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["paging", "carousel", "dots"],
      icon: "ellipsis.rectangle",
      tintHex: "#0A84FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/page-controls",
      higPathTitle: "Components • Page controls",
      platformNotes: "page control은 현재 페이지 위치를 보여줄 때 사용하며 카테고리 전환용이 아닙니다.",
      swiftUIReference: "TabView with .page style + index display",
      previewKind: .pageControl,
      keyPoints: [
        "현재 위치 표시와 페이지 전환 맥락을 함께 제공합니다.",
        "페이지 수가 과도하게 많을 때는 다른 탐색 구조를 고려합니다.",
        "페이지 콘텐츠와 인디케이터가 연결되어 보여야 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_pickers",
      name: "Pickers",
      koreanTitle: "피커",
      summary: "여러 선택지 중 하나를 고르는 입력 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["picker", "selection", "input"],
      icon: "list.bullet.circle",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/pickers",
      higPathTitle: "Components • Pickers",
      platformNotes: "선택 항목 수와 맥락에 따라 menu, inline, wheel 등 적절한 스타일을 택해야 합니다.",
      swiftUIReference: "Picker + style variants (.menu, .wheel, .inline)",
      previewKind: .picker,
      keyPoints: [
        "선택지 수와 중요도에 맞는 스타일을 사용합니다.",
        "현재 선택 상태를 쉽게 읽을 수 있어야 합니다.",
        "입력 흐름을 방해하지 않는 형태를 고릅니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_progress_indicators",
      name: "Progress indicators",
      koreanTitle: "진행 표시기",
      summary: "진행 중인 작업 상태와 완료까지의 흐름을 보여주는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["progress", "status", "activity"],
      icon: "chart.bar.xaxis",
      tintHex: "#30D158",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/progress-indicators",
      higPathTitle: "Components • Progress indicators",
      platformNotes: "진행률을 알 수 있을 때는 determinate, 모를 때는 indeterminate 표현을 사용합니다.",
      swiftUIReference: "ProgressView + circular/linear styles",
      previewKind: .progress,
      keyPoints: [
        "진행률을 알 수 있으면 수치나 선형 막대로 표현합니다.",
        "짧은 대기에는 과도한 장식을 넣지 않습니다.",
        "완료 후 상태 전환이 명확해야 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_segmented_controls",
      name: "Segmented controls",
      koreanTitle: "세그먼트 컨트롤",
      summary: "서로 배타적인 소수의 선택지를 빠르게 전환하는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["segmented", "switcher", "selection"],
      icon: "rectangle.split.3x1",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/segmented-controls",
      higPathTitle: "Components • Segmented controls",
      platformNotes: "세그먼트는 소수의 peer 옵션을 전환할 때만 적합합니다.",
      swiftUIReference: "Picker + .segmented style",
      previewKind: .segmentedControl,
      keyPoints: [
        "상호 배타적인 소수 옵션에만 사용합니다.",
        "라벨은 짧고 명확해야 합니다.",
        "탭바처럼 최상위 목적지에 과용하지 않습니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_text_fields",
      name: "Text fields",
      koreanTitle: "텍스트 필드",
      summary: "짧은 텍스트를 입력하거나 편집하는 가장 기본적인 입력 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["text field", "input", "form"],
      icon: "character.cursor.ibeam",
      tintHex: "#FF9F0A",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/text-fields",
      higPathTitle: "Components • Text fields",
      platformNotes: "레이블, placeholder, 입력 상태, 오류 상태가 분명해야 합니다.",
      swiftUIReference: "TextField + FocusState + submitLabel",
      previewKind: .textField,
      keyPoints: [
        "레이블과 입력 목적을 분명하게 보여줍니다.",
        "placeholder는 예시이지 레이블을 대체하지 않습니다.",
        "포커스와 오류 상태를 명확히 표현합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_toggles",
      name: "Toggles",
      koreanTitle: "토글",
      summary: "켜짐/꺼짐 상태를 즉시 전환하는 이진 선택 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      tags: ["toggle", "switch", "settings"],
      icon: "switch.2",
      tintHex: "#30D158",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/toggles",
      higPathTitle: "Components • Toggles",
      platformNotes: "토글은 저장 버튼 없이 즉시 적용되는 설정에 적합합니다.",
      swiftUIReference: "Toggle with inline settings row label",
      previewKind: .toggle,
      keyPoints: [
        "켜짐/꺼짐이 즉시 반영되는 설정에 사용합니다.",
        "상태의 의미가 레이블만으로 명확해야 합니다.",
        "추가 확인이 필요한 작업에는 토글을 쓰지 않습니다."
      ],
      isSystemDemo: false
    )
  ]
}
