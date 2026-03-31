/**
 * expo-swiftui-hig
 * Apple Human Interface Guidelines compliant SwiftUI components for React Native Expo
 */

import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';
import { type ViewProps } from 'react-native';

// MARK: - HIGButton

export interface HIGButtonProps extends ViewProps {
  title?: string;
  variant?: 'filled' | 'outlined' | 'plain' | 'linked';
  size?: 'small' | 'medium' | 'large';
  accentColorHex?: string;
  isLoading?: boolean;
  isDisabled?: boolean;
  onPress?: (event: { nativeEvent: { title: string } }) => void;
}

const NativeHIGButton = requireNativeViewManager<HIGButtonProps>('HIGButton');

export function HIGButton({
  title = 'Button',
  variant = 'filled',
  size = 'medium',
  accentColorHex = '#007AFF',
  isLoading = false,
  isDisabled = false,
  onPress,
  style,
}: HIGButtonProps) {
  return (
    <NativeHIGButton
      title={title}
      variant={variant}
      size={size}
      accentColorHex={accentColorHex}
      isLoading={isLoading}
      isDisabled={isDisabled}
      onPress={onPress}
      style={style}
    />
  );
}

// MARK: - HIGTextField

export interface HIGTextFieldProps extends ViewProps {
  placeholder?: string;
  value?: string;
  variant?: 'rounded' | 'underline' | 'filled';
  isSecure?: boolean;
  isError?: boolean;
  errorMessage?: string;
  accentColorHex?: string;
  onChangeText?: (event: { nativeEvent: { text: string } }) => void;
  onSubmitEditing?: (event: { nativeEvent: { text: string } }) => void;
}

const NativeHIGTextField = requireNativeViewManager<HIGTextFieldProps>('HIGTextField');

export function HIGTextField({
  placeholder = 'Enter text',
  value = '',
  variant = 'rounded',
  isSecure = false,
  isError = false,
  errorMessage = '',
  accentColorHex = '#007AFF',
  onChangeText,
  onSubmitEditing,
  style,
}: HIGTextFieldProps) {
  return (
    <NativeHIGTextField
      placeholder={placeholder}
      value={value}
      variant={variant}
      isSecure={isSecure}
      isError={isError}
      errorMessage={errorMessage}
      accentColorHex={accentColorHex}
      onChangeText={onChangeText}
      onSubmitEditing={onSubmitEditing}
      style={style}
    />
  );
}

// MARK: - HIGBadge

export interface HIGBadgeProps extends ViewProps {
  value?: string;
  variant?: 'filled' | 'outlined';
  size?: 'small' | 'medium' | 'large';
  accentColorHex?: string;
}

const NativeHIGBadge = requireNativeViewManager<HIGBadgeProps>('HIGBadge');

export function HIGBadge({
  value = '1',
  variant = 'filled',
  size = 'medium',
  accentColorHex = '#FF3B30',
  style,
}: HIGBadgeProps) {
  return (
    <NativeHIGBadge
      value={value}
      variant={variant}
      size={size}
      accentColorHex={accentColorHex}
      style={style}
    />
  );
}

// MARK: - HIGToggle

export interface HIGToggleProps extends ViewProps {
  label?: string;
  isOn?: boolean;
  accentColorHex?: string;
  isDisabled?: boolean;
  onValueChange?: (event: { nativeEvent: { isOn: boolean } }) => void;
}

const NativeHIGToggle = requireNativeViewManager<HIGToggleProps>('HIGToggle');

export function HIGToggle({
  label = '',
  isOn = false,
  accentColorHex = '#34C759',
  isDisabled = false,
  onValueChange,
  style,
}: HIGToggleProps) {
  return (
    <NativeHIGToggle
      label={label}
      isOn={isOn}
      accentColorHex={accentColorHex}
      isDisabled={isDisabled}
      onValueChange={onValueChange}
      style={style}
    />
  );
}

// MARK: - HIGSlider

export interface HIGSliderProps extends ViewProps {
  minimumValue?: number;
  maximumValue?: number;
  value?: number;
  accentColorHex?: string;
  isDisabled?: boolean;
  showValueLabel?: boolean;
  onValueChange?: (event: { nativeEvent: { value: number } }) => void;
}

const NativeHIGSlider = requireNativeViewManager<HIGSliderProps>('HIGSlider');

export function HIGSlider({
  minimumValue = 0.0,
  maximumValue = 1.0,
  value = 0.5,
  accentColorHex = '#007AFF',
  isDisabled = false,
  showValueLabel = false,
  onValueChange,
  style,
}: HIGSliderProps) {
  return (
    <NativeHIGSlider
      minimumValue={minimumValue}
      maximumValue={maximumValue}
      value={value}
      accentColorHex={accentColorHex}
      isDisabled={isDisabled}
      showValueLabel={showValueLabel}
      onValueChange={onValueChange}
      style={style}
    />
  );
}

// MARK: - Design Tokens

export const HIGDesignTokens = {
  colors: {
    systemBlue: '#007AFF',
    systemPurple: '#AF52DE',
    systemPink: '#FF2D55',
    systemRed: '#FF3B30',
    systemOrange: '#FF9500',
    systemYellow: '#FFCC00',
    systemGreen: '#34C759',
    systemTeal: '#5AC8FA',
    systemIndigo: '#5856D6',
  },
  spacing: {
    xxxSmall: 2,
    xxSmall: 4,
    xSmall: 8,
    small: 12,
    medium: 16,
    large: 20,
    xLarge: 24,
    xxLarge: 32,
    xxxLarge: 40,
    huge: 48,
    massive: 64,
  },
  cornerRadius: {
    small: 6,
    medium: 10,
    large: 12,
    xLarge: 16,
    xxLarge: 20,
    circular: 9999,
  },
};

export default {
  HIGButton,
  HIGTextField,
  HIGBadge,
  HIGToggle,
  HIGSlider,
  HIGDesignTokens,
};
