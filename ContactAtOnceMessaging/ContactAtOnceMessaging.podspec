Pod::Spec.new do |s|
  s.name         = "ContactAtOnceMessaging"
  s.version      = "1.0.9"
  s.summary      = "In-App Messaging framework for Contact At Once customers"
  s.authors      = "Contact At Once"
  s.license      = "Private"
  s.homepage     = "https://ContactAtOnce.com/Support"

  s.platform                = :ios, '10.0'
  
  s.source                  = { :http => 'github.com/ContactAtOnce/iOS-Messaging-SDK/ContactAtOnceMessaging/ContactAtOnceMessaging.zip' }
  s.vendored_frameworks     = 'ContactAtOnceMessaging.framework'
  s.frameworks              = 'UIKit'
  s.pod_target_xcconfig     = { 'SWIFT_VERSION' => '4.1' }
  
  s.ios.dependency 'TTTAttributedLabel', '~> 2.0'
  s.ios.dependency 'SLXMPPFramework', '~> 4.0'
  s.ios.dependency 'Promises', '~> 2.0'
  s.ios.dependency 'RNCryptor', '~> 5.0'
  s.ios.dependency 'ReachabilitySwift', '~> 4.1'
  
end
