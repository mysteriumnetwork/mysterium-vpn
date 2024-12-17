#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint storekit_extensions.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'storekit_extensions'
  s.version          = '0.0.1'
  s.summary          = 'Flutter StoreKit extensions'
  s.description      = <<-DESC
  Flutter StoreKit extensions not yet supported by in_app_purchases plugin
                       DESC
  s.homepage         = 'https://mysteriumvpn.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mysterium VPN' => 'davidm@mysteriumvpn.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
