import Foundation
import RxSwift

typealias PostsWithQuery = (posts: [Post], query: String)

final class ListInteractor: ListInteractorInterface {
    
    //MARK: Relationships
    private let interactorOutput: ListPresenterInterface
    private let gateway: ListGateway
    private let router: ListRoutingInterface
    private let disposeBag = DisposeBag()
    
    //MARK: - Lifecycle
    init(router: ListRoutingInterface,
        outputInterface: ListPresenterInterface,
        gateway: ListGateway) {
        self.interactorOutput = outputInterface
        self.gateway = gateway
        self.router = router
    }
    
    //MARK: - ListInteractorInterface
    func initializeTitles() {
        interactorOutput.configureTitles()
    }
    
    func configure(with searchObservable: Observable<String>) {
        interactorOutput.setupPosts(with: Observable.combineLatest(gateway.getPosts().asObservable(), searchObservable) { posts, searchString -> PostsWithQuery in
            return (posts.filter {
                guard !searchString.isEmpty else { return true }
                return $0.title.lowercased().contains(searchString.lowercased())
            }, searchString)
        })
    }
    
    func configureSelection(with selectionIdObservable: Observable<Int>) {
        selectionIdObservable
            .withLatestFrom(gateway.getPosts().asObservable()) { id, posts -> Post? in
                return posts.first { $0.id == id }
            }.subscribe(onNext: { [unowned self] post in
                guard let post = post else { return }
                self.router.gotoDetail(with: post)
            }).disposed(by: disposeBag)
    }
}

//MARK: - Private methods
private extension ListInteractor {
    
}
