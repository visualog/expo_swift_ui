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

  assert.match(homeSource, /DisclosureGroup\("핵심 포인트"/);
  assert.match(homeSource, /DisclosureGroup\("SwiftUI 참고"/);
  assert.match(homeSource, /Link\("공식 HIG 열기"/);
  assert.match(homeSource, /topic\.higUrl/);
  assert.match(homeSource, /topic\.sectionTitle/);
  assert.match(homeSource, /topic\.swiftUIReference/);
  assert.match(catalogSource, /let cardSummary: String/);
  assert.doesNotMatch(homeSource, /Text\("파라미터"\)/);
  assert.doesNotMatch(homeSource, /Slider\(value: \$duration/);
  assert.doesNotMatch(homeSource, /Picker\("Easing"/);
  assert.doesNotMatch(previewSource, /duration: Double/);
  assert.match(catalogSource, /let keyPoints: \[String\]/);
});

test('preview scenes use semantic preview tokens instead of fixed white surfaces and repeated fixed caption sizes', () => {
  const source = fs.readFileSync(previewPath, 'utf8');

  assert.match(source, /private enum AppleDesignPreviewTokens/);
  assert.match(source, /Color\(uiColor:\s*\.secondarySystemBackground\)/);
  assert.match(source, /Color\(uiColor:\s*\.label\)/);
  assert.match(source, /Color\(uiColor:\s*\.secondaryLabel\)/);
  assert.match(source, /font\(\.footnote\)/);
  assert.match(source, /font\(\.headline\)/);
  assert.doesNotMatch(source, /\.font\(\.system\(size:\s*12,\s*weight:\s*\.medium\)\)/);
});

test('detail preview hero is sized as primary content and the helper hint is visually secondary', () => {
  const source = fs.readFileSync(previewPath, 'utf8');

  assert.match(source, /\.frame\(height:\s*AppleDesignPreviewTokens\.shellHeight\)/);
  assert.match(source, /Text\(interactionHint\)/);
  assert.match(source, /\.font\(\.caption\)/);
  assert.doesNotMatch(source, /\.font\(\.footnote\)\s*[\r\n]+\s*\.foregroundStyle\(AppleDesignPreviewTokens\.secondaryText\)\s*[\r\n]+\s*\.padding\(\.horizontal,\s*4\)/);
});

test('preview shell uses shared spacing tokens instead of mixed literal paddings', () => {
  const source = fs.readFileSync(previewPath, 'utf8');

  assert.match(source, /static let sectionGap:\s*CGFloat = 12/);
  assert.match(source, /static let shellPadding:\s*CGFloat = 16/);
  assert.match(source, /static let shellHeight:\s*CGFloat = 320/);
  assert.match(source, /VStack\(alignment:\s*\.leading,\s*spacing:\s*AppleDesignPreviewTokens\.sectionGap\)/);
  assert.match(source, /\.padding\(AppleDesignPreviewTokens\.shellPadding\)/);
  assert.match(source, /\.frame\(height:\s*AppleDesignPreviewTokens\.shellHeight\)/);
});

test('catalog defines official HIG hierarchy metadata and planned status markers', () => {
  const source = fs.readFileSync(catalogPath, 'utf8');

  assert.match(source, /enum AppleReferenceStatus:\s*String,\s*CaseIterable,\s*Codable/);
  assert.match(source, /case implemented/);
  assert.match(source, /case planned/);
  assert.match(source, /enum AppleComponentGroup:\s*String,\s*CaseIterable,\s*Identifiable,\s*Codable/);
  assert.match(source, /case content/);
  assert.match(source, /case layoutAndOrganization/);
  assert.match(source, /case menusAndActions/);
  assert.match(source, /case navigationAndSearch/);
  assert.match(source, /case presentation/);
  assert.match(source, /case selectionAndInput/);
  assert.match(source, /case status/);
  assert.match(source, /case systemExperiences/);
  assert.match(source, /let status: AppleReferenceStatus/);
  assert.match(source, /let componentGroup: AppleComponentGroup\?/);
  assert.match(source, /"Layout and organization"/);
  assert.match(source, /"Navigation and search"/);
  assert.match(source, /"System experiences"/);
  assert.match(source, /status:\s*\.planned/);
  assert.match(source, /name:\s*"Drag and drop"/);
  assert.match(source, /name:\s*"Settings"/);
});

test('catalog mirrors the broader official HIG pattern list and moves menu semantics under components', () => {
  const source = fs.readFileSync(catalogPath, 'utf8');

  assert.match(source, /name:\s*"Charting data"/);
  assert.match(source, /name:\s*"Entering data"/);
  assert.match(source, /name:\s*"Feedback"/);
  assert.match(source, /name:\s*"Going full screen"/);
  assert.match(source, /name:\s*"Live-viewing apps"/);
  assert.match(source, /name:\s*"Managing accounts"/);
  assert.match(source, /name:\s*"Managing notifications"/);
  assert.match(source, /name:\s*"Multitasking"/);
  assert.match(source, /name:\s*"Offering help"/);
  assert.match(source, /name:\s*"Playing audio"/);
  assert.match(source, /name:\s*"Playing haptics"/);
  assert.match(source, /name:\s*"Playing video"/);
  assert.match(source, /name:\s*"Printing"/);
  assert.match(source, /name:\s*"Ratings and reviews"/);
  assert.match(source, /name:\s*"Undo and redo"/);
  assert.match(source, /name:\s*"Workouts"/);
  assert.match(source, /id:\s*"component_menus"/);
  assert.match(source, /componentGroup:\s*\.menusAndActions/);
  assert.doesNotMatch(source, /id:\s*"pattern_menus"/);
  assert.doesNotMatch(source, /id:\s*"pattern_writing"/);
  assert.doesNotMatch(source, /id:\s*"pattern_notifications"/);
});

test('catalog fills sparse component groups with official-style planned leaves for presentation and system experiences', () => {
  const source = fs.readFileSync(catalogPath, 'utf8');

  assert.match(source, /id:\s*"component_alerts"/);
  assert.match(source, /name:\s*"Alerts"/);
  assert.match(source, /componentGroup:\s*\.presentation/);
  assert.match(source, /id:\s*"component_sheets"/);
  assert.match(source, /name:\s*"Sheets"/);
  assert.match(source, /id:\s*"component_windows"/);
  assert.match(source, /name:\s*"Windows"/);
  assert.match(source, /componentGroup:\s*\.systemExperiences/);
  assert.match(source, /id:\s*"component_toolbars"/);
  assert.match(source, /name:\s*"Toolbars"/);
  assert.match(source, /componentGroup:\s*\.navigationAndSearch/);
  assert.match(source, /status:\s*\.planned/);
});
