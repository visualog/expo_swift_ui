import ExpoModulesCore
import Combine
import SwiftUI
import UIKit

private enum RootTab: Hashable {
  case library
  case favorites
  case settings
  case search
}

private enum AppleDesignSemanticTokens {
  enum Colors {
    static let backgroundPrimary = Color(uiColor: .systemBackground)
    static let backgroundSecondary = Color(uiColor: .secondarySystemBackground)
    static let backgroundTertiary = Color(uiColor: .tertiarySystemBackground)
    static let primaryText = Color(uiColor: .label)
    static let secondaryText = Color(uiColor: .secondaryLabel)
    static let tertiaryText = Color(uiColor: .tertiaryLabel)
    static let separator = Color(uiColor: .separator)
    static let panelStroke = Color(uiColor: .separator).opacity(0.28)
    static let subtleFill = Color(uiColor: .secondarySystemFill)
    static let secondaryFill = Color(uiColor: .secondarySystemFill)
    static let strongFill = Color(uiColor: .systemFill)
  }

  enum Spacing {
    static let pageInset: CGFloat = 16
    static let sectionGap: CGFloat = 16
    static let compactGap: CGFloat = 12
    static let cardGap: CGFloat = 12
    static let panelPadding: CGFloat = 16
    static let heroPadding: CGFloat = 16
    static let heroBottomPadding: CGFloat = 24
    static let detailSectionGap: CGFloat = 16
    static let screenTopPadding: CGFloat = 12
    static let screenBottomPadding: CGFloat = 24
  }
}

private struct GridOverlayView: View {
  private func layoutSpec() -> (columns: Int, margin: CGFloat, gutter: CGFloat) {
    (columns: 4, margin: 16, gutter: 12)
  }

  var body: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let spec = layoutSpec()
      let contentWidth = width - (spec.margin * 2)
      let totalGutter = spec.gutter * CGFloat(spec.columns - 1)
      let columnWidth = max((contentWidth - totalGutter) / CGFloat(spec.columns), 0)

      HStack(spacing: spec.gutter) {
        ForEach(0..<spec.columns, id: \.self) { _ in
          RoundedRectangle(cornerRadius: 2, style: .continuous)
            .fill(Color.blue.opacity(0.12))
            .overlay(
              RoundedRectangle(cornerRadius: 2, style: .continuous)
                .stroke(Color.blue.opacity(0.2), lineWidth: 0.5)
            )
            .frame(width: columnWidth)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(.horizontal, spec.margin)
    }
    .ignoresSafeArea()
    .allowsHitTesting(false)
    .accessibilityHidden(true)
  }
}

private final class GridOverlayStore: ObservableObject {
  @Published var isVisible = false
}

private final class GridOverlayPassthroughWindow: UIWindow {
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    false
  }
}

private final class GridOverlayWindowPresenter {
  private var window: GridOverlayPassthroughWindow?

  func attach(to windowScene: UIWindowScene?) {
    guard let windowScene else {
      window = nil
      return
    }

    if let window, window.windowScene === windowScene {
      window.frame = windowScene.coordinateSpace.bounds
      return
    }

    let overlayWindow = GridOverlayPassthroughWindow(windowScene: windowScene)
    let controller = UIHostingController(rootView: GridOverlayView())
    controller.view.backgroundColor = .clear

    overlayWindow.rootViewController = controller
    overlayWindow.backgroundColor = .clear
    overlayWindow.windowLevel = .alert + 1
    overlayWindow.isHidden = true
    overlayWindow.frame = windowScene.coordinateSpace.bounds

    window = overlayWindow
  }

  func setVisible(_ isVisible: Bool) {
    window?.isHidden = !isVisible
  }
}

private struct CompatibleNavigationContainer<Content: View>: View {
  @ViewBuilder let content: () -> Content

  var body: some View {
    if #available(iOS 16.0, *) {
      NavigationStack {
        content()
      }
    } else {
      NavigationView {
        content()
      }
      .navigationViewStyle(.stack)
    }
  }
}

private struct AppleScreenHeader: View {
  let title: String

  var body: some View {
    Text(title)
      .font(.largeTitle.weight(.bold))
      .foregroundStyle(AppleDesignSemanticTokens.Colors.primaryText)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 4)
  }
}

private struct LiquidGlassLibraryBackground: View {
  @Environment(\.colorScheme) private var colorScheme

  private var gradientColors: [Color] {
    if colorScheme == .dark {
      return [
        Color(uiColor: .black),
        AppleDesignSemanticTokens.Colors.backgroundPrimary,
        AppleDesignSemanticTokens.Colors.backgroundSecondary
      ]
    }

    return [
      AppleDesignSemanticTokens.Colors.backgroundPrimary,
      AppleDesignSemanticTokens.Colors.backgroundSecondary,
      AppleDesignSemanticTokens.Colors.backgroundTertiary
    ]
  }

  var body: some View {
    LinearGradient(
      colors: gradientColors,
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
    .overlay(alignment: .topLeading) {
      Circle()
        .fill(
          colorScheme == .dark
            ? AppleDesignSemanticTokens.Colors.primaryText.opacity(0.08)
            : AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.72)
        )
        .frame(width: 220, height: 220)
        .blur(radius: 60)
        .offset(x: -40, y: -30)
    }
    .overlay(alignment: .bottomTrailing) {
      Circle()
        .fill(
          colorScheme == .dark
            ? Color(uiColor: .systemBlue).opacity(0.18)
            : AppleDesignSemanticTokens.Colors.strongFill.opacity(0.52)
        )
        .frame(width: 260, height: 260)
        .blur(radius: 72)
        .offset(x: 80, y: 120)
    }
    .ignoresSafeArea()
  }
}

