import UIKit
import RxChallengeDomain

class DetailCoordinator {
    
    private unowned var navigationController: UINavigationController
    private let providers: AppProviders
    private let post: Post
    
    init(navigationController: UINavigationController, providers: AppProviders, post: Post) {
        self.navigationController = navigationController
        self.providers = providers
        self.post = post
    }
    
    func start(animated: Bool = true) {
        let moduleView = DetailView()
        let modulePresenter = DetailPresenter(outputInterface: moduleView)
        moduleView.viewOutput = DetailInteractor(outputInterface: modulePresenter, providers: providers, post: post)
        navigationController.pushViewController(moduleView, animated: animated)
    }
}
