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

test('library shell defines shared layout spacing tokens for grid alignment across screens', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /static let pageInset:\s*CGFloat = 16/);
  assert.match(source, /static let sectionGap:\s*CGFloat = 16/);
  assert.match(source, /static let cardGap:\s*CGFloat = 12/);
  assert.match(source, /static let panelPadding:\s*CGFloat = 16/);
  assert.match(source, /static let heroPadding:\s*CGFloat = 16/);
  assert.match(source, /static let heroBottomPadding:\s*CGFloat = 24/);
  assert.match(source, /static let detailSectionGap:\s*CGFloat = 16/);
  assert.match(source, /static let compactGap:\s*CGFloat = 12/);
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

  assert.match(source, /private struct AppleScreenHeader: View/);
  assert.match(homeSection, /AppleScreenHeader\(title:\s*"Apple HIG 레퍼런스"\)/);
  assert.match(homeSection, /\.hideNavigationBarForCustomHeader\(\)/);
  assert.doesNotMatch(homeSection, /실제 화면 맥락으로 훑는 레퍼런스/);
  assert.match(homeSection, /selectedLibraryKind == \.patterns \? "실제 화면 패턴" : "공식 구성요소 그룹"/);
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
  assert.match(source, /LazyVStack\(spacing:\s*AppleDesignSemanticTokens\.Spacing\.cardGap\)/);
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
  assert.match(searchSection, /AppleScreenHeader\(title:\s*"검색"\)/);
  assert.match(searchSection, /\.hideNavigationBarForCustomHeader\(\)/);
  assert.match(searchSection, /\.searchable\(text:\s*\$searchQuery,\s*prompt:\s*"패턴 또는 구성요소 검색"\)/);
});

test('all top-level screens reuse the shared horizontal rhythm and section spacing tokens', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const homeMatch = source.match(/private struct AppleDesignLibraryHomeScreen: View \{[\s\S]*?private struct SearchScreen: View/);
  const homeSection = homeMatch ? homeMatch[0] : '';
  const searchMatch = source.match(/private struct SearchScreen: View \{[\s\S]*?private struct FavoritesScreen: View/);
  const searchSection = searchMatch ? searchMatch[0] : '';
  const favoritesMatch = source.match(/private struct FavoritesScreen: View \{[\s\S]*?private struct SettingsScreen: View/);
  const favoritesSection = favoritesMatch ? favoritesMatch[0] : '';
  const settingsMatch = source.match(/private struct SettingsScreen: View \{[\s\S]*?private struct AppleDesignLibraryRootTabView: View/);
  const settingsSection = settingsMatch ? settingsMatch[0] : '';

  assert.match(homeSection, /VStack\(alignment:\s*\.leading,\s*spacing:\s*AppleDesignSemanticTokens\.Spacing\.sectionGap\)/);
  assert.match(homeSection, /AppleScreenHeader\(title:\s*"Apple HIG 레퍼런스"\)/);
  assert.match(homeSection, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)\s*\.padding\(\.horizontal,\s*AppleDesignSemanticTokens\.Spacing\.pageInset\)/);
  assert.match(homeSection, /LazyVStack\(spacing:\s*AppleDesignSemanticTokens\.Spacing\.cardGap\)/);
  assert.match(searchSection, /VStack\(alignment:\s*\.leading,\s*spacing:\s*AppleDesignSemanticTokens\.Spacing\.sectionGap\)/);
  assert.match(searchSection, /AppleScreenHeader\(title:\s*"검색"\)/);
  assert.match(searchSection, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)\s*\.padding\(\.horizontal,\s*AppleDesignSemanticTokens\.Spacing\.pageInset\)/);
  assert.match(searchSection, /LazyVStack\(spacing:\s*AppleDesignSemanticTokens\.Spacing\.cardGap\)/);
  assert.match(favoritesSection, /VStack\(spacing:\s*AppleDesignSemanticTokens\.Spacing\.cardGap\)/);
  assert.match(favoritesSection, /AppleScreenHeader\(title:\s*"즐겨찾기"\)/);
  assert.match(favoritesSection, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)\s*\.padding\(\.horizontal,\s*AppleDesignSemanticTokens\.Spacing\.pageInset\)/);
  assert.match(settingsSection, /VStack\(alignment:\s*\.leading,\s*spacing:\s*AppleDesignSemanticTokens\.Spacing\.sectionGap\)/);
  assert.match(settingsSection, /AppleScreenHeader\(title:\s*"설정"\)/);
  assert.match(settingsSection, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)\s*\.padding\(\.horizontal,\s*AppleDesignSemanticTokens\.Spacing\.pageInset\)/);
});

