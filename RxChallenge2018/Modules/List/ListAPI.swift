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
    func setupObservables(controllers: Driver<[TableCellController]>, selection: Driver<()>)
    func didSelectCell(with id: Int)
    func showError(with title: String, message: String)
    func startAnimating()
    func stopAnimating()
}

protocol ListPresenterInterface {
    func configureTitles()
    func setupObservables(postsObservable: Observable<PostsWithQuery>, selectionObservable: Observable<()>)
    func showError(with error: NetworkError)
}

protocol ListInteractorInterface {
    func initializeTitles()
    func configureObservables(startupObservable: Observable<()>, refreshObservable: Observable<()>, searchObservable: Observable<String>, selectionIdObservable: Observable<Int>)
}
