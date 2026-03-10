import Foundation

enum MotionCategory: String, CaseIterable, Identifiable, Codable {
  case entrance
  case emphasis
  case exit
  case gesture

  var id: String { rawValue }

  var title: String {
    switch self {
    case .entrance: return "Entrance"
    case .emphasis: return "Emphasis"
    case .exit: return "Exit"
    case .gesture: return "Gesture"
    }
  }
}

enum MotionEasing: String, CaseIterable, Identifiable, Codable {
  case smooth
  case spring
  case easeInOut
  case bouncy

  var id: String { rawValue }

  var title: String {
    switch self {
    case .smooth: return "Smooth"
    case .spring: return "Spring"
    case .easeInOut: return "Ease In/Out"
    case .bouncy: return "Bouncy"
    }
  }
}

enum MotionIntensity: String, CaseIterable, Identifiable, Codable {
  case soft
  case normal
  case expressive

  var id: String { rawValue }

  var title: String {
    switch self {
    case .soft: return "Soft"
    case .normal: return "Normal"
    case .expressive: return "Expressive"
    }
  }

  var dampingScale: Double {
    switch self {
    case .soft: return 0.5
    case .normal: return 1.0
    case .expressive: return 1.35
    }
  }
}

struct MotionPreset: Identifiable, Hashable, Codable {
  let id: String
  let name: String
  let summary: String
  let category: MotionCategory
  let tags: [String]
  let icon: String
  let tintHex: String
  let duration: Double
  let delay: Double
  let easing: MotionEasing
  let intensity: MotionIntensity
}

