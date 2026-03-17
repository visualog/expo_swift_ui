const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');

const homeViewPath = '/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/ExpoShortcutsHomeView.swift';

test('library shell defines shared liquid glass helpers and keeps native navigation controls', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /private enum AppleDesignSemanticTokens/);
  assert.match(source, /private struct LiquidGlassLibraryBackground: View/);
  assert.match(source, /private struct LiquidGlassPanelModifier: ViewModifier/);
  assert.match(source, /private struct LightweightLiquidPanelModifier: ViewModifier/);
  assert.match(source, /func liquidGlassPanel\(/);
  assert.match(source, /func lightweightLiquidPanel\(/);
  assert.match(source, /Picker\("라이브러리 분류", selection: \$selectedLibraryKind\)/);
  assert.match(source, /\.pickerStyle\(\.segmented\)/);
  assert.match(source, /TabView/);
});

test('home, cards, detail, and settings use shared liquid glass shell surfaces', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /LiquidGlassLibraryBackground\(\)/);
  assert.match(source, /AppleDesignTopicCard[\s\S]*?\.lightweightLiquidPanel\(/);
  assert.match(source, /AppleDesignTopicDetailSheet[\s\S]*?\.liquidGlassPanel\(/);
  assert.match(source, /SettingsScreen[\s\S]*?\.liquidGlassPanel\(/);
  assert.match(source, /FavoritesScreen[\s\S]*?\.liquidGlassPanel\(/);
});

test('home search moves out of the header into the bottom tab shell search affordance', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.doesNotMatch(source, /TextField\("패턴 또는 구성요소 검색", text: \$query\)/);
  assert.doesNotMatch(source, /@State private var query = ""/);
  assert.match(source, /case search/);
  assert.match(source, /role:\s*\.search/);
  assert.doesNotMatch(source, /tabContainer\s*\.searchable\(text:\s*\$searchQuery/);
  assert.match(source, /SearchScreen[\s\S]*?\.searchable\(text:\s*\$searchQuery/);
  assert.match(source, /검색/);
});

test('segmented control stays native while extra heavy chrome is removed from the home header', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /Picker\("라이브러리 분류", selection: \$selectedLibraryKind\)/);
  assert.match(source, /\.pickerStyle\(\.segmented\)/);
  assert.doesNotMatch(source, /\.pickerStyle\(\.segmented\)\s*\.liquidGlassPanel/);
});

test('library shell no longer relies on flat grouped-background cards for primary surfaces', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.doesNotMatch(source, /\.background\(Color\(uiColor: \.systemGroupedBackground\)\)/);
  assert.doesNotMatch(source, /\.background\(Color\(uiColor: \.secondarySystemGroupedBackground\), in: RoundedRectangle/);
});

test('library shell uses semantic background and text tokens instead of raw color ramps and repeated fixed text sizes', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.doesNotMatch(source, /Color\(red:\s*0\.91,\s*green:\s*0\.97,\s*blue:\s*1\.0\)/);
  assert.doesNotMatch(source, /Color\(hex:\s*"#6BB7FF"\)\.opacity\(0\.15\)/);
  assert.match(source, /@Environment\(\\\.colorScheme\) private var colorScheme/);
  assert.match(source, /colorScheme == \.dark/);
  assert.match(source, /Color\(uiColor:\s*\.systemBackground\)/);
  assert.match(source, /Color\(uiColor:\s*\.secondarySystemBackground\)/);
  assert.match(source, /Color\(uiColor:\s*\.label\)/);
  assert.match(source, /Color\(uiColor:\s*\.secondaryLabel\)/);
  assert.match(source, /font\(\.largeTitle\)/);
  assert.match(source, /font\(\.title2\)/);
  assert.match(source, /font\(\.body\)/);
  assert.match(source, /font\(\.footnote\)/);
});

