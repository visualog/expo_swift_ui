import ExpoModulesCore
import Combine
import SwiftUI
import UIKit

private enum RootTab: Hashable {
  case library
  case favorites
  case settings
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
  @Published var isVisible = true
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

private struct LiquidGlassLibraryBackground: View {
  var body: some View {
    LinearGradient(
      colors: [
        Color(red: 0.91, green: 0.97, blue: 1.0),
        Color(red: 0.90, green: 0.95, blue: 0.98),
        Color(red: 0.95, green: 0.95, blue: 1.0)
      ],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
    .overlay(alignment: .topLeading) {
      Circle()
        .fill(Color.white.opacity(0.55))
        .frame(width: 220, height: 220)
        .blur(radius: 60)
        .offset(x: -40, y: -30)
    }
    .overlay(alignment: .bottomTrailing) {
      Circle()
        .fill(Color(hex: "#6BB7FF").opacity(0.15))
        .frame(width: 260, height: 260)
        .blur(radius: 72)
        .offset(x: 80, y: 120)
    }
    .ignoresSafeArea()
  }
}

private struct LiquidGlassPanelModifier: ViewModifier {
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
                .stroke(.white.opacity(0.42), lineWidth: 0.75)
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
                .fill(Color.white.opacity(0.55))
            )
            .overlay(
              shape
                .stroke(.white.opacity(0.42), lineWidth: 0.75)
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

private extension View {
  func liquidGlassPanel(
    cornerRadius: CGFloat = 22,
    tint: Color? = nil,
    padding: CGFloat = 16
  ) -> some View {
    modifier(LiquidGlassPanelModifier(cornerRadius: cornerRadius, tint: tint, padding: padding))
  }
}

private struct AppleDesignTopicCard: View {
  let topic: AppleDesignTopic
  let isFavorite: Bool
  let onToggleFavorite: () -> Void
  let onSelect: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(alignment: .top) {
        Image(systemName: topic.icon)
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(Color(hex: topic.tintHex))
          .frame(width: 44, height: 44)
          .background(Color(hex: topic.tintHex).opacity(0.14), in: Circle())

        Spacer()

        Button(action: onToggleFavorite) {
          Image(systemName: isFavorite ? "star.fill" : "star")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(isFavorite ? Color.yellow : Color.secondary)
            .frame(width: 32, height: 32)
            .background(Color(uiColor: .tertiarySystemFill), in: Circle())
        }
        .buttonStyle(.plain)
      }

      Text(topic.koreanTitle)
        .font(.system(size: 18, weight: .semibold))
        .foregroundStyle(.primary)

      Text(topic.summary)
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(.secondary)
        .lineLimit(3)

      HStack(spacing: 6) {
        Text(topic.sectionTitle)
          .lineLimit(1)
        Text("•")
        Text(topic.name)
          .lineLimit(1)
      }
      .font(.system(size: 12, weight: .medium))
      .foregroundStyle(.secondary)

      Text(topic.higPathTitle)
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(.tertiary)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, minHeight: 196, alignment: .topLeading)
    .liquidGlassPanel(cornerRadius: 24, tint: Color(hex: topic.tintHex), padding: 14)
    .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    .onTapGesture(perform: onSelect)
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

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 18) {
          MotionPreviewView(topic: topic)

          VStack(alignment: .leading, spacing: 10) {
            Text(topic.koreanTitle)
              .font(.system(size: 24, weight: .bold))
              .accessibilityAddTraits(.isHeader)

            Text(topic.summary)
              .font(.system(size: 15, weight: .regular))
              .foregroundStyle(.secondary)

            metadataRow(title: "분류", value: topic.sectionTitle)
            metadataRow(title: "HIG 경로", value: topic.higPathTitle)
            metadataRow(title: "플랫폼 메모", value: topic.platformNotes)
          }
          .liquidGlassPanel(tint: Color(hex: topic.tintHex))

          VStack(alignment: .leading, spacing: 12) {
            Text("핵심 포인트")
              .font(.system(size: 20, weight: .semibold))
              .accessibilityAddTraits(.isHeader)

            ForEach(topic.keyPoints, id: \.self) { point in
              HStack(alignment: .top, spacing: 10) {
                Circle()
                  .fill(Color(hex: topic.tintHex))
                  .frame(width: 8, height: 8)
                  .padding(.top, 6)
                Text(point)
                  .font(.system(size: 15, weight: .regular))
                  .foregroundStyle(.primary)
              }
            }
          }
          .liquidGlassPanel(tint: Color(hex: topic.tintHex))

          VStack(alignment: .leading, spacing: 12) {
            Text("SwiftUI 참고")
              .font(.system(size: 20, weight: .semibold))
              .accessibilityAddTraits(.isHeader)

            Text(topic.swiftUIReference)
              .font(.system(size: 15, weight: .medium))
              .foregroundStyle(.primary)

            Text(snippet)
              .font(.system(.footnote, design: .monospaced))
              .frame(maxWidth: .infinity, alignment: .leading)
              .liquidGlassPanel(cornerRadius: 16, tint: Color(hex: topic.tintHex), padding: 12)
          }
          .liquidGlassPanel(tint: Color(hex: topic.tintHex))

          VStack(alignment: .leading, spacing: 12) {
            Text("공식 가이드")
              .font(.system(size: 20, weight: .semibold))
              .accessibilityAddTraits(.isHeader)

            if let topicURL {
              Link("공식 HIG 열기", destination: topicURL)
                .font(.system(size: 16, weight: .semibold))
            }

            Text(topic.higUrl)
              .font(.system(size: 13, weight: .regular))
              .foregroundStyle(.secondary)

            Text(topic.isSystemDemo ? "이 장면은 시스템 화면 구조를 축약한 데모입니다." : "이 장면은 HIG 항목의 사용 맥락을 빠르게 떠올리기 위한 reference preview입니다.")
              .font(.system(size: 13, weight: .regular))
              .foregroundStyle(.secondary)
          }
          .liquidGlassPanel(tint: Color(hex: topic.tintHex))
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 30)
      }
      .background {
        LiquidGlassLibraryBackground()
      }
      .navigationTitle(topic.koreanTitle)
      .navigationBarTitleDisplayMode(.inline)
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
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(.secondary)
      Text(value)
        .font(.system(size: 15, weight: .regular))
        .foregroundStyle(.primary)
    }
  }
}

