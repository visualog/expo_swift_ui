# Apple HIG SwiftUI 컴포넌트 라이브러리

Apple Human Interface Guidelines 를 준수하는 SwiftUI 컴포넌트 라이브러리입니다.

## 🎨 구현된 컴포넌트

### 1. HIGButton
- **변형**: filled, outlined, plain, linked
- **크기**: small, medium, large
- **상태**: 로딩, 비활성화
- **특징**: 자동 다크모드 지원, 커스텀 색상

```swift
HIGButton(
    title: "확인",
    variant: .filled,
    size: .medium,
    accentColorHex: "#007AFF",
    isLoading: false,
    isDisabled: false,
    onPress: { print("pressed") }
)
```

### 2. HIGTextField
- **스타일**: rounded, underline, filled
- **기능**: 보안입력, 에러상태, 에러메시지
- **이벤트**: 값변경, 제출

```swift
HIGTextField(
    placeholder: "이메일을 입력하세요",
    value: email,
    variant: .rounded,
    isSecure: false,
    isError: false,
    errorMessage: "",
    onChangeText: { newText in print(newText) }
)
```

### 3. HIGBadge
- **변형**: filled, outlined
- **크기**: small, medium, large
- **용도**: 알림 카운터, 상태표시

```swift
HIGBadge(
    value: "3",
    variant: .filled,
    size: .medium,
    accentColorHex: "#FF3B30"
)
```

### 4. HIGToggle
- **기능**: 라벨표시, 상태변경
- **커스텀**: 색상변경, 비활성화

```swift
HIGToggle(
    label: "알림 받기",
    isOn: true,
    accentColorHex: "#34C759",
    isDisabled: false,
    onValueChange: { isOn in print(isOn) }
)
```

### 5. HIGSlider
- **범위**: 최소/최대값 설정
- **표시**: 값 레이블 표시/숨김
- **이벤트**: 실시간 값 변경

```swift
HIGSlider(
    minimumValue: 0.0,
    maximumValue: 100.0,
    value: 50.0,
    accentColorHex: "#007AFF",
    isDisabled: false,
    showValueLabel: true,
    onValueChange: { value in print(value) }
)
```

## 🎯 디자인 토큰

### 색상 (Colors)
- **시스템 색상**: systemBlue, systemRed, systemGreen, systemOrange, systemYellow, systemPurple, systemPink, systemGray, systemIndigo
- **시맨틱 색상**: primary, secondary, tertiary, background, surface, divider, fill

### 간격 (Spacing) - 8pt 그리드
- extraSmall: 4
- small: 8
- medium: 12
- large: 16
- extraLarge: 20
- xxl: 24
- xxxl: 32
- huge: 40
- massive: 64

### 코너 반경 (Corner Radius)
- small: 6
- medium: 10
- large: 12
- xlarge: 16
- xxlarge: 20
- circular: 999

### 타이포그래피
- **폰트**: SF Pro (System Font)
- **스타일**: regular, medium, semibold, bold
- **크기**: caption, body, headline, title, largeTitle

## 📦 설치 및 사용

### Expo 프로젝트에 추가
```bash
cd your-expo-project
npm install ../modules/expo-swiftui-hig
```

### React Native 에서 사용
```tsx
import { HIGButton, HIGTextField, HIGBadge, HIGToggle, HIGSlider } from 'expo-swiftui-hig';

function MyComponent() {
  const [email, setEmail] = useState('');
  const [toggleOn, setToggleOn] = useState(true);
  const [sliderValue, setSliderValue] = useState(50);

  return (
    <View>
      <HIGButton 
        title="제출" 
        variant="filled" 
        onPress={() => console.log('submitted')}
      />
      
      <HIGTextField 
        placeholder="이메일"
        value={email}
        onChangeText={(e) => setEmail(e.nativeEvent.text)}
      />
      
      <HIGToggle 
        label="알림 받기"
        isOn={toggleOn}
        onValueChange={(e) => setToggleOn(e.nativeEvent.isOn)}
      />
      
      <HIGSlider 
        value={sliderValue}
        onValueChange={(e) => setSliderValue(e.nativeEvent.value)}
      />
      
      <HIGBadge value="새로운" />
    </View>
  );
}
```

## 🌗 다크모드 지원

모든 컴포넌트는 iOS 시스템 다크모드를 자동으로 지원합니다. 별도의 설정 없이 라이트/다크 모드 전환에 반응합니다.

## 📋 개발 로드맵

### ✅ 완료
- [x] 디자인 토큰 시스템
- [x] HIGButton
- [x] HIGTextField
- [x] HIGBadge
- [x] HIGToggle
- [x] HIGSlider

### 🚧 진행 중
- [ ] List & Row
- [ ] NavigationBar
- [ ] ProgressIndicator

### 📅 계획
- [ ] Toolbar
- [ ] TabBar
- [ ] Alert / Toast
- [ ] Picker / DatePicker
- [ ] SegmentedControl
- [ ] Card
- [ ] Sheet / Modal
- [ ] ActionSheet
- [ ] Popover

## 📖 문서

- [README.md](./modules/expo-swiftui-hig/README.md) - 상세 API 문서
- [DEVELOPMENT.md](./modules/expo-swiftui-hig/DEVELOPMENT.md) - 개발 가이드

## 라이선스

MIT License
