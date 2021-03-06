import RxChallengeDomain
import RxChallengeUtils
import RxSwift
import RxCocoa
import GenericCellControllers

final class ListPresenter: ListPresenterInterface {
    
    //MARK: Relationships
    private weak var presenterOutput: ListViewInterface?
    
    //MARK: - Lifecycle
    init(outputInterface: ListViewInterface) {
        self.presenterOutput = outputInterface
    }
    
    //MARK: - ListPresenterInterface
    func configureTitles() {
        presenterOutput?.configureTitle(Constants.postsTitle)
        presenterOutput?.configureSearchBarPlaceholder(Constants.searchPostsTitle)
    }
    
    func setupObservables(postsObservable: Observable<PostsWithQuery>, selectionObservable: Observable<()>) {
        let postsDriver: Driver<[TableCellController]> = postsObservable
            .do(onNext: { [unowned self] _ in
                self.presenterOutput?.stopAnimating()
                }, onSubscribe: { [unowned self] in
                    self.presenterOutput?.startAnimating()
            })
            .map { [unowned self] data in
                return data.posts.map { PostCellController(descriptor: PostCellDescriptor(title: $0.title ?? ""), didSelectCell: self.didSelectCell(with: $0.id ?? 0)) }
            }
            .asDriver(onErrorJustReturn: [])
        presenterOutput?.setupObservables(controllers: postsDriver,
                                          selection: selectionObservable.asDriver(onErrorJustReturn: ()))
    }
    
    func showError(with error: NetworkError) {
        var errorMessage = ""
        switch error {
        //Option to show different errors for each network error
        default:
            errorMessage = Constants.errorLoadingErrorMessage
        }
        presenterOutput?.stopAnimating()
        presenterOutput?.showError(with: Constants.errorLoadingErrorTitle, message: errorMessage)
    }
}

//MARK: - Private methods
private extension ListPresenter {
    func didSelectCell(with id: Int) -> VoidClosure {
        return { [weak self] in
            self?.presenterOutput?.didSelectCell(with: id)
        }
    }
}

//MARK: - Constants
private extension ListPresenter {
    enum Constants {
        static var postsTitle: String { return .str_posts }
        static var searchPostsTitle: String { return .str_search_posts }
        static var errorLoadingErrorTitle: String { return .str_error }
        static var errorLoadingErrorMessage: String { return .str_error_loading_data }
    }
}
