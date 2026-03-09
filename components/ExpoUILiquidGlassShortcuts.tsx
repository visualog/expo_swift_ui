import {
  Button,
  GlassEffectContainer,
  HStack,
  Host,
  Image,
  Picker,
  ScrollView,
  Spacer,
  Text,
  VStack,
} from '@expo/ui/swift-ui';
import {
  background,
  buttonStyle,
  clipShape,
  controlSize,
  cornerRadius,
  font,
  foregroundStyle,
  frame,
  glassEffect,
  padding,
  pickerStyle,
  tag,
} from '@expo/ui/swift-ui/modifiers';
import * as React from 'react';
import { Platform, SafeAreaView, StyleSheet, View } from 'react-native';

type Segment = 0 | 1 | 2;
type TabKey = 'shortcuts' | 'automation' | 'gallery';

type FolderItem = {
  id: string;
  icon: string;
  title: string;
  count: number;
  iconColor: string;
  iconBackground: string;
};

type SuggestionItem = {
  id: string;
  title: string;
  subtitle: string;
};

const folders: FolderItem[] = [
  {
    id: 'all',
    icon: 'play.fill',
    title: '모든 단축어',
    count: 42,
    iconColor: '#0A84FF',
    iconBackground: '#CFE6FF',
  },
  {
    id: 'share',
    icon: 'arrow.up.right',
    title: '공유 시트',
    count: 8,
    iconColor: '#35C759',
    iconBackground: '#D8F5E0',
  },
  {
    id: 'watch',
    icon: 'applewatch',
    title: 'Apple Watch',
    count: 6,
    iconColor: '#FF9500',
    iconBackground: '#F8E8D4',
  },
  {
    id: 'quick',
    icon: 'bolt.fill',
    title: '빠른 실행',
    count: 15,
    iconColor: '#AF52DE',
    iconBackground: '#ECDCF7',
  },
];

const suggestions: SuggestionItem[] = [
  {
    id: 's1',
    title: '출근 루틴 실행',
    subtitle: '지도, 음악, 메시지 자동 실행',
  },
  {
    id: 's2',
    title: '회의 요약 만들기',
    subtitle: '녹음 파일을 텍스트로 요약',
  },
  {
    id: 's3',
    title: '사진 정리 자동화',
    subtitle: '촬영 시간 기준 앨범 분류',
  },
];

const tabs: Array<{ key: TabKey; label: string; icon: string }> = [
  { key: 'shortcuts', label: '단축어', icon: 'square.grid.2x2.fill' },
  { key: 'automation', label: '자동화', icon: 'clock.arrow.circlepath' },
  { key: 'gallery', label: '갤러리', icon: 'sparkles' },
];

function Header({
  selectedSegment,
  onChangeSegment,
}: {
  selectedSegment: Segment;
  onChangeSegment: (value: Segment) => void;
}) {
  return (
    <VStack spacing={12} modifiers={[padding({ top: 12, leading: 16, trailing: 16, bottom: 12 })]}>
      <GlassEffectContainer spacing={14}>
        <HStack
          spacing={10}
          alignment="center"
          modifiers={[
            padding({ all: 8 }),
            glassEffect({
              glass: { variant: 'regular', interactive: true },
              shape: 'roundedRectangle',
              cornerRadius: 28,
            }),
          ]}>
          <Text modifiers={[font({ size: 30, weight: 'bold', design: 'rounded' })]}>단축어</Text>
          <Spacer />
          <Button
            systemImage="plus"
            onPress={() => {}}
            modifiers={[buttonStyle('glassProminent'), controlSize('large')]}
          />
          <Button
            systemImage="person.crop.circle"
            onPress={() => {}}
            modifiers={[buttonStyle('glass'), controlSize('large')]}
          />
        </HStack>
      </GlassEffectContainer>

      <Picker<Segment>
        selection={selectedSegment}
        onSelectionChange={(value) => onChangeSegment((value ?? 0) as Segment)}
        modifiers={[pickerStyle('segmented')]}>
        <Text modifiers={[tag(0)]}>모든 단축어</Text>
        <Text modifiers={[tag(1)]}>최근</Text>
        <Text modifiers={[tag(2)]}>자동화</Text>
      </Picker>
    </VStack>
  );
}

function FolderCard({ item }: { item: FolderItem }) {
  return (
    <VStack
      spacing={10}
      modifiers={[
        frame({ width: 170, minHeight: 150, alignment: 'topLeading' }),
        padding({ all: 14 }),
        background('#FFFFFF'),
        cornerRadius(18),
      ]}>
      <Image
        systemName={item.icon as any}
        size={18}
        color={item.iconColor}
        modifiers={[
          frame({ width: 44, height: 44, alignment: 'center' }),
          background(item.iconBackground),
          clipShape('circle'),
        ]}
      />
      <Spacer minLength={2} />
      <Text modifiers={[font({ size: 17, weight: 'semibold' })]}>{item.title}</Text>
      <Text modifiers={[font({ size: 14 }), foregroundStyle({ type: 'hierarchical', style: 'secondary' })]}>
        {item.count}개 단축어
      </Text>
    </VStack>
  );
}