private struct LiquidGlassPanelModifier: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  let cornerRadius: CGFloat
  let tint: Color?
  let padding: CGFloat

  func body(content: Content) -> some View {
    let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

    content
      .padding(padding)
      .background {
        if #available(iOS 26.0, *) {
          shape
            .fill(.clear)
            .glassEffect(.regular, in: shape)
            .overlay(
              shape
                .stroke(AppleDesignSemanticTokens.Colors.panelStroke, lineWidth: 0.75)
            )
            .overlay {
              if let tint {
                shape
                  .fill(tint.opacity(0.08))
              }
            }
        } else {
          shape
            .fill(.ultraThinMaterial)
            .overlay(
              shape
                .fill(
                  colorScheme == .dark
                    ? AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.92)
                    : AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.78)
                )
            )
            .overlay(
              shape
                .stroke(AppleDesignSemanticTokens.Colors.panelStroke, lineWidth: 0.75)
            )
            .overlay {
              if let tint {
                shape
                  .fill(tint.opacity(0.08))
              }
            }
        }
      }
      .shadow(color: .black.opacity(0.06), radius: 22, y: 10)
  }
}

private struct LightweightLiquidPanelModifier: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme
  let cornerRadius: CGFloat
  let tint: Color?
  let padding: CGFloat

  func body(content: Content) -> some View {
    let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

    content
      .padding(padding)
      .background {
        if #available(iOS 26.0, *) {
          shape
            .fill(.clear)
            .glassEffect(.regular, in: shape)
            .overlay(
              shape
                .stroke(AppleDesignSemanticTokens.Colors.separator.opacity(0.22), lineWidth: 0.6)
            )
            .overlay {
              if let tint {
                shape
                  .fill(tint.opacity(0.04))
              }
            }
        } else {
          shape
            .fill(.thinMaterial)
            .overlay(
              shape
                .fill(
                  colorScheme == .dark
                    ? AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.9)
                    : AppleDesignSemanticTokens.Colors.backgroundTertiary.opacity(0.78)
                )
            )
            .overlay(
              shape
                .stroke(AppleDesignSemanticTokens.Colors.separator.opacity(0.18), lineWidth: 0.6)
            )
            .overlay {
              if let tint {
                shape
                  .fill(tint.opacity(0.04))
              }
            }
        }
      }
      .shadow(color: .black.opacity(0.03), radius: 10, y: 4)
  }
}

private extension View {
  func liquidGlassPanel(
    cornerRadius: CGFloat = 22,
    tint: Color? = nil,
    padding: CGFloat = AppleDesignSemanticTokens.Spacing.panelPadding
  ) -> some View {
    modifier(LiquidGlassPanelModifier(cornerRadius: cornerRadius, tint: tint, padding: padding))
  }

  func lightweightLiquidPanel(
    cornerRadius: CGFloat = 22,
    tint: Color? = nil,
    padding: CGFloat = AppleDesignSemanticTokens.Spacing.panelPadding
  ) -> some View {
    modifier(LightweightLiquidPanelModifier(cornerRadius: cornerRadius, tint: tint, padding: padding))
  }
}

private struct TopRoundedHeroShape: Shape {
  let cornerRadius: CGFloat

  func path(in rect: CGRect) -> Path {
    Path(
      UIBezierPath(
        roundedRect: rect,
        byRoundingCorners: [.topLeft, .topRight],
        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
      ).cgPath
    )
  }
}

private struct AppleDesignTopicThumbnail: View {
  let topic: AppleDesignTopic

  private var tint: Color {
    Color(hex: topic.tintHex)
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      LinearGradient(
        colors: [
          tint.opacity(0.24),
          AppleDesignSemanticTokens.Colors.backgroundSecondary,
          AppleDesignSemanticTokens.Colors.backgroundTertiary
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )

      Group {
        if topic.status == .planned {
          plannedThumbnail
        } else {
          contextualThumbnailContent
        }
      }
        .padding(.horizontal, AppleDesignSemanticTokens.Spacing.heroPadding)
        .padding(.top, AppleDesignSemanticTokens.Spacing.heroPadding)
        .padding(.bottom, AppleDesignSemanticTokens.Spacing.heroBottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      LinearGradient(
        colors: [
          .clear,
          AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.08),
          AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.42)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(height: 72)
    }
    .clipShape(TopRoundedHeroShape(cornerRadius: 24))
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(AppleDesignSemanticTokens.Colors.separator.opacity(0.16))
        .frame(height: 0.8)
    }
  }

  @ViewBuilder
  private var contextualThumbnailContent: some View {
    switch topic.previewKind {
    case .launch:
      launchThumbnail
    case .loading, .progress:
      loadingThumbnail
    case .search:
      searchThumbnail
    case .modal, .share:
      modalThumbnail
    case .menu:
      menuThumbnail
    case .pageControl, .onboarding:
      pageThumbnail
    case .picker, .segmentedControl:
      segmentedThumbnail
    case .toggle:
      toggleThumbnail
    case .textField, .writing:
      textFieldThumbnail
    case .list, .collection, .image:
      collectionThumbnail
    default:
      iconThumbnail
    }
  }

  private var plannedThumbnail: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("준비 중")
        .font(.caption.weight(.semibold))
        .foregroundStyle(tint)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(tint.opacity(0.14), in: Capsule())

      Spacer(minLength: 0)