test('home cards stay compact and detail sections defer longer guidance behind disclosure groups', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const cardSectionMatch = source.match(/private struct AppleDesignTopicCard: View \{[\s\S]*?private struct AppleDesignTopicDetailSheet: View/);
  const cardSection = cardSectionMatch ? cardSectionMatch[0] : '';
  const homeSectionMatch = source.match(/private struct AppleDesignLibraryHomeScreen: View \{[\s\S]*?private struct SearchScreen: View/);
  const homeSection = homeSectionMatch ? homeSectionMatch[0] : '';

  assert.doesNotMatch(cardSection, /Text\(topic\.cardSummary\)/);
  assert.doesNotMatch(cardSection, /Text\(topic\.summary\)/);
  assert.match(cardSection, /Text\(topic\.koreanTitle\)/);
  assert.match(cardSection, /Text\(topic\.usageContext\)/);
  assert.doesNotMatch(homeSection, /패턴과 구성요소를 빠르게 훑는 내부 reference/);
  assert.match(source, /DisclosureGroup\("핵심 포인트"/);
  assert.match(source, /DisclosureGroup\("SwiftUI 참고"/);
});

test('home clarifies HIG reference identity and cards use usage-context metadata instead of taxonomy metadata', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const cardSectionMatch = source.match(/private struct AppleDesignTopicCard: View \{[\s\S]*?private struct AppleDesignTopicDetailSheet: View/);
  const cardSection = cardSectionMatch ? cardSectionMatch[0] : '';
  const homeSectionMatch = source.match(/private struct AppleDesignLibraryHomeScreen: View \{[\s\S]*?private struct SearchScreen: View/);
  const homeSection = homeSectionMatch ? homeSectionMatch[0] : '';
  const topicSource = fs.readFileSync('/Users/im_018/Documents/GitHub/Project/SMP/smp-ios-mvp/modules/expo-swiftui-card/ios/MotionPreset.swift', 'utf8');

  assert.match(homeSection, /\.navigationTitle\("Apple HIG 레퍼런스"\)/);
  assert.doesNotMatch(homeSection, /실제 화면 맥락으로 훑는 레퍼런스/);
  assert.match(homeSection, /selectedLibraryKind == \.patterns \? "실제 화면 패턴" : "실제 UI 구성요소"/);
  assert.match(cardSection, /Text\(topic\.usageContext\)/);
  assert.doesNotMatch(cardSection, /Text\(topic\.sectionTitle\)/);
  assert.doesNotMatch(cardSection, /Text\(topic\.name\)/);
  assert.match(topicSource, /let usageContext: String/);
});

test('home cards use a visual signature thumbnail so topics are scannable without reading long copy', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const cardSectionMatch = source.match(/private struct AppleDesignTopicCard: View \{[\s\S]*?private struct AppleDesignTopicDetailSheet: View/);
  const cardSection = cardSectionMatch ? cardSectionMatch[0] : '';

  assert.match(source, /private struct AppleDesignTopicThumbnail: View/);
  assert.match(source, /switch topic\.previewKind/);
  assert.match(source, /AppleDesignTopicThumbnail\(topic: topic\)/);
  assert.match(cardSection, /VStack\(alignment:\s*\.leading,\s*spacing:\s*0\)/);
  assert.match(cardSection, /\.frame\(maxWidth:\s*\.infinity\)/);
  assert.match(cardSection, /\.frame\(height:\s*184\)/);
  assert.match(cardSection, /\.lightweightLiquidPanel\(cornerRadius:\s*24,\s*tint:\s*Color\(hex:\s*topic\.tintHex\),\s*padding:\s*0\)/);
});

test('thumbnail scenes favor literal iOS context fragments over abstract placeholder blocks', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /private var launchThumbnail: some View \{[\s\S]*?RoundedRectangle\(cornerRadius:\s*18,\s*style:\s*\.continuous\)[\s\S]*?RoundedRectangle\(cornerRadius:\s*16,\s*style:\s*\.continuous\)[\s\S]*?\.frame\(height:\s*68\)/);
  assert.match(source, /private var loadingThumbnail: some View \{[\s\S]*?ForEach\(0\.\.<2,\s*id:\s*\\\.self\)/);
  assert.match(source, /private var searchThumbnail: some View \{[\s\S]*?ForEach\(0\.\.<3,\s*id:\s*\\\.self\)/);
  assert.match(source, /private var searchThumbnail: some View \{[\s\S]*?\.frame\(height:\s*34\)/);
  assert.match(source, /private var modalThumbnail: some View \{[\s\S]*?RoundedRectangle\(cornerRadius:\s*18,\s*style:\s*\.continuous\)[\s\S]*?\.frame\(height:\s*72\)/);
  assert.match(source, /private var menuThumbnail: some View \{[\s\S]*?RoundedRectangle\(cornerRadius:\s*16,\s*style:\s*\.continuous\)[\s\S]*?Image\(systemName:\s*"ellipsis"\)/);
  assert.match(source, /private var pageThumbnail: some View \{[\s\S]*?\.frame\(height:\s*52\)/);
  assert.match(source, /private var toggleThumbnail: some View \{[\s\S]*?\.background\(AppleDesignSemanticTokens\.Colors\.backgroundSecondary,\s*in:\s*RoundedRectangle\(cornerRadius:\s*16,\s*style:\s*\.continuous\)\)/);
});

test('home and search results use a single-column list layout instead of a two-column grid', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.doesNotMatch(source, /private let columns = \[GridItem\(\.flexible\(\), spacing: 12\), GridItem\(\.flexible\(\), spacing: 12\)\]/);
  assert.doesNotMatch(source, /LazyVGrid\(columns: columns, spacing: 12\)/);
  assert.match(source, /LazyVStack\(spacing: 12\)/);
});

test('home cards enlarge tappable affordances and promote secondary metadata for faster scanning', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const cardSectionMatch = source.match(/private struct AppleDesignTopicCard: View \{[\s\S]*?private struct AppleDesignTopicDetailSheet: View/);
  const cardSection = cardSectionMatch ? cardSectionMatch[0] : '';

  assert.match(cardSection, /\.font\(\.title3\.weight\(\.semibold\)\)/);
  assert.match(cardSection, /\.font\(\.subheadline\)/);
  assert.match(cardSection, /\.frame\(width:\s*44,\s*height:\s*44\)/);
  assert.doesNotMatch(cardSection, /\.frame\(width:\s*32,\s*height:\s*32\)/);
});

test('search screen removes the duplicated intro hero and relies on navigation title plus results list', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const searchSectionMatch = source.match(/private struct SearchScreen: View \{[\s\S]*?private struct FavoritesScreen: View/);
  const searchSection = searchSectionMatch ? searchSectionMatch[0] : '';

  assert.doesNotMatch(searchSection, /Text\("전체 HIG 항목 검색"\)/);
  assert.doesNotMatch(searchSection, /\.liquidGlassPanel\(cornerRadius:\s*20,\s*padding:\s*14\)/);
  assert.match(searchSection, /\.navigationTitle\("검색"\)/);
  assert.match(searchSection, /\.searchable\(text:\s*\$searchQuery,\s*prompt:\s*"패턴 또는 구성요소 검색"\)/);
});
