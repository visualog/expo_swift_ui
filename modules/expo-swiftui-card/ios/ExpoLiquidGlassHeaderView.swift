import ExpoModulesCore
import SwiftUI
import UIKit

private struct LiquidGlassHeaderContent: View {
  let title: String
  let subtitle: String
  let onAddPress: () -> Void

  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 3) {
        Text(title)
          .font(.system(size: 26, weight: .bold))
          .foregroundStyle(.primary)
        if !subtitle.isEmpty {
          Text(subtitle)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.secondary)
        }
      }
      Spacer()
      Button(action: onAddPress) {
        Image(systemName: "plus")
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(Color.accentColor)
          .frame(width: 34, height: 34)
          .background(Color.white.opacity(0.46), in: Circle())
      }
      .buttonStyle(.plain)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: 22, style: .continuous)
        .stroke(Color.white.opacity(0.35), lineWidth: 0.7)
    )
    .shadow(color: Color.black.opacity(0.1), radius: 14, x: 0, y: 8)
  }
}

internal final class ExpoLiquidGlassHeaderView: ExpoView {
  let onAddPress = EventDispatcher()

  var title: String = "단축어" {
    didSet {
      render()
    }
  }

  var subtitle: String = "" {
    didSet {
      render()
    }
  }

  private lazy var hostingController = UIHostingController(rootView: makeRootView())

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    setupHostedView()
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

  private func render() {
    hostingController.rootView = makeRootView()
  }

  private func makeRootView() -> LiquidGlassHeaderContent {
    return LiquidGlassHeaderContent(
      title: title,
      subtitle: subtitle,
      onAddPress: { [weak self] in
        self?.onAddPress([:])
      }
    )
  }
}
