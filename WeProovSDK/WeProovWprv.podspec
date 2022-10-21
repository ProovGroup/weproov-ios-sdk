Pod::Spec.new do |s|
  s.name             = 'WeProovWprv'
  s.version          = '1.0.0'
  s.summary          = 'WeProov Wprv'
  s.description      = 'WeProov Wprv framework'
  s.license          = { :type => 'ProovGroup License', :file => 'LICENSE' }
  s.author           = 'ProovGroup'
  s.homepage         = 'https://github.com/ProovGroup/weproov-ios-wprv'
  s.source           = { :git => 'https://github.com/ProovGroup/weproov-ios-wprv.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.1'
  s.ios.vendored_frameworks = ['Wprv.framework']

end
