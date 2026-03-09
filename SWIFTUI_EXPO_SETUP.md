# Expo + SwiftUI Component Setup

This project is configured to render a native SwiftUI component through a local Expo module.

## Added module

- Local module path: `modules/expo-swiftui-card`
- Native iOS module class: `ExpoSwiftUICardModule`
- Native view class: `ExpoSwiftUICardView`
- JS wrapper: `components/ExpoSwiftUICard.tsx`

## Important

- SwiftUI native components are available only in development builds.
- `Expo Go` does not load local native modules.
- iOS build prerequisites still required on this machine:
  - Accept Xcode license: `sudo xcodebuild -license accept`
  - Install CocoaPods CLI (`pod`)

## Run steps

1. Regenerate native iOS config (if needed):

```bash
npm run prebuild:ios
```

2. Install iOS pods:

```bash
npx pod-install ios
```

3. Run iOS dev build:

```bash
npm run ios
```

## Usage

`App.tsx` already includes a sample:

- Renders `ExpoSwiftUICard`
- Sends `title`, `subtitle`, `accentColorHex` props
- Receives native `onPress` event