      HStack(alignment: .center, spacing: 12) {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.88))
          .frame(width: 60, height: 60)
          .overlay {
            Image(systemName: topic.icon)
              .font(.system(size: 22, weight: .semibold))
              .foregroundStyle(tint)
          }

        VStack(alignment: .leading, spacing: 10) {
          RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(tint.opacity(0.22))
            .frame(width: 72, height: 10)

          RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
            .frame(maxWidth: .infinity)
            .frame(height: 10)

          RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(AppleDesignSemanticTokens.Colors.secondaryFill.opacity(0.82))
            .frame(maxWidth: .infinity)
            .frame(height: 10)
        }
      }
      .padding(AppleDesignSemanticTokens.Spacing.compactGap)
      .background(
        AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.92),
        in: RoundedRectangle(cornerRadius: 20, style: .continuous)
      )

      HStack(spacing: 8) {
        ForEach(0..<3, id: \.self) { index in
          RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(index == 0 ? tint.opacity(0.26) : AppleDesignSemanticTokens.Colors.secondaryFill.opacity(0.9))
            .frame(maxWidth: .infinity)
            .frame(height: 8)
        }
      }
    }
  }

  private var launchThumbnail: some View {
    ZStack(alignment: .bottomLeading) {
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(tint.opacity(0.08))
        .overlay(alignment: .topLeading) {
          VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(tint.opacity(0.28))
              .frame(width: 56, height: 8)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
              .frame(width: 94, height: 8)
          }
          .padding(AppleDesignSemanticTokens.Spacing.compactGap)
        }

      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(AppleDesignSemanticTokens.Colors.backgroundSecondary)
        .frame(height: 68)
        .overlay(alignment: .leading) {
          RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(tint.opacity(0.16))
            .frame(width: 44)
            .overlay(
              Image(systemName: topic.icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(tint)
            )
            .padding(.leading, AppleDesignSemanticTokens.Spacing.compactGap)
            .padding(.vertical, AppleDesignSemanticTokens.Spacing.compactGap)
        }
        .overlay(alignment: .topLeading) {
          VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(tint.opacity(0.28))
              .frame(width: 46, height: 8)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
              .fill(AppleDesignSemanticTokens.Colors.strongFill.opacity(0.22))
              .frame(height: 12)
          }
          .padding(.leading, 68)
          .padding(.trailing, AppleDesignSemanticTokens.Spacing.panelPadding)
          .padding(.top, AppleDesignSemanticTokens.Spacing.panelPadding)
        }
    }
  }

  private var loadingThumbnail: some View {
    VStack(alignment: .leading, spacing: 12) {
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(tint.opacity(0.24))
        .frame(width: 52, height: 8)
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(AppleDesignSemanticTokens.Colors.backgroundSecondary)
        .frame(height: 22)
      VStack(spacing: 8) {
        ForEach(0..<2, id: \.self) { index in
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(index == 0 ? AppleDesignSemanticTokens.Colors.backgroundSecondary : AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.82))
            .frame(height: 18)
            .overlay(alignment: .leading) {
              RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(index == 0 ? tint.opacity(0.18) : AppleDesignSemanticTokens.Colors.secondaryFill)
                .frame(width: index == 0 ? 54 : 72, height: 8)
                .padding(.leading, 10)
            }
        }
      }
      Capsule()
        .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
        .frame(height: 6)
        .overlay(alignment: .leading) {
          Capsule()
            .fill(tint)
            .frame(width: 56, height: 6)
        }
    }
  }

  private var searchThumbnail: some View {
    VStack(spacing: 10) {
      HStack(spacing: 8) {
        Image(systemName: "magnifyingglass")
          .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
        RoundedRectangle(cornerRadius: 4, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
          .frame(height: 8)
      }
      .padding(.horizontal, AppleDesignSemanticTokens.Spacing.compactGap)
      .frame(height: 34)
      .background(AppleDesignSemanticTokens.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

      VStack(spacing: 8) {
        ForEach(0..<3, id: \.self) { index in
          HStack(spacing: 8) {
            Circle()
              .fill(index == 0 ? tint.opacity(0.28) : tint.opacity(0.14))
              .frame(width: 12, height: 12)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
              .fill(index == 0 ? tint.opacity(0.16) : AppleDesignSemanticTokens.Colors.secondaryFill)
              .frame(height: 8)
          }
          .padding(.horizontal, AppleDesignSemanticTokens.Spacing.compactGap)
          .padding(.vertical, AppleDesignSemanticTokens.Spacing.compactGap)
          .background(
            index == 0
              ? tint.opacity(0.08)
              : AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.75),
            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
          )
        }
      }
    }
  }

  private var modalThumbnail: some View {
    ZStack(alignment: .bottom) {
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(tint.opacity(0.08))
        .overlay(alignment: .topLeading) {
          VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
              .frame(width: 60, height: 8)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(AppleDesignSemanticTokens.Colors.secondaryFill.opacity(0.8))
              .frame(width: 84, height: 8)
          }
          .padding(AppleDesignSemanticTokens.Spacing.compactGap)
        }

      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(AppleDesignSemanticTokens.Colors.backgroundSecondary)
        .frame(height: 72)
        .overlay(alignment: .top) {
          Capsule()
            .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
            .frame(width: 30, height: 4)
            .padding(.top, 8)
        }
        .overlay(alignment: .center) {
          VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
              .frame(width: 86, height: 8)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(AppleDesignSemanticTokens.Colors.secondaryFill.opacity(0.75))
              .frame(width: 66, height: 8)
          }
          .padding(.top, 10)
        }
    }
  }

  private var menuThumbnail: some View {
    HStack(spacing: 12) {
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(AppleDesignSemanticTokens.Colors.backgroundSecondary.opacity(0.78))
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading) {
          HStack(spacing: 10) {
            Circle()
              .fill(tint.opacity(0.18))
              .frame(width: 24, height: 24)
            VStack(alignment: .leading, spacing: 6) {
              RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
                .frame(width: 44, height: 8)
              RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(AppleDesignSemanticTokens.Colors.secondaryFill.opacity(0.76))
                .frame(width: 64, height: 8)
            }
          }
          .padding(.horizontal, 12)
        }

      VStack(alignment: .leading, spacing: 6) {
        ForEach(0..<3, id: \.self) { _ in
          HStack(spacing: 8) {
            Circle()
              .fill(tint.opacity(0.24))
              .frame(width: 8, height: 8)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
              .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
              .frame(width: 56, height: 8)
          }
        }
      }
      .padding(AppleDesignSemanticTokens.Spacing.compactGap)
      .background(AppleDesignSemanticTokens.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
      .overlay(alignment: .topTrailing) {
        Image(systemName: "ellipsis")
          .font(.system(size: 11, weight: .bold))
          .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
          .padding(8)
      }
    }
  }

  private var pageThumbnail: some View {
    VStack(spacing: 10) {
      HStack(spacing: 10) {
        ForEach(0..<2, id: \.self) { index in
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(index == 0 ? tint.opacity(0.22) : AppleDesignSemanticTokens.Colors.backgroundSecondary)
            .frame(height: 52)
            .overlay(alignment: .bottomLeading) {
              RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(index == 0 ? tint.opacity(0.3) : AppleDesignSemanticTokens.Colors.secondaryFill)
                .frame(width: 28, height: 6)
                .padding(10)
            }
        }
      }

      HStack(spacing: 6) {
        ForEach(0..<3, id: \.self) { index in
          Circle()
            .fill(index == 1 ? tint : AppleDesignSemanticTokens.Colors.secondaryFill)
            .frame(width: 6, height: 6)
        }
      }
    }
  }

  private var segmentedThumbnail: some View {
    VStack(spacing: 10) {
      HStack(spacing: 0) {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.backgroundSecondary)
          .frame(height: 30)
          .overlay(
            HStack(spacing: 0) {
              RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tint.opacity(0.22))
              Color.clear
              Color.clear
            }
            .padding(3)
          )
      }

      HStack(spacing: 8) {
        Circle()
          .fill(tint.opacity(0.24))
          .frame(width: 10, height: 10)
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
          .frame(height: 8)
      }
    }
  }

  private var toggleThumbnail: some View {
    HStack {
      VStack(alignment: .leading, spacing: 8) {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
          .frame(width: 58, height: 8)
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.secondaryFill.opacity(0.75))
          .frame(width: 44, height: 8)
      }

      Spacer()

      Capsule()
        .fill(tint.opacity(0.32))
        .frame(width: 42, height: 26)
        .overlay(alignment: .trailing) {
          Circle()
            .fill(.white.opacity(0.92))
            .frame(width: 20, height: 20)
            .padding(.trailing, 3)
        }
    }
    .padding(.horizontal, AppleDesignSemanticTokens.Spacing.compactGap)
    .padding(.vertical, AppleDesignSemanticTokens.Spacing.compactGap)
    .background(AppleDesignSemanticTokens.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
  }

  private var textFieldThumbnail: some View {
    VStack(alignment: .leading, spacing: 8) {
      RoundedRectangle(cornerRadius: 5, style: .continuous)
        .fill(tint.opacity(0.22))
        .frame(width: 44, height: 8)

      HStack {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
          .frame(width: 72, height: 8)
        Rectangle()
          .fill(tint)
          .frame(width: 2, height: 14)
        Spacer(minLength: 0)
      }
      .padding(.horizontal, 10)
      .frame(height: 30)
      .background(AppleDesignSemanticTokens.Colors.backgroundSecondary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
  }

  private var collectionThumbnail: some View {
    HStack(spacing: 8) {
      ForEach(0..<3, id: \.self) { index in
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(index == 0 ? tint.opacity(0.24) : AppleDesignSemanticTokens.Colors.backgroundSecondary)
          .frame(maxWidth: .infinity)
      }
    }
  }

  private var iconThumbnail: some View {
    HStack(spacing: 10) {
      Circle()
        .fill(tint.opacity(0.16))
        .frame(width: 42, height: 42)
        .overlay(
          Image(systemName: topic.icon)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(tint)
        )

      VStack(alignment: .leading, spacing: 8) {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.secondaryFill)
          .frame(width: 54, height: 8)
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(AppleDesignSemanticTokens.Colors.secondaryFill.opacity(0.78))
          .frame(width: 70, height: 8)
      }
      Spacer(minLength: 0)
    }
  }
}

