# expo-swiftui-hig 개발 가이드

## 프로젝트 구조

```
modules/expo-swiftui-hig/
├── ios/                      # iOS 네이티브 SwiftUI 구현
│   ├── ExpoSwiftUIHIGModule.swift   # 모듈 정의
│   ├── HIGDesignTokens.swift        # 디자인 토큰
│   ├── HIGButton.swift              # Button 컴포넌트
│   ├── HIGTextField.swift           # TextField 컴포넌트
│   ├── HIGBadge.swift               # Badge 컴포넌트
│   ├── HIGToggle.swift              # Toggle 컴포넌트
│   ├── HIGSlider.swift              # Slider 컴포넌트
│   └── ExpoSwiftUIHIG.podspec       # CocoaPods 명세
├── src/                      # TypeScript/React Native 래퍼
│   └── index.ts
├── package.json
└── README.md
```

## 새 컴포넌트 추가 방법

### 1. iOS SwiftUI 컴포넌트 생성

`ios/HIGNewComponent.swift` 파일 생성:

```swift
import ExpoModulesCore
import SwiftUI

/// Apple HIG [컴포넌트명] 컴포넌트
struct HIGNewComponentContent: View {
  // Props 정의
  let title: String
  let accentColor: Color
  
  var body: some View {
    // SwiftUI 구현
    Text(title)
      .foregroundColor(accentColor)
  }
}

// MARK: - Expo Module View

final class HIGNewComponentView: ExpoView {
  // EventDispatcher 정의
  let onPress = EventDispatcher()
  
  // Props 정의
  var title: String = "Default" {
    didSet { render() }
  }
  
  var accentColorHex: String = "#007AFF" {
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
  
  private func makeRootView() -> HIGNewComponentContent {
    let accentColor = UIColor.fromHex(accentColorHex).map { Color($0) } ?? HIGDesignTokens.systemBlue
    
    return HIGNewComponentContent(
      title: title,
      accentColor: accentColor
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
```

### 2. 모듈 정의 업데이트

`ios/ExpoSwiftUIHIGModule.swift` 에 새 컴포넌트 등록:

```swift
// MARK: - HIGNewComponent

View(HIGNewComponentView.self) {
  Events("onPress")
  
  Prop("title") { (view: HIGNewComponentView, title: String) in
    view.title = title
  }
  
  Prop("accentColorHex") { (view: HIGNewComponentView, accentColorHex: String) in
    view.accentColorHex = accentColorHex
  }
}
```

### 3. TypeScript 래퍼 추가

`src/index.ts` 에 타입 정의 및 컴포넌트 export:

```typescript
// MARK: - HIGNewComponent

export interface HIGNewComponentProps extends ViewProps {
  title?: string;
  accentColorHex?: string;
  onPress?: (event: { nativeEvent: { title: string } }) => void;
}

const NativeHIGNewComponent = requireNativeViewManager<HIGNewComponentProps>('HIGNewComponent');

export function HIGNewComponent({
  title = 'Default',
  accentColorHex = '#007AFF',
  onPress,
  style,
}: HIGNewComponentProps) {
  return (
    <NativeHIGNewComponent
      title={title}
      accentColorHex={accentColorHex}
      onPress={onPress}
      style={style}
    />
  );
}
```

### 4. README.md 업데이트

사용 예제 및 Props 설명 추가.

## 디자인 토큰 사용

### 색상

```swift
HIGDesignTokens.systemBlue
HIGDesignTokens.primary
HIGDesignTokens.secondaryBackground
```

### 간격 (8pt 그리드)

```swift
HIGDesignTokens.Spacing.small.value    // 12
HIGDesignTokens.Spacing.medium.value   // 16
HIGDesignTokens.Spacing.large.value    // 20
```

### 코너 반경

```swift
HIGDesignTokens.CornerRadius.small.value    // 6
HIGDesignTokens.CornerRadius.medium.value   // 10
HIGDesignTokens.CornerRadius.large.value    // 12
```

### 타이포그래피

```swift
HIGDesignTokens.FontSize.body.font
HIGDesignTokens.FontSize.headline.weight
```

## 모범 사례

1. **Apple HIG 준수**: 공식 가이드라인의 색상, 간격, 타이포그래피 따르기
2. **다크모드 지원**: 시스템 색상은 자동으로 다크모드 대응
3. **Dynamic Type**: 글꼴 크기는 Dynamic Type 지원
4. **접근성**: VoiceOver 및 기타 접근성 기능 고려
5. **성능**: `didSet` 에서 `render()` 호출로 불필요한 리렌더링 방지

## 테스트

iOS 시뮬레이터에서 실제 동작 확인:

```bash
cd /workspace
npm run ios
```

## 다음 컴포넌트 후보

- List & Row
- NavigationBar
- Toolbar
- ProgressIndicator
- Picker / DatePicker
- SegmentedControl
- Alert / Toast
- Sheet / Modal
