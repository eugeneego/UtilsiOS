Pod::Spec.new do |s|
  s.name         = "EEUtilsiOS"
  s.version      = "1.0.0"
  s.summary      = "Useful utils for iOS."
  s.homepage     = "https://github.com/eugeneego/UtilsiOS"
  s.license      = "MIT"
  s.author       = "Evgeniy Egorov"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/eugeneego/UtilsiOS.git", :tag => "#{s.version}" }
  s.source_files  = "EEUtilsiOS/*.{h,m,c}"
  s.requires_arc = true
end
