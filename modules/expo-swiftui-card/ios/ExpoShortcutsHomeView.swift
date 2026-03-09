import ExpoModulesCore
import SwiftUI
import UIKit

private struct ShortcutFolderItem: Identifiable {
  let id: String
  let icon: String
  let title: String
  let count: Int
  let tint: Color
}

private struct ShortcutSuggestionItem: Identifiable {
  let id: String
  let title: String
  let subtitle: String
}

private enum RootTab: Hashable {
  case shortcuts
  case automation
  case gallery
}

private struct GridOverlayView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  private func layoutSpec(for width: CGFloat) -> (columns: Int, margin: CGFloat, gutter: CGFloat) {
    if horizontalSizeClass == .regular || width >= 700 {
      return (columns: 6, margin: 24, gutter: 16)
    }

    if width >= 430 {
      return (columns: 4, margin: 20, gutter: 12)
    }

    return (columns: 4, margin: 16, gutter: 12)
  }

  var body: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let spec = layoutSpec(for: width)
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

private struct ShortcutsPrimaryScreen: View {
  @State private var selectedSegment = 0

  private let folders: [ShortcutFolderItem] = [
    ShortcutFolderItem(id: "all", icon: "play.fill", title: "모든 단축어", count: 42, tint: .blue),
    ShortcutFolderItem(id: "share", icon: "arrow.up.right", title: "공유 시트", count: 8, tint: .green),
    ShortcutFolderItem(id: "watch", icon: "applewatch", title: "Apple Watch", count: 6, tint: .orange),
    ShortcutFolderItem(id: "quick", icon: "bolt.fill", title: "빠른 실행", count: 15, tint: .purple)
  ]

  private let suggestions: [ShortcutSuggestionItem] = [
    ShortcutSuggestionItem(id: "s1", title: "출근 루틴 실행", subtitle: "지도, 음악, 메시지 자동 실행"),
    ShortcutSuggestionItem(id: "s2", title: "회의 요약 만들기", subtitle: "녹음 파일을 텍스트로 요약"),
    ShortcutSuggestionItem(id: "s3", title: "사진 정리 자동화", subtitle: "촬영 시간 기준 앨범 분류")
  ]

  private let folderColumns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 18) {
          HStack(alignment: .center) {
            Text("단축어")
              .font(.system(size: 34, weight: .bold))
              .foregroundStyle(.primary)

            Spacer()

            Button(action: {}) {
              Image(systemName: "plus")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: 56, height: 56)
                .background(Color(uiColor: .secondarySystemBackground), in: Circle())
            }
            .buttonStyle(.plain)
          }

          Picker("", selection: $selectedSegment) {
            Text("모든 단축어").tag(0)
            Text("최근").tag(1)
            Text("자동화").tag(2)
          }
          .pickerStyle(.segmented)

          HStack {
            Text("내 단축어")
              .font(.system(size: 34, weight: .bold))
              .foregroundStyle(.primary)
            Spacer()
            Button("편집") {}
              .font(.system(size: 19, weight: .semibold))
          }

          LazyVGrid(columns: folderColumns, spacing: 12) {
            ForEach(folders) { folder in
              VStack(alignment: .leading, spacing: 10) {
                Image(systemName: folder.icon)
                  .font(.system(size: 16, weight: .bold))
                  .foregroundStyle(folder.tint)
                  .frame(width: 44, height: 44)
                  .background(folder.tint.opacity(0.15), in: Circle())
                Spacer(minLength: 2)
                Text(folder.title)
                  .font(.system(size: 17, weight: .semibold))
                  .foregroundStyle(.primary)
                Text("\(folder.count)개 단축어")
                  .font(.system(size: 14, weight: .regular))
                  .foregroundStyle(.secondary)
              }
              .frame(maxWidth: .infinity, minHeight: 148, alignment: .topLeading)
              .padding(14)
              .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
          }

          HStack {
            Text("추천 단축어")
              .font(.system(size: 22, weight: .bold))
            Spacer()
            Button("모두 보기") {}
              .font(.system(size: 17, weight: .semibold))
          }

          VStack(spacing: 0) {
            ForEach(Array(suggestions.enumerated()), id: \.element.id) { idx, item in
              HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                  .fill(Color(uiColor: .tertiarySystemFill))
                  .frame(width: 48, height: 48)
                  .overlay(
                    Text("⋯")
                      .font(.system(size: 26, weight: .medium))
                      .foregroundStyle(.secondary)
                  )

                VStack(alignment: .leading, spacing: 2) {
                  Text(item.title)
                    .font(.system(size: 17, weight: .semibold))
                  Text(item.subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                }

                Spacer()
                Image(systemName: "chevron.right")
                  .font(.system(size: 16, weight: .semibold))
                  .foregroundStyle(.tertiary)
              }
              .padding(.horizontal, 14)
              .padding(.vertical, 12)

              if idx < suggestions.count - 1 {
                Divider()
                  .padding(.leading, 74)
              }
            }
          }
          .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 22)
      }
      .background(Color(uiColor: .systemGroupedBackground))
      .hideNavigationBarForCustomHeader()
    }
  }
}

private struct PlaceholderTabView: View {
  let title: String
  let symbol: String

  var body: some View {
    CompatibleNavigationContainer {
      VStack(spacing: 14) {
        Image(systemName: symbol)
          .font(.system(size: 38, weight: .regular))
          .foregroundStyle(.secondary)
        Text("\(title) 화면")
          .font(.system(size: 20, weight: .semibold))
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(uiColor: .systemGroupedBackground))
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

private struct ShortcutsRootTabView: View {
  @State private var selectedTab: RootTab = .shortcuts
  private let showGridOverlay = true

  @ViewBuilder
  var body: some View {
    ZStack {
      if #available(iOS 18.0, *) {
        TabView(selection: $selectedTab) {
          Tab("단축어", systemImage: "square.grid.2x2.fill", value: .shortcuts) {
            ShortcutsPrimaryScreen()
          }

          Tab("자동화", systemImage: "clock.arrow.circlepath", value: .automation) {
            PlaceholderTabView(title: "자동화", symbol: "clock.arrow.circlepath")
          }

          Tab("갤러리", systemImage: "sparkles.rectangle.stack", value: .gallery) {
            PlaceholderTabView(title: "갤러리", symbol: "sparkles.rectangle.stack")
          }
        }
        .tabViewStyle(.tabBarOnly)
        .applyLiquidTabBarBehaviorIfAvailable()
        .tint(.blue)
      } else {
        TabView {
          ShortcutsPrimaryScreen()
            .tabItem {
              Label("단축어", systemImage: "square.grid.2x2.fill")
            }

          PlaceholderTabView(title: "자동화", symbol: "clock.arrow.circlepath")
            .tabItem {
              Label("자동화", systemImage: "clock.arrow.circlepath")
            }

          PlaceholderTabView(title: "갤러리", symbol: "sparkles.rectangle.stack")
            .tabItem {
              Label("갤러리", systemImage: "sparkles.rectangle.stack")
            }
        }
        .tint(.blue)
      }

      if showGridOverlay {
        GridOverlayView()
          .zIndex(9_999)
      }
    }
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
  private lazy var hostingController: UIHostingController<ShortcutsRootTabView> = {
    UIHostingController(rootView: ShortcutsRootTabView())
  }()

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    setupHostedView()
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
