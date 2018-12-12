import RxChallengeDomain
import RxSwift

typealias PostsWithQuery = (posts: [Post], query: String)

final class ListInteractor: ListInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: ListPresenterInterface
    private let router: ListRoutingInterface
    private let providers: AppProviders
    private var posts: [Post] = []
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
    
    func configure(with startupObservable: Observable<()>, refreshObservable: Observable<()>, searchObservable: Observable<String>) {
        let refreshData = Observable.merge([startupObservable, refreshObservable]).flatMap { [unowned self] in
            self.providers.typicodeProvider.getPosts().asObservable()
        }
        let observable = Observable
            .combineLatest(refreshData, searchObservable) { posts, searchString -> PostsWithQuery in
                return (posts.filter {
                    guard !searchString.isEmpty, let title = $0.title else { return true }
                    return title.lowercased().contains(searchString.lowercased())
                }, searchString)
            }
            .do(onNext: { [unowned self] result in
                self.posts = result.posts
            }, onError: { [unowned self] error in
                let error = error as? NetworkError ?? .undefined
                self.interactorOutput.showError(with: error)
            })
        interactorOutput.setupPosts(with: observable)
    }
    
    func configureSelection(with selectionIdObservable: Observable<Int>) {
        selectionIdObservable
            .map { [unowned self] id in
                return self.posts.first { $0.id == id }
            }
            .subscribe(onNext: { [unowned self] post in
                guard let post = post else { return }
                self.router.gotoDetail(with: post)
            }).disposed(by: disposeBag)
    }
}
