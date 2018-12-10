import RxChallengeDomain
import RxSwift

typealias PostsWithQuery = (posts: [Post], query: String)

final class ListInteractor: ListInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: ListPresenterInterface
    private let router: ListRoutingInterface
    private let providers: AppProviders
    private let disposeBag = DisposeBag()
    
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
    
    func configure(with searchObservable: Observable<String>) {
        let observable = Observable
            .combineLatest(providers.typicodeProvider.getPosts().asObservable(), searchObservable) { posts, searchString -> PostsWithQuery in
                return (posts.filter {
                    guard !searchString.isEmpty, let title = $0.title else { return true }
                    return title.lowercased().contains(searchString.lowercased())
                }, searchString)
            }
            .do(onError: { [unowned self] error in
                let error = error as? NetworkError ?? .undefined
                self.interactorOutput.showError(with: error)
            })
        interactorOutput.setupPosts(with: observable)
    }
    
    func configureSelection(with selectionIdObservable: Observable<Int>) {
        selectionIdObservable
            .withLatestFrom(providers.typicodeProvider.getPosts().asObservable()) { id, posts -> Post? in
                return posts.first { $0.id == id }
            }.subscribe(onNext: { [unowned self] post in
                guard let post = post else { return }
                self.router.gotoDetail(with: post)
            }).disposed(by: disposeBag)
    }
}
