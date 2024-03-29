Pod::Spec.new do |s|
  s.name             = 'WeProovSDK'
  s.version          = '1.6.2'
  s.summary          = 'WeProovSDK is an extension deploy by WeProov'
  s.description      = 'WeProovSDK is an extension of WeProov tools to complete report with multiple features.'
  s.license          = { :type => 'ProovGroup License', :file => 'LICENSE' }
  s.author           = 'ProovGroup'
  s.homepage         = 'https://github.com/ProovGroup/weproov-ios-sdk'
  s.source           = { :git => 'https://github.com/ProovGroup/weproov-ios-sdk.git', :tag => s.version.to_s }
  s.platform = :ios, "12.1"
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'IPHONEOS_DEPLOYMENT_TARGET' => '12.1' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'IPHONEOS_DEPLOYMENT_TARGET' => '12.1' }
  s.ios.deployment_target = '12.1'
  s.swift_versions = '5.0'
  s.ios.vendored_frameworks = ['WeProovSDK/WeProovSDK.framework' ]
  s.preserve_paths = 'WeProovSDK/Wprv.framework'
  s.dependency 'APAddressBook/Swift'
    #s.dependency 'JTBorderDotAnimation', '~> 1.0'
     #s.dependency 'SignatureView', '~> 1.1'
  s.dependency 'SwiftyDraw'
  s.dependency 'FLAnimatedImage', '~> 1.0'
  #s.dependency 'JTMaterialSpinner', '~> 3.0'
  s.dependency 'MBProgressHUD', '1.1'
  s.dependency 'SnapKit', '~> 4.0'
  s.dependency 'SwiftRichString'
  #s.dependency 'JTTableViewController', '~> 1.0.10'
  s.dependency 'Then', '~> 2.7.0'

end
