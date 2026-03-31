# expo-swiftui-hig

Apple Human Interface Guidelines(HIG) 를 준수하는 SwiftUI 컴포넌트 라이브러리입니다. React Native Expo 환경에서 네이티브 iOS 품질의 UI 를 제공합니다.

## 설치

```bash
npm install expo-swiftui-hig
```

## 지원 컴포넌트

### 입력 컨트롤 (Input Controls)

#### HIGButton
Apple HIG 가이드라인을 따르는 버튼 컴포넌트입니다.

```tsx
import { HIGButton } from 'expo-swiftui-hig';

// 기본 사용법
<HIGButton 
  title="확인" 
  variant="filled" 
  size="medium"
  onPress={() => console.log('pressed')}
/>

// 로딩 상태
<HIGButton 
  title="저장 중..." 
  isLoading={true} 
/>

// 비활성화
<HIGButton 
  title="제출" 
  isDisabled={true} 
/>

// 아웃라인 스타일
<HIGButton 
  title="취소" 
  variant="outlined" 
  accentColorHex="#007AFF"
/>
```

**Props:**
- `title`: 버튼 텍스트
- `variant`: `filled` | `outlined` | `plain` | `linked`
- `size`: `small` | `medium` | `large`
- `accentColorHex`: 강조 색상 (hex 값)
- `isLoading`: 로딩 상태 표시
- `isDisabled`: 비활성화 여부
- `onPress`: 클릭 이벤트

#### HIGTextField
Apple HIG 가이드라인을 따르는 텍스트 입력 필드입니다.

```tsx
import { HIGTextField } from 'expo-swiftui-hig';

// 기본 사용법
<HIGTextField 
  placeholder="이메일을 입력하세요"
  value={email}
  onChangeText={(e) => setEmail(e.nativeEvent.text)}
/>

// 비밀번호 필드
<HIGTextField 
  placeholder="비밀번호"
  isSecure={true}
/>

// 에러 상태
<HIGTextField 
  placeholder="이메일"
  isError={true}
  errorMessage="유효하지 않은 이메일 주소입니다"
/>

// 언더라인 스타일
<HIGTextField 
  placeholder="검색"
  variant="underline"
/>
```

**Props:**
- `placeholder`: 플레이스홀더 텍스트
- `value`: 입력 값
- `variant`: `rounded` | `underline` | `filled`
- `isSecure`: 비밀번호 모드
- `isError`: 에러 상태
- `errorMessage`: 에러 메시지
- `accentColorHex`: 강조 색상
- `onChangeText`: 값 변경 이벤트
- `onSubmitEditing`: 제출 이벤트

### 피드백 (Feedback)

#### HIGBadge
알림 배지 및 카운터 표시 컴포넌트입니다.

```tsx
import { HIGBadge } from 'expo-swiftui-hig';

// 기본 배지
<HIGBadge value="3" />

// 작은 크기
<HIGBadge value="9+" size="small" />

// 아웃라인 스타일
<HIGBadge value="새로운" variant="outlined" accentColorHex="#34C759" />
```

**Props:**
- `value`: 표시할 텍스트
- `variant`: `filled` | `outlined`
- `size`: `small` | `medium` | `large`
- `accentColorHex`: 배경 색상

#### HIGToggle
토글 스위치 컴포넌트입니다.

```tsx
import { HIGToggle } from 'expo-swiftui-hig';

// 기본 토글
<HIGToggle 
  label="알림 받기"
  isOn={notificationsEnabled}
  onValueChange={(e) => setNotificationsEnabled(e.nativeEvent.isOn)}
/>

// 커스텀 색상
<HIGToggle 
  label="프리미엄"
  isOn={isPremium}
  accentColorHex="#AF52DE"
/>

// 비활성화
<HIGToggle 
  label="사용 불가"
  isDisabled={true}
/>
```

**Props:**
- `label`: 라벨 텍스트 (선택사항)
- `isOn`: 토글 상태
- `accentColorHex`: 강조 색상
- `isDisabled`: 비활성화 여부
- `onValueChange`: 값 변경 이벤트

#### HIGSlider
범위 선택 슬라이더 컴포넌트입니다.

```tsx
import { HIGSlider } from 'expo-swiftui-hig';

// 기본 슬라이더
<HIGSlider 
  value={volume}
  onValueChange={(e) => setVolume(e.nativeEvent.value)}
/>

// 범위 지정
<HIGSlider 
  minimumValue={0}
  maximumValue={100}
  value={brightness}
  showValueLabel={true}
/>

// 커스텀 색상
<HIGSlider 
  value={progress}
  accentColorHex="#FF9500"
/>
```

**Props:**
- `minimumValue`: 최소값 (기본: 0.0)
- `maximumValue`: 최대값 (기본: 1.0)
- `value`: 현재 값
- `accentColorHex`: 강조 색상
- `isDisabled`: 비활성화 여부
- `showValueLabel`: 값 레이블 표시 여부
- `onValueChange`: 값 변경 이벤트

## 디자인 토큰

Apple HIG 에서 정의한 디자인 토큰을 제공합니다.

```tsx
import { HIGDesignTokens } from 'expo-swiftui-hig';

// 시스템 색상
HIGDesignTokens.colors.systemBlue;   // #007AFF
HIGDesignTokens.colors.systemRed;    // #FF3B30
HIGDesignTokens.colors.systemGreen;  // #34C759

// 간격 (8pt 그리드 시스템)
HIGDesignTokens.spacing.small;   // 12
HIGDesignTokens.spacing.medium;  // 16
HIGDesignTokens.spacing.large;   // 20

// 코너 반경
HIGDesignTokens.cornerRadius.small;   // 6
HIGDesignTokens.cornerRadius.medium;  // 10
HIGDesignTokens.cornerRadius.large;   // 12
```

## 다크모드 지원

모든 컴포넌트는 iOS 시스템 다크모드를 자동으로 지원합니다. 추가 설정 없이도 라이트/다크 모드 전환에 반응합니다.

## 로드맵

다음 컴포넌트들이 개발 예정입니다:

- [x] Toggle / Switch ✅
- [x] Slider ✅
- [ ] List & Row
- [ ] NavigationBar
- [ ] Toolbar
- [ ] TabBar
- [ ] Alert / Toast
- [ ] ProgressIndicator
- [ ] Picker / DatePicker
- [ ] SegmentedControl
- [ ] Card
- [ ] Sheet / Modal
- [ ] ActionSheet
- [ ] Popover

## 라이선스

MIT License
