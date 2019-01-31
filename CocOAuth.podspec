Pod::Spec.new do |spec|
  spec.name         = 'CocOAuth'
  spec.version      = '0.1.7'
  spec.license      = { :type => 'Apache 2' }
  spec.homepage     = 'https://github.com/CocOAuth'
  spec.authors      = { 'Open Source Project: CocOAuth' => 'https://github.com/orgs/CocOAuth/people' }
  spec.summary      = 'OAuth2 Authorization Client for iOS'
  spec.source       = { :git => 'https://github.com/CocOAuth/CocOAuth.git', :tag => '0.1.7'}
  spec.source_files = 'CocOAuth/*.{h,swift}'
  spec.framework    = 'Foundation'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  spec.ios.deployment_target = '9.0'
end 
