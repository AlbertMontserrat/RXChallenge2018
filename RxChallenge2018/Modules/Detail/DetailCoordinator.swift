import UIKit

class DetailCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let completionClosure: VoidClosure?
    private let post: Post
    
    init(navigationController: UINavigationController, post: Post, completionClosure: VoidClosure?) {
        self.navigationController = navigationController
        self.completionClosure = completionClosure
        self.post = post
    }
    
    func start(animated: Bool = true) {
        let moduleView = DetailView()
        let modulePresenter = DetailPresenter(outputInterface: moduleView)
        let gateway = DetailGateway(provider: TypicodeProvider())
        moduleView.viewOutput = DetailInteractor(router: self, outputInterface: modulePresenter, gateway: gateway, post: post)
        navigationController?.pushViewController(moduleView, animated: animated)
    }
}

extension DetailCoordinator: DetailRoutingInterface {
    
}
