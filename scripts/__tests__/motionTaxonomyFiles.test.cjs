const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');

const catalogPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift';
const homeViewPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift';

test('design catalog defines Apple HIG library kinds and topics', () => {
  const source = fs.readFileSync(catalogPath, 'utf8');

  assert.match(source, /enum AppleLibraryKind:/);
  assert.match(source, /case patterns/);
  assert.match(source, /case components/);
  assert.match(source, /enum PreviewKind:/);
  assert.match(source, /struct AppleDesignTopic:/);
  assert.match(source, /let libraryKind: AppleLibraryKind/);
  assert.match(source, /let higUrl: String/);
  assert.match(source, /let previewKind: PreviewKind/);
  assert.match(source, /static let sampleData: \[AppleDesignTopic\]/);
});

test('design catalog mirrors pattern and component topics from Apple HIG', () => {
  const source = fs.readFileSync(catalogPath, 'utf8');

  assert.match(source, /Launching/);
  assert.match(source, /Loading/);
  assert.match(source, /Searching/);
  assert.match(source, /Modality/);
  assert.match(source, /Buttons/);
  assert.match(source, /Page controls/);
  assert.match(source, /Segmented controls/);
  assert.match(source, /Text fields/);
  assert.match(source, /Toggles/);
  assert.match(source, /https:\/\/developer\.apple\.com\/design\/human-interface-guidelines\/page-controls/);
});

test('home view is branded as Apple Design Library and segmented by patterns vs components', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /Text\("애플 디자인 라이브러리"\)/);
  assert.match(source, /Picker\("라이브러리 분류", selection: \$selectedLibraryKind\)/);
  assert.match(source, /ForEach\(AppleLibraryKind\.allCases\)/);
  assert.match(source, /Text\(kind\.koreanTitle\)\.tag\(kind\)/);
  assert.match(source, /AppleDesignTopic\.sampleData/);
  assert.doesNotMatch(source, /Text\("모션 라이브러리"\)/);
  assert.doesNotMatch(source, /MotionPreset/);
});
