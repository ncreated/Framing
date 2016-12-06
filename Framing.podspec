Pod::Spec.new do |s|
  s.name         = "Framing"
  s.version      = "0.1.1"
  s.summary      = "Swifty approach to declarative frame layouts"
  s.homepage     = "https://github.com/ncreated/Framing"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = "Maciek Grzybowski"
  s.social_media_url   = "http://twitter.com/ncreated"

  s.platform     = :ios, "8.4"

  s.source       = { :git => "https://github.com/ncreated/Framing.git", :tag => "#{s.version}" }
  s.source_files  = "Framing/*.swift"
end
