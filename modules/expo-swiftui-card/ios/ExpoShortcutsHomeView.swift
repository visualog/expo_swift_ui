import ExpoModulesCore
import SwiftUI
import UIKit

private enum RootTab: Hashable {
  case library
  case favorites
  case settings
}

private struct GridOverlayView: View {
  private func layoutSpec() -> (columns: Int, margin: CGFloat, gutter: CGFloat) {
    return (columns: 4, margin: 16, gutter: 12)
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

private struct MotionPresetCard: View {
  let preset: MotionPreset
  let isFavorite: Bool
  let onToggleFavorite: () -> Void
  let onSelect: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Image(systemName: preset.icon)
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(Color(hex: preset.tintHex))
          .frame(width: 44, height: 44)
          .background(Color(hex: preset.tintHex).opacity(0.14), in: Circle())

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

      Spacer(minLength: 2)

      Text(preset.name)
        .font(.system(size: 17, weight: .semibold))
        .foregroundStyle(.primary)

      Text(preset.summary)
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(.secondary)
        .lineLimit(2)

      HStack(spacing: 6) {
        Text(preset.easing.title)
        Text("\(Int(preset.duration * 1000))ms")
      }
      .font(.system(size: 12, weight: .medium))
      .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, minHeight: 172, alignment: .topLeading)
    .padding(14)
    .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .stroke(Color(uiColor: .separator).opacity(0.32), lineWidth: 0.5)
    )
    .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    .onTapGesture(perform: onSelect)
  }
}

private struct MotionPresetDetailSheet: View {
  let preset: MotionPreset
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var duration: Double
  @State private var delay: Double
  @State private var easing: MotionEasing
  @State private var intensity: MotionIntensity

  init(preset: MotionPreset, favoritesStore: FavoritesStore) {
    self.preset = preset
    self.favoritesStore = favoritesStore
    _duration = State(initialValue: preset.duration)
    _delay = State(initialValue: preset.delay)
    _easing = State(initialValue: preset.easing)
    _intensity = State(initialValue: preset.intensity)
  }

  private var snippet: String {
    """
    withAnimation(\(easing.rawValue), duration: \(String(format: "%.2f", duration))) {
      // \(preset.name)
    }
    """
  }

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 18) {
          MotionPreviewView(
            preset: preset,
            duration: duration,
            delay: delay,
            easing: easing,
            intensity: intensity
          )

          VStack(alignment: .leading, spacing: 10) {
            Text("파라미터")
              .font(.system(size: 20, weight: .semibold))
              .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 8) {
              HStack {
                Text("Duration")
                Spacer()
                Text("\(Int(duration * 1000))ms")
                  .foregroundStyle(.secondary)
              }
              Slider(value: $duration, in: 0.15...1.2)
            }

            VStack(alignment: .leading, spacing: 8) {
              HStack {
                Text("Delay")
                Spacer()
                Text("\(Int(delay * 1000))ms")
                  .foregroundStyle(.secondary)
              }
              Slider(value: $delay, in: 0...0.4)
            }

            Picker("Easing", selection: $easing) {
              ForEach(MotionEasing.allCases) { item in
                Text(item.title).tag(item)
              }
            }
            .pickerStyle(.segmented)

            Picker("Intensity", selection: $intensity) {
              ForEach(MotionIntensity.allCases) { item in
                Text(item.title).tag(item)
              }
            }
            .pickerStyle(.segmented)
          }
          .padding(14)
          .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))

          VStack(alignment: .leading, spacing: 8) {
            Text("SwiftUI Snippet")
              .font(.system(size: 18, weight: .semibold))
            Text(snippet)
              .font(.system(.footnote, design: .monospaced))
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(12)
              .background(Color(uiColor: .tertiarySystemFill), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
          }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 30)
      }
      .background(Color(uiColor: .systemGroupedBackground))
      .navigationTitle(preset.name)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: { favoritesStore.toggle(preset.id) }) {
            Image(systemName: favoritesStore.isFavorite(preset.id) ? "star.fill" : "star")
          }
        }
      }
    }
  }
}

private struct MotionLibraryHomeScreen: View {
  let presets: [MotionPreset]
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var selectedCategory: MotionCategory = .entrance
  @State private var query = ""
  @State private var selectedPreset: MotionPreset?

  private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

  private var filteredPresets: [MotionPreset] {
    presets.filter { preset in
      preset.category == selectedCategory &&
      (query.isEmpty ||
       preset.name.localizedCaseInsensitiveContains(query) ||
       preset.tags.contains(where: { $0.localizedCaseInsensitiveContains(query) }))
    }
  }