private struct AppleDesignLibraryHomeScreen: View {
  let topics: [AppleDesignTopic]
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var selectedLibraryKind: AppleLibraryKind = .patterns
  @State private var query = ""
  @State private var selectedTopic: AppleDesignTopic?

  private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

  private var filteredTopics: [AppleDesignTopic] {
    topics.filter { topic in
      topic.libraryKind == selectedLibraryKind &&
      (query.isEmpty ||
       topic.name.localizedCaseInsensitiveContains(query) ||
       topic.koreanTitle.localizedCaseInsensitiveContains(query) ||
       topic.sectionTitle.localizedCaseInsensitiveContains(query) ||
       topic.tags.contains(where: { $0.localizedCaseInsensitiveContains(query) }))
    }
  }

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          Text("애플 디자인 라이브러리")
            .font(.system(size: 34, weight: .bold))
            .accessibilityAddTraits(.isHeader)

          Text("Apple Human Interface Guidelines를 기준으로 패턴과 구성요소를 빠르게 탐색하는 내부 reference 라이브러리입니다.")
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(.secondary)
            .liquidGlassPanel(cornerRadius: 20, padding: 14)

          HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
              .foregroundStyle(.secondary)
            TextField("패턴 또는 구성요소 검색", text: $query)
              .textInputAutocapitalization(.never)
              .disableAutocorrection(true)
          }
          .liquidGlassPanel(cornerRadius: 18, padding: 12)

          Picker("라이브러리 분류", selection: $selectedLibraryKind) {
            ForEach(AppleLibraryKind.allCases) { kind in
              Text(kind.koreanTitle).tag(kind)
            }
          }
          .pickerStyle(.segmented)
          .liquidGlassPanel(cornerRadius: 22, padding: 8)

          HStack {
            Text(selectedLibraryKind == .patterns ? "패턴 주제" : "구성요소 주제")
              .font(.system(size: 28, weight: .bold))
              .accessibilityAddTraits(.isHeader)
            Spacer()
            Text("\(filteredTopics.count)개")
              .font(.system(size: 15, weight: .semibold))
              .foregroundStyle(.secondary)
          }

          LazyVGrid(columns: columns, spacing: 12) {
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
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 22)
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