function ShortcutsBody() {
  return (
    <VStack spacing={18}>
      <HStack alignment="center">
        <Text modifiers={[font({ size: 38, weight: 'bold', design: 'rounded' })]}>내 단축어</Text>
        <Spacer />
        <Button label="편집" modifiers={[buttonStyle('plain')]} onPress={() => {}} />
      </HStack>

      <VStack spacing={12}>
        <HStack spacing={12}>
          <FolderCard item={folders[0]} />
          <FolderCard item={folders[1]} />
        </HStack>
        <HStack spacing={12}>
          <FolderCard item={folders[2]} />
          <FolderCard item={folders[3]} />
        </HStack>
      </VStack>

      <HStack alignment="center">
        <Text modifiers={[font({ size: 28, weight: 'bold', design: 'rounded' })]}>추천 단축어</Text>
        <Spacer />
        <Button label="모두 보기" modifiers={[buttonStyle('plain')]} onPress={() => {}} />
      </HStack>

      <VStack modifiers={[background('#FFFFFF'), cornerRadius(18)]}>
        {suggestions.map((item) => (
          <HStack
            key={item.id}
            alignment="center"
            spacing={12}
            modifiers={[padding({ top: 12, bottom: 12, leading: 14, trailing: 14 })]}>
            <VStack
              modifiers={[
                frame({ width: 48, height: 48, alignment: 'center' }),
                background('#F1F2F6'),
                cornerRadius(12),
              ]}>
              <Text modifiers={[font({ size: 24, weight: 'medium' }), foregroundStyle('#8B8B95')]}>
                ...
              </Text>
            </VStack>
            <VStack spacing={3} modifiers={[frame({ minHeight: 48, alignment: 'leading' })]}>
              <Text modifiers={[font({ size: 17, weight: 'semibold' })]}>{item.title}</Text>
              <Text
                modifiers={[font({ size: 14 }), foregroundStyle({ type: 'hierarchical', style: 'secondary' })]}>
                {item.subtitle}
              </Text>
            </VStack>
            <Spacer />
            <Image systemName="chevron.right" size={16} color="#C4C6CC" />
          </HStack>
        ))}
      </VStack>
    </VStack>
  );
}

function TabBar({ activeTab, onChangeTab }: { activeTab: TabKey; onChangeTab: (tab: TabKey) => void }) {
  return (
    <GlassEffectContainer spacing={12} modifiers={[padding({ leading: 16, trailing: 16, bottom: 14, top: 8 })]}>
      <HStack
        spacing={10}
        alignment="center"
        modifiers={[
          padding({ all: 8 }),
          glassEffect({
            glass: { variant: 'regular', interactive: true },
            shape: 'capsule',
          }),
        ]}>
        {tabs.map((tab) => {
          const isActive = activeTab === tab.key;
          return (
            <Button
              key={tab.key}
              onPress={() => onChangeTab(tab.key)}
              modifiers={[buttonStyle(isActive ? 'glassProminent' : 'glass'), controlSize('large')]}>
              <VStack spacing={4} modifiers={[padding({ horizontal: 6, vertical: 2 })]}>
                <Image systemName={tab.icon as any} size={17} color={isActive ? '#0A84FF' : '#8E8E93'} />
                <Text
                  modifiers={[
                    font({ size: 11, weight: isActive ? 'semibold' : 'regular' }),
                    foregroundStyle(isActive ? '#0A84FF' : '#8E8E93'),
                  ]}>
                  {tab.label}
                </Text>
              </VStack>
            </Button>
          );
        })}
      </HStack>
    </GlassEffectContainer>
  );
}

export default function ExpoUILiquidGlassShortcuts() {
  const [selectedSegment, setSelectedSegment] = React.useState<Segment>(0);
  const [activeTab, setActiveTab] = React.useState<TabKey>('shortcuts');

  if (Platform.OS !== 'ios') {
    return (
      <View style={styles.fallback}>
        <Text>iOS 전용 Expo UI SwiftUI 화면입니다.</Text>
      </View>
    );
  }

  return (
    <SafeAreaView style={styles.safeArea}>
      <Host style={styles.host}>
        <VStack spacing={0} modifiers={[background('#F2F2F7')]}>
          <Header selectedSegment={selectedSegment} onChangeSegment={setSelectedSegment} />

          <ScrollView showsIndicators={false} modifiers={[padding({ leading: 16, trailing: 16, bottom: 6 })]}>
            {activeTab === 'shortcuts' ? (
              <ShortcutsBody />
            ) : (
              <VStack
                spacing={10}
                modifiers={[
                  frame({ minHeight: 640, alignment: 'center' }),
                  padding({ top: 24, bottom: 24, leading: 8, trailing: 8 }),
                ]}>
                <Image
                  systemName={activeTab === 'automation' ? 'clock.arrow.circlepath' : 'sparkles'}
                  size={42}
                  color="#9BA1AD"
                />
                <Text
                  modifiers={[
                    font({ size: 24, weight: 'semibold', design: 'rounded' }),
                    foregroundStyle('#1E293B'),
                  ]}>
                  {activeTab === 'automation' ? '자동화' : '갤러리'} 화면
                </Text>
              </VStack>
            )}
          </ScrollView>

          <TabBar activeTab={activeTab} onChangeTab={setActiveTab} />
        </VStack>
      </Host>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#F2F2F7',
  },
  host: {
    flex: 1,
  },
  fallback: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#F2F2F7',
  },
});
