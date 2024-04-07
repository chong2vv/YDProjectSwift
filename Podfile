$:.unshift __dir__
require 'Podfile_Hook.rb'
# Uncomment the next line to define a global platform for your project
#source 'https://cdn.cocoapods.org/'
source 'https://github.com/CocoaPods/Specs.git'

VERSION = '10.0'

platform :ios, VERSION

abstract_target 'ArtAIClass' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!
  use_modular_headers!

  # Pods for ObjC
  pod 'Bugly', '2.5.71', :configurations => 'Release'
  pod 'MarqueeLabel', '4.0.2'
  pod 'SVProgressHUD', '2.2.5'
  pod 'MBProgressHUD', '1.1.0'
  pod 'YDLogger', '~> 0.2.1'
  pod 'YDMonitor', '~> 0.1.0'
  pod 'YDUtilKit', '~> 0.1.1'
  pod 'YDPlayer', '~> 0.1.2'
  pod 'YDClearCacheService', '~> 0.1.0'
  
  # Pods for Swift
  pod "Alamofire", "5.6.4"
  pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift.git', :tag => '1.4.0'
  pod 'Hue', '5.0.0'
  pod 'JXSegmentedView'
  pod 'JXPagingView/Paging', '2.0.12'
  pod 'KeychainSwift', '19.0.0'
  pod 'KingfisherWebP', '0.7.0'
  pod 'RxGesture', '3.0.1'
  pod 'SDWebImage', '5.7.3'
  pod 'SQLite.swift', '0.13.2'
  pod 'SwiftGifOrigin', '1.7.0'
  pod 'HandyJSON', '5.0.4-beta'
  pod 'IQKeyboardManagerSwift', '6.5.6'
  pod 'SYProgressView', '1.1.3'
  pod 'ZLPhotoBrowser', '4.1.9'
  pod 'SGQRCode', '3.5.1'
  
  pod 'lottie-ios', '2.5.2'


  # Pods for targets
  target 'YDProjectSwift' do
    
  end
  
  target 'YDProjectSwiftPre' do
   
  end
  
  target 'YDProjectSwiftDev' do
   
  end
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGN_IDENTITY'] = ''
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < VERSION.to_f
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = VERSION
      end
#      if config.build_settings['PRODUCT_NAME'] == 'SensorsAnalyticsSDK'
#        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ["$(inherited)", "COCOAPODS=1","SENSORS_ANALYTICS_DISABLE_UIWEBVIEW=1"]
#      end
    end
  end
end
