const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');

const homeViewPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift';

test('grid overlay is promoted above sheets via a window-level presenter', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /private final class GridOverlayStore: ObservableObject/);
  assert.match(source, /private final class GridOverlayWindowPresenter/);
  assert.match(source, /private final class GridOverlayPassthroughWindow: UIWindow/);
  assert.match(source, /override func didMoveToWindow\(\)/);
  assert.match(source, /gridOverlayPresenter\.attach\(to: windowScene/);
  assert.match(source, /gridOverlayPresenter\.setVisible\(gridOverlayStore\.isVisible\)/);
  assert.doesNotMatch(source, /if showGridOverlay \{\s*GridOverlayView\(\)/);
});

test('root tab body wraps its availability branches so lifecycle modifiers attach to a concrete view', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /private var tabContainer: some View/);
  assert.match(source, /tabContainer\s*\.onAppear \{ favoritesStore\.load\(\) \}/);
});