private struct AppleDesignTopicCard: View {
  let topic: AppleDesignTopic
  let isFavorite: Bool
  let onToggleFavorite: () -> Void
  let onSelect: () -> Void

  private var statusColor: Color {
    topic.status == .planned ? Color(hex: topic.tintHex) : AppleDesignSemanticTokens.Colors.secondaryText
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      AppleDesignTopicThumbnail(topic: topic)
        .frame(maxWidth: .infinity)
        .frame(height: 184)

      HStack(alignment: .top, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
        VStack(alignment: .leading, spacing: 8) {
          Text(topic.koreanTitle)
            .font(.title3.weight(.semibold))
            .foregroundStyle(AppleDesignSemanticTokens.Colors.primaryText)
            .lineLimit(2)

          HStack(spacing: 8) {
            Text(topic.usageContext)
              .lineLimit(1)
              .font(.subheadline)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)

            if topic.status == .planned {
              Text("준비 중")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(hex: topic.tintHex))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: topic.tintHex).opacity(0.12), in: Capsule())
            }
          }

          Text(topic.status == .implemented ? "구현됨" : "준비 중")
            .font(.caption)
            .foregroundStyle(statusColor)
        }

        Spacer(minLength: 0)

        Button(action: onToggleFavorite) {
          Image(systemName: isFavorite ? "star.fill" : "star")
            .font(.body.weight(.semibold))
            .foregroundStyle(isFavorite ? Color.yellow : AppleDesignSemanticTokens.Colors.secondaryText)
            .frame(width: 44, height: 44)
            .background(AppleDesignSemanticTokens.Colors.subtleFill, in: Circle())
        }
        .buttonStyle(.plain)
      }
      .padding(AppleDesignSemanticTokens.Spacing.panelPadding)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .lightweightLiquidPanel(cornerRadius: 24, tint: Color(hex: topic.tintHex), padding: 0)
    .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    .onTapGesture(perform: onSelect)
  }
}