private struct FavoritesScreen: View {
  let topics: [AppleDesignTopic]
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var selectedTopic: AppleDesignTopic?

  private var favoriteTopics: [AppleDesignTopic] {
    topics.filter { favoritesStore.isFavorite($0.id) }
  }

  var body: some View {
    CompatibleNavigationContainer {
      Group {
        if favoriteTopics.isEmpty {
          VStack(spacing: 10) {
            Image(systemName: "star")
              .font(.system(size: 34, weight: .regular))
              .foregroundStyle(.secondary)
            Text("저장한 라이브러리 항목이 없습니다")
              .font(.system(size: 18, weight: .semibold))
            Text("라이브러리에서 별 버튼으로 topic을 저장해 보세요")
              .font(.system(size: 14, weight: .regular))
              .foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding(.horizontal, 16)
          .liquidGlassPanel(cornerRadius: 28)
          .background {
            LiquidGlassLibraryBackground()
          }
        } else {
          ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
              ForEach(favoriteTopics) { topic in
                AppleDesignTopicCard(
                  topic: topic,
                  isFavorite: favoritesStore.isFavorite(topic.id),
                  onToggleFavorite: { favoritesStore.toggle(topic.id) },
                  onSelect: { selectedTopic = topic }
                )
              }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 20)
          }
          .background {
            LiquidGlassLibraryBackground()
          }
        }
      }
      .navigationTitle("즐겨찾기")
      .navigationBarTitleDisplayMode(.large)
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
        VStack(alignment: .leading, spacing: 16) {
          VStack(alignment: .leading, spacing: 12) {
            Text("레이아웃")
              .font(.system(size: 20, weight: .semibold))
              .accessibilityAddTraits(.isHeader)

            Toggle("레이아웃 그리드 표시", isOn: $gridOverlayStore.isVisible)
          }
          .liquidGlassPanel()

          VStack(alignment: .leading, spacing: 12) {
            Text("라이브러리 정보")
              .font(.system(size: 20, weight: .semibold))
              .accessibilityAddTraits(.isHeader)

            Text("이 화면은 Apple Human Interface Guidelines를 빠르게 참조하기 위한 내부 라이브러리입니다.")
              .font(.system(size: 14, weight: .regular))
              .foregroundStyle(.secondary)
          }
          .liquidGlassPanel()

          VStack(alignment: .leading, spacing: 12) {
            Text("현재 스타일")
              .font(.system(size: 20, weight: .semibold))
              .accessibilityAddTraits(.isHeader)

            Text("iOS 26 이상에서는 Liquid Glass 계열 surface를 사용하고, 그 미만에서는 material 기반 fallback을 사용합니다.")
              .font(.system(size: 14, weight: .regular))
              .foregroundStyle(.secondary)
          }
          .liquidGlassPanel()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 28)
      }
      .background {
        LiquidGlassLibraryBackground()
      }
      .navigationTitle("설정")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

private struct AppleDesignLibraryRootTabView: View {
  @State private var selectedTab: RootTab = .library
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
