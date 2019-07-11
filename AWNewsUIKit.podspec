#
#  Be sure to run `pod spec lint NewsAPIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "AWNewsUIKit"
  spec.version      = "0.0.1"
  spec.summary      = "A NewsUIKit"
  spec.homepage     = "https://github.com/feixue299/NewsUIKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "wpf" => "1569485690@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/feixue299/NewsUIKit.git", :tag => "#{spec.version}" }
  spec.swift_version = '4.0'
  spec.source_files  = "Sources", "Sources/**/*.{swift}"
  spec.requires_arc = true
  spec.dependency "AWNewsAPIKit"
  spec.dependency "JXSegmentedView"
  spec.dependency "SnapKit"
  spec.dependency "Kingfisher"
end
