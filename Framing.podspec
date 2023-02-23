Pod::Spec.new do |s|
  s.name         = "Framing"
  s.version      = "0.2.0"
  s.summary      = "Swifty approach to defining frame layouts"
  s.homepage     = "https://github.com/ncreated/Framing"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors             = "Maciek Grzybowski"
  s.social_media_url   = "http://twitter.com/ncreated"

  s.swift_version             = '5.6'
  s.ios.deployment_target     = "11.0"
  s.source                    = { :git => "https://github.com/ncreated/Framing.git", :tag => "#{s.version}" }
  s.ios.source_files          = "Sources/Framing/*.swift"
end