private struct AppleComponentGroupCard: View {
  let group: AppleComponentGroup
  let topics: [AppleDesignTopic]

  private var implementedCount: Int {
    topics.filter { $0.status == .implemented }.count
  }

  private var plannedCount: Int {
    topics.filter { $0.status == .planned }.count
  }

  var body: some View {
    HStack(alignment: .center, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
      Circle()
        .fill(AppleDesignSemanticTokens.Colors.subtleFill)
        .frame(width: 44, height: 44)
        .overlay {
          Image(systemName: "square.grid.2x2")
            .foregroundStyle(.blue)
        }

      VStack(alignment: .leading, spacing: 6) {
        Text(group.title)
          .font(.headline)
          .foregroundStyle(AppleDesignSemanticTokens.Colors.primaryText)

        Text("\(topics.count)개 항목 · \(implementedCount)개 구현 · \(plannedCount)개 준비 중")
          .font(.subheadline)
          .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
      }

      Spacer(minLength: 0)

      Image(systemName: "chevron.right")
        .font(.body.weight(.semibold))
        .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
        .frame(width: 44, height: 44)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .lightweightLiquidPanel(cornerRadius: 24, padding: AppleDesignSemanticTokens.Spacing.panelPadding)
  }
}

private struct AppleComponentGroupScreen: View {
  let group: AppleComponentGroup
  let topics: [AppleDesignTopic]
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var selectedTopic: AppleDesignTopic?

  private var groupTopics: [AppleDesignTopic] {
    topics.filter { $0.libraryKind == .components && $0.componentGroup == group }
  }

  private var plannedTopics: [AppleDesignTopic] {
    groupTopics.filter { $0.status == .planned }
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.sectionGap) {
        AppleScreenHeader(title: group.title)

        HStack {
          Text("공식 구성요소 항목")
            .font(.title2)
            .accessibilityAddTraits(.isHeader)
          Spacer()
          Text(plannedTopics.isEmpty ? "\(groupTopics.count)개" : "\(groupTopics.count)개 · \(plannedTopics.count) 준비 중")
            .font(.footnote)
            .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        LazyVStack(spacing: AppleDesignSemanticTokens.Spacing.cardGap) {
          ForEach(groupTopics) { topic in
            AppleDesignTopicCard(
              topic: topic,
              isFavorite: favoritesStore.isFavorite(topic.id),
              onToggleFavorite: { favoritesStore.toggle(topic.id) },
              onSelect: { selectedTopic = topic }
            )
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, AppleDesignSemanticTokens.Spacing.pageInset)
      .padding(.top, AppleDesignSemanticTokens.Spacing.screenTopPadding)
      .padding(.bottom, AppleDesignSemanticTokens.Spacing.screenBottomPadding)
    }
    .background {
      LiquidGlassLibraryBackground()
    }
    .hideNavigationBarForCustomHeader()
    .sheet(item: $selectedTopic) { topic in
      AppleDesignTopicDetailSheet(topic: topic, favoritesStore: favoritesStore)
    }
  }
}

private struct AppleDesignTopicDetailSheet: View {
  let topic: AppleDesignTopic
  @ObservedObject var favoritesStore: FavoritesStore

  private var topicURL: URL? {
    URL(string: topic.higUrl)
  }

  private var snippet: String {
    """
    // \(topic.higPathTitle)
    \(topic.swiftUIReference)
    """
  }

  private var plannedReferencePlaceholder: some View {
    VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
      HStack(spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
        Circle()
          .fill(Color(hex: topic.tintHex).opacity(0.16))
          .frame(width: 52, height: 52)
          .overlay {
            Image(systemName: topic.icon)
              .font(.title3.weight(.semibold))
              .foregroundStyle(Color(hex: topic.tintHex))
          }

        VStack(alignment: .leading, spacing: 6) {
          Text("준비 중인 레퍼런스")
            .font(.headline)
            .foregroundStyle(AppleDesignSemanticTokens.Colors.primaryText)
          Text("이 HIG 항목은 구조만 먼저 미러링되어 있고, 인터랙티브 샘플은 아직 준비 중입니다.")
            .font(.body)
            .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
        }
      }

      Text("공식 HIG 경로를 먼저 확인하고, 샘플 scene은 다음 단계에서 채워집니다.")
        .font(.footnote)
        .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .liquidGlassPanel(tint: Color(hex: topic.tintHex), padding: AppleDesignSemanticTokens.Spacing.panelPadding)
  }

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.detailSectionGap) {
          AppleScreenHeader(title: topic.koreanTitle)

          if topic.status == .implemented {
            MotionPreviewView(topic: topic)
          } else {
            plannedReferencePlaceholder
          }

          VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
            Text(topic.summary)
              .font(.body)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)

            metadataRow(title: "분류", value: topic.sectionTitle)
            metadataRow(title: "HIG 경로", value: topic.higPathTitle)
            metadataRow(title: "플랫폼 메모", value: topic.platformNotes)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlassPanel(tint: Color(hex: topic.tintHex), padding: AppleDesignSemanticTokens.Spacing.panelPadding)

          VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
            DisclosureGroup("핵심 포인트") {
              VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
                ForEach(topic.keyPoints, id: \.self) { point in
                  HStack(alignment: .top, spacing: 10) {
                    Circle()
                      .fill(Color(hex: topic.tintHex))
                      .frame(width: 8, height: 8)
                      .padding(.top, 6)
                    Text(point)
                      .font(.body)
                      .foregroundStyle(AppleDesignSemanticTokens.Colors.primaryText)
                  }
                }
              }
            }
            .font(.title3.weight(.semibold))
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlassPanel(tint: Color(hex: topic.tintHex), padding: AppleDesignSemanticTokens.Spacing.panelPadding)

          VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
            DisclosureGroup("SwiftUI 참고") {
              VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
                Text(topic.swiftUIReference)
                  .font(.body)
                  .foregroundStyle(AppleDesignSemanticTokens.Colors.primaryText)

                Text(snippet)
                  .font(.system(.footnote, design: .monospaced))
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .liquidGlassPanel(cornerRadius: 16, tint: Color(hex: topic.tintHex), padding: 12)
              }
            }
            .font(.title3.weight(.semibold))
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlassPanel(tint: Color(hex: topic.tintHex), padding: AppleDesignSemanticTokens.Spacing.panelPadding)

          VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
            Text("공식 가이드")
              .font(.title2)
              .accessibilityAddTraits(.isHeader)

            if let topicURL {
              Link("공식 HIG 열기", destination: topicURL)
                .font(.headline)
            }

            Text(topic.higUrl)
              .font(.footnote)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)

            Text(topic.isSystemDemo ? "이 장면은 시스템 화면 구조를 축약한 데모입니다." : "이 장면은 HIG 항목의 사용 맥락을 빠르게 떠올리기 위한 reference preview입니다.")
              .font(.footnote)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlassPanel(tint: Color(hex: topic.tintHex), padding: AppleDesignSemanticTokens.Spacing.panelPadding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppleDesignSemanticTokens.Spacing.pageInset)
        .padding(.top, AppleDesignSemanticTokens.Spacing.screenTopPadding)
        .padding(.bottom, AppleDesignSemanticTokens.Spacing.screenBottomPadding)
      }
      .background {
        LiquidGlassLibraryBackground()
      }
      .hideNavigationBarForCustomHeader()
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: { favoritesStore.toggle(topic.id) }) {
            Image(systemName: favoritesStore.isFavorite(topic.id) ? "star.fill" : "star")
          }
        }
      }
    }
  }

  private func metadataRow(title: String, value: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.caption)
        .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
      Text(value)
        .font(.body)
        .foregroundStyle(AppleDesignSemanticTokens.Colors.primaryText)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct AppleDesignLibraryHomeScreen: View {
  let topics: [AppleDesignTopic]
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var selectedLibraryKind: AppleLibraryKind = .patterns
  @State private var selectedTopic: AppleDesignTopic?

  private var filteredTopics: [AppleDesignTopic] {
    topics.filter { $0.libraryKind == selectedLibraryKind }
  }

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.sectionGap) {
          AppleScreenHeader(title: "Apple HIG 레퍼런스")

          Picker("라이브러리 분류", selection: $selectedLibraryKind) {
            ForEach(AppleLibraryKind.allCases) { kind in
              Text(kind.koreanTitle).tag(kind)
            }
          }
          .pickerStyle(.segmented)
          .frame(maxWidth: .infinity)

          HStack {
            Text(selectedLibraryKind == .patterns ? "실제 화면 패턴" : "공식 구성요소 그룹")
              .font(.title2)
              .accessibilityAddTraits(.isHeader)
            Spacer()
            Text("\(selectedLibraryKind == .patterns ? filteredTopics.count : AppleComponentGroup.allCases.count)개")
              .font(.footnote)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          if selectedLibraryKind == .patterns {
            LazyVStack(spacing: AppleDesignSemanticTokens.Spacing.cardGap) {
              ForEach(filteredTopics) { topic in
                AppleDesignTopicCard(
                  topic: topic,
                  isFavorite: favoritesStore.isFavorite(topic.id),
                  onToggleFavorite: { favoritesStore.toggle(topic.id) },
                  onSelect: { selectedTopic = topic }
                )
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          } else {
            LazyVStack(spacing: AppleDesignSemanticTokens.Spacing.cardGap) {
              ForEach(AppleComponentGroup.allCases) { group in
                let groupTopics = filteredTopics.filter { $0.componentGroup == group }

                NavigationLink(destination: AppleComponentGroupScreen(group: group, topics: topics, favoritesStore: favoritesStore)) {
                  AppleComponentGroupCard(group: group, topics: groupTopics)
                }
                .buttonStyle(.plain)
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppleDesignSemanticTokens.Spacing.pageInset)
        .padding(.top, AppleDesignSemanticTokens.Spacing.screenTopPadding)
        .padding(.bottom, AppleDesignSemanticTokens.Spacing.screenBottomPadding)
      }
      .background {
        LiquidGlassLibraryBackground()
      }
      .hideNavigationBarForCustomHeader()
      .sheet(item: $selectedTopic) { topic in
        AppleDesignTopicDetailSheet(topic: topic, favoritesStore: favoritesStore)
      }
    }
  }
}

private struct SearchScreen: View {
  let topics: [AppleDesignTopic]
  @ObservedObject var favoritesStore: FavoritesStore
  @Binding var searchQuery: String

  @State private var selectedTopic: AppleDesignTopic?

  private var normalizedQuery: String {
    searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var filteredGroups: [AppleComponentGroup] {
    AppleComponentGroup.allCases.filter { group in
      normalizedQuery.isEmpty ||
      group.title.localizedCaseInsensitiveContains(normalizedQuery) ||
      topics.contains {
        $0.componentGroup == group &&
        (
          $0.name.localizedCaseInsensitiveContains(normalizedQuery) ||
          $0.koreanTitle.localizedCaseInsensitiveContains(normalizedQuery) ||
          $0.usageContext.localizedCaseInsensitiveContains(normalizedQuery)
        )
      }
    }
  }

  private var filteredTopics: [AppleDesignTopic] {
    guard !normalizedQuery.isEmpty else {
      return topics
    }

    return topics.filter { topic in
      topic.name.localizedCaseInsensitiveContains(normalizedQuery) ||
      topic.koreanTitle.localizedCaseInsensitiveContains(normalizedQuery) ||
      topic.usageContext.localizedCaseInsensitiveContains(normalizedQuery) ||
      topic.sectionTitle.localizedCaseInsensitiveContains(normalizedQuery) ||
      topic.higPathTitle.localizedCaseInsensitiveContains(normalizedQuery) ||
      topic.tags.contains(where: { $0.localizedCaseInsensitiveContains(normalizedQuery) })
    }
  }

  private var totalResultCount: Int {
    filteredGroups.count + filteredTopics.count
  }

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.sectionGap) {
          AppleScreenHeader(title: "검색")

          HStack {
            Text(normalizedQuery.isEmpty ? "전체 항목" : "검색 결과")
              .font(.title2)
              .accessibilityAddTraits(.isHeader)
            Spacer()
            Text("\(totalResultCount)개")
              .font(.footnote)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          if filteredTopics.isEmpty && filteredGroups.isEmpty {
            VStack(alignment: .center, spacing: 10) {
              Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
              Text("검색 결과가 없습니다")
                .font(.headline)
              Text("다른 키워드나 HIG 항목 이름으로 다시 찾아보세요.")
                .font(.body)
                .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lightweightLiquidPanel(cornerRadius: 24, padding: AppleDesignSemanticTokens.Spacing.panelPadding)
          } else {
            VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.sectionGap) {
              if !filteredGroups.isEmpty {
                VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.cardGap) {
                  Text("구성요소 그룹")
                    .font(.headline)
                    .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)

                  ForEach(filteredGroups) { group in
                    let groupTopics = topics.filter { $0.componentGroup == group }

                    NavigationLink(destination: AppleComponentGroupScreen(group: group, topics: topics, favoritesStore: favoritesStore)) {
                      AppleComponentGroupCard(group: group, topics: groupTopics)
                    }
                    .buttonStyle(.plain)
                  }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }

              if !filteredTopics.isEmpty {
                VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.cardGap) {
                  Text("HIG 항목")
                    .font(.headline)
                    .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)

                  LazyVStack(spacing: AppleDesignSemanticTokens.Spacing.cardGap) {
                    ForEach(filteredTopics) { topic in
                      AppleDesignTopicCard(
                        topic: topic,
                        isFavorite: favoritesStore.isFavorite(topic.id),
                        onToggleFavorite: { favoritesStore.toggle(topic.id) },
                        onSelect: { selectedTopic = topic }
                      )
                    }
                  }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppleDesignSemanticTokens.Spacing.pageInset)
        .padding(.top, AppleDesignSemanticTokens.Spacing.screenTopPadding)
        .padding(.bottom, AppleDesignSemanticTokens.Spacing.screenBottomPadding)
      }
      .background {
        LiquidGlassLibraryBackground()
      }
      .hideNavigationBarForCustomHeader()
      .sheet(item: $selectedTopic) { topic in
        AppleDesignTopicDetailSheet(topic: topic, favoritesStore: favoritesStore)
      }
      .searchable(text: $searchQuery, prompt: "패턴 또는 구성요소 검색")
    }
  }
}

private struct FavoritesScreen: View {
  let topics: [AppleDesignTopic]
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var selectedTopic: AppleDesignTopic?

  private var favoriteTopics: [AppleDesignTopic] {
    topics.filter { favoritesStore.isFavorite($0.id) }
  }

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.sectionGap) {
          AppleScreenHeader(title: "즐겨찾기")

          if favoriteTopics.isEmpty {
            VStack(spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
              Image(systemName: "star")
                .font(.largeTitle)
                .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
              Text("저장한 라이브러리 항목이 없습니다")
                .font(.headline)
              Text("라이브러리에서 별 버튼으로 topic을 저장해 보세요")
                .font(.body)
                .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 220)
            .liquidGlassPanel(cornerRadius: 28, padding: AppleDesignSemanticTokens.Spacing.panelPadding)
          } else {
            LazyVStack(spacing: AppleDesignSemanticTokens.Spacing.cardGap) {
              ForEach(favoriteTopics) { topic in
                AppleDesignTopicCard(
                  topic: topic,
                  isFavorite: favoritesStore.isFavorite(topic.id),
                  onToggleFavorite: { favoritesStore.toggle(topic.id) },
                  onSelect: { selectedTopic = topic }
                )
              }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppleDesignSemanticTokens.Spacing.pageInset)
        .padding(.top, AppleDesignSemanticTokens.Spacing.screenTopPadding)
        .padding(.bottom, AppleDesignSemanticTokens.Spacing.screenBottomPadding)
      }
      .background {
        LiquidGlassLibraryBackground()
      }
      .hideNavigationBarForCustomHeader()
      .sheet(item: $selectedTopic) { topic in
        AppleDesignTopicDetailSheet(topic: topic, favoritesStore: favoritesStore)
      }
    }
  }
}

