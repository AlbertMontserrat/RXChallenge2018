import UIKit

class ListCoordinator: MainCoordinator {
    
    unowned var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool = true) {
        let moduleView = ListView()
        let modulePresenter = ListPresenter(outputInterface: moduleView)
        let gateway = ListGateway(provider: TypicodeProvider())
        moduleView.viewOutput = ListInteractor(router: self, outputInterface: modulePresenter, gateway: gateway)
        navigationController.pushViewController(moduleView, animated: animated)
    }
}

extension ListCoordinator: ListRoutingInterface {
    func gotoDetail(with post: Post) {
        let coordinator = DetailCoordinator(navigationController: navigationController, post: post)
        coordinator.start()
    }
}
