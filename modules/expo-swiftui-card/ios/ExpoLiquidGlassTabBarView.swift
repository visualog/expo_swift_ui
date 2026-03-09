import ExpoModulesCore
import SwiftUI
import UIKit

private struct LiquidGlassTabBarItem: Identifiable {
  let id: String
  let label: String
  let symbol: String
}

private struct LiquidGlassTabBarContent: View {
  let selectedTab: String
  let onTabPress: (String) -> Void

  private let items: [LiquidGlassTabBarItem] = [
    LiquidGlassTabBarItem(id: "shortcuts", label: "단축어", symbol: "square.grid.2x2.fill"),
    LiquidGlassTabBarItem(id: "automation", label: "자동화", symbol: "clock.arrow.circlepath"),
    LiquidGlassTabBarItem(id: "gallery", label: "갤러리", symbol: "sparkles.rectangle.stack")
  ]

  var body: some View {
    HStack(spacing: 6) {
      ForEach(items) { item in
        Button(action: { onTabPress(item.id) }) {
          VStack(spacing: 4) {
            Image(systemName: item.symbol)
              .font(.system(size: 15, weight: .semibold))
            Text(item.label)
              .font(.system(size: 11, weight: .semibold))
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 8)
          .foregroundStyle(selectedTab == item.id ? Color.accentColor : Color.secondary)
          .background(
            Group {
              if selectedTab == item.id {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                  .fill(Color.white.opacity(0.42))
              } else {
                Color.clear
              }
            }
          )
        }
        .buttonStyle(.plain)
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 10)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .stroke(Color.white.opacity(0.35), lineWidth: 0.7)
    )
    .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 8)
  }
}

internal final class ExpoLiquidGlassTabBarView: ExpoView {
  let onTabPress = EventDispatcher()

  var selectedTab: String = "shortcuts" {
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

  private func makeRootView() -> LiquidGlassTabBarContent {
    return LiquidGlassTabBarContent(
      selectedTab: selectedTab,
      onTabPress: { [weak self] id in
        self?.onTabPress(["id": id])
      }
    )
  }
}