private struct SettingsScreen: View {
  @ObservedObject var gridOverlayStore: GridOverlayStore

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.sectionGap) {
          AppleScreenHeader(title: "설정")

          VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
            Text("레이아웃")
              .font(.title3)
              .accessibilityAddTraits(.isHeader)

            Toggle("레이아웃 그리드 표시", isOn: $gridOverlayStore.isVisible)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlassPanel(padding: AppleDesignSemanticTokens.Spacing.panelPadding)

          VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
            Text("라이브러리 정보")
              .font(.title3)
              .accessibilityAddTraits(.isHeader)

            Text("이 화면은 Apple Human Interface Guidelines를 빠르게 참조하기 위한 내부 라이브러리입니다.")
              .font(.body)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlassPanel(padding: AppleDesignSemanticTokens.Spacing.panelPadding)

          VStack(alignment: .leading, spacing: AppleDesignSemanticTokens.Spacing.compactGap) {
            Text("현재 스타일")
              .font(.title3)
              .accessibilityAddTraits(.isHeader)

            Text("iOS 26 이상에서는 Liquid Glass 계열 surface를 사용하고, 그 미만에서는 material 기반 fallback을 사용합니다.")
              .font(.body)
              .foregroundStyle(AppleDesignSemanticTokens.Colors.secondaryText)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .liquidGlassPanel(padding: AppleDesignSemanticTokens.Spacing.panelPadding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, AppleDesignSemanticTokens.Spacing.pageInset)
        .padding(.top, AppleDesignSemanticTokens.Spacing.screenTopPadding)
        .padding(.bottom, AppleDesignSemanticTokens.Spacing.screenBottomPadding)
      }
      .background {
        LiquidGlassLibraryBackground()
      }
      .hideNavigationBarForCustomHeader()
    }
  }
}

