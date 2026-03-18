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

enum AppleReferenceStatus: String, CaseIterable, Codable {
  case implemented
  case planned
}

enum AppleComponentGroup: String, CaseIterable, Identifiable, Codable {
  case content
  case layoutAndOrganization
  case menusAndActions
  case navigationAndSearch
  case presentation
  case selectionAndInput
  case status
  case systemExperiences

  var id: String { rawValue }

  var title: String {
    switch self {
    case .content: return "Content"
    case .layoutAndOrganization: return "Layout and organization"
    case .menusAndActions: return "Menus and actions"
    case .navigationAndSearch: return "Navigation and search"
    case .presentation: return "Presentation"
    case .selectionAndInput: return "Selection and input"
    case .status: return "Status"
    case .systemExperiences: return "System experiences"
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
  let cardSummary: String
  let summary: String
  let libraryKind: AppleLibraryKind
  let status: AppleReferenceStatus
  let sectionTitle: String
  let componentGroup: AppleComponentGroup?
  let usageContext: String
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

  init(
    id: String,
    name: String,
    koreanTitle: String,
    cardSummary: String,
    summary: String,
    libraryKind: AppleLibraryKind,
    status: AppleReferenceStatus = .implemented,
    sectionTitle: String,
    componentGroup: AppleComponentGroup? = nil,
    usageContext: String,
    tags: [String],
    icon: String,
    tintHex: String,
    higUrl: String,
    higPathTitle: String,
    platformNotes: String,
    swiftUIReference: String,
    previewKind: PreviewKind,
    keyPoints: [String],
    isSystemDemo: Bool
  ) {
    self.id = id
    self.name = name
    self.koreanTitle = koreanTitle
    self.cardSummary = cardSummary
    self.summary = summary
    self.libraryKind = libraryKind
    self.status = status
    self.sectionTitle = sectionTitle
    self.componentGroup = componentGroup
    self.usageContext = usageContext
    self.tags = tags
    self.icon = icon
    self.tintHex = tintHex
    self.higUrl = higUrl
    self.higPathTitle = higPathTitle
    self.platformNotes = platformNotes
    self.swiftUIReference = swiftUIReference
    self.previewKind = previewKind
    self.keyPoints = keyPoints
    self.isSystemDemo = isSystemDemo
  }
}

extension AppleDesignTopic {
  static let sampleData: [AppleDesignTopic] = [
    AppleDesignTopic(
      id: "pattern_charting_data",
      name: "Charting data",
      koreanTitle: "차트 데이터",
      cardSummary: "수치와 추세 시각화",
      summary: "수치, 비교, 추세를 시각적으로 이해하기 쉽게 보여주는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "차트와 지표 시각화",
      tags: ["chart", "data", "metrics"],
      icon: "chart.bar",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/charting-data",
      higPathTitle: "Patterns • Charting data",
      platformNotes: "차트는 핵심 비교와 변화량이 빠르게 읽히도록 설계해야 합니다.",
      swiftUIReference: "Charts + summary metrics + focused annotation",
      previewKind: .progress,
      keyPoints: [
        "가장 중요한 비교 기준을 먼저 보여줍니다.",
        "색과 형태는 정보 구분을 돕는 정도로만 사용합니다.",
        "세부 수치는 필요할 때만 드러나게 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_collaboration_and_sharing",
      name: "Collaboration and sharing",
      koreanTitle: "협업 및 공유",
      cardSummary: "대상과 권한 공유",
      summary: "콘텐츠를 다른 사람과 공유하거나 함께 작업하게 만드는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "공유와 초대 흐름",
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
      id: "pattern_drag_and_drop",
      name: "Drag and drop",
      koreanTitle: "드래그 앤 드롭",
      cardSummary: "항목 직접 이동",
      summary: "항목을 집어 다른 위치나 다른 컨테이너로 직접 옮기는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "직접 이동 상호작용",
      tags: ["drag", "drop", "reorder"],
      icon: "hand.draw",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/drag-and-drop",
      higPathTitle: "Patterns • Drag and drop",
      platformNotes: "끌 수 있는 객체와 놓을 수 있는 대상, 결과 피드백이 명확해야 합니다.",
      swiftUIReference: "draggable + dropDestination + reorderable containers",
      previewKind: .collection,
      keyPoints: [
        "끌 수 있는 항목과 놓을 수 있는 대상을 분명하게 보여줍니다.",
        "이동 결과를 예측할 수 있어야 합니다.",
        "다른 제스처와 충돌하지 않도록 설계합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_entering_data",
      name: "Entering data",
      koreanTitle: "데이터 입력",
      cardSummary: "집중 입력 화면",
      summary: "텍스트를 작성, 편집, 검토하는 흐름에서 집중과 가독성을 유지하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "집중 입력 화면",
      tags: ["writing", "editor", "input"],
      icon: "square.and.pencil",
      tintHex: "#BF5AF2",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/entering-data",
      higPathTitle: "Patterns • Entering data",
      platformNotes: "입력 화면은 방해를 줄이고 입력 상태와 포커스를 분명하게 유지해야 합니다.",
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
      id: "pattern_feedback",
      name: "Feedback",
      koreanTitle: "피드백",
      cardSummary: "상태와 결과 전달",
      summary: "사용자 행동의 결과와 현재 상태를 즉시 이해할 수 있게 전달하는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "상태 변화 피드백",
      tags: ["feedback", "status", "response"],
      icon: "sparkle",
      tintHex: "#30D158",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/feedback",
      higPathTitle: "Patterns • Feedback",
      platformNotes: "피드백은 빠르고 구체적이어야 하며 사용자의 다음 행동을 방해하지 않아야 합니다.",
      swiftUIReference: "inline status + confirmation transitions + haptic cues",
      previewKind: .progress,
      keyPoints: [
        "행동 직후 결과를 빠르게 보여줍니다.",
        "시각, 모션, 햅틱을 과하지 않게 조합합니다.",
        "오류와 성공의 차이를 분명하게 전달합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_file_management",
      name: "File management",
      koreanTitle: "파일 관리",
      cardSummary: "브라우징과 선택",
      summary: "문서와 파일을 브라우징, 정렬, 선택, 이동하는 흐름을 정리하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "파일 브라우징",
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
      id: "pattern_going_full_screen",
      name: "Going full screen",
      koreanTitle: "전체 화면 전환",
      cardSummary: "몰입형 전체 화면",
      summary: "현재 콘텐츠를 방해 요소 없이 더 몰입감 있게 보여주는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "전체 화면 몰입 보기",
      tags: ["full screen", "immersive", "focus"],
      icon: "arrow.up.left.and.arrow.down.right",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/going-full-screen",
      higPathTitle: "Patterns • Going full screen",
      platformNotes: "전체 화면 전환은 진입과 복귀 경로가 예측 가능해야 합니다.",
      swiftUIReference: "fullScreenCover + chrome transitions + gesture dismissal",
      previewKind: .modal,
      keyPoints: [
        "전체 화면 전환 목적을 분명하게 합니다.",
        "복귀 제스처와 컨트롤을 쉽게 찾게 합니다.",
        "기존 맥락으로 자연스럽게 돌아가야 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_launching",
      name: "Launching",
      koreanTitle: "앱 실행",
      cardSummary: "첫 화면 진입 흐름",
      summary: "앱이 열리고 첫 화면으로 전환될 때 브랜드보다 실제 첫 작업으로 빠르게 연결하는 흐름입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "앱 시작 화면",
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
      id: "pattern_live_viewing_apps",
      name: "Live-viewing apps",
      koreanTitle: "실시간 보기 앱",
      cardSummary: "라이브 상태 관찰",
      summary: "라이브 상태나 지속적으로 갱신되는 콘텐츠를 안정적으로 보여주는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "실시간 상태 관찰",
      tags: ["live", "stream", "realtime"],
      icon: "play.tv",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/live-viewing-apps",
      higPathTitle: "Patterns • Live-viewing apps",
      platformNotes: "실시간 콘텐츠는 현재 상태, 지연, 제어 수단을 함께 이해할 수 있어야 합니다.",
      swiftUIReference: "timeline updates + lightweight controls + state indicators",
      previewKind: .image,
      keyPoints: [
        "현재 상태와 지연 여부를 함께 알려줍니다.",
        "중요 제어만 전면에 둡니다.",
        "실시간 변화가 과도한 피로를 주지 않게 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_loading",
      name: "Loading",
      koreanTitle: "로딩",
      cardSummary: "대기와 진행 상태",
      summary: "콘텐츠가 준비되는 동안 진행 상태와 대기 맥락을 이해할 수 있게 만드는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "대기 상태와 진행 흐름",
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
      id: "pattern_managing_accounts",
      name: "Managing accounts",
      koreanTitle: "계정 관리",
      cardSummary: "계정 전환과 상태",
      summary: "로그인 상태, 계정 전환, 프로필 관리 흐름을 다루는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "계정 전환 흐름",
      tags: ["accounts", "profile", "signin"],
      icon: "person.crop.circle",
      tintHex: "#8E8E93",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/managing-accounts",
      higPathTitle: "Patterns • Managing accounts",
      platformNotes: "현재 계정 상태와 전환 흐름은 언제나 분명해야 합니다.",
      swiftUIReference: "account menu + profile rows + auth state transitions",
      previewKind: .list,
      keyPoints: [
        "현재 계정과 전환 대상을 쉽게 구분하게 합니다.",
        "로그인, 로그아웃, 관리 동작을 예측 가능하게 둡니다.",
        "개인 정보와 권한 상태를 이해하기 쉽게 보여줍니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_managing_notifications",
      name: "Managing notifications",
      koreanTitle: "알림 관리",
      cardSummary: "시의적절한 전달",
      summary: "사용자에게 시의적절한 정보를 전달하고 다시 앱으로 연결하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "알림에서 앱 복귀",
      tags: ["notification", "alerts", "updates"],
      icon: "bell.badge",
      tintHex: "#FF375F",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/managing-notifications",
      higPathTitle: "Patterns • Managing notifications",
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
      id: "pattern_modality",
      name: "Modality",
      koreanTitle: "모달리티",
      cardSummary: "집중 작업 분리",
      summary: "현재 작업 흐름을 잠시 분리해 집중이 필요한 내용을 다루는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "시트 전환 흐름",
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
      id: "pattern_multitasking",
      name: "Multitasking",
      koreanTitle: "멀티태스킹",
      cardSummary: "작업 전환과 병렬성",
      summary: "여러 작업 흐름이나 화면 맥락을 함께 다루는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "병렬 작업 전환",
      tags: ["multitasking", "windows", "flow"],
      icon: "square.split.2x1",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/multitasking",
      higPathTitle: "Patterns • Multitasking",
      platformNotes: "멀티태스킹은 현재 작업 문맥을 잃지 않게 설계해야 합니다.",
      swiftUIReference: "scene management + split layouts + state restoration",
      previewKind: .collection,
      keyPoints: [
        "작업 전환 시 현재 문맥을 보존합니다.",
        "열린 작업 상태를 쉽게 다시 찾게 합니다.",
        "동시에 보이는 정보량을 과도하게 늘리지 않습니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_offering_help",
      name: "Offering help",
      koreanTitle: "도움 제공",
      cardSummary: "맥락형 도움말",
      summary: "현재 화면과 작업에 맞는 도움말을 방해 없이 제공하는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "맥락 도움말",
      tags: ["help", "support", "guidance"],
      icon: "questionmark.circle",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/offering-help",
      higPathTitle: "Patterns • Offering help",
      platformNotes: "도움말은 현재 작업을 가로막지 않으면서도 바로 쓸 수 있어야 합니다.",
      swiftUIReference: "inline help + contextual tooltips + support destinations",
      previewKind: .modal,
      keyPoints: [
        "현재 작업과 관련된 도움만 보여줍니다.",
        "자주 쓰는 해결책은 가장 가까운 곳에 둡니다.",
        "도움말이 본 흐름을 방해하지 않게 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_onboarding",
      name: "Onboarding",
      koreanTitle: "온보딩",
      cardSummary: "초기 학습 흐름",
      summary: "초기 학습과 권한, 핵심 가치 제안을 단계적으로 소개하는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "첫 실행 안내 흐름",
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
      id: "pattern_playing_audio",
      name: "Playing audio",
      koreanTitle: "오디오 재생",
      cardSummary: "미디어 재생 제어",
      summary: "오디오 재생 상태와 제어를 일관된 흐름으로 보여주는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "오디오 재생 상태",
      tags: ["audio", "media", "playback"],
      icon: "speaker.wave.2",
      tintHex: "#FF9F0A",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/playing-audio",
      higPathTitle: "Patterns • Playing audio",
      platformNotes: "오디오 재생은 현재 상태, 제어, 백그라운드 연속성을 함께 고려해야 합니다.",
      swiftUIReference: "Now Playing controls + playback state + progress scrubber",
      previewKind: .progress,
      keyPoints: [
        "현재 재생 상태를 즉시 읽을 수 있게 합니다.",
        "주요 제어는 손이 잘 닿는 곳에 둡니다.",
        "백그라운드 전환 후에도 흐름이 이어져야 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_playing_haptics",
      name: "Playing haptics",
      koreanTitle: "햅틱 재생",
      cardSummary: "촉각 피드백 전달",
      summary: "작업 결과와 상태 변화를 촉각으로 보조하는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "촉각 피드백",
      tags: ["haptics", "feedback", "touch"],
      icon: "wave.3.forward.circle",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/playing-haptics",
      higPathTitle: "Patterns • Playing haptics",
      platformNotes: "햅틱은 시각 신호를 보조하는 정도로 사용해야 하며 과하면 피로를 줍니다.",
      swiftUIReference: "sensoryFeedback + state transitions + role-based cues",
      previewKind: .toggle,
      keyPoints: [
        "행동과 결과에 맞는 촉각만 사용합니다.",
        "반복적이거나 과한 햅틱을 피합니다.",
        "시각 피드백과 함께 설계합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_playing_video",
      name: "Playing video",
      koreanTitle: "비디오 재생",
      cardSummary: "영상 재생 경험",
      summary: "영상 재생 상태와 주요 컨트롤을 자연스럽게 제공하는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "영상 재생 화면",
      tags: ["video", "media", "playback"],
      icon: "play.rectangle",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/playing-video",
      higPathTitle: "Patterns • Playing video",
      platformNotes: "재생 컨트롤은 필요할 때만 드러나고, 몰입을 방해하지 않아야 합니다.",
      swiftUIReference: "AVPlayer view + overlay controls + full-screen transitions",
      previewKind: .image,
      keyPoints: [
        "콘텐츠 몰입과 제어 접근성의 균형을 잡습니다.",
        "현재 재생 상태를 쉽게 파악하게 합니다.",
        "전체 화면 전환과 복귀가 자연스러워야 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_printing",
      name: "Printing",
      koreanTitle: "프린팅",
      cardSummary: "출력 준비와 전송",
      summary: "출력 대상과 옵션을 정하고 인쇄 작업을 시작하는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "출력 설정 흐름",
      tags: ["print", "share", "document"],
      icon: "printer",
      tintHex: "#8E8E93",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/printing",
      higPathTitle: "Patterns • Printing",
      platformNotes: "출력 대상과 옵션은 실제 결과를 예측할 수 있게 정리해야 합니다.",
      swiftUIReference: "share sheet print action + printer destination + job options",
      previewKind: .list,
      keyPoints: [
        "현재 문서와 출력 결과의 관계를 분명히 보여줍니다.",
        "필수 옵션만 먼저 노출합니다.",
        "프린터 선택과 상태를 쉽게 이해하게 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_ratings_and_reviews",
      name: "Ratings and reviews",
      koreanTitle: "평점 및 리뷰",
      cardSummary: "피드백 요청과 표시",
      summary: "평점과 리뷰를 요청하거나 읽는 흐름을 다루는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "리뷰 요청과 읽기",
      tags: ["ratings", "reviews", "feedback"],
      icon: "star.bubble",
      tintHex: "#FFCC00",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/ratings-and-reviews",
      higPathTitle: "Patterns • Ratings and reviews",
      platformNotes: "평점 요청은 적절한 시점에만 보여주고 흐름을 방해하지 않아야 합니다.",
      swiftUIReference: "review prompt timing + feedback history + contextual request triggers",
      previewKind: .modal,
      keyPoints: [
        "가치가 느껴진 시점에만 평점을 요청합니다.",
        "리뷰 읽기와 작성 흐름을 명확히 구분합니다.",
        "사용자 흐름을 방해하지 않도록 합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_searching",
      name: "Searching",
      koreanTitle: "검색",
      cardSummary: "입력과 결과 흐름",
      summary: "검색 필드, 최근 검색, 결과 목록이 하나의 흐름으로 이어지는 패턴입니다.",
      libraryKind: .patterns,
      sectionTitle: "패턴",
      usageContext: "검색 결과 흐름",
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
      id: "pattern_settings",
      name: "Settings",
      koreanTitle: "설정",
      cardSummary: "환경과 선호 조정",
      summary: "사용자 선호와 환경 설정을 예측 가능한 구조로 보여주는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "환경 설정 구조",
      tags: ["settings", "preferences", "configuration"],
      icon: "gearshape",
      tintHex: "#8E8E93",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/settings",
      higPathTitle: "Patterns • Settings",
      platformNotes: "설정은 현재 작업 흐름과 분리하고 즉시 반영 여부를 분명히 보여줘야 합니다.",
      swiftUIReference: "Form + sectioned settings rows + stored preferences",
      previewKind: .toggle,
      keyPoints: [
        "작업 흐름과 환경 설정을 섞지 않습니다.",
        "즉시 반영과 확인이 필요한 설정을 구분합니다.",
        "설정 구조를 예측 가능하게 유지합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_undo_and_redo",
      name: "Undo and redo",
      koreanTitle: "실행 취소 및 다시 실행",
      cardSummary: "실수 복구 흐름",
      summary: "최근 작업을 되돌리거나 다시 적용하는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "실수 복구",
      tags: ["undo", "redo", "editing"],
      icon: "arrow.uturn.backward.circle",
      tintHex: "#64D2FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/undo-and-redo",
      higPathTitle: "Patterns • Undo and redo",
      platformNotes: "되돌릴 수 있는 범위와 결과는 사용자가 예측할 수 있어야 합니다.",
      swiftUIReference: "undoManager + command feedback + reversible actions",
      previewKind: .button,
      keyPoints: [
        "되돌릴 수 있는 동작을 명확히 합니다.",
        "최근 작업 맥락을 유지한 채 복구하게 합니다.",
        "확인 없이도 안전하게 되돌릴 수 있게 설계합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "pattern_workouts",
      name: "Workouts",
      koreanTitle: "운동",
      cardSummary: "운동 진행 상태",
      summary: "운동 세션의 진행 상태와 목표 달성을 보여주는 패턴입니다.",
      libraryKind: .patterns,
      status: .planned,
      sectionTitle: "패턴",
      usageContext: "운동 세션 추적",
      tags: ["workout", "health", "session"],
      icon: "figure.run",
      tintHex: "#FF375F",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/workouts",
      higPathTitle: "Patterns • Workouts",
      platformNotes: "운동 흐름은 현재 상태와 핵심 지표를 즉시 읽게 해야 합니다.",
      swiftUIReference: "live workout metrics + session states + goal progress",
      previewKind: .progress,
      keyPoints: [
        "현재 세션 상태와 주요 수치를 빠르게 보여줍니다.",
        "운동 중 조작은 최소화합니다.",
        "완료 후 요약과 회고 흐름을 자연스럽게 제공합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_menus",
      name: "Menus",
      koreanTitle: "메뉴",
      cardSummary: "맥락 작업 노출",
      summary: "보조 명령을 현재 화면 맥락 안에서 간결하게 노출하는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .menusAndActions,
      usageContext: "맥락 메뉴 호출",
      tags: ["menu", "actions", "context"],
      icon: "ellipsis.circle",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/menus",
      higPathTitle: "Components • Menus",
      platformNotes: "메뉴는 현재 선택과 연관된 작업을 짧고 명확하게 노출해야 합니다.",
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
      id: "component_buttons",
      name: "Buttons",
      koreanTitle: "버튼",
      cardSummary: "명확한 액션 실행",
      summary: "명확한 액션을 표현하는 기본 조작 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .menusAndActions,
      usageContext: "주요 액션 버튼",
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
      cardSummary: "카드 기반 브라우징",
      summary: "카드나 썸네일 기반의 반복 콘텐츠를 브라우징하는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .content,
      usageContext: "카드 목록 브라우징",
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
      cardSummary: "현재 색 표시",
      summary: "현재 색을 보여주고 색상 변경을 시작하는 작은 조작 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .selectionAndInput,
      usageContext: "현재 색상 선택",
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
      cardSummary: "기호 기반 의미 전달",
      summary: "작은 시각 기호로 의미를 전달하는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .content,
      usageContext: "기호 기반 레이블",
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
      cardSummary: "시각 콘텐츠 표시",
      summary: "썸네일, 히어로, 미디어 프리뷰 등 시각 콘텐츠를 보여주는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .content,
      usageContext: "썸네일과 미디어 표시",
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
      cardSummary: "아이콘과 텍스트 조합",
      summary: "아이콘과 텍스트를 묶어 의미를 전달하는 조합형 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .content,
      usageContext: "아이콘+텍스트 조합",
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
      cardSummary: "행 기반 정보 구조",
      summary: "행 기반 데이터와 설정 화면을 구성하는 핵심 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .layoutAndOrganization,
      usageContext: "행 기반 정보 목록",
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
      id: "component_toolbars",
      name: "Toolbars",
      koreanTitle: "툴바",
      cardSummary: "화면 주요 명령 배치",
      summary: "현재 화면의 주요 명령을 접근하기 쉽게 배치하는 구성요소입니다.",
      libraryKind: .components,
      status: .planned,
      sectionTitle: "구성요소",
      componentGroup: .navigationAndSearch,
      usageContext: "상단·하단 명령 바",
      tags: ["toolbar", "actions", "navigation"],
      icon: "rectangle.topthird.inset.filled",
      tintHex: "#0A84FF",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/toolbars",
      higPathTitle: "Components • Toolbars",
      platformNotes: "툴바는 현재 화면에서 가장 자주 쓰는 명령만 간결하게 제공해야 합니다.",
      swiftUIReference: "toolbar(content:) + ToolbarItem placements",
      previewKind: .button,
      keyPoints: [
        "현재 맥락에서 중요한 명령만 노출합니다.",
        "화면 제목과 충돌하지 않게 계층을 정리합니다.",
        "상단과 하단 툴바 역할을 섞지 않습니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_page_controls",
      name: "Page controls",
      koreanTitle: "페이지 컨트롤",
      cardSummary: "현재 페이지 위치",
      summary: "여러 페이지 중 현재 위치를 점 형태로 알려주는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .navigationAndSearch,
      usageContext: "페이지 넘김 탐색",
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
      id: "component_alerts",
      name: "Alerts",
      koreanTitle: "알림 창",
      cardSummary: "즉시 확인이 필요한 안내",
      summary: "즉시 확인이나 결정을 요구하는 짧은 메시지를 보여주는 구성요소입니다.",
      libraryKind: .components,
      status: .planned,
      sectionTitle: "구성요소",
      componentGroup: .presentation,
      usageContext: "짧은 확인과 경고",
      tags: ["alert", "confirmation", "warning"],
      icon: "exclamationmark.bubble",
      tintHex: "#FF9F0A",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/alerts",
      higPathTitle: "Components • Alerts",
      platformNotes: "알림 창은 중요한 확인에만 사용하고, 내용과 버튼 역할을 분명하게 해야 합니다.",
      swiftUIReference: "alert(_:isPresented:actions:message:)",
      previewKind: .modal,
      keyPoints: [
        "정말 즉시 판단이 필요한 경우에만 사용합니다.",
        "버튼 역할과 결과를 분명하게 적습니다.",
        "과도한 반복 표시를 피합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_sheets",
      name: "Sheets",
      koreanTitle: "시트",
      cardSummary: "맥락 유지형 전환",
      summary: "현재 화면 맥락을 유지하면서 별도의 작업 흐름을 보여주는 구성요소입니다.",
      libraryKind: .components,
      status: .planned,
      sectionTitle: "구성요소",
      componentGroup: .presentation,
      usageContext: "바텀 시트와 모달 시트",
      tags: ["sheet", "presentation", "modal"],
      icon: "rectangle.bottomhalf.inset.filled",
      tintHex: "#30B0C7",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/sheets",
      higPathTitle: "Components • Sheets",
      platformNotes: "시트는 현재 맥락을 보존하면서도 독립된 작업 흐름을 제공해야 합니다.",
      swiftUIReference: "sheet(isPresented:) + presentationDetents",
      previewKind: .modal,
      keyPoints: [
        "원래 화면 맥락을 잃지 않게 합니다.",
        "닫기와 완료 경로를 쉽게 찾게 합니다.",
        "필요 이상으로 깊은 중첩을 만들지 않습니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_pickers",
      name: "Pickers",
      koreanTitle: "피커",
      cardSummary: "단일 선택 입력",
      summary: "여러 선택지 중 하나를 고르는 입력 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .selectionAndInput,
      usageContext: "단일 옵션 선택",
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
      id: "component_windows",
      name: "Windows",
      koreanTitle: "윈도우",
      cardSummary: "다중 장면 관리",
      summary: "여러 장면이나 윈도우를 동시에 다루는 시스템 경험 구성요소입니다.",
      libraryKind: .components,
      status: .planned,
      sectionTitle: "구성요소",
      componentGroup: .systemExperiences,
      usageContext: "다중 윈도우 장면",
      tags: ["window", "scene", "multitasking"],
      icon: "macwindow.on.rectangle",
      tintHex: "#5E5CE6",
      higUrl: "https://developer.apple.com/design/human-interface-guidelines/windows",
      higPathTitle: "Components • Windows",
      platformNotes: "윈도우와 장면은 현재 문맥을 잃지 않게 관리할 수 있어야 합니다.",
      swiftUIReference: "WindowGroup + scene phase + state restoration",
      previewKind: .collection,
      keyPoints: [
        "열린 장면의 상태를 다시 찾기 쉽게 합니다.",
        "각 장면의 역할을 분명히 구분합니다.",
        "멀티태스킹 흐름과 자연스럽게 연결합니다."
      ],
      isSystemDemo: false
    ),
    AppleDesignTopic(
      id: "component_progress_indicators",
      name: "Progress indicators",
      koreanTitle: "진행 표시기",
      cardSummary: "작업 진행 상태",
      summary: "진행 중인 작업 상태와 완료까지의 흐름을 보여주는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .status,
      usageContext: "진행 상태 표시",
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
      cardSummary: "소수 옵션 전환",
      summary: "서로 배타적인 소수의 선택지를 빠르게 전환하는 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .selectionAndInput,
      usageContext: "소수 옵션 전환",
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
      cardSummary: "짧은 텍스트 입력",
      summary: "짧은 텍스트를 입력하거나 편집하는 가장 기본적인 입력 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .selectionAndInput,
      usageContext: "짧은 텍스트 입력",
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
      cardSummary: "즉시 상태 전환",
      summary: "켜짐/꺼짐 상태를 즉시 전환하는 이진 선택 구성요소입니다.",
      libraryKind: .components,
      sectionTitle: "구성요소",
      componentGroup: .selectionAndInput,
      usageContext: "설정 상태 전환",
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
