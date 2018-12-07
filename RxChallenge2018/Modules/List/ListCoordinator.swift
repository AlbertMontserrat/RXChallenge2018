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
        let alertController = UIAlertController(title: post.title, message: post.body, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}