private struct AppleDesignLibraryRootTabView: View {
  @State private var selectedTab: RootTab = .library
  @State private var searchQuery = ""
  @StateObject private var favoritesStore = FavoritesStore()
  @ObservedObject var gridOverlayStore: GridOverlayStore

  private let topics = AppleDesignTopic.sampleData

  @ViewBuilder
  private var tabContainer: some View {
    if #available(iOS 18.0, *) {
      TabView(selection: $selectedTab) {
        Tab("라이브러리", systemImage: "books.vertical.fill", value: .library) {
          AppleDesignLibraryHomeScreen(topics: topics, favoritesStore: favoritesStore)
        }

        Tab("즐겨찾기", systemImage: "star.fill", value: .favorites) {
          FavoritesScreen(topics: topics, favoritesStore: favoritesStore)
        }

        Tab("설정", systemImage: "gearshape.fill", value: .settings) {
          SettingsScreen(gridOverlayStore: gridOverlayStore)
        }

        Tab("검색", systemImage: "magnifyingglass", value: .search, role: .search) {
          SearchScreen(
            topics: topics,
            favoritesStore: favoritesStore,
            searchQuery: $searchQuery
          )
        }
      }
      .tabViewStyle(.tabBarOnly)
      .applyLiquidTabBarBehaviorIfAvailable()
      .tint(.blue)
    } else {
      TabView {
        AppleDesignLibraryHomeScreen(topics: topics, favoritesStore: favoritesStore)
          .tabItem {
            Label("라이브러리", systemImage: "books.vertical.fill")
          }

        FavoritesScreen(topics: topics, favoritesStore: favoritesStore)
          .tabItem {
            Label("즐겨찾기", systemImage: "star.fill")
          }

        SettingsScreen(gridOverlayStore: gridOverlayStore)
          .tabItem {
            Label("설정", systemImage: "gearshape.fill")
          }

        SearchScreen(
          topics: topics,
          favoritesStore: favoritesStore,
          searchQuery: $searchQuery
        )
          .tabItem {
            Label("검색", systemImage: "magnifyingglass")
          }
      }
      .tint(.blue)
    }
  }

  var body: some View {
    tabContainer
      .onAppear { favoritesStore.load() }
  }
}

private extension View {
  @ViewBuilder
  func hideNavigationBarForCustomHeader() -> some View {
    if #available(iOS 16.0, *) {
      self.toolbar(.hidden, for: .navigationBar)
    } else {
      self.navigationBarHidden(true)
    }
  }

  @ViewBuilder
  func applyLiquidTabBarBehaviorIfAvailable() -> some View {
    if #available(iOS 26.0, *) {
      self.tabBarMinimizeBehavior(.onScrollDown)
    } else {
      self
    }
  }
}

internal final class ExpoShortcutsHomeView: ExpoView {
  private let gridOverlayStore = GridOverlayStore()
  private let gridOverlayPresenter = GridOverlayWindowPresenter()
  private var cancellables = Set<AnyCancellable>()

  private lazy var hostingController: UIHostingController<AppleDesignLibraryRootTabView> = {
    UIHostingController(rootView: AppleDesignLibraryRootTabView(gridOverlayStore: gridOverlayStore))
  }()

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    bindGridOverlay()
    setupHostedView()
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    guard let windowScene = window?.windowScene else {
      gridOverlayPresenter.attach(to: nil)
      return
    }
    gridOverlayPresenter.attach(to: windowScene)
    gridOverlayPresenter.setVisible(gridOverlayStore.isVisible)
  }

  private func bindGridOverlay() {
    gridOverlayStore.$isVisible
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isVisible in
        self?.gridOverlayPresenter.setVisible(isVisible)
      }
      .store(in: &cancellables)
  }

  private func setupHostedView() {
    backgroundColor = .clear

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
}