test('cards, thumbnails, and detail panels reuse shared padding values instead of mixed literals', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const cardMatch = source.match(/private struct AppleDesignTopicCard: View \{[\s\S]*?private struct AppleDesignTopicDetailSheet: View/);
  const cardSection = cardMatch ? cardMatch[0] : '';
  const detailMatch = source.match(/private struct AppleDesignTopicDetailSheet: View \{[\s\S]*?private struct AppleDesignLibraryHomeScreen: View/);
  const detailSection = detailMatch ? detailMatch[0] : '';
  const thumbnailMatch = source.match(/private struct AppleDesignTopicThumbnail: View \{[\s\S]*?private struct AppleDesignTopicCard: View/);
  const thumbnailSection = thumbnailMatch ? thumbnailMatch[0] : '';

  assert.match(cardSection, /\.padding\(AppleDesignSemanticTokens\.Spacing\.panelPadding\)/);
  assert.match(cardSection, /HStack\(alignment:\s*\.top,\s*spacing:\s*AppleDesignSemanticTokens\.Spacing\.compactGap\)/);
  assert.match(thumbnailSection, /\.padding\(\.horizontal,\s*AppleDesignSemanticTokens\.Spacing\.heroPadding\)/);
  assert.match(thumbnailSection, /\.padding\(\.top,\s*AppleDesignSemanticTokens\.Spacing\.heroPadding\)/);
  assert.match(thumbnailSection, /\.padding\(\.bottom,\s*AppleDesignSemanticTokens\.Spacing\.heroBottomPadding\)/);
  assert.match(detailSection, /VStack\(alignment:\s*\.leading,\s*spacing:\s*AppleDesignSemanticTokens\.Spacing\.detailSectionGap\)/);
  assert.match(detailSection, /AppleScreenHeader\(title:\s*topic\.koreanTitle\)/);
  assert.match(detailSection, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)\s*\.padding\(\.horizontal,\s*AppleDesignSemanticTokens\.Spacing\.pageInset\)/);
  assert.match(detailSection, /\.padding\(\.horizontal,\s*AppleDesignSemanticTokens\.Spacing\.pageInset\)/);
  assert.match(detailSection, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)\s*\.liquidGlassPanel\(tint:\s*Color\(hex:\s*topic\.tintHex\),\s*padding:\s*AppleDesignSemanticTokens\.Spacing\.panelPadding\)/);
  assert.match(detailSection, /\.liquidGlassPanel\(tint:\s*Color\(hex:\s*topic\.tintHex\),\s*padding:\s*AppleDesignSemanticTokens\.Spacing\.panelPadding\)/);
});

test('custom screen headers and full-width panels keep titles and cards inside the page margin grid', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const favoritesMatch = source.match(/private struct FavoritesScreen: View \{[\s\S]*?private struct SettingsScreen: View/);
  const favoritesSection = favoritesMatch ? favoritesMatch[0] : '';
  const settingsMatch = source.match(/private struct SettingsScreen: View \{[\s\S]*?private struct AppleDesignLibraryRootTabView: View/);
  const settingsSection = settingsMatch ? settingsMatch[0] : '';
  const detailMatch = source.match(/private struct AppleDesignTopicDetailSheet: View \{[\s\S]*?private struct AppleDesignLibraryHomeScreen: View/);
  const detailSection = detailMatch ? detailMatch[0] : '';

  assert.match(source, /private struct AppleScreenHeader: View/);
  assert.match(source, /\.font\(\.largeTitle\.weight\(\.bold\)\)/);
  assert.match(source, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)/);
  assert.match(favoritesSection, /\.frame\(minHeight:\s*220\)/);
  assert.match(settingsSection, /\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)\s*\.liquidGlassPanel\(padding:\s*AppleDesignSemanticTokens\.Spacing\.panelPadding\)/);
  assert.match(detailSection, /\.hideNavigationBarForCustomHeader\(\)/);
});

test('section headers, segmented control, and list stacks explicitly fill the width inside the page margins', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const cardSectionMatch = source.match(/private struct AppleDesignTopicCard: View \{[\s\S]*?private struct AppleComponentGroupCard: View/);
  const cardSection = cardSectionMatch ? cardSectionMatch[0] : '';
  const homeMatch = source.match(/private struct AppleDesignLibraryHomeScreen: View \{[\s\S]*?private struct SearchScreen: View/);
  const homeSection = homeMatch ? homeMatch[0] : '';
  const groupMatch = source.match(/private struct AppleComponentGroupScreen: View \{[\s\S]*?private struct AppleDesignTopicDetailSheet: View/);
  const groupSection = groupMatch ? groupMatch[0] : '';
  const searchMatch = source.match(/private struct SearchScreen: View \{[\s\S]*?private struct FavoritesScreen: View/);
  const searchSection = searchMatch ? searchMatch[0] : '';

  assert.match(cardSection, /\.padding\(AppleDesignSemanticTokens\.Spacing\.panelPadding\)\s*\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)/);
  assert.match(homeSection, /\.pickerStyle\(\.segmented\)\s*\.frame\(maxWidth:\s*\.infinity\)/);
  assert.match(homeSection, /HStack \{[\s\S]*?Text\(selectedLibraryKind == \.patterns \? "실제 화면 패턴" : "공식 구성요소 그룹"\)[\s\S]*?\}\s*\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)/);
  assert.match(homeSection, /LazyVStack\(spacing:\s*AppleDesignSemanticTokens\.Spacing\.cardGap\)[\s\S]*?\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)/);
  assert.match(groupSection, /HStack \{[\s\S]*?Text\("공식 구성요소 항목"\)[\s\S]*?\}\s*\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)/);
  assert.match(searchSection, /HStack \{[\s\S]*?Text\(normalizedQuery\.isEmpty \? "전체 항목" : "검색 결과"\)[\s\S]*?\}\s*\.frame\(maxWidth:\s*\.infinity,\s*alignment:\s*\.leading\)/);
});

