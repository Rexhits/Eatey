# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Eatey' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'Fabric'
  pod 'TwitterKit'
  pod 'TwitterCore'
  pod 'Socket.IO-Client-Swift'
  # Pods for Eatey

  pod 'SwiftyJSON'
  pod 'AFNetworking'
  pod 'Lockbox'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end