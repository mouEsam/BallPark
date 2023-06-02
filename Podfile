platform :ios, '15.0'

target 'BallPark' do
  use_frameworks!

  pod 'ReachabilitySwift', '~> 5.0'
  pod 'Kingfisher', '~> 7.0', :inhibit_warnings => true
  pod 'Alamofire', '~> 5.7'
  pod 'Swinject', '~> 2.8'

end

post_install do |installer|
  return if !installer
  project = installer.pods_project
  project_deployment_target = project.build_configurations.first.build_settings['IPHONEOS_DEPLOYMENT_TARGET']

  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
    target.build_configurations.each do |config|
      old_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
      new_target = project_deployment_target
      next if old_target == new_target || old_target == nil || new_target == nil
      puts "    #{config.name}: #{old_target.yellow} -> #{new_target.green}"
      #config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = new_target
    end
  end
end
