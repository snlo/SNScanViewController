# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

inhibit_all_warnings!

target 'SNScanViewController' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'SNTool'
  pod 'Masonry'

# 加入这些配置
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == "Masonry"
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
end
#post_install do |installer|
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
#        end
#    end
#end
  target 'SNScanViewControllerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SNScanViewControllerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
