import SwiftUI

struct MotionPreviewView: View {
  let topic: AppleDesignTopic

  @State private var isLaunched = false
  @State private var loadingComplete = false
  @State private var searchQuery = ""
  @State private var isSearchFocused = false
  @FocusState private var isTextFieldFocused: Bool
  @State private var selectedPage = 0
  @State private var pickerSelection = 1
  @State private var toggleValue = true
  @State private var modalOffset: CGFloat = 136
  @State private var isMenuPresented = false
  @State private var shareSheetPresented = false
  @State private var buttonIsPressed = false
  @State private var selectedSwatch = 0
  @State private var selectedListRow = 1
  @State private var selectedCollectionCard = 0
  @State private var draftText = "designer@apple.com"

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      ZStack {
        previewShell
        previewScene
          .padding(18)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .frame(height: 264)

      Text(interactionHint)
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 4)
    }
    .onAppear(perform: resetScene)
  }

  @ViewBuilder
  private var previewScene: some View {
    switch topic.previewKind {
    case .launch:
      launchScene
    case .loading:
      loadingScene
    case .search:
      searchScene
    case .onboarding:
      onboardingScene
    case .modal:
      modalScene
    case .share:
      shareScene
    case .menu:
      menuScene
    case .writing:
      writingScene
    case .button:
      buttonScene
    case .collection:
      collectionScene
    case .colorWell:
      colorWellScene
    case .icon:
      iconScene
    case .image:
      imageScene
    case .label:
      labelScene
    case .list:
      listScene
    case .pageControl:
      pageControlScene
    case .picker:
      pickerScene
    case .progress:
      progressScene
    case .segmentedControl:
      segmentedControlScene
    case .textField:
      textFieldScene
    case .toggle:
      toggleScene
    }
  }

  private var sceneTint: Color {
    Color(hex: topic.tintHex)
  }

  private var interactionHint: String {
    switch topic.previewKind {
    case .modal, .share, .pageControl:
      return "탭하거나 스와이프해 실제 전환 반응을 확인할 수 있습니다."
    case .toggle, .picker, .segmentedControl, .textField:
      return "실제 컨트롤을 직접 조작해 상태 변화를 확인할 수 있습니다."
    default:
      return "샘플을 직접 탭해 화면 반응과 상태 변화를 확인할 수 있습니다."
    }
  }

  private var previewShell: some View {
    let shape = RoundedRectangle(cornerRadius: 28, style: .continuous)

    return ZStack {
      LinearGradient(
        colors: [
          sceneTint.opacity(0.16),
          sceneTint.opacity(0.07),
          Color.white.opacity(0.72)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )

      if #available(iOS 26.0, *) {
        shape
          .fill(.clear)
          .glassEffect(.regular, in: shape)
      } else {
        shape
          .fill(.ultraThinMaterial)
      }
    }
    .clipShape(shape)
    .overlay(
      shape
        .stroke(.white.opacity(0.44), lineWidth: 0.8)
    )
    .shadow(color: .black.opacity(0.08), radius: 24, y: 10)
  }

  private func resetScene() {
    isLaunched = false
    loadingComplete = false
    searchQuery = ""
    isSearchFocused = false
    isTextFieldFocused = false
    selectedPage = 0
    pickerSelection = 1
    toggleValue = true
    modalOffset = 136
    isMenuPresented = false
    shareSheetPresented = false
    buttonIsPressed = false
    selectedSwatch = 0
    selectedListRow = 1
    selectedCollectionCard = 0
    draftText = "designer@apple.com"
  }

  private var launchScene: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(sceneTint.opacity(0.09))

      if isLaunched {
        VStack(alignment: .leading, spacing: 12) {
          RoundedRectangle(cornerRadius: 7, style: .continuous)
            .fill(sceneTint.opacity(0.2))
            .frame(width: 122, height: 12)

          RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(.white.opacity(0.84))
            .frame(height: 96)

          HStack(spacing: 10) {
            ForEach(0..<2, id: \.self) { _ in
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.6))
                .frame(height: 56)
            }
          }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.96)))
        .padding(18)
      } else {
        VStack(spacing: 12) {
          Image(systemName: topic.icon)
            .font(.system(size: 32, weight: .semibold))
            .foregroundStyle(sceneTint)
          Text("Tap to Launch")
            .font(.system(size: 16, weight: .semibold))
        }
        .transition(.opacity.combined(with: .scale(scale: 1.04)))
      }
    }
    .animation(.spring(duration: 0.45, bounce: 0.14), value: isLaunched)
    .onTapGesture {
      isLaunched.toggle()
    }
  }

  private var loadingScene: some View {
    VStack(alignment: .leading, spacing: 14) {
      HStack {
        Text(loadingComplete ? "Loaded" : "Loading")
          .font(.system(size: 14, weight: .semibold))
        Spacer()
        Button(loadingComplete ? "Reset" : "Complete") {
          withAnimation(.easeInOut(duration: 0.25)) {
            loadingComplete.toggle()
          }
        }
        .applyPreviewGlassButtonStyle()
      }

      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(.white.opacity(0.62))
        .frame(height: 96)
        .overlay(alignment: .topLeading) {
          VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(sceneTint.opacity(0.22))
              .frame(width: loadingComplete ? 116 : 86, height: 11)
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .fill(Color.white.opacity(loadingComplete ? 0.9 : 0.48))
              .frame(height: 10)
            ProgressView(value: loadingComplete ? 1.0 : 0.34)
              .tint(sceneTint)
          }
          .padding(16)
        }

      if loadingComplete {
        HStack(spacing: 10) {
          Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(sceneTint)
          Text("콘텐츠가 준비되어 실제 화면으로 전환됩니다.")
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.secondary)
        }
      } else {
        HStack(spacing: 10) {
          ProgressView()
            .tint(sceneTint)
          Text("콘텐츠 준비 중")
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.secondary)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }

  private var searchScene: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        Image(systemName: "magnifyingglass")
          .foregroundStyle(isSearchFocused ? sceneTint : .secondary)
        Text(searchQuery.isEmpty ? "검색어 입력" : searchQuery)
          .foregroundStyle(searchQuery.isEmpty ? .secondary : .primary)
        Spacer()
      }
      .padding(.horizontal, 12)
      .frame(height: 42)
      .background(.white.opacity(0.52), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .stroke(sceneTint.opacity(isSearchFocused ? 0.7 : 0.0), lineWidth: 1.5)
      )
      .onTapGesture {
        withAnimation(.easeInOut(duration: 0.2)) {
          isSearchFocused = true
          searchQuery = searchQuery.isEmpty ? "Safari" : ""
        }
      }

      VStack(spacing: 10) {
        searchRow(title: "최근 검색", subtitle: "디자인 시스템", isHighlighted: searchQuery.isEmpty)
        searchRow(title: "검색 결과", subtitle: searchQuery.isEmpty ? "추천 결과" : "\"\(searchQuery)\" 관련 결과", isHighlighted: !searchQuery.isEmpty)
        searchRow(title: "추천", subtitle: "패턴과 구성요소", isHighlighted: false)
      }
    }
  }

  private func searchRow(title: String, subtitle: String, isHighlighted: Bool) -> some View {
    HStack(spacing: 10) {
      Circle()
        .fill(isHighlighted ? sceneTint : Color(uiColor: .systemGray4))
        .frame(width: 10, height: 10)
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.system(size: 13, weight: .semibold))
          .foregroundStyle(.primary)
        Text(subtitle)
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(.secondary)
      }
      Spacer()
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .background(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .fill(isHighlighted ? sceneTint.opacity(0.14) : .white.opacity(0.42))
    )
  }

  private var onboardingScene: some View {
    VStack(spacing: 14) {
      TabView(selection: $selectedPage) {
        onboardingCard(title: "권한 안내", subtitle: "핵심 기능을 쓰기 전에 필요한 정보를 설명합니다.", icon: topic.icon)
          .tag(0)
        onboardingCard(title: "가치 제안", subtitle: "앱의 주요 흐름을 한 화면씩 보여줍니다.", icon: "sparkles")
          .tag(1)
        onboardingCard(title: "시작 준비", subtitle: "완료 후 즉시 메인 작업으로 이어집니다.", icon: "checkmark.circle.fill")
          .tag(2)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))

      HStack(spacing: 8) {
        ForEach(0..<3, id: \.self) { index in
          dot(isActive: selectedPage == index)
        }
      }
    }
  }

  private func onboardingCard(title: String, subtitle: String, icon: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Image(systemName: icon)
        .font(.system(size: 24, weight: .medium))
        .foregroundStyle(sceneTint)
      Text(title)
        .font(.system(size: 16, weight: .semibold))
      Text(subtitle)
        .font(.system(size: 13, weight: .regular))
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(18)
    .background(.white.opacity(0.46), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    .padding(.horizontal, 2)
  }

  private var modalScene: some View {
    ZStack(alignment: .bottom) {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(.white.opacity(0.18))
        .overlay(Color.black.opacity(backdropOpacity))
        .onTapGesture {
          dismissSheet()
        }

      VStack(spacing: 12) {
        Capsule()
          .fill(Color.white.opacity(0.9))
          .frame(width: 44, height: 5)
          .padding(.top, 10)

        VStack(alignment: .leading, spacing: 10) {
          Text("Focused Task")
            .font(.system(size: 16, weight: .semibold))
          Text("탭으로 열고 아래로 드래그해 닫는 시트 프레젠테이션입니다.")
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(.secondary)
        }

        Button(modalOffset < 100 ? "Dismiss" : "Present") {
          if modalOffset < 100 {
            dismissSheet()
          } else {
            presentSheet()
          }
        }
        .applyPreviewGlassProminentButtonStyle()
      }
      .padding(.horizontal, 18)
      .frame(maxWidth: .infinity)
      .frame(height: 148)
      .background(.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
      .offset(y: modalOffset)
      .gesture(
        DragGesture()
          .onChanged { value in
            modalOffset = max(0, value.translation.height)
          }
          .onEnded { value in
            if value.translation.height > 70 {
              dismissSheet()
            } else {
              presentSheet()
            }
          }
      )
    }
    .onTapGesture {
      if modalOffset >= 100 {
        presentSheet()
      }
    }
  }

  private var backdropOpacity: Double {
    max(0.04, 0.18 - (modalOffset / 900))
  }

  private func presentSheet() {
    withAnimation(.spring(duration: 0.4, bounce: 0.18)) {
      modalOffset = 0
    }
  }

  private func dismissSheet() {
    withAnimation(.spring(duration: 0.4, bounce: 0.12)) {
      modalOffset = 136
    }
  }

  private var shareScene: some View {
    ZStack(alignment: .bottom) {
      listScene

      VStack(spacing: 14) {
        Capsule()
          .fill(Color.white.opacity(0.9))
          .frame(width: 54, height: 6)

        HStack(spacing: 14) {
          shareAction(symbol: "person.crop.circle", title: "AirDrop")
          shareAction(symbol: "message.fill", title: "메시지")
          shareAction(symbol: "square.and.arrow.up", title: "공유")
        }
      }
      .padding(.top, 14)
      .padding(.bottom, 18)
      .frame(maxWidth: .infinity)
      .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
      .offset(y: shareSheetPresented ? 0 : 150)
      .animation(.spring(duration: 0.42, bounce: 0.16), value: shareSheetPresented)
    }
    .onTapGesture {
      shareSheetPresented.toggle()
    }
  }

  private func shareAction(symbol: String, title: String) -> some View {
    VStack(spacing: 8) {
      Circle()
        .fill(sceneTint.opacity(0.18))
        .frame(width: 46, height: 46)
        .overlay {
          Image(systemName: symbol)
            .foregroundStyle(sceneTint)
        }
      Text(title)
        .font(.system(size: 12, weight: .medium))
    }
  }

  private var menuScene: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 22, style: .continuous)
        .fill(.white.opacity(0.22))

      VStack {
        HStack {
          Spacer()
          Circle()
            .fill(sceneTint.opacity(0.18))
            .frame(width: 44, height: 44)
            .overlay {
              Image(systemName: "ellipsis")
                .foregroundStyle(sceneTint)
            }
            .onTapGesture {
              withAnimation(.spring(duration: 0.28, bounce: 0.12)) {
                isMenuPresented.toggle()
              }
            }
        }
        Spacer()
      }

      if isMenuPresented {
        VStack(alignment: .leading, spacing: 10) {
          menuItem(symbol: "pencil", title: "Rename", destructive: false)
          menuItem(symbol: "star", title: "Favorite", destructive: false)
          menuItem(symbol: "trash", title: "Delete", destructive: true)
        }
        .padding(14)
        .frame(width: 144)
        .background(.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .offset(x: 32, y: 8)
        .transition(.opacity.combined(with: .scale(scale: 0.94)))
      }
    }
  }

  private func menuItem(symbol: String, title: String, destructive: Bool) -> some View {
    HStack(spacing: 10) {
      Image(systemName: symbol)
        .foregroundStyle(destructive ? Color.red : sceneTint)
      Text(title)
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(destructive ? .red : .primary)
      Spacer()
    }
  }

  private var writingScene: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 10) {
        Button("Insert") {
          selectedPage = 1
        }
        .applyPreviewGlassButtonStyle()

        Button("Review") {
          selectedPage = 2
        }
        .applyPreviewGlassButtonStyle()

        Spacer()
      }

      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(.white.opacity(0.48))
        .overlay(alignment: .topLeading) {
          VStack(alignment: .leading, spacing: 10) {
            Text(selectedPage == 2 ? "Comment mode" : "Draft mode")
              .font(.system(size: 14, weight: .semibold))
            Text(selectedPage == 2 ? "리뷰 메모와 수정 제안이 강조됩니다." : "작성 중인 본문이 집중 상태로 유지됩니다.")
              .font(.system(size: 12, weight: .regular))
              .foregroundStyle(.secondary)
            Rectangle()
              .fill(sceneTint)
              .frame(width: 2, height: 24)
              .opacity(0.9)
          }
          .padding(18)
        }
    }
  }

  private var buttonScene: some View {
    VStack(spacing: 16) {
      Spacer()

      Button("Continue") {}
        .applyPreviewGlassProminentButtonStyle()
        .frame(maxWidth: .infinity)
        .scaleEffect(buttonIsPressed ? 0.96 : 1.0)
        .simultaneousGesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in buttonIsPressed = true }
            .onEnded { _ in
              withAnimation(.easeOut(duration: 0.18)) {
                buttonIsPressed = false
              }
            }
        )

      Button("Later") {}
        .applyPreviewGlassButtonStyle()
        .frame(maxWidth: .infinity)

      Spacer()
    }
  }

  private var collectionScene: some View {
    VStack(spacing: 10) {
      HStack(spacing: 10) {
        collectionCard(index: 0, title: "Featured")
        collectionCard(index: 1, title: "Recent")
      }
      HStack(spacing: 10) {
        collectionCard(index: 2, title: "Saved")
        collectionCard(index: 3, title: "Shared")
      }
    }
  }

  private func collectionCard(index: Int, title: String) -> some View {
    let isSelected = selectedCollectionCard == index

    return VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 13, weight: .semibold))
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(isSelected ? sceneTint.opacity(0.28) : Color.white.opacity(0.48))
        .frame(height: 10)
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(Color.white.opacity(0.4))
        .frame(height: 10)
    }
    .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
    .padding(14)
    .background(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(isSelected ? sceneTint.opacity(0.16) : .white.opacity(0.3))
    )
    .onTapGesture {
      selectedCollectionCard = index
    }
  }

  private var colorWellScene: some View {
    HStack(spacing: 16) {
      ForEach(Array([sceneTint, .orange, .mint].enumerated()), id: \.offset) { index, color in
        Circle()
          .fill(color)
          .frame(width: 48, height: 48)
          .overlay(
            Circle()
              .stroke(Color.white.opacity(selectedSwatch == index ? 1.0 : 0.0), lineWidth: 3)
              .padding(4)
          )
          .onTapGesture {
            selectedSwatch = index
          }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var iconScene: some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        iconTile("heart.fill")
        iconTile("star.fill")
        iconTile("paperplane.fill")
      }
      HStack(spacing: 12) {
        iconTile("person.fill")
        iconTile("house.fill")
        iconTile("bookmark.fill")
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func iconTile(_ symbol: String) -> some View {
    RoundedRectangle(cornerRadius: 16, style: .continuous)
      .fill(.white.opacity(0.4))
      .frame(width: 54, height: 54)
      .overlay {
        Image(systemName: symbol)
          .foregroundStyle(sceneTint)
      }
  }

  private var imageScene: some View {
    VStack(spacing: 10) {
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(
          LinearGradient(
            colors: [sceneTint.opacity(0.4), sceneTint.opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .frame(height: 118)
        .overlay(alignment: .bottomLeading) {
          RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(Color.white.opacity(0.82))
            .frame(width: 90, height: 10)
            .padding(14)
        }

      HStack(spacing: 10) {
        ForEach(0..<2, id: \.self) { index in
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(index == selectedCollectionCard ? sceneTint.opacity(0.18) : .white.opacity(0.34))
            .frame(height: 54)
            .onTapGesture {
              selectedCollectionCard = index
            }
        }
      }
    }
  }

  private var labelScene: some View {
    VStack(alignment: .leading, spacing: 12) {
      Label("Primary label", systemImage: "star.fill")
        .font(.system(size: 17, weight: .semibold))
      Label("Secondary description", systemImage: "clock")
        .foregroundStyle(.secondary)
      Label("Status", systemImage: "checkmark.circle.fill")
        .foregroundStyle(sceneTint)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
  }

  private var listScene: some View {
    VStack(spacing: 10) {
      listRow(index: 0, title: "Settings", subtitle: "General preferences")
      listRow(index: 1, title: "Notifications", subtitle: "Immediate updates")
      listRow(index: 2, title: "Privacy", subtitle: "Focused controls")
    }
  }

  private func listRow(index: Int, title: String, subtitle: String) -> some View {
    let isSelected = selectedListRow == index

    return HStack(spacing: 10) {
      Circle()
        .fill(isSelected ? sceneTint : Color(uiColor: .systemGray4))
        .frame(width: 10, height: 10)

      VStack(alignment: .leading, spacing: 5) {
        Text(title)
          .font(.system(size: 14, weight: .semibold))
        Text(subtitle)
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(.secondary)
      }

      Spacer()

      Image(systemName: "chevron.right")
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(.tertiary)
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 12)
    .background(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(isSelected ? sceneTint.opacity(0.12) : .white.opacity(0.34))
    )
    .onTapGesture {
      selectedListRow = index
    }
  }

  private var pageControlScene: some View {
    VStack(spacing: 16) {
      TabView(selection: $selectedPage) {
        pageCard(title: "Page One", subtitle: "핵심 내용을 순서대로 살펴봅니다.")
          .tag(0)
        pageCard(title: "Page Two", subtitle: "스와이프로 현재 위치와 다음 화면을 연결합니다.")
          .tag(1)
        pageCard(title: "Page Three", subtitle: "마지막 단계에서 명확한 완료 지점을 보여줍니다.")
          .tag(2)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))

      HStack(spacing: 8) {
        ForEach(0..<3, id: \.self) { index in
          dot(isActive: selectedPage == index)
        }
      }
    }
  }

  private func pageCard(title: String, subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(.system(size: 16, weight: .semibold))
      Text(subtitle)
        .font(.system(size: 13, weight: .regular))
        .foregroundStyle(.secondary)
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .padding(18)
    .background(sceneTint.opacity(0.12), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    .padding(.horizontal, 1)
  }

  private func dot(isActive: Bool) -> some View {
    Capsule(style: .continuous)
      .fill(isActive ? sceneTint : Color(uiColor: .systemGray4))
      .frame(width: isActive ? 18 : 8, height: 8)
  }

  private var pickerScene: some View {
    VStack(spacing: 14) {
      HStack {
        Text("Sort by")
          .font(.system(size: 14, weight: .semibold))
        Spacer()
      }

      Picker("정렬", selection: $pickerSelection) {
        Text("Latest").tag(0)
        Text("Popular").tag(1)
        Text("Saved").tag(2)
      }
      .pickerStyle(.menu)
      .tint(sceneTint)

      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(pickerSelection == 2 ? sceneTint.opacity(0.16) : .white.opacity(0.36))
        .frame(height: 108)
        .overlay {
          Text(["Latest first", "Popular now", "Saved collection"][pickerSelection])
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(pickerSelection == 2 ? sceneTint : .secondary)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }

  private var progressScene: some View {
    VStack(alignment: .leading, spacing: 18) {
      ProgressView(value: loadingComplete ? 1.0 : 0.28)
        .tint(sceneTint)

      HStack(spacing: 18) {
        ProgressView()
          .controlSize(.large)
          .tint(sceneTint)
          .opacity(loadingComplete ? 0.0 : 1.0)
        VStack(alignment: .leading, spacing: 6) {
          RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(sceneTint.opacity(0.22))
            .frame(width: 82, height: 10)
          RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(Color.white.opacity(0.52))
            .frame(width: 110, height: 8)
        }
      }

      Button(loadingComplete ? "Run Again" : "Complete Task") {
        withAnimation(.easeInOut(duration: 0.2)) {
          loadingComplete.toggle()
        }
      }
      .applyPreviewGlassButtonStyle()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }

  private var segmentedControlScene: some View {
    VStack(spacing: 16) {
      Picker("보기 방식", selection: $pickerSelection) {
        Text("패턴").tag(0)
        Text("구성요소").tag(1)
        Text("저장").tag(2)
      }
      .pickerStyle(.segmented)

      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(pickerSelection == 2 ? sceneTint.opacity(0.12) : .white.opacity(0.34))
        .frame(height: 112)
        .overlay {
          Text(["패턴 보기", "구성요소 보기", "저장된 보기"][pickerSelection])
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(pickerSelection == 2 ? sceneTint : .secondary)
        }
    }
  }

  private var textFieldScene: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Email")
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(.secondary)

      TextField("designer@apple.com", text: $draftText)
        .textFieldStyle(.plain)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.white.opacity(0.52), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
          RoundedRectangle(cornerRadius: 14, style: .continuous)
            .stroke(sceneTint.opacity(isTextFieldFocused ? 0.68 : 0.0), lineWidth: 1.5)
        )
        .focused($isTextFieldFocused)
        .onTapGesture {
          isTextFieldFocused = true
        }

      Text(isTextFieldFocused ? "입력 중에는 focus ring이 유지됩니다." : "필드를 탭해 focus 상태를 확인해 보세요.")
        .font(.system(size: 12, weight: .regular))
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }

  private var toggleScene: some View {
    VStack(spacing: 12) {
      Toggle(isOn: $toggleValue) {
        VStack(alignment: .leading, spacing: 4) {
          Text("Notifications")
            .font(.system(size: 15, weight: .semibold))
          Text("즉시 반영되는 설정")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(.secondary)
        }
      }
      .toggleStyle(.switch)
      .tint(sceneTint)

      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(toggleValue ? sceneTint.opacity(0.14) : .white.opacity(0.36))
        .frame(height: 86)
        .overlay {
          Text(toggleValue ? "On state preview" : "Off state preview")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(toggleValue ? sceneTint : .secondary)
        }
    }
    .padding(.horizontal, 4)
  }
}

private extension View {
  @ViewBuilder
  func applyPreviewGlassButtonStyle() -> some View {
    if #available(iOS 26.0, *) {
      self.buttonStyle(.glass)
    } else {
      self.buttonStyle(.bordered)
    }
  }

  @ViewBuilder
  func applyPreviewGlassProminentButtonStyle() -> some View {
    if #available(iOS 26.0, *) {
      self.buttonStyle(.glassProminent)
    } else {
      self.buttonStyle(.borderedProminent)
    }
  }
}
