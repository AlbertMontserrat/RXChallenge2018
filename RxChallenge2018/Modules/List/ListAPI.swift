import RxChallengeDomain
import RxSwift
import RxCocoa
import GenericCellControllers

protocol ListRoutingInterface {
    func gotoDetail(with post: Post)
}

protocol ListViewInterface: class {
    func configureTitle(_ title: String)
    func configureSearchBarPlaceholder(_ title: String)
    func setupControllers(with driver: Driver<[TableCellController]>, selectionObservable: Driver<()>)
    func didSelectCell(with id: Int)
    func showError(with title: String, message: String)
    func startAnimating()
    func stopAnimating()
}

protocol ListPresenterInterface {
    func configureTitles()
    func setupPosts(with postsObservable: Observable<PostsWithQuery>, selectionObservable: Observable<()>)
    func showError(with error: NetworkError)
}

protocol ListInteractorInterface {
    func initializeTitles()
    func configure(with startupObservable: Observable<()>, refreshObservable: Observable<()>, searchObservable: Observable<String>, selectionIdObservable: Observable<Int>)
}
