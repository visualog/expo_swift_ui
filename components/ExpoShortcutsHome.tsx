import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import { StyleSheet, Text, View, ViewProps } from 'react-native';

type NativeShortcutsHomeProps = ViewProps;

let NativeShortcutsHome: React.ComponentType<NativeShortcutsHomeProps> | null = null;

try {
  NativeShortcutsHome = requireNativeViewManager<NativeShortcutsHomeProps>('ExpoShortcutsHome');
} catch {
  NativeShortcutsHome = null;
}

export default function ExpoShortcutsHome(props: ViewProps) {
  if (!NativeShortcutsHome) {
    return (
      <View style={[styles.fallback, props.style]}>
        <Text style={styles.title}>ExpoShortcutsHome native view unavailable</Text>
        <Text style={styles.body}>
          iOS development build를 다시 생성하면 NavigationStack/TabView 기반 UI가 표시됩니다.
        </Text>
      </View>
    );
  }

  return <NativeShortcutsHome {...props} />;
}

const styles = StyleSheet.create({
  fallback: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 20,
    backgroundColor: '#F2F2F7',
  },
  title: {
    fontSize: 19,
    fontWeight: '700',
    color: '#111827',
    marginBottom: 8,
  },
  body: {
    fontSize: 14,
    color: '#6B7280',
    lineHeight: 20,
  },
});
