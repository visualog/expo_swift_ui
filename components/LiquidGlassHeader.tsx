import { NativeModulesProxy, requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import { NativeSyntheticEvent, StyleSheet, Text, View, ViewProps } from 'react-native';

type NativeLiquidGlassHeaderProps = ViewProps & {
  title: string;
  subtitle?: string;
  onAddPress?: (event: NativeSyntheticEvent<Record<string, never>>) => void;
};

export type LiquidGlassHeaderProps = ViewProps & {
  title: string;
  subtitle?: string;
  onAddPress?: () => void;
};

let NativeLiquidGlassHeader: React.ComponentType<NativeLiquidGlassHeaderProps> | null = null;

try {
  const hasNativeModule = Boolean(
    (NativeModulesProxy as Record<string, unknown>)?.ExpoLiquidGlassHeader
  );
  if (hasNativeModule) {
    NativeLiquidGlassHeader =
      requireNativeViewManager<NativeLiquidGlassHeaderProps>('ExpoLiquidGlassHeader');
  }
} catch {
  NativeLiquidGlassHeader = null;
}

export default function LiquidGlassHeader({
  title,
  subtitle,
  onAddPress,
  ...rest
}: LiquidGlassHeaderProps) {
  if (!NativeLiquidGlassHeader) {
    return (
      <View {...rest} style={[styles.fallback, rest.style]}>
        <Text style={styles.fallbackTitle}>{title}</Text>
        {!!subtitle && <Text style={styles.fallbackSubtitle}>{subtitle}</Text>}
      </View>
    );
  }

  return (
    <NativeLiquidGlassHeader
      {...rest}
      title={title}
      subtitle={subtitle}
      onAddPress={() => onAddPress?.()}
    />
  );
}

const styles = StyleSheet.create({
  fallback: {
    minHeight: 70,
    borderRadius: 22,
    backgroundColor: '#FFFFFFCC',
    justifyContent: 'center',
    paddingHorizontal: 16,
  },
  fallbackTitle: {
    fontSize: 26,
    fontWeight: '700',
    color: '#111827',
  },
  fallbackSubtitle: {
    marginTop: 3,
    fontSize: 12,
    color: '#6B7280',
  },
});
