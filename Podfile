# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'My Bank' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for My Bank
  pod 'ObjectMapper'
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'SVProgressHUD'
  pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Whisper'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
end
