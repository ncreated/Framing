Pod::Spec.new do |s|
  s.name         = "Framing"
  s.version      = "0.2.0"
  s.summary      = "Swifty approach to defining frame layouts"
  s.homepage     = "https://github.com/ncreated/Framing"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = "Maciek Grzybowski"
  s.social_media_url   = "http://twitter.com/ncreated"

  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/ncreated/Framing.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/Framing/*.swift"
end
