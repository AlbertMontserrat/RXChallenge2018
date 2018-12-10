import RxChallengeDomain
import RxSwift

typealias DetailData = (post: Post, user: User, comments: [Comment])

final class DetailInteractor: DetailInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: DetailPresenterInterface
    private let providers: AppProviders
    private let post: Post
    
    //MARK: - Lifecycle
    init(outputInterface: DetailPresenterInterface,
        providers: AppProviders,
        post: Post) {
        self.interactorOutput = outputInterface
        self.providers = providers
        self.post = post
    }
    
    //MARK: - DetailInteractorInterface
    func initializeTitles() {
        interactorOutput.configureTitles()
    }
    
    func setupStartupObservable(_ startupObservable: Observable<()>) {
        let observable = startupObservable
            .flatMap { [unowned self] _ in
                return Single.zip(self.providers.typicodeProvider.getUser(with: self.post.userId ?? 0),
                                  self.providers.typicodeProvider.getComments(for: self.post.id ?? 0)) { [unowned self] user, comments -> DetailData in
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
