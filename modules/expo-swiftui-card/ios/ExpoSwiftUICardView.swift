import ExpoModulesCore
import SwiftUI
import UIKit

private struct SwiftUICardContent: View {
  let title: String
  let subtitle: String
  let accentColor: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 20, weight: .semibold))
        .foregroundStyle(.primary)

      if !subtitle.isEmpty {
        Text(subtitle)
          .font(.system(size: 14, weight: .regular))
          .foregroundStyle(.secondary)
      }
    }
    .padding(18)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(accentColor.opacity(0.14))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .stroke(accentColor.opacity(0.3), lineWidth: 1)
    )
  }
}

internal final class ExpoSwiftUICardView: ExpoView {
  let onPress = EventDispatcher()

  var title: String = "SwiftUI Card" {
    didSet {
      render()
    }
  }

  var subtitle: String = "Rendered from a native SwiftUI component." {
    didSet {
      render()
    }
  }

  var accentColorHex: String = "#0A84FF" {
    didSet {
      render()
    }
  }

  private lazy var hostingController = UIHostingController(rootView: makeRootView())

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    setupHostedView()
    setupTapRecognizer()
  }

  @objc
  private func handleTap() {
    onPress([
      "title": title,
      "subtitle": subtitle
    ])
  }

  private func setupHostedView() {
    backgroundColor = .clear
    clipsToBounds = false

    guard let hostedView = hostingController.view else {
      return
    }

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

  private func render() {
    hostingController.rootView = makeRootView()
  }

  private func makeRootView() -> SwiftUICardContent {
    let accentUIColor = UIColor.fromHex(accentColorHex) ?? UIColor.systemBlue
    return SwiftUICardContent(
      title: title,
      subtitle: subtitle,
      accentColor: Color(uiColor: accentUIColor)
    )
  }
}

private extension UIColor {
  static func fromHex(_ value: String) -> UIColor? {
    let hex = value
      .replacingOccurrences(of: "#", with: "")
      .trimmingCharacters(in: .whitespacesAndNewlines)

    guard hex.count == 6 || hex.count == 8 else {
      return nil
    }

    var parsed: UInt64 = 0
    guard Scanner(string: hex).scanHexInt64(&parsed) else {
      return nil
    }

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
