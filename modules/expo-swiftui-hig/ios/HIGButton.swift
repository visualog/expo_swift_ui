import ExpoModulesCore
import SwiftUI

/// Apple HIG Button 컴포넌트
/// https://developer.apple.com/design/human-interface-guidelines/buttons
struct HIGButtonContent: View {
  let title: String
  let variant: ButtonVariant
  let size: ButtonSize
  let isLoading: Bool
  let isDisabled: Bool
  let accentColor: Color
  
  enum ButtonVariant: String {
    case filled = "filled"
    case outlined = "outlined"
    case plain = "plain"
    case linked = "linked"
    
    var foregroundColor: Color {
      switch self {
      case .filled, .linked: return .white
      case .outlined: return HIGDesignTokens.systemBlue
      case .plain: return HIGDesignTokens.primary
      }
    }
  }
  
  enum ButtonSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
    
    var height: CGFloat {
      switch self {
      case .small: return 32
      case .medium: return 40
      case .large: return 48
      }
    }
    
    var fontSize: CGFloat {
      switch self {
      case .small: return 14
      case .medium: return 16
      case .large: return 18
      }
    }
    
    var cornerRadius: CGFloat {
      switch self {
      case .small: return 6
      case .medium: return 8
      case .large: return 10
      }
    }
    
    var horizontalPadding: CGFloat {
      switch self {
      case .small: return 12
      case .medium: return 16
      case .large: return 20
      }
    }
  }
  
  var body: some View {
    Button(action: {}) {
      Group {
        if isLoading {
          HIGLoadingIndicator(size: .small, color: currentForegroundColor)
        } else {
          Text(title)
            .font(.system(size: size.fontSize, weight: .semibold))
        }
      }
      .foregroundColor(currentForegroundColor)
      .frame(height: size.height)
      .padding(.horizontal, size.horizontalPadding)
      .background(backgroundView)
      .opacity(isDisabled ? 0.5 : 1.0)
      .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
    .disabled(isDisabled || isLoading)
  }
  
  private var currentForegroundColor: Color {
    if isDisabled {
      return .secondary
    }
    switch variant {
    case .filled: return .white
    case .outlined: return accentColor
    case .plain: return accentColor
    case .linked: return accentColor
    }
  }
  
  @ViewBuilder
  private var backgroundView: some View {
    switch variant {
    case .filled:
      RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
        .fill(accentColor)
    case .outlined:
      RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
        .stroke(accentColor, lineWidth: 1.5)
        .background(
          RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
            .fill(Color.clear)
        )
    case .plain:
      RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
        .fill(accentColor.opacity(0.12))
    case .linked:
      Color.clear
    }
  }
}

/// 로딩 인디케이터
struct HIGLoadingIndicator: View {
  let size: LoadingSize
  let color: Color
  
  enum LoadingSize {
    case small
    case medium
    case large
    
    var dimension: CGFloat {
      switch self {
      case .small: return 16
      case .medium: return 20
      case .large: return 24
      }
    }
    
    var lineWidth: CGFloat {
      switch self {
      case .small: return 2
      case .medium: return 2.5
      case .large: return 3
      }
    }
  }
  
  @State private var isAnimating = false
  
  var body: some View {
    Circle()
      .trim(from: 0, to: 0.7)
      .stroke(color, style: StrokeStyle(lineWidth: size.lineWidth, lineCap: .round))
      .frame(width: size.dimension, height: size.dimension)
      .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
      .onAppear {
        withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
          isAnimating = true
        }
      }
  }
}

// MARK: - Expo Module View

final class HIGButtonView: ExpoView {
  let onPress = EventDispatcher()
  
  var title: String = "Button" {
    didSet { render() }
  }
  
  var variant: String = "filled" {
    didSet { render() }
  }
  
  var size: String = "medium" {
    didSet { render() }
  }
  
  var accentColorHex: String = "#007AFF" {
    didSet { render() }
  }
  
  var isLoading: Bool = false {
    didSet { render() }
  }
  
  var isDisabled: Bool = false {
    didSet { render() }
  }
  
  private lazy var hostingController = UIHostingController(rootView: makeRootView())
  
  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    setupHostedView()
    setupTapRecognizer()
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
  
  private func setupTapRecognizer() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    addGestureRecognizer(tapRecognizer)
    isUserInteractionEnabled = true
  }
  
  @objc private func handleTap() {
    if !isLoading && !isDisabled {
      onPress(["title": title])
    }
  }
  
  private func render() {
    hostingController.rootView = makeRootView()
  }
  
  private func makeRootView() -> HIGButtonContent {
    let variant = HIGButtonContent.ButtonVariant(rawValue: self.variant) ?? .filled
    let size = HIGButtonContent.ButtonSize(rawValue: self.size) ?? .medium
    let accentColor = UIColor.fromHex(accentColorHex).map { Color($0) } ?? HIGDesignTokens.systemBlue
    
    return HIGButtonContent(
      title: title,
      variant: variant,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
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
