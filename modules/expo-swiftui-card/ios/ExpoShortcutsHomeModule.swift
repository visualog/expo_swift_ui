import ExpoModulesCore

public final class ExpoShortcutsHomeModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoShortcutsHome")

    View(ExpoShortcutsHomeView.self) {}
  }
}
