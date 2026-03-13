const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');

const homeViewPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift';

test('library shell defines shared liquid glass helpers and keeps native navigation controls', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /private struct LiquidGlassLibraryBackground: View/);
  assert.match(source, /private struct LiquidGlassPanelModifier: ViewModifier/);
  assert.match(source, /func liquidGlassPanel\(/);
  assert.match(source, /Picker\("라이브러리 분류", selection: \$selectedLibraryKind\)/);
  assert.match(source, /\.pickerStyle\(\.segmented\)/);
  assert.match(source, /TabView/);
});

test('home, cards, detail, and settings use shared liquid glass shell surfaces', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /LiquidGlassLibraryBackground\(\)/);
  assert.match(source, /AppleDesignTopicCard[\s\S]*?\.liquidGlassPanel\(/);
  assert.match(source, /AppleDesignTopicDetailSheet[\s\S]*?\.liquidGlassPanel\(/);
  assert.match(source, /SettingsScreen[\s\S]*?\.liquidGlassPanel\(/);
  assert.match(source, /FavoritesScreen[\s\S]*?\.liquidGlassPanel\(/);
});

test('library shell no longer relies on flat grouped-background cards for primary surfaces', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.doesNotMatch(source, /\.background\(Color\(uiColor: \.systemGroupedBackground\)\)/);
  assert.doesNotMatch(source, /\.background\(Color\(uiColor: \.secondarySystemGroupedBackground\), in: RoundedRectangle/);
});