test('library home mirrors HIG hierarchy with pattern leaves and component groups', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /private struct AppleComponentGroupCard: View/);
  assert.match(source, /private struct AppleComponentGroupScreen: View/);
  assert.match(source, /AppleComponentGroup\.allCases/);
  assert.match(source, /Text\(selectedLibraryKind == \.patterns \? "실제 화면 패턴" : "공식 구성요소 그룹"\)/);
  assert.match(source, /if selectedLibraryKind == \.patterns/);
  assert.match(source, /ForEach\(filteredTopics\)/);
  assert.match(source, /ForEach\(AppleComponentGroup\.allCases\)/);
  assert.match(source, /NavigationLink\(destination:\s*AppleComponentGroupScreen/);
});

test('planned hierarchy items are exposed with a 준비 중 state instead of being hidden', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');

  assert.match(source, /Text\("준비 중"\)/);
  assert.match(source, /topic\.status == \.planned/);
  assert.match(source, /groupTopics\.filter/);
});

test('planned topics use a detail fallback instead of always requiring a live preview', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const detailMatch = source.match(/private struct AppleDesignTopicDetailSheet: View \{[\s\S]*?private struct AppleDesignLibraryHomeScreen: View/);
  const detailSection = detailMatch ? detailMatch[0] : '';

  assert.match(detailSection, /if topic\.status == \.implemented/);
  assert.match(detailSection, /MotionPreviewView\(topic: topic\)/);
  assert.match(detailSection, /Text\("준비 중인 레퍼런스"\)/);
  assert.match(detailSection, /Text\("이 HIG 항목은 구조만 먼저 미러링되어 있고, 인터랙티브 샘플은 아직 준비 중입니다\."\)/);
});

test('search surfaces both topic leaves and official component groups while favorites stay topic-only', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const searchMatch = source.match(/private struct SearchScreen: View \{[\s\S]*?private struct FavoritesScreen: View/);
  const searchSection = searchMatch ? searchMatch[0] : '';
  const favoritesMatch = source.match(/private struct FavoritesScreen: View \{[\s\S]*?private struct SettingsScreen: View/);
  const favoritesSection = favoritesMatch ? favoritesMatch[0] : '';

  assert.match(searchSection, /private var filteredGroups:/);
  assert.match(searchSection, /AppleComponentGroup\.allCases\.filter/);
  assert.match(searchSection, /NavigationLink\(destination:\s*AppleComponentGroupScreen/);
  assert.match(searchSection, /ForEach\(filteredGroups\)/);
  assert.match(searchSection, /ForEach\(filteredTopics\)/);
  assert.doesNotMatch(favoritesSection, /AppleComponentGroupCard/);
  assert.doesNotMatch(favoritesSection, /ForEach\(filteredGroups\)/);
});

test('planned items are visually clearer in group and search flows through explicit status copy and counts', () => {
  const source = fs.readFileSync(homeViewPath, 'utf8');
  const groupCardMatch = source.match(/private struct AppleComponentGroupCard: View \{[\s\S]*?private struct AppleComponentGroupScreen: View/);
  const groupCardSection = groupCardMatch ? groupCardMatch[0] : '';
  const cardMatch = source.match(/private struct AppleDesignTopicCard: View \{[\s\S]*?private struct AppleComponentGroupCard: View/);
  const cardSection = cardMatch ? cardMatch[0] : '';
  const groupScreenMatch = source.match(/private struct AppleComponentGroupScreen: View \{[\s\S]*?private struct AppleDesignTopicDetailSheet: View/);
  const groupScreenSection = groupScreenMatch ? groupScreenMatch[0] : '';
  const searchMatch = source.match(/private struct SearchScreen: View \{[\s\S]*?private struct FavoritesScreen: View/);
  const searchSection = searchMatch ? searchMatch[0] : '';

  assert.match(groupCardSection, /private var plannedCount: Int/);
  assert.match(groupCardSection, /Text\("\\\(topics\.count\)개 항목 · \\\(implementedCount\)개 구현 · \\\(plannedCount\)개 준비 중"\)/);
  assert.match(cardSection, /Text\(topic\.status == \.implemented \? "구현됨" : "준비 중"\)/);
  assert.match(cardSection, /topic\.status == \.planned \? Color\(hex: topic\.tintHex\) : AppleDesignSemanticTokens\.Colors\.secondaryText/);
  assert.match(groupScreenSection, /Text\(plannedTopics\.isEmpty \? "\\\(groupTopics\.count\)개" : "\\\(groupTopics\.count\)개 · \\\(plannedTopics\.count\) 준비 중"\)/);
  assert.match(searchSection, /Text\("구성요소 그룹"\)/);
  assert.match(searchSection, /Text\("HIG 항목"\)/);
});
