Pod::Spec.new do |s|
  s.name           = 'ExpoSwiftUIHIG'
  s.version        = '1.0.0'
  s.summary        = 'Apple HIG compliant SwiftUI components for Expo'
  s.description    = 'A collection of SwiftUI components following Apple Human Interface Guidelines'
  s.author         = 'SMP'
  s.homepage       = 'https://github.com/expo/expo'
  s.platforms      = { :ios => '15.0', :tvos => '15.0' }
  s.source         = { git: '' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'

  # Swift/Objective-C compatibility
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_OPTIMIZATION_LEVEL' => '-Onone'
  }

  s.source_files = "**/*.{h,m,swift}"
end
