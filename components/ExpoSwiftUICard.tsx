import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import {
  NativeSyntheticEvent,
  StyleSheet,
  Text,
  View,
  ViewProps,
} from 'react-native';

type OnPressPayload = {
  title: string;
  subtitle: string;
};

export type ExpoSwiftUICardProps = ViewProps & {
  title: string;
  subtitle?: string;
  accentColorHex?: string;
  onPress?: (event: NativeSyntheticEvent<OnPressPayload>) => void;
};

let NativeExpoSwiftUICard: React.ComponentType<ExpoSwiftUICardProps> | null = null;

try {
  NativeExpoSwiftUICard = requireNativeViewManager<ExpoSwiftUICardProps>('ExpoSwiftUICard');
} catch {
  NativeExpoSwiftUICard = null;
}

export default function ExpoSwiftUICard(props: ExpoSwiftUICardProps) {
  if (!NativeExpoSwiftUICard) {
    return (
      <View style={[styles.fallback, props.style]}>
        <Text style={styles.fallbackTitle}>Native SwiftUI view unavailable</Text>
        <Text style={styles.fallbackBody}>
          Run with a development build (`expo run:ios`) instead of Expo Go.
        </Text>
      </View>
    );
  }

  return <NativeExpoSwiftUICard {...props} />;
}

const styles = StyleSheet.create({
  fallback: {
    minHeight: 130,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#D1D5DB',
    backgroundColor: '#F8FAFC',
    padding: 16,
    justifyContent: 'center',
  },
  fallbackTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: '#0F172A',
    marginBottom: 6,
  },
  fallbackBody: {
    fontSize: 13,
    color: '#334155',
    lineHeight: 18,
  },
});
