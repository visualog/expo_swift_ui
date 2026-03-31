import ExpoModulesCore
import SwiftUI

/// Apple HIG Slider 컴포넌트
/// https://developer.apple.com/design/human-interface-guidelines/sliders
struct HIGSliderContent: View {
  let minimumValue: Double
  let maximumValue: Double
  let value: Double
  let accentColor: Color
  let isDisabled: Bool
  let showValueLabel: Bool
  
  @State private var sliderValue: Double = 0.5
  
  var body: some View {
    VStack(spacing: HIGDesignTokens.Spacing.small.value) {
      if showValueLabel {
        Text(String(format: "%.1f", sliderValue))
          .font(.system(size: 14, weight: .semibold, design: .rounded))
          .foregroundColor(HIGDesignTokens.secondary)
      }
      
      Slider(value: $sliderValue, in: minimumValue...maximumValue)
        .tint(accentColor)
        .disabled(isDisabled)
    }
    .onChange(of: value) { newValue in
      sliderValue = newValue
    }
  }
}

// MARK: - Expo Module View

final class HIGSliderView: ExpoView {
  let onValueChange = EventDispatcher()
  
  var minimumValue: Double = 0.0 {
    didSet { render() }
  }
  
  var maximumValue: Double = 1.0 {
    didSet { render() }
  }
  
  var value: Double = 0.5 {
    didSet { render() }
  }
  
  var accentColorHex: String = "#007AFF" {
    didSet { render() }
  }
  
  var isDisabled: Bool = false {
    didSet { render() }
  }
  
  var showValueLabel: Bool = false {
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
  
  private func makeRootView() -> HIGSliderContent {
    let accentColor = UIColor.fromHex(accentColorHex).map { Color($0) } ?? HIGDesignTokens.systemBlue
    
    return HIGSliderContent(
      minimumValue: minimumValue,
      maximumValue: maximumValue,
      value: value,
      accentColor: accentColor,
      isDisabled: isDisabled,
      showValueLabel: showValueLabel
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
