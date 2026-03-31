import ExpoModulesCore
import SwiftUI

/// Apple HIG Toggle/Switch 컴포넌트
/// https://developer.apple.com/design/human-interface-guidelines/toggles
struct HIGToggleContent: View {
  let label: String?
  let isOn: Bool
  let accentColor: Color
  let isDisabled: Bool
  
  @State private var toggleState = false
  
  var body: some View {
    HStack(spacing: HIGDesignTokens.Spacing.small.value) {
      if let label = label {
        Text(label)
          .font(.system(size: 17, weight: .regular))
          .foregroundColor(isDisabled ? HIGDesignTokens.secondary : HIGDesignTokens.primary)
      }
      
      Spacer()
      
      Toggle("", isOn: $toggleState)
        .toggleStyle(SwitchToggleStyle(tint: accentColor))
        .disabled(isDisabled)
        .scaleEffect(1.1) // iOS 기본 스위치 크기 조정
    }
    .onChange(of: isOn) { newValue in
      toggleState = newValue
    }
  }
}

// MARK: - Expo Module View

final class HIGToggleView: ExpoView {
  let onValueChange = EventDispatcher()
  
  var label: String = "" {
    didSet { render() }
  }
  
  var isOn: Bool = false {
    didSet { render() }
  }
  
  var accentColorHex: String = "#34C759" {
    didSet { render() }
  }
  
  var isDisabled: Bool = false {
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
  
  private func makeRootView() -> HIGToggleContent {
    let accentColor = UIColor.fromHex(accentColorHex).map { Color($0) } ?? HIGDesignTokens.systemGreen
    
    return HIGToggleContent(
      label: label.isEmpty ? nil : label,
      isOn: isOn,
      accentColor: accentColor,
      isDisabled: isDisabled
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
