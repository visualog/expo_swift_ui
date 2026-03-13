const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');

const catalogPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift';
const previewPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreviewView.swift';
const homeViewPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift';

test('preview view switches on preview kind and renders HIG topic scenes', () => {
  const source = fs.readFileSync(previewPath, 'utf8');

  assert.match(source, /let topic: AppleDesignTopic/);
  assert.match(source, /switch topic\.previewKind/);
  assert.match(source, /launchScene/);
  assert.match(source, /loadingScene/);
  assert.match(source, /searchScene/);
  assert.match(source, /menuScene/);
  assert.match(source, /buttonScene/);
  assert.match(source, /collectionScene/);
  assert.match(source, /pageControlScene/);
  assert.match(source, /segmentedControlScene/);
  assert.match(source, /textFieldScene/);
  assert.match(source, /toggleScene/);
  assert.doesNotMatch(source, /switch preset\.id/);
});

test('preview view uses live interaction state instead of replay-only motion', () => {
  const source = fs.readFileSync(previewPath, 'utf8');

  assert.match(source, /@State private var selectedPage =/);
  assert.match(source, /@State private var searchQuery =/);
  assert.match(source, /@State private var isSearchFocused =/);
  assert.match(source, /@FocusState private var isTextFieldFocused:/);
  assert.match(source, /@State private var modalOffset:/);
  assert.match(source, /@State private var isMenuPresented =/);
  assert.match(source, /@State private var shareSheetPresented =/);
  assert.match(source, /@State private var buttonIsPressed =/);
  assert.match(source, /DragGesture/);
  assert.match(source, /onTapGesture/);
  assert.doesNotMatch(source, /Button\("다시 보기"\)/);
  assert.doesNotMatch(source, /\.disabled\(true\)/);
});

test('home and detail surfaces expose HIG metadata instead of motion tuning controls', () => {
  const homeSource = fs.readFileSync(homeViewPath, 'utf8');
  const previewSource = fs.readFileSync(previewPath, 'utf8');
  const catalogSource = fs.readFileSync(catalogPath, 'utf8');

  assert.match(homeSource, /Text\("핵심 포인트"\)/);
  assert.match(homeSource, /Text\("SwiftUI 참고"\)/);
  assert.match(homeSource, /Link\("공식 HIG 열기"/);
  assert.match(homeSource, /topic\.higUrl/);
  assert.match(homeSource, /topic\.sectionTitle/);
  assert.match(homeSource, /topic\.swiftUIReference/);
  assert.doesNotMatch(homeSource, /Text\("파라미터"\)/);
  assert.doesNotMatch(homeSource, /Slider\(value: \$duration/);
  assert.doesNotMatch(homeSource, /Picker\("Easing"/);
  assert.doesNotMatch(previewSource, /duration: Double/);
  assert.match(catalogSource, /let keyPoints: \[String\]/);
});
