import SwiftUI

struct MotionPreviewView: View {
  let preset: MotionPreset
  let duration: Double
  let delay: Double
  let easing: MotionEasing
  let intensity: MotionIntensity

  @State private var animate = false

  var body: some View {
    VStack(spacing: 16) {
      ZStack {
        RoundedRectangle(cornerRadius: 26, style: .continuous)
          .fill(Color(uiColor: .secondarySystemGroupedBackground))
          .frame(height: 190)
          .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
              .stroke(Color(uiColor: .separator).opacity(0.28), lineWidth: 0.5)
          )

        previewCard
          .animation(currentAnimation, value: animate)
      }

      Button("재생") {
        replay()
      }
      .buttonStyle(.borderedProminent)
      .tint(.blue)
    }
    .onAppear(perform: replay)
    .onChange(of: duration) { _ in replay() }
    .onChange(of: delay) { _ in replay() }
    .onChange(of: easing) { _ in replay() }
    .onChange(of: intensity) { _ in replay() }
  }

  private var previewCard: some View {
    VStack(spacing: 8) {
      Image(systemName: preset.icon)
        .font(.system(size: 22, weight: .semibold))
      Text(preset.name)
        .font(.system(size: 14, weight: .semibold))
    }
    .foregroundStyle(Color(hex: preset.tintHex))
    .frame(width: 148, height: 108)
    .background(Color(hex: preset.tintHex).opacity(0.14), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    .scaleEffect(scaleValue)
    .offset(x: xOffset, y: yOffset)
    .opacity(alphaValue)
  }

  private var currentAnimation: Animation {
    switch easing {
    case .smooth:
      return .easeOut(duration: duration)
    case .spring:
      return .spring(duration: duration, bounce: 0.16 * intensity.dampingScale)
    case .easeInOut:
      return .easeInOut(duration: duration)
    case .bouncy:
      return .spring(duration: duration, bounce: 0.28 * intensity.dampingScale)
    }
  }

  private var scaleValue: CGFloat {
    if animate { return 1.0 }
    switch preset.category {
    case .entrance: return 0.86
    case .emphasis: return 0.94
    case .exit: return 1.0
    case .gesture: return 0.92
    }
  }

  private var xOffset: CGFloat {
    guard !animate else { return 0 }
    if preset.category == .gesture { return 26 * intensity.dampingScale }
    return 0
  }

  private var yOffset: CGFloat {
    guard !animate else { return 0 }
    switch preset.category {
    case .entrance: return 24 * intensity.dampingScale
    case .emphasis: return 0
    case .exit: return -12 * intensity.dampingScale
    case .gesture: return 10 * intensity.dampingScale
    }
  }

  private var alphaValue: Double {
    if animate { return 1.0 }
    switch preset.category {
    case .exit: return 1.0
    default: return 0.35
    }
  }

  private func replay() {
    animate = false
    DispatchQueue.main.asyncAfter(deadline: .now() + max(delay, 0)) {
      withAnimation(currentAnimation) {
        animate = true
      }
    }
  }
}
