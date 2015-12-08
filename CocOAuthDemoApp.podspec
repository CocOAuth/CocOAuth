
Pod::Spec.new do |spec|
  spec.name         = 'CocOAuth'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'Apache 2' }
  spec.homepage     = 'https://github.com/CocOAuth'
  spec.authors      = { 'Open Source Project: CocOAuth' => 'https://github.com/orgs/CocOAuth/people' }
  spec.summary      = 'OAuth2 Authorization Client for iOS'
  spec.source       = { :git => 'https://github.com/CocOAuth/CocOAuth.git', :branch => 'development'}
  spec.source_files = 'CocOAuth/*.{h,m}'
  spec.framework    = 'Foundation'
end
