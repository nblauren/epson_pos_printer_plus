#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint epson_pos_printer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'epson_pos_printer'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://nikkothe.dev'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nikko Laurenciana' => 'info@nikkothe.dev' }
  s.source       = { :git => 'https://github.com/nblauren/epson_pos_printer.git', :tag => s.version.to_s }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'



  # External Accessory is required by libepos2.a for USB and so
  s.framework = 'ExternalAccessory'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
  s.swift_version = '5.0'
  s.vendored_libraries = 'libepos2.a'
end
