import ExpoModulesCore

public final class ExpoLiquidGlassTabBarModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoLiquidGlassTabBar")

    View(ExpoLiquidGlassTabBarView.self) {
      Events("onTabPress")

      Prop("selectedTab") { (view: ExpoLiquidGlassTabBarView, selectedTab: String) in
        view.selectedTab = selectedTab
      }
    }
  }
}
