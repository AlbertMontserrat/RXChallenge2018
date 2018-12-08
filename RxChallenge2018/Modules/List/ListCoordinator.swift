import UIKit

class ListCoordinator: MainCoordinator {
    
    weak var navigationController: UINavigationController?
    private let completionClosure: VoidClosure?
    
    init(navigationController: UINavigationController, completionClosure: VoidClosure?) {
        self.navigationController = navigationController
        self.completionClosure = completionClosure
    }
    
    func start(animated: Bool = true) {
        let moduleView = ListView()
        let modulePresenter = ListPresenter(outputInterface: moduleView)
        let gateway = ListGateway(provider: TypicodeProvider())
        moduleView.viewOutput = ListInteractor(router: self, outputInterface: modulePresenter, gateway: gateway)
        navigationController?.pushViewController(moduleView, animated: animated)
    }
}

extension ListCoordinator: ListRoutingInterface {
    func gotoDetail(with post: Post) {
        guard let navigationController = navigationController else { return }
        let coordinator = DetailCoordinator(navigationController: navigationController, post: post, completionClosure: {
            navigationController.popViewController(animated: true)
        })
        coordinator.start()
    }
}
