import { StatusBar } from 'expo-status-bar';
import { useEffect } from 'react';
import { StyleSheet, View } from 'react-native';

import ExpoShortcutsHome from './components/ExpoShortcutsHome';

export default function App() {
  useEffect(() => {
    if (!__DEV__) return;
    try {
      const DevMenu = require('expo-dev-menu');
      DevMenu.hideMenu?.();
    } catch {
      // Ignore when dev menu module is unavailable.
    }
  }, []);

  return (
    <View style={styles.screen}>
      <StatusBar style="dark" />
      <ExpoShortcutsHome style={styles.nativeRoot} />
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: '#F2F2F7',
  },
  nativeRoot: {
    width: '100%',
    flex: 1,
  },
});
