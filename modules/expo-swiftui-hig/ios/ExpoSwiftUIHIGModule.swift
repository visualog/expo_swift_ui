import ExpoModulesCore

public final class ExpoSwiftUIHIGModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoSwiftUIHIG")
    
    // MARK: - HIGButton
    
    View(HIGButtonView.self) {
      Events("onPress")
      
      Prop("title") { (view: HIGButtonView, title: String) in
        view.title = title
      }
      
      Prop("variant") { (view: HIGButtonView, variant: String) in
        view.variant = variant
      }
      
      Prop("size") { (view: HIGButtonView, size: String) in
        view.size = size
      }
      
      Prop("accentColorHex") { (view: HIGButtonView, accentColorHex: String) in
        view.accentColorHex = accentColorHex
      }
      
      Prop("isLoading") { (view: HIGButtonView, isLoading: Bool) in
        view.isLoading = isLoading
      }
      
      Prop("isDisabled") { (view: HIGButtonView, isDisabled: Bool) in
        view.isDisabled = isDisabled
      }
    }
    
    // MARK: - HIGTextField
    
    View(HIGTextFieldView.self) {
      Events("onChangeText", "onSubmitEditing")
      
      Prop("placeholder") { (view: HIGTextFieldView, placeholder: String) in
        view.placeholder = placeholder
      }
      
      Prop("value") { (view: HIGTextFieldView, value: String) in
        view.value = value
      }
      
      Prop("variant") { (view: HIGTextFieldView, variant: String) in
        view.variant = variant
      }
      
      Prop("isSecure") { (view: HIGTextFieldView, isSecure: Bool) in
        view.isSecure = isSecure
      }
      
      Prop("isError") { (view: HIGTextFieldView, isError: Bool) in
        view.isError = isError
      }
      
      Prop("errorMessage") { (view: HIGTextFieldView, errorMessage: String) in
        view.errorMessage = errorMessage
      }
      
      Prop("accentColorHex") { (view: HIGTextFieldView, accentColorHex: String) in
        view.accentColorHex = accentColorHex
      }
    }
    
    // MARK: - HIGBadge
    
    View(HIGBadgeView.self) {
      Prop("value") { (view: HIGBadgeView, value: String) in
        view.value = value
      }
      
      Prop("variant") { (view: HIGBadgeView, variant: String) in
        view.variant = variant
      }
      
      Prop("size") { (view: HIGBadgeView, size: String) in
        view.size = size
      }
      
      Prop("accentColorHex") { (view: HIGBadgeView, accentColorHex: String) in
        view.accentColorHex = accentColorHex
      }
    }
    
    // MARK: - HIGToggle
    
    View(HIGToggleView.self) {
      Events("onValueChange")
      
      Prop("label") { (view: HIGToggleView, label: String) in
        view.label = label
      }
      
      Prop("isOn") { (view: HIGToggleView, isOn: Bool) in
        view.isOn = isOn
      }
      
      Prop("accentColorHex") { (view: HIGToggleView, accentColorHex: String) in
        view.accentColorHex = accentColorHex
      }
      
      Prop("isDisabled") { (view: HIGToggleView, isDisabled: Bool) in
        view.isDisabled = isDisabled
      }
    }
    
    // MARK: - HIGSlider
    
    View(HIGSliderView.self) {
      Events("onValueChange")
      
      Prop("minimumValue") { (view: HIGSliderView, minimumValue: Double) in
        view.minimumValue = minimumValue
      }
      
      Prop("maximumValue") { (view: HIGSliderView, maximumValue: Double) in
        view.maximumValue = maximumValue
      }
      
      Prop("value") { (view: HIGSliderView, value: Double) in
        view.value = value
      }
      
      Prop("accentColorHex") { (view: HIGSliderView, accentColorHex: String) in
        view.accentColorHex = accentColorHex
      }
      
      Prop("isDisabled") { (view: HIGSliderView, isDisabled: Bool) in
        view.isDisabled = isDisabled
      }
      
      Prop("showValueLabel") { (view: HIGSliderView, showValueLabel: Bool) in
        view.showValueLabel = showValueLabel
      }
    }
  }
}
