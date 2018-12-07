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
        let gateway = ListGateway()
        moduleView.viewOutput = ListInteractor(router: self, outputInterface: modulePresenter, gateway: gateway)
        navigationController?.pushViewController(moduleView, animated: animated)
    }
}

extension ListCoordinator: ListRoutingInterface {
    
}
