import UIKit
import RxChallengeDomain

class DetailCoordinator: CoordinatorType {
    
    unowned var navigationController: UINavigationController
    private let screenFactory: AppScreenFactory
    private let providers: AppProviders
    private let post: Post
    
    init(navigationController: UINavigationController, screenFactory: AppScreenFactory, providers: AppProviders, post: Post) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
        self.providers = providers
        self.post = post
    }
    
    func start(animated: Bool = true) {
        navigationController.pushViewController(screenFactory.postScreenFactory.getPostDetailScreen(with: post, providers: providers), animated: animated)
    }
}
