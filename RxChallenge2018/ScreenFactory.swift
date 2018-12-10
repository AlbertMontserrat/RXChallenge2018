import UIKit
import RxChallengeDomain

protocol PostScreenInstantiable {
    func getPostListScreen(router: ListRoutingInterface, providers: AppProviders) -> UIViewController
    func getPostDetailScreen(with post: Post, providers: AppProviders) -> UIViewController
}

struct AppScreenFactory {
    let postScreenFactory: PostScreenInstantiable
}

struct PostScreenFactory: PostScreenInstantiable {
    func getPostListScreen(router: ListRoutingInterface, providers: AppProviders) -> UIViewController {
        let moduleView = ListView()
        let modulePresenter = ListPresenter(outputInterface: moduleView)
        moduleView.viewOutput = ListInteractor(router: router, outputInterface: modulePresenter, providers: providers)
        return moduleView
    }
    
    func getPostDetailScreen(with post: Post, providers: AppProviders) -> UIViewController {
        let moduleView = DetailView()
        let modulePresenter = DetailPresenter(outputInterface: moduleView)
        moduleView.viewOutput = DetailInteractor(outputInterface: modulePresenter, providers: providers, post: post)
        return moduleView
    }
}