  var body: some View {
    CompatibleNavigationContainer {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          HStack {
            Text("모션 라이브러리")
              .font(.system(size: 34, weight: .bold))
              .accessibilityAddTraits(.isHeader)

            Spacer()

            Button(action: {}) {
              Image(systemName: "plus")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
          }

          HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
              .foregroundStyle(.secondary)
            TextField("모션 검색", text: $query)
              .textInputAutocapitalization(.never)
              .disableAutocorrection(true)
          }
          .padding(.horizontal, 12)
          .padding(.vertical, 10)
          .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

          Picker("카테고리", selection: $selectedCategory) {
            ForEach(MotionCategory.allCases) { category in
              Text(category.title).tag(category)
            }
          }
          .pickerStyle(.segmented)

          HStack {
            Text("프리셋")
              .font(.system(size: 28, weight: .bold))
              .accessibilityAddTraits(.isHeader)
            Spacer()
            Text("\(filteredPresets.count)개")
              .font(.system(size: 15, weight: .semibold))
              .foregroundStyle(.secondary)
          }

          LazyVGrid(columns: columns, spacing: 12) {
            ForEach(filteredPresets) { preset in
              MotionPresetCard(
                preset: preset,
                isFavorite: favoritesStore.isFavorite(preset.id),
                onToggleFavorite: { favoritesStore.toggle(preset.id) },
                onSelect: { selectedPreset = preset }
              )
            }
          }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 22)
      }
      .background(Color(uiColor: .systemGroupedBackground))
      .hideNavigationBarForCustomHeader()
      .sheet(item: $selectedPreset) { preset in
        MotionPresetDetailSheet(preset: preset, favoritesStore: favoritesStore)
      }
    }
  }
}

private struct FavoritesScreen: View {
  let presets: [MotionPreset]
  @ObservedObject var favoritesStore: FavoritesStore

  @State private var selectedPreset: MotionPreset?

  private var favoritePresets: [MotionPreset] {
    presets.filter { favoritesStore.isFavorite($0.id) }
  }

  var body: some View {
    CompatibleNavigationContainer {
      Group {
        if favoritePresets.isEmpty {
          VStack(spacing: 10) {
            Image(systemName: "star")
              .font(.system(size: 34, weight: .regular))
              .foregroundStyle(.secondary)
            Text("즐겨찾기한 모션이 없습니다")
              .font(.system(size: 18, weight: .semibold))
            Text("라이브러리에서 별 버튼으로 저장해 보세요")
              .font(.system(size: 14, weight: .regular))
              .foregroundStyle(.secondary)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color(uiColor: .systemGroupedBackground))
        } else {
          ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
              ForEach(favoritePresets) { preset in
                MotionPresetCard(
                  preset: preset,
                  isFavorite: favoritesStore.isFavorite(preset.id),
                  onToggleFavorite: { favoritesStore.toggle(preset.id) },
                  onSelect: { selectedPreset = preset }
                )
              }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 20)
          }
          .background(Color(uiColor: .systemGroupedBackground))
        }
      }
      .navigationTitle("즐겨찾기")
      .navigationBarTitleDisplayMode(.large)
      .sheet(item: $selectedPreset) { preset in
        MotionPresetDetailSheet(preset: preset, favoritesStore: favoritesStore)
      }
    }
  }
}

private struct SettingsScreen: View {
  @Binding var showGridOverlay: Bool
  @AppStorage("motion_library.default_intensity") private var defaultIntensityRaw = MotionIntensity.normal.rawValue

  var body: some View {
    CompatibleNavigationContainer {
      Form {
        Section("레이아웃") {
          Toggle("레이아웃 그리드 표시", isOn: $showGridOverlay)
        }

        Section("모션 기본값") {
          Picker("기본 강도", selection: $defaultIntensityRaw) {
            ForEach(MotionIntensity.allCases) { item in
              Text(item.title).tag(item.rawValue)
            }
          }
        }
      }
      .navigationTitle("설정")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

private struct MotionLibraryRootTabView: View {
  @State private var selectedTab: RootTab = .library
  @StateObject private var favoritesStore = FavoritesStore()
  @State private var showGridOverlay = true

  private let presets = MotionPreset.sampleData

  @ViewBuilder
  var body: some View {
    ZStack {
      if #available(iOS 18.0, *) {
        TabView(selection: $selectedTab) {
          Tab("라이브러리", systemImage: "sparkles.rectangle.stack.fill", value: .library) {
            MotionLibraryHomeScreen(presets: presets, favoritesStore: favoritesStore)
          }

          Tab("즐겨찾기", systemImage: "star.fill", value: .favorites) {
            FavoritesScreen(presets: presets, favoritesStore: favoritesStore)
          }

          Tab("설정", systemImage: "gearshape.fill", value: .settings) {
            SettingsScreen(showGridOverlay: $showGridOverlay)
          }
        }
        .tabViewStyle(.tabBarOnly)
        .applyLiquidTabBarBehaviorIfAvailable()
        .tint(.blue)
      } else {
        TabView {
          MotionLibraryHomeScreen(presets: presets, favoritesStore: favoritesStore)
            .tabItem {
              Label("라이브러리", systemImage: "sparkles.rectangle.stack.fill")
            }

          FavoritesScreen(presets: presets, favoritesStore: favoritesStore)
            .tabItem {
              Label("즐겨찾기", systemImage: "star.fill")
            }

          SettingsScreen(showGridOverlay: $showGridOverlay)
            .tabItem {
              Label("설정", systemImage: "gearshape.fill")
            }
        }
        .tint(.blue)
      }

      if showGridOverlay {
        GridOverlayView()
          .zIndex(9_999)
      }
    }
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
  private lazy var hostingController: UIHostingController<MotionLibraryRootTabView> = {
    UIHostingController(rootView: MotionLibraryRootTabView())
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
