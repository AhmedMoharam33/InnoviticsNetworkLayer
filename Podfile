# Uncomment the next line to define a global platform for your project
# platform :ios, '13'

platform :ios, '13.0'
inhibit_all_warnings!
def shared_pods

pod 'Alamofire'

end

target 'InnoviticsNetworkLayer' do
  use_frameworks!
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
