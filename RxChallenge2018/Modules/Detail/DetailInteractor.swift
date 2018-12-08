import Foundation
import RxSwift

typealias DetailData = (post: Post, user: User, comments: [Comment])

final class DetailInteractor: DetailInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: DetailPresenterInterface
    private let gateway: DetailGateway
    private let post: Post
    
    //MARK: - Lifecycle
    init(outputInterface: DetailPresenterInterface,
        gateway: DetailGateway,
        post: Post) {
        self.interactorOutput = outputInterface
        self.gateway = gateway
        self.post = post
    }
    
    //MARK: - DetailInteractorInterface
    func initializeTitles() {
        interactorOutput.configureTitles()
    }
    
    func setupStartupObservable(_ startupObservable: Observable<()>) {
        let observable = startupObservable
            .flatMap { [unowned self] _ in
                return Observable.zip(self.gateway.getUser(with: self.post.userId ?? 0).asObservable(),
                                      self.gateway.getComments(for: self.post.id ?? 0).asObservable()) { [unowned self] user, comments -> DetailData in
                                        return (self.post, user, comments)
                }
            }
            .do(onError: { [unowned self] error in
                let error = error as? NetworkError ?? .undefined
                self.interactorOutput.showError(with: error)
            })
        interactorOutput.setupTitles(with: observable)
    }
}
