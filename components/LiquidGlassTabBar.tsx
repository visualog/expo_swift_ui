import { NativeModulesProxy, requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import {
  NativeSyntheticEvent,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ViewProps,
} from 'react-native';

export type TabId = 'shortcuts' | 'automation' | 'gallery';

type NativeTabBarProps = ViewProps & {
  selectedTab: string;
  onTabPress?: (event: NativeSyntheticEvent<{ id: string }>) => void;
};

export type LiquidGlassTabBarProps = ViewProps & {
  selectedTab: TabId;
  onTabPress?: (tab: TabId) => void;
};

let NativeTabBar: React.ComponentType<NativeTabBarProps> | null = null;

try {
  const hasNativeModule = Boolean(
    (NativeModulesProxy as Record<string, unknown>)?.ExpoLiquidGlassTabBar
  );
  if (hasNativeModule) {
    NativeTabBar = requireNativeViewManager<NativeTabBarProps>('ExpoLiquidGlassTabBar');
  }
} catch {
  NativeTabBar = null;
}

export default function LiquidGlassTabBar({
  selectedTab,
  onTabPress,
  ...rest
}: LiquidGlassTabBarProps) {
  if (!NativeTabBar) {
    return (
      <View {...rest} style={[styles.fallback, rest.style]}>
        {(['shortcuts', 'automation', 'gallery'] as TabId[]).map((item) => (
          <TouchableOpacity key={item} style={styles.fallbackItem} onPress={() => onTabPress?.(item)}>
            <Text style={[styles.fallbackText, selectedTab === item && styles.fallbackTextActive]}>
              {item === 'shortcuts' ? '단축어' : item === 'automation' ? '자동화' : '갤러리'}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    );
  }

  return (
    <NativeTabBar
      {...rest}
      selectedTab={selectedTab}
      onTabPress={(event) => {
        const raw = event.nativeEvent?.id;
        if (raw === 'shortcuts' || raw === 'automation' || raw === 'gallery') {
          onTabPress?.(raw);
        }
      }}
    />
  );
}

const styles = StyleSheet.create({
  fallback: {
    minHeight: 62,
    backgroundColor: '#FFFFFFCC',
    borderRadius: 22,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    paddingHorizontal: 8,
  },
  fallbackItem: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  fallbackText: {
    fontSize: 12,
    color: '#6B7280',
    fontWeight: '600',
  },
  fallbackTextActive: {
    color: '#007AFF',
  },
});
