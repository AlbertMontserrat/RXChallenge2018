import UIKit
import RxChallengeDomain

class ListCoordinator: MainCoordinator {
    
    unowned var navigationController: UINavigationController
    private let screenFactory: AppScreenFactory
    private let providers: AppProviders
    
    init(navigationController: UINavigationController, screenFactory: AppScreenFactory, providers: AppProviders) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
        self.providers = providers
    }
    
    func start(animated: Bool = true) {
        navigationController.pushViewController(screenFactory.postScreenFactory.getPostListScreen(router: self, providers: providers), animated: animated)
    }
}

extension ListCoordinator: ListRoutingInterface {
    func gotoDetail(with post: Post) {
        let coordinator = DetailCoordinator(navigationController: navigationController, screenFactory: screenFactory, providers: providers, post: post)
        coordinator.start()
    }
}
