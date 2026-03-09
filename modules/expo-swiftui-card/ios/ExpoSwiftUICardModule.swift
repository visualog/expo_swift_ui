import ExpoModulesCore

public final class ExpoSwiftUICardModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoSwiftUICard")

    View(ExpoSwiftUICardView.self) {
      Events("onPress")

      Prop("title") { (view: ExpoSwiftUICardView, title: String) in
        view.title = title
      }

      Prop("subtitle") { (view: ExpoSwiftUICardView, subtitle: String) in
        view.subtitle = subtitle
      }

      Prop("accentColorHex") { (view: ExpoSwiftUICardView, accentColorHex: String) in
        view.accentColorHex = accentColorHex
      }
    }
  }
}
