import ExpoModulesCore
import SwiftUI

/// Apple HIG Badge 컴포넌트 (뱃지/카운터)
/// https://developer.apple.com/design/human-interface-guidelines/badges
struct HIGBadgeContent: View {
  let value: String
  let variant: BadgeVariant
  let size: BadgeSize
  let accentColor: Color
  
  enum BadgeVariant: String {
    case filled = "filled"
    case outlined = "outlined"
    
    var foregroundColor: Color {
      switch self {
      case .filled: return .white
      case .outlined: return accentColor
      }
    }
  }
  
  enum BadgeSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
    
    var minHeight: CGFloat {
      switch self {
      case .small: return 18
      case .medium: return 22
      case .large: return 26
      }
    }
    
    var fontSize: CGFloat {
      switch self {
      case .small: return 11
      case .medium: return 13
      case .large: return 15
      }
    }
    
    var horizontalPadding: CGFloat {
      switch self {
      case .small: return 6
      case .medium: return 8
      case .large: return 10
      }
    }
    
    var cornerRadius: CGFloat {
      switch self {
      case .small: return 9
      case .medium: return 11
      case .large: return 13
      }
    }
  }
  
  var body: some View {
    Text(value)
      .font(.system(size: size.fontSize, weight: .semibold))
      .foregroundColor(currentForegroundColor)
      .padding(.horizontal, size.horizontalPadding)
      .frame(minHeight: size.minHeight)
      .background(backgroundView)
  }
  
  private var currentForegroundColor: Color {
    switch variant {
    case .filled: return .white
    case .outlined: return accentColor
    }
  }
  
  @ViewBuilder
  private var backgroundView: some View {
    switch variant {
    case .filled:
      Capsule(style: .continuous)
        .fill(accentColor)
    case .outlined:
      Capsule(style: .continuous)
        .stroke(accentColor, lineWidth: 1.5)
        .background(
          Capsule(style: .continuous)
            .fill(Color.clear)
        )
    }
  }
}

// MARK: - Expo Module View

final class HIGBadgeView: ExpoView {
  var value: String = "1" {
    didSet { render() }
  }
  
  var variant: String = "filled" {
    didSet { render() }
  }
  
  var size: String = "medium" {
    didSet { render() }
  }
  
  var accentColorHex: String = "#FF3B30" {
    didSet { render() }
  }
  
  private lazy var hostingController = UIHostingController(rootView: makeRootView())
  
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    setupHostedView()
  }
  
  private func setupHostedView() {
    backgroundColor = .clear
    clipsToBounds = false
    
    guard let hostedView = hostingController.view else { return }
    
    hostedView.backgroundColor = .clear
    hostedView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(hostedView)
    
    NSLayoutConstraint.activate([
      hostedView.topAnchor.constraint(equalTo: topAnchor),
      hostedView.leadingAnchor.constraint(equalTo: leadingAnchor),
      hostedView.trailingAnchor.constraint(equalTo: trailingAnchor),
      hostedView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func render() {
    hostingController.rootView = makeRootView()
  }
  
  private func makeRootView() -> HIGBadgeContent {
    let variant = HIGBadgeContent.BadgeVariant(rawValue: self.variant) ?? .filled
    let size = HIGBadgeContent.BadgeSize(rawValue: self.size) ?? .medium
    let accentColor = UIColor.fromHex(accentColorHex).map { Color($0) } ?? HIGDesignTokens.systemRed
    
    return HIGBadgeContent(
      value: value,
      variant: variant,
      size: size,
      accentColor: accentColor
    )
  }
}

private extension UIColor {
  static func fromHex(_ value: String) -> UIColor? {
    let hex = value.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    guard hex.count == 6 || hex.count == 8 else { return nil }
    
    var parsed: UInt64 = 0
    guard Scanner(string: hex).scanHexInt64(&parsed) else { return nil }
    
    if hex.count == 6 {
      let red = CGFloat((parsed & 0xFF0000) >> 16) / 255
      let green = CGFloat((parsed & 0x00FF00) >> 8) / 255
      let blue = CGFloat(parsed & 0x0000FF) / 255
      return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    let alpha = CGFloat((parsed & 0xFF000000) >> 24) / 255
    let red = CGFloat((parsed & 0x00FF0000) >> 16) / 255
    let green = CGFloat((parsed & 0x0000FF00) >> 8) / 255
    let blue = CGFloat(parsed & 0x000000FF) / 255
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
}
