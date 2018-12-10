import UIKit

class DetailCoordinator {
    
    private unowned var navigationController: UINavigationController
    private let post: Post
    
    init(navigationController: UINavigationController, post: Post) {
        self.navigationController = navigationController
        self.post = post
    }
    
    func start(animated: Bool = true) {
        let moduleView = DetailView()
        let modulePresenter = DetailPresenter(outputInterface: moduleView)
        let gateway = DetailGateway(provider: TypicodeProvider())
        moduleView.viewOutput = DetailInteractor(outputInterface: modulePresenter, gateway: gateway, post: post)
        navigationController.pushViewController(moduleView, animated: animated)
    }
}
