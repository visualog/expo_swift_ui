import ExpoModulesCore
import SwiftUI

/// Apple HIG TextField 컴포넌트
/// https://developer.apple.com/design/human-interface-guidelines/text-fields
struct HIGTextFieldContent: View {
  let placeholder: String
  let value: String
  let variant: TextFieldVariant
  let isSecure: Bool
  let isError: Bool
  let errorMessage: String
  let accentColor: Color
  
  @State private var text = ""
  
  enum TextFieldVariant: String {
    case rounded = "rounded"
    case underline = "underline"
    case filled = "filled"
    
    var backgroundColor: Color {
      switch self {
      case .rounded, .underline: return .clear
      case .filled: return HIGDesignTokens.secondaryFill
      }
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Group {
        if isSecure {
          SecureField(placeholder, text: $text)
            .font(.system(size: 17, weight: .regular))
        } else {
          TextField(placeholder, text: $text)
            .font(.system(size: 17, weight: .regular))
        }
      }
      .foregroundColor(isError ? HIGDesignTokens.systemRed : HIGDesignTokens.primary)
      .padding(.horizontal, horizontalPadding)
      .frame(height: 44)
      .background(backgroundView)
      .overlay(overlayView)
      .cornerRadius(cornerRadius)
      
      if isError && !errorMessage.isEmpty {
        Text(errorMessage)
          .font(.system(size: 12, weight: .regular))
          .foregroundColor(HIGDesignTokens.systemRed)
          .padding(.leading, horizontalPadding)
      }
    }
  }
  
  private var horizontalPadding: CGFloat {
    switch variant {
    case .rounded: return 16
    case .filled: return 16
    case .underline: return 0
    }
  }
  
  private var cornerRadius: CGFloat {
    switch variant {
    case .rounded: return 10
    case .filled: return 10
    case .underline: return 0
    }
  }
  
  @ViewBuilder
  private var backgroundView: some View {
    switch variant {
    case .rounded:
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .stroke(isError ? HIGDesignTokens.systemRed : accentColor.opacity(0.3), lineWidth: 1)
        .background(
          RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(variant.backgroundColor)
        )
    case .filled:
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(variant.backgroundColor)
        .overlay(
          RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(isError ? HIGDesignTokens.systemRed : accentColor.opacity(0.3), lineWidth: 1)
        )
    case .underline:
      Rectangle()
        .fill(Color.clear)
        .overlay(
          Rectangle()
            .frame(height: 1)
            .foregroundColor(isError ? HIGDesignTokens.systemRed : accentColor)
        )
    }
  }
  
  @ViewBuilder
  private var overlayView: some View {
    // Focus state indicator could be added here
  }
}

// MARK: - Expo Module View

final class HIGTextFieldView: ExpoView {
  let onChangeText = EventDispatcher()
  let onSubmitEditing = EventDispatcher()
  
  var placeholder: String = "Enter text" {
    didSet { render() }
  }
  
  var value: String = "" {
    didSet { render() }
  }
  
  var variant: String = "rounded" {
    didSet { render() }
  }
  
  var isSecure: Bool = false {
    didSet { render() }
  }
  
  var isError: Bool = false {
    didSet { render() }
  }
  
  var errorMessage: String = "" {
    didSet { render() }
  }
  
  var accentColorHex: String = "#007AFF" {
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
  
  private func makeRootView() -> HIGTextFieldContent {
    let variant = HIGTextFieldContent.TextFieldVariant(rawValue: self.variant) ?? .rounded
    let accentColor = UIColor.fromHex(accentColorHex).map { Color($0) } ?? HIGDesignTokens.systemBlue
    
    return HIGTextFieldContent(
      placeholder: placeholder,
      value: value,
      variant: variant,
      isSecure: isSecure,
      isError: isError,
      errorMessage: errorMessage,
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
