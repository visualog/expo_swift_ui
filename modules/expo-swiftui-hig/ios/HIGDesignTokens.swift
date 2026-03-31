import SwiftUI

/// Apple Human Interface Guidelines 디자인 토큰
/// https://developer.apple.com/design/human-interface-guidelines/color
public struct HIGDesignTokens {
  
  // MARK: - System Colors (Apple HIG Standard)
  
  public static let systemBlue = Color(.systemBlue)
  public static let systemPurple = Color(.systemPurple)
  public static let systemPink = Color(.systemPink)
  public static let systemRed = Color(.systemRed)
  public static let systemOrange = Color(.systemOrange)
  public static let systemYellow = Color(.systemYellow)
  public static let systemGreen = Color(.systemGreen)
  public static let systemTeal = Color(.systemTeal)
  public static let systemIndigo = Color(.systemIndigo)
  
  // MARK: - Semantic Colors
  
  public static let primary = Color(.label)
  public static let secondary = Color(.secondaryLabel)
  public static let tertiary = Color(.tertiaryLabel)
  public static let quaternary = Color(.quaternaryLabel)
  
  public static let background = Color(.systemBackground)
  public static let secondaryBackground = Color(.secondarySystemBackground)
  public static let tertiaryBackground = Color(.tertiarySystemBackground)
  
  public static let groupBackground = Color(.systemGroupedBackground)
  public static let secondaryGroupBackground = Color(.secondarySystemGroupedBackground)
  public static let tertiaryGroupBackground = Color(.tertiarySystemGroupedBackground)
  
  public static let fill = Color(.systemFill)
  public static let secondaryFill = Color(.secondarySystemFill)
  public static let tertiaryFill = Color(.tertiarySystemFill)
  public static let quaternaryFill = Color(.quaternarySystemFill)
  
  public static let separator = Color(.separator)
  public static let opaqueSeparator = Color(.opaqueSeparator)
  
  // MARK: - Typography (SF Pro Dynamic Type)
  
  public enum FontSize {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2
    
    @ViewBuilder
    public var font: Font {
      switch self {
      case .largeTitle: Font.system(.largeTitle, design: .default)
      case .title1: Font.system(.title, design: .default)
      case .title2: Font.system(.title2, design: .default)
      case .title3: Font.system(.title3, design: .default)
      case .headline: Font.system(.headline, design: .default)
      case .body: Font.system(.body, design: .default)
      case .callout: Font.system(.callout, design: .default)
      case .subheadline: Font.system(.subheadline, design: .default)
      case .footnote: Font.system(.footnote, design: .default)
      case .caption1: Font.system(.caption, design: .default)
      case .caption2: Font.system(.caption2, design: .default)
      }
    }
    
    public var weight: Font.Weight {
      switch self {
      case .largeTitle, .title1, .title2, .title3: .regular
      case .headline: .semibold
      case .body, .callout: .regular
      case .subheadline: .regular
      case .footnote, .caption1, .caption2: .regular
      }
    }
  }
  
  // MARK: - Spacing (8pt Grid System)
  
  public enum Spacing: CGFloat {
    case xxxSmall = 2
    case xxSmall = 4
    case xSmall = 8
    case small = 12
    case medium = 16
    case large = 20
    case xLarge = 24
    case xxLarge = 32
    case xxxLarge = 40
    case huge = 48
    case massive = 64
    
    public var value: CGFloat { rawValue }
  }
  
  // MARK: - Corner Radius
  
  public enum CornerRadius: CGFloat {
    case small = 6
    case medium = 10
    case large = 12
    case xLarge = 16
    case xxLarge = 20
    case circular = 9999
    
    public var value: CGFloat { rawValue }
  }
  
  // MARK: - Elevation Shadows
  
  public enum Elevation {
    case none
    case small
    case medium
    case large
    case xl
    
    @ViewBuilder
    public var shadow: some ViewModifier {
      switch self {
      case .none: EmptyModifier()
      case .small: ShadowModifier(radius: 2, x: 0, y: 1, opacity: 0.08)
      case .medium: ShadowModifier(radius: 4, x: 0, y: 2, opacity: 0.12)
      case .large: ShadowModifier(radius: 8, x: 0, y: 4, opacity: 0.16)
      case .xl: ShadowModifier(radius: 16, x: 0, y: 8, opacity: 0.20)
      }
    }
  }
  
  private struct ShadowModifier: ViewModifier {
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    let opacity: Double
    
    func body(content: Content) -> some View {
      content.shadow(color: Color.black.opacity(opacity), radius: radius, x: x, y: y)
    }
  }
}

// MARK: - Convenience Extensions

extension Font {
  public static func hig(_ size: HIGDesignTokens.FontSize) -> Font {
    size.font
  }
}

extension CGFloat {
  public static func hig(_ spacing: HIGDesignTokens.Spacing) -> CGFloat {
    spacing.value
  }
}
