#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint okta_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'okta_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = 'Okta Flutter package makes it easy to add authentication to flutter apps. This library is a wrapper around Okta OIDC Android and Okta OIDC iOS.'
  s.homepage         = 'https://github.com/Mobioxy/okta_flutter_package'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mobioxy' => 'pankaj@mobioxy.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'OktaOidc','3.11.2'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
