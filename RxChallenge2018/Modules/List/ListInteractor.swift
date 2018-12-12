import RxChallengeDomain
import RxSwift

typealias PostsWithQuery = (posts: [Post], query: String)

final class ListInteractor: ListInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: ListPresenterInterface
    private let router: ListRoutingInterface
    private let providers: AppProviders
    
    //MARK: - Lifecycle
    init(router: ListRoutingInterface,
        outputInterface: ListPresenterInterface,
        providers: AppProviders) {
        self.interactorOutput = outputInterface
        self.providers = providers
        self.router = router
    }
    
    //MARK: - ListInteractorInterface
    func initializeTitles() {
        interactorOutput.configureTitles()
    }
    
    func configureObservables(startupObservable: Observable<()>, refreshObservable: Observable<()>, searchObservable: Observable<String>, selectionIdObservable: Observable<Int>) {
        let refreshData = Observable
            .merge([startupObservable, refreshObservable])
            .flatMapLatest { [unowned self] in
                self.providers.typicodeProvider.getPosts().asObservable()
            }
            .share()
        
        let postsObservable = Observable<PostsWithQuery>
            .combineLatest(refreshData, searchObservable) { posts, searchString -> PostsWithQuery in
                return (posts.filter {
                    guard !searchString.isEmpty, let title = $0.title else { return true }
                    return title.lowercased().contains(searchString.lowercased())
                }, searchString)
            }
            .do(onError: { [unowned self] error in
                let error = error as? NetworkError ?? .undefined
                self.interactorOutput.showError(with: error)
            })
        
        let selectionObservable = selectionIdObservable
            .withLatestFrom(postsObservable) { id, result -> Post? in
                return result.posts.first { $0.id == id }
            }
            .do(onNext: { [unowned self] post in
                guard let post = post else { return }
                self.router.gotoDetail(with: post)
            })
            .map { _ in () }
        
        interactorOutput.setupObservables(postsObservable: postsObservable,
                                          selectionObservable: selectionObservable)
    }
}
