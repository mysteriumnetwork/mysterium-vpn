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
  s.homepage         = 'https://mysterium.network'
  s.license          = { :type => 'MIT', :file => 'COPYING' }
  s.author           = 'Mysterium Network'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'

  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'storekit_extensions_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
