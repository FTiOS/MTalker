#
# Be sure to run `pod lib lint MTalker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MTalker'
  s.version          = '0.1.0'
  s.summary          = '咨询医生的音视频服务'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
咨询医生的音视频服务，底层封装成静态库，支持pod
                       DESC

  s.homepage         = 'https://github.com/rrun/MTalker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rrun' => 'hxy_sky@foxmail.com' }
  s.source           = { :git => 'https://github.com/rrun/MTalker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'Example/MTalker_Products／MTalkerClient/**/*.h'
  s.public_header_files = "Example/MTalker_Products／MTalkerClient/**/*.h"
  s.vendored_libraries = "Example/MTalker_Products／libMTalkerClient.a"
  s.preserve_paths = "Example/MTalker_Products／libMTalkerClient.a"

  # s.resource_bundles = {
  #   'MTalker' => ['MTalker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