extension MotionPreset {
  static let sampleData: [MotionPreset] = [
    MotionPreset(id: "entrance_fade_up", name: "Fade Up", summary: "아래에서 부드럽게 등장", category: .entrance, tags: ["intro", "card"], icon: "arrow.up", tintHex: "#0A84FF", duration: 0.42, delay: 0.00, easing: .smooth, intensity: .normal),
    MotionPreset(id: "entrance_fade_down", name: "Fade Down", summary: "위에서 자연스럽게 등장", category: .entrance, tags: ["intro", "list"], icon: "arrow.down", tintHex: "#30B0C7", duration: 0.45, delay: 0.02, easing: .easeInOut, intensity: .soft),
    MotionPreset(id: "entrance_slide_lead", name: "Slide Lead", summary: "리스트 첫 요소 강조 등장", category: .entrance, tags: ["list", "lead"], icon: "list.bullet", tintHex: "#32D74B", duration: 0.38, delay: 0.00, easing: .spring, intensity: .normal),
    MotionPreset(id: "entrance_zoom_in", name: "Zoom In", summary: "축소 상태에서 확대", category: .entrance, tags: ["hero", "focus"], icon: "plus.magnifyingglass", tintHex: "#64D2FF", duration: 0.35, delay: 0.00, easing: .spring, intensity: .expressive),
    MotionPreset(id: "entrance_pop", name: "Pop", summary: "짧은 탄성 팝 효과", category: .entrance, tags: ["cta", "button"], icon: "sparkles", tintHex: "#5E5CE6", duration: 0.30, delay: 0.00, easing: .bouncy, intensity: .expressive),

    MotionPreset(id: "emphasis_pulse", name: "Pulse", summary: "미세 확대/축소 반복", category: .emphasis, tags: ["attention", "cta"], icon: "waveform.path", tintHex: "#FF9F0A", duration: 0.55, delay: 0.00, easing: .smooth, intensity: .normal),
    MotionPreset(id: "emphasis_shimmer", name: "Shimmer", summary: "광택이 스쳐가는 하이라이트", category: .emphasis, tags: ["loading", "skeleton"], icon: "sun.max", tintHex: "#FFD60A", duration: 0.70, delay: 0.02, easing: .easeInOut, intensity: .soft),
    MotionPreset(id: "emphasis_bounce", name: "Bounce", summary: "강조용 탄성 바운스", category: .emphasis, tags: ["icon", "reaction"], icon: "arrow.up.and.down", tintHex: "#FF375F", duration: 0.42, delay: 0.00, easing: .bouncy, intensity: .expressive),
    MotionPreset(id: "emphasis_wiggle", name: "Wiggle", summary: "짧은 흔들림으로 피드백", category: .emphasis, tags: ["warning", "input"], icon: "scribble.variable", tintHex: "#BF5AF2", duration: 0.36, delay: 0.00, easing: .easeInOut, intensity: .normal),
    MotionPreset(id: "emphasis_glow", name: "Glow", summary: "은은한 밝기 강조", category: .emphasis, tags: ["highlight", "premium"], icon: "lightbulb", tintHex: "#30D158", duration: 0.62, delay: 0.01, easing: .smooth, intensity: .soft),

    MotionPreset(id: "exit_fade_out", name: "Fade Out", summary: "불투명도 감소로 종료", category: .exit, tags: ["dismiss", "card"], icon: "eye.slash", tintHex: "#8E8E93", duration: 0.28, delay: 0.00, easing: .smooth, intensity: .soft),
    MotionPreset(id: "exit_slide_down", name: "Slide Down", summary: "아래로 이탈", category: .exit, tags: ["sheet", "panel"], icon: "arrow.down.square", tintHex: "#0A84FF", duration: 0.32, delay: 0.00, easing: .easeInOut, intensity: .normal),
    MotionPreset(id: "exit_shrink", name: "Shrink", summary: "축소되며 사라짐", category: .exit, tags: ["popover", "hint"], icon: "minus.magnifyingglass", tintHex: "#AC8E68", duration: 0.30, delay: 0.00, easing: .spring, intensity: .soft),
    MotionPreset(id: "exit_snap", name: "Snap", summary: "빠른 스냅 종료", category: .exit, tags: ["toast", "ephemeral"], icon: "bolt", tintHex: "#FF9F0A", duration: 0.22, delay: 0.00, easing: .bouncy, intensity: .expressive),
    MotionPreset(id: "exit_blur", name: "Blur Away", summary: "블러 증가와 함께 사라짐", category: .exit, tags: ["transition", "content"], icon: "camera.filters", tintHex: "#30B0C7", duration: 0.35, delay: 0.01, easing: .easeInOut, intensity: .normal),

    MotionPreset(id: "gesture_peek", name: "Peek", summary: "당겨서 미리보기", category: .gesture, tags: ["drag", "preview"], icon: "hand.draw", tintHex: "#64D2FF", duration: 0.25, delay: 0.00, easing: .spring, intensity: .normal),
    MotionPreset(id: "gesture_swipe_commit", name: "Swipe Commit", summary: "스와이프 완료 시 확정", category: .gesture, tags: ["swipe", "action"], icon: "hand.point.right", tintHex: "#32D74B", duration: 0.27, delay: 0.00, easing: .smooth, intensity: .normal),
    MotionPreset(id: "gesture_pull_refresh", name: "Pull Refresh", summary: "당김 후 리프레시 피드백", category: .gesture, tags: ["refresh", "feed"], icon: "arrow.clockwise", tintHex: "#0A84FF", duration: 0.40, delay: 0.00, easing: .spring, intensity: .soft),
    MotionPreset(id: "gesture_long_press_lift", name: "Long Press Lift", summary: "길게 누르면 떠오르는 느낌", category: .gesture, tags: ["context", "menu"], icon: "hand.tap", tintHex: "#BF5AF2", duration: 0.24, delay: 0.00, easing: .spring, intensity: .normal),
    MotionPreset(id: "gesture_reorder_flow", name: "Reorder Flow", summary: "재정렬 중 유체감 이동", category: .gesture, tags: ["drag", "list"], icon: "line.3.horizontal", tintHex: "#FF375F", duration: 0.33, delay: 0.00, easing: .easeInOut, intensity: .expressive)
  ]
}
