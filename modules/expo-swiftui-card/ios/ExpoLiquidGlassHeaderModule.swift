import ExpoModulesCore

public final class ExpoLiquidGlassHeaderModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoLiquidGlassHeader")

    View(ExpoLiquidGlassHeaderView.self) {
      Events("onAddPress")

      Prop("title") { (view: ExpoLiquidGlassHeaderView, title: String) in
        view.title = title
      }

      Prop("subtitle") { (view: ExpoLiquidGlassHeaderView, subtitle: String) in
        view.subtitle = subtitle
      }
    }
  }
}
