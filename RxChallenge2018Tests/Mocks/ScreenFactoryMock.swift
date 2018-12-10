@testable import RxChallenge2018
import UIKit
import RxChallengeDomain

struct PostScreenFactoryMock: PostScreenInstantiable {
    let viewControllerList = UIViewController()
    let viewControllerDetail = UIViewController()

    func getPostListScreen(router: ListRoutingInterface, providers: AppProviders) -> UIViewController {
        return viewControllerList
    }
    
    func getPostDetailScreen(with post: Post, providers: AppProviders) -> UIViewController {
        return viewControllerDetail
    }
}
