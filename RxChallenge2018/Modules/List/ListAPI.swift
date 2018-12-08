import Foundation
import RxSwift
import RxCocoa
import GenericCellControllers

protocol ListRoutingInterface {
    func gotoDetail(with post: Post)
}

protocol ListViewInterface: class {
    func configureTitle(_ title: String)
    func configureSearchBarPlaceholder(_ title: String)
    func setupControllers(with controllersObservable: Driver<[TableCellController]>)
    func didSelectCell(with id: Int)
    func showError(with text: String)
}

protocol ListPresenterInterface {
    func configureTitles()
    func setupPosts(with postsObservable: Observable<PostsWithQuery>)
    func showError(with error: NetworkError)
}

protocol ListInteractorInterface {
    func initializeTitles()
    func configure(with searchObservable: Observable<String>)
    func configureSelection(with selectionIdObservable: Observable<Int>)
}
