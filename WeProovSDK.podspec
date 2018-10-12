Pod::Spec.new do |s|
  s.name             = 'WeProovSDK'
  s.version          = '0.3.0'
  s.summary          = 'A short description of WeProovSDK.'

  s.description      = <<-DESC
Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ProovGroup/weproov-ios-sdk'
  s.license          = { :type => 'ProovGroup License', :file => 'LICENSE' }
  s.author           = 'ProovGroup'
  s.source           = { :git => 'https://github.com/ProovGroup/weproov-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.ios.vendored_frameworks = ['WeProovSDK/WeProovSDK.framework']
  s.user_target_xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => ['$(inherited)', '"' + Dir.pwd + '"'] }

  s.dependency 'ACEDrawingView', '~> 2.2'
  s.dependency 'APAddressBook', '~> 0.3'
  s.dependency 'FLAnimatedImage', '~> 1.0'
  s.dependency 'JTMaterialSpinner', '~> 3.0'
  s.dependency 'MBProgressHUD', '~> 1.1'
  s.dependency 'SnapKit', '~> 4.0'  

end
