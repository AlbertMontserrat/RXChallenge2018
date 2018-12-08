import Foundation
import RxSwift

typealias DetailData = (post: Post, user: User, comments: [Comment])

final class DetailInteractor: DetailInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: DetailPresenterInterface
    private let gateway: DetailGateway
    private let router: DetailRoutingInterface
    private let post: Post
    
    //MARK: - Lifecycle
    init(router: DetailRoutingInterface,
        outputInterface: DetailPresenterInterface,
        gateway: DetailGateway,
        post: Post) {
        self.interactorOutput = outputInterface
        self.gateway = gateway
        self.router = router
        self.post = post
    }
    
    //MARK: - DetailInteractorInterface
    func initializeTitles() {
        interactorOutput.configureTitles()
    }
    
    func setupStartupObservable(_ startupObservable: Observable<()>) {
        interactorOutput.setupTitles(with: startupObservable.flatMap { [unowned self] _ in
            return Observable.zip(self.gateway.getUser(with: self.post.userId ?? 0).asObservable(),
                                  self.gateway.getComments(for: self.post.id ?? 0).asObservable()) { [unowned self] user, comments -> DetailData in
                                    return (self.post, user, comments)
            }
        })
    }
}

//MARK: - Private methods
private extension DetailInteractor {
    
}
