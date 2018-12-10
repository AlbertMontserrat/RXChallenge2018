import UIKit
import RxChallengeDomain

class ListCoordinator: MainCoordinator {
    
    unowned var navigationController: UINavigationController
    private let providers: AppProviders
    
    init(navigationController: UINavigationController, providers: AppProviders) {
        self.navigationController = navigationController
        self.providers = providers
    }
    
    func start(animated: Bool = true) {
        let moduleView = ListView()
        let modulePresenter = ListPresenter(outputInterface: moduleView)
        moduleView.viewOutput = ListInteractor(router: self, outputInterface: modulePresenter, providers: providers)
        navigationController.pushViewController(moduleView, animated: animated)
    }
}

extension ListCoordinator: ListRoutingInterface {
    func gotoDetail(with post: Post) {
        let coordinator = DetailCoordinator(navigationController: navigationController, providers: providers, post: post)
        coordinator.start()
    }
}
