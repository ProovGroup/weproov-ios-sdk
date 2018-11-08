Pod::Spec.new do |s|
  s.name             = 'WeProovSDK'
  s.version          = '1.0.2'
  s.summary          = 'A short description of WeProovSDK'
  s.description      = 'A long description of WeProovSDK'
  s.license          = { :type => 'ProovGroup License', :file => 'LICENSE' }
  s.author           = 'ProovGroup'
  s.homepage         = 'https://github.com/ProovGroup/weproov-ios-sdk'
  s.source           = { :git => 'https://github.com/ProovGroup/weproov-ios-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.ios.vendored_frameworks = ['WeProovSDK/WeProovSDK.framework']
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' } # because of `WeProovWprv`
  s.user_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' } # because of `WeProovWprv`

  # s.dependency 'WeProovWprv'
  s.dependency 'ACEDrawingView', '~> 2.2'
  s.dependency 'APAddressBook', '~> 0.3'
  s.dependency 'FLAnimatedImage', '~> 1.0'
  s.dependency 'JTMaterialSpinner', '~> 3.0'
  s.dependency 'MBProgressHUD', '~> 1.1'
  s.dependency 'SnapKit', '~> 4.0'  
end
