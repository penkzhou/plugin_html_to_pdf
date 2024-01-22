#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'html_to_pdf'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin which transfer html into pdf.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://greenrobot.me'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Old Autumn' => 'penkstudio@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '11.0'
end

