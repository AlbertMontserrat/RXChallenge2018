platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'RxChallenge2018' do

  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'GenericCellControllers'
  pod 'RxKeyboard'
  pod 'Hue'
  pod 'SwiftyJSON', '~> 4.0'

  target 'RxChallengeUtils' do
    inherit! :search_paths
    pod 'SwiftMessages'
  end

  target 'RxChallengeDomain' do
    inherit! :search_paths
  end

  target 'RxChallengeNetwork' do
    inherit! :search_paths
    pod 'Moya/RxSwift', '~> 11.0'
  end

  target 'RxChallenge2018Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RxChallenge2018UITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
