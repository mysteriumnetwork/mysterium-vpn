Pod::Spec.new do |s|
  s.name             = 'mail_launcher'
  s.version          = '0.1.0'
  s.summary          = 'Launch installed mail apps to inbox.'
  s.description      = <<-DESC
Detect and launch installed mail clients on iOS, macOS, and Android.
                       DESC
  s.homepage         = 'https://mysteriumvpn.com'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Mysterium Network' => 'support@mysterium.network' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*.swift'
  s.dependency 'Flutter'
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
