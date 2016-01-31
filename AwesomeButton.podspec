#
# Be sure to run `pod lib lint AwesomeButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AwesomeButton"
  s.version          = "0.2.0"
  s.summary          = "UIButton inheritance with @IBDesignable and @IBInspectable force."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
AwesomeButton is an open source control with ability to add image and text just using Interface Builder. This control inheritance with IBDesignable and IBInspectable force. 
                       DESC

  s.homepage         = "https://github.com/AndreyPanov/AwesomeButton"
  s.license          = 'MIT'
  s.author           = { "Andrey Panov" => "panovdev@gmail.com" }
  s.source           = { :git => "https://github.com/AndreyPanov/AwesomeButton.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/panovdev'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.swift'
  s.resource_bundles = {
    'AwesomeButton' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
end
